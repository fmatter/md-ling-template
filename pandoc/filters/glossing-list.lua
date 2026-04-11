--[[
glossing-list.lua - Auto-discover and link glossing abbreviations

This filter:
1. Reads abbreviation definitions from metadata (glossing-abbreviations)
2. Auto-discovers used abbreviations from span.gl (linguistic-markup.lua output)  
3. Generates a list of ALL abbreviations defined in metadata
4. Links abbreviations to definitions in HTML output (for .gl spans)
5. Warns about abbreviations used but not defined in metadata

Note: Abbreviations in pandoc-ling interlinear glosses are not auto-discovered.
Include all abbreviations you use (including those in examples) in the metadata.

Metadata structure:
  glossing-abbreviations:
    APPL: applicative
    INV: inverse voice
    3: third person
  
  glossing-list:
    position: after      # 'before' (after intro) or 'after' (before references) or null (no list)
    title: "List of Glossing Abbreviations"
    warn-undefined: true # warn about used but undefined abbreviations
]]

local abbreviations = {}  -- From metadata: { ABBR = "definition" }
local used_abbrs = {}     -- Discovered in document: { ABBR = true }
local config = {
  position = "after",
  title = "List of Glossing Abbreviations",
  warn_undefined = true
}

-- Parse delimited string into individual abbreviations
-- Delimiters: - _ . , whitespace
local function parse_abbreviations(text)
  local abbrs = {}
  -- Split on delimiters but keep the parts
  -- Uppercase the text first since abbreviations might be lowercase in source
  local upper_text = text:upper()
  for abbr in upper_text:gmatch("[^%-%._,%s]+") do
    if abbr:match("^[A-Z0-9]+$") then  -- Only uppercase + numbers
      table.insert(abbrs, abbr)
    end
  end
  return abbrs
end

-- Check if element is inside a linguistic example table
local function is_in_linguistic_example(elem)
  -- This is a simplified check - in a real scenario we'd need to track context
  -- For now we'll check in the Span walker if parent is a Table
  return false  -- Will be checked differently
end

-- Collect abbreviations from metadata
function Meta(meta)
  -- Read abbreviation definitions
  if meta['glossing-abbreviations'] then
    for k, v in pairs(meta['glossing-abbreviations']) do
      abbreviations[k] = pandoc.utils.stringify(v)
    end
  end
  
  -- Read configuration
  if meta['glossing-list'] then
    local list_config = meta['glossing-list']
    if list_config.position then
      config.position = pandoc.utils.stringify(list_config.position)
      if config.position == "none" or config.position == "null" then
        config.position = nil
      end
    end
    if list_config.title then
      config.title = pandoc.utils.stringify(list_config.title)
    end
    if list_config['warn-undefined'] ~= nil then
      config.warn_undefined = list_config['warn-undefined']
    end
  end
  
  return meta
end

-- First pass: collect all used abbreviations
local function collect_abbreviations(doc)
  local span_count = 0
  local gl_count = 0
  local sc_count = 0
  local raw_count = 0
  
  local function collect_from_span(span)
    span_count = span_count + 1
    
    -- Check for span.gl (our linguistic markup)
    if span.classes:includes('gl') then
      gl_count = gl_count + 1
      local text = pandoc.utils.stringify(span)
      local abbrs = parse_abbreviations(text)
      for _, abbr in ipairs(abbrs) do
        used_abbrs[abbr] = true
      end
    end
    
    -- Check for span.smallcaps (from pandoc-ling or formatGloss)
    if span.classes:includes('smallcaps') then
      sc_count = sc_count + 1
      local text = pandoc.utils.stringify(span):upper()
      -- Single abbreviation or part of compound
      local abbrs = parse_abbreviations(text)
      for _, abbr in ipairs(abbrs) do
        used_abbrs[abbr] = true
      end
    end
    
    return span
  end
  
  local function collect_from_raw(raw)
    raw_count = raw_count + 1
    -- For HTML raw blocks, parse for  smallcaps spans
    if raw.format == "html" then
      -- Extract smallcaps abbreviations from HTML
      for abbr in raw.text:gmatch('<span class="smallcaps">([^<]+)</span>') do
        local upper = abbr:upper()
        local abbrs = parse_abbreviations(upper)
        for _, a in ipairs(abbrs) do
          used_abbrs[a] = true
        end
      end
    end
    return raw
  end
  
  -- Walk entire document blocks list to collect abbreviations
  doc.blocks:walk({
    Span = collect_from_span,
    RawBlock = collect_from_raw,
    RawInline = collect_from_raw
  })
end

-- Second pass: link abbreviations in HTML
local function link_abbreviations(doc)
  if not FORMAT:match('html') then
    return doc  -- Only link in HTML
  end
  
  local function link_span(span)
    -- Only process gl and smallcaps spans
    if not (span.classes:includes('gl') or span.classes:includes('smallcaps')) then
      return span
    end
    
    local text = pandoc.utils.stringify(span)
    local upper_text = text:upper()
    
    -- For span.gl, we might have multiple abbreviations
    if span.classes:includes('gl') then
      local abbrs = parse_abbreviations(upper_text)
      if #abbrs == 1 and abbreviations[abbrs[1]] then
        -- Single abbreviation - wrap in abbr tag
        local abbr = abbrs[1]
        local abbr_elem = pandoc.RawInline('html', 
          '<abbr title="' .. abbreviations[abbr] .. '" class="gloss-abbr">')
        local abbr_close = pandoc.RawInline('html', '</abbr>')
        return {abbr_elem, span, abbr_close}
      end
      -- Multiple abbreviations - would need more complex parsing
    end
    
    -- For span.smallcaps, check if it's a single abbreviation
    if span.classes:includes('smallcaps') then
      local abbrs = parse_abbreviations(upper_text)
      if #abbrs == 1 and abbreviations[abbrs[1]] then
        local abbr = abbrs[1]
        local abbr_elem = pandoc.RawInline('html',
          '<abbr title="' .. abbreviations[abbr] .. '" class="gloss-abbr">')
        local abbr_close = pandoc.RawInline('html', '</abbr>')
        return {abbr_elem, span, abbr_close}
      end
    end
    
    return span
  end
  
  -- Walk all blocks
  local temp_div = pandoc.Div(doc.blocks)
  temp_div = temp_div:walk({
    Span = link_span  
  })
  doc.blocks = temp_div.content
  
  return doc
end

-- Generate abbreviations list
local function generate_abbr_list()
  if not config.position then
    return nil
  end
  
  -- Build sorted list of ALL abbreviations from metadata
  local abbr_list = {}
  for abbr in pairs(abbreviations) do
    table.insert(abbr_list, abbr)
  end
  table.sort(abbr_list)
  
  if #abbr_list == 0 then
    return nil
  end
  
  -- Generate blocks
  local blocks = {}
  
  -- Add header
  if config.title then
    table.insert(blocks, pandoc.Header(1, config.title, {class = "unnumbered"}))
  end
  
  --Generate table or description list
  if FORMAT:match('latex') then
    -- LaTeX: use description list
    local items = {}
    for _, abbr in ipairs(abbr_list) do
      local def = abbreviations[abbr]
      -- Use .gl class for consistent formatting (lowercase for smallcaps)
      local abbr_span = pandoc.Span({pandoc.Str(abbr:lower())}, {class = "gl"})
      table.insert(items, {
        {abbr_span},
        {{pandoc.Plain({pandoc.Str(def)})}}
      })
    end
    table.insert(blocks, pandoc.DefinitionList(items))
  else
    -- HTML/DOCX: use simple table
    local header_row = {
      {pandoc.Plain({pandoc.Str("Abbreviation")})},
      {pandoc.Plain({pandoc.Str("Meaning")})}
    }
    
    local body_rows = {}
    for _, abbr in ipairs(abbr_list) do
      local def = abbreviations[abbr]
      -- Use .gl class for consistent formatting and tooltips (lowercase for smallcaps)
      local abbr_span = pandoc.Span({pandoc.Str(abbr:lower())}, {class = "gl"})
      table.insert(body_rows, {
        {pandoc.Plain({abbr_span})},
        {pandoc.Plain({pandoc.Str(def)})}
      })
    end
    
    -- Use SimpleTable for compatibility
    local tbl = pandoc.utils.from_simple_table(pandoc.SimpleTable(
      {},  -- caption
      {pandoc.AlignDefault, pandoc.AlignDefault},  -- aligns
      {0, 0},  -- widths
      header_row,  -- headers
      body_rows  -- rows
    ))
    
    table.insert(blocks, tbl)
  end
  
  return blocks
end

-- Generate inline abbreviation list
local function generate_inline_abbr_list()
  -- Build sorted list of ALL abbreviations from metadata
  local abbr_list = {}
  for abbr in pairs(abbreviations) do
    table.insert(abbr_list, abbr)
  end
  table.sort(abbr_list)
  
  if #abbr_list == 0 then
    return {}
  end
  
  local inlines = {}
  for i, abbr in ipairs(abbr_list) do
    local def = abbreviations[abbr]
    
    -- Add abbreviation with .gl class (lowercase for smallcaps)
    local abbr_span = pandoc.Span({pandoc.Str(abbr:lower())}, {class = "gl"})
    table.insert(inlines, abbr_span)
    
    -- Add definition in parentheses
    table.insert(inlines, pandoc.Space())
    table.insert(inlines, pandoc.Str("("))
    table.insert(inlines, pandoc.Str(def))
    table.insert(inlines, pandoc.Str(")"))
    
    -- Add comma separator except after last item
    if i < #abbr_list then
      table.insert(inlines, pandoc.Str(","))
      table.insert(inlines, pandoc.Space())
    end
  end
  
  return inlines
end

-- Replace inline abbreviation list placeholders
local function replace_inline_abbr_lists(doc)
  local function process_div(div)
    -- Check for glossing-abbreviations-inline class
    if div.classes:includes('glossing-abbreviations-inline') then
      local inlines = generate_inline_abbr_list()
      return pandoc.Para(inlines)
    end
    return div
  end
  
  -- Walk all blocks
  local temp_div = pandoc.Div(doc.blocks)
  temp_div = temp_div:walk({
    Div = process_div
  })
  doc.blocks = temp_div.content
  
  return doc
end

-- Warn about undefined abbreviations
local function warn_undefined()
  if not config.warn_undefined then
    return
  end
  
  local undefined = {}
  for abbr in pairs(used_abbrs) do
    if not abbreviations[abbr] then
      table.insert(undefined, abbr)
    end
  end
  
  if #undefined > 0 then
    table.sort(undefined)
    io.stderr:write("Warning: Glossing abbreviations used but not defined in metadata:\n")
    for _, abbr in ipairs(undefined) do
      io.stderr:write("  - " .. abbr .. "\n")
    end
  end
end

-- Main processing
function Pandoc(doc)
  -- Pass 1: Collect abbreviations
  collect_abbreviations(doc)
  
  -- Warn about undefined
  warn_undefined()
  
  -- Pass 2: Replace inline abbreviation list placeholders
  doc = replace_inline_abbr_lists(doc)
  
  -- Pass 3: Insert abbreviations table if requested
  if config.position then
    local abbr_list = generate_abbr_list()
    if abbr_list then
      if config.position == "before" then
        -- Insert after first heading (intro)
        local inserted = false
        local new_blocks = pandoc.List()
        for i, block in ipairs(doc.blocks) do
          new_blocks:insert(block)
          if not inserted and block.t == "Header" and block.level == 1 then
            -- Insert after first level-1 header
            for _, list_block in ipairs(abbr_list) do
              new_blocks:insert(list_block)
            end
            inserted = true
          end
        end
        doc.blocks = new_blocks
      elseif config.position == "after" then
        -- Insert before references/bibliography
        local inserted = false
        local new_blocks = pandoc.List()
        for i, block in ipairs(doc.blocks) do
          -- Check if this is the references heading
          if block.t == "Header" and (
            block.identifier == "references" or
            block.identifier == "bibliography" or
            pandoc.utils.stringify(block):lower():match("reference") or
            pandoc.utils.stringify(block):lower():match("bibliograph")
          ) then
            -- Insert before references
            for _, list_block in ipairs(abbr_list) do
              new_blocks:insert(list_block)
            end
            inserted = true
          end
          new_blocks:insert(block)
        end
        -- If no references found, append to end
        if not inserted then
          for _, list_block in ipairs(abbr_list) do
            new_blocks:insert(list_block)
          end
        end
        doc.blocks = new_blocks
      end
    end
  end
  
  -- Pass 4: Link abbreviations (do this AFTER inserting inline list and table
  -- so that .gl spans in those get linked too)
  doc = link_abbreviations(doc)
  
  return doc
end

return {
  {Meta = Meta},
  {Pandoc = Pandoc}
}

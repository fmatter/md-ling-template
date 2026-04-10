--[[
subtables.lua - Pandoc Lua filter for subtable support

Syntax (matching your format):
::: {#tbl:main}
**Overall caption**

Table: First subtable {#tbl:first}

| Data | Value |
|------|-------|
| A    | 1     |

Table: Second subtable {#tbl:second}

| Data | Value |
|------|-------|
| B    | 2     |
:::
]]

function Div(el)
  local id = el.identifier
  
  -- Only process divs with tbl: prefix
  if not id or not id:match("^tbl:") then
    return nil
  end
  
  -- Find all tables and the overall caption (first strong paragraph)
  local tables = {}
  local overall_caption = nil
  
  for i, block in ipairs(el.content) do
    if block.t == "Para" and block.content[1] and block.content[1].t == "Strong" and not overall_caption then
      overall_caption = pandoc.utils.stringify(block.content[1])
    elseif block.t == "Table" then
      table.insert(tables, block)
    end
  end
  
  -- Need at least 2 tables to be a subtable group
  if #tables < 2 then
    return nil
  end
  
  if FORMAT:match("latex") then
    -- LaTeX output using subfloat
    local latex_subfloats = {}
    
    for _, tbl in ipairs(tables) do
      local caption = pandoc.utils.stringify(tbl.caption.long)
      local label = tbl.identifier ~= "" and ("\\label{" .. tbl.identifier .. "}") or ""
      
      -- Render table to LaTeX
      local subdoc = pandoc.Pandoc({tbl})
      local table_latex = pandoc.write(subdoc, "latex")
      
      -- Strip longtable/caption/label since we handle those
      -- longtable structure: header \endfirsthead repeatheader \endhead footer \endlastfoot content
      -- We want: header only (no repetition blocks)
      table_latex = table_latex
        :gsub("\\begin{longtable}%b[]", "\\begin{tabular}")
        :gsub("\\begin{longtable}", "\\begin{tabular}")
        :gsub("\\end{longtable}", "\\end{tabular}")
        -- Remove the repetition blocks: from \endfirsthead to \endlastfoot
        :gsub("\\endfirsthead.-\\endlastfoot%s*", "")
        :gsub("\\caption%b{}%s*", "")
        :gsub("\\label%b{}%s*", "")
        -- Add bottomrule before end of tabular
        :gsub("(\\end{tabular})", "\\bottomrule\n%1")
      
      local subfloat = "\\subfloat[" .. caption .. "]{" .. label .. "\n" .. table_latex .. "}"
      table.insert(latex_subfloats, subfloat)
    end
    
    local output = "\\begin{table}[ht]\n\\centering\n" ..
      table.concat(latex_subfloats, "\\qquad\n") ..
      "\n\\caption{" .. (overall_caption or "Subtables") .. "}\\label{" .. id .. "}\n\\end{table}"
    
    return pandoc.RawBlock("latex", output)
  else
    -- For HTML: keep structure, let pandoc-crossref handle individual tables
    -- Add class for CSS styling to visually group them
    el.classes:insert("subtable-group")
    return el
  end
end

function Div(el)
  local id = el.identifier

  -- Only process divs with tbl: prefix
  if not id or not id:match("^tbl:") then
    return nil
  end

  -- Helper function to escape special LaTeX characters in captions
  local function escape_latex(str)
    if not str then return "" end
    -- Only escape characters that are problematic in captions
    -- Don't escape backslash since caption text shouldn't have raw backslashes
    str = str:gsub("&", "\\&")
    str = str:gsub("%%", "\\%%")
    str = str:gsub("%$", "\\$")
    str = str:gsub("#", "\\#")
    str = str:gsub("_", "\\_")
    str = str:gsub("{", "\\{")
    str = str:gsub("}", "\\}")
    return str
  end

  -- Find all tables and the overall caption (first strong paragraph)
  local tables = {}
  local overall_caption = nil
  for _, block in ipairs(el.content) do
    if block.t == "Para"
      and block.content[1]
      and block.content[1].t == "Strong"
      and not overall_caption then
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
    local n = #tables
    local layout = el.attributes["layout"] or "side"

    -- Determine subtable width based on layout and count
    local subtable_width
    if layout == "stack" then
      subtable_width = "\\linewidth"
    elseif n == 2 then
      subtable_width = ".47\\linewidth"
    elseif n == 3 then
      subtable_width = ".31\\linewidth"
    else
      -- More than 3: fall back to stacking
      subtable_width = "\\linewidth"
      layout = "stack"
    end

    local separator = (layout == "stack")
      and "\n\n\\bigskip\n\n"
      or "\n\\hfill\n"

    -- Build subtable blocks
    local latex_subfloats = {}
    for _, tbl in ipairs(tables) do
      local caption = pandoc.utils.stringify(tbl.caption.long)
      caption = escape_latex(caption)  -- Escape special LaTeX characters
      local label = (tbl.identifier ~= "")
        and ("\\label{" .. tbl.identifier .. "}")
        or ""

      -- Strip column widths to force auto-width columns (l/c/r instead of p{...})
      if tbl.colspecs then
        local new_colspecs = {}
        for _, spec in ipairs(tbl.colspecs) do
          local align = spec[1]  -- Keep alignment
          -- Set width to nil (not 0) to get auto-width columns
          table.insert(new_colspecs, {align, nil})
        end
        tbl.colspecs = new_colspecs
      end

      -- Render table to LaTeX
      local subdoc = pandoc.Pandoc({tbl})
      local table_latex = pandoc.write(subdoc, "latex")

      -- Convert longtable to tabular, strip pandoc-generated captions/labels
      table_latex = table_latex
        :gsub("\\begin{longtable}%b[]", "\\begin{tabular}")
        :gsub("\\begin{longtable}", "\\begin{tabular}")
        :gsub("\\end{longtable}", "\\end{tabular}")
        :gsub("\\endfirsthead.-\\endlastfoot%s*", "")
        :gsub("\\caption%b{}%s*", "")
        :gsub("\\label%b{}%s*", "")
        :gsub("(\\end{tabular})", "\\bottomrule\n%1")

      local subtable = "\\begin{subtable}{" .. subtable_width .. "}\n"
        .. "\\caption{" .. caption .. "}" .. label .. "\n"
        .. "\\centering\n"
        .. table_latex .. "\n"
        .. "\\end{subtable}"

      table.insert(latex_subfloats, subtable)
    end

    -- Escape overall caption for LaTeX
    local escaped_overall_caption = escape_latex(overall_caption or "Subtables")

    -- Wrap in table float
    local output = "\\begin{table}[ht]\n"
      .. "\\caption{" .. escaped_overall_caption .. "}"
      .. "\\label{" .. id .. "}\n"
      .. "\\centering\n"
      .. table.concat(latex_subfloats, separator) .. "\n"
      .. "\\end{table}"

    return pandoc.RawBlock("latex", output)

  else
    -- HTML: add grouping class, let pandoc-crossref handle individual tables
    el.classes:insert("subtable-group")
    return el
  end
end

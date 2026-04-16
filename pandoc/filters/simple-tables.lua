--[[
simple-tables.lua - Render all tables with auto-width columns

For ALL tables, this filter:
- Uses auto-width columns ('l') instead of percentage-based 'p{...}'
- Places caption ABOVE the table (standard linguistics convention)
- Uses tabular for tables (longtable only if needed for page breaks)
- Avoids unnecessary full-width stretching

Only affects LaTeX output; other formats pass through unchanged.
]]

function Table(tbl)
  -- Only process for LaTeX output
  if not FORMAT:match('latex') then
    return nil
  end
  
  -- Get number of columns
  local num_cols = 0
  if tbl.colspecs and #tbl.colspecs > 0 then
    num_cols = #tbl.colspecs
  elseif tbl.bodies and #tbl.bodies > 0 then
    local first_body = tbl.bodies[1]
    if first_body.body and #first_body.body > 0 then
      local first_row = first_body.body[1]
      if first_row.cells then
        num_cols = #first_row.cells
      end
    end
  end
  
  if num_cols == 0 then
    return nil  -- Empty table
  end
  
  -- Build column spec: use 'l' for left-aligned auto-width columns
  -- Could also honor alignment from colspecs if needed
  local col_spec = string.rep('l', num_cols)
  
  -- Start building LaTeX code
  local latex = {}
  
  -- Begin table environment
  table.insert(latex, '\\begin{table}[ht]')
  
  -- Add caption BEFORE centering (caption above table)
  if tbl.caption and tbl.caption.long and #tbl.caption.long > 0 then
    local caption_doc = pandoc.Pandoc(tbl.caption.long)
    local caption_latex = pandoc.write(caption_doc, 'latex')
    caption_latex = caption_latex:gsub('^%s+', ''):gsub('%s+$', '')
    table.insert(latex, '\\caption{' .. caption_latex .. '}')
  end
  
  -- Add label if present
  if tbl.identifier and tbl.identifier ~= '' then
    table.insert(latex, '\\label{' .. tbl.identifier .. '}')
  end
  
  table.insert(latex, '\\centering')
  table.insert(latex, '\\begin{tabular}{@{}' .. col_spec .. '@{}}')
  table.insert(latex, '\\toprule')
  
  -- Process header rows if they exist
  if tbl.head and tbl.head.rows and #tbl.head.rows > 0 then
    for _, row in ipairs(tbl.head.rows) do
      local cells = {}
      for _, cell in ipairs(row.cells) do
        local cell_doc = pandoc.Pandoc(cell.contents)
        local cell_latex = pandoc.write(cell_doc, 'latex')
        cell_latex = cell_latex:gsub('^%s+', ''):gsub('%s+$', '')
        table.insert(cells, cell_latex)
      end
      table.insert(latex, table.concat(cells, ' & ') .. ' \\\\')
    end
    table.insert(latex, '\\midrule')
  end
  
  -- Process body rows
  for _, body in ipairs(tbl.bodies) do
    for i, row in ipairs(body.body) do
      local cells = {}
      for _, cell in ipairs(row.cells) do
        -- Render cell contents
        local cell_doc = pandoc.Pandoc(cell.contents)
        local cell_latex = pandoc.write(cell_doc, 'latex')
        -- Clean up extra whitespace/newlines
        cell_latex = cell_latex:gsub('^%s+', ''):gsub('%s+$', '')
        table.insert(cells, cell_latex)
      end
      table.insert(latex, table.concat(cells, ' & ') .. ' \\\\')
    end
  end
  
  -- End table
  table.insert(latex, '\\bottomrule')
  table.insert(latex, '\\end{tabular}')
  table.insert(latex, '\\end{table}')
  
  -- Return as raw LaTeX block
  return pandoc.RawBlock('latex', table.concat(latex, '\n'))
end

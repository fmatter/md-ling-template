--[[
simple-tables.lua - Convert tables with empty headers to simple tabular

For tables without meaningful headers (empty header row), this filter:
- Uses tabular instead of longtable (no page breaks needed)
- Uses 'l' columns (auto-width) instead of 'p{...}' (percentage-width)
- Avoids unnecessary full-width stretching

Only affects LaTeX output; other formats pass through unchanged.
]]

function Table(tbl)
  -- Only process for LaTeX output
  if not FORMAT:match('latex') then
    return nil
  end
  
  -- Check if table has empty/meaningless headers
  local has_empty_header = true
  if tbl.head and tbl.head.rows and #tbl.head.rows > 0 then
    local header_row = tbl.head.rows[1]
    if header_row.cells then
      for _, cell in ipairs(header_row.cells) do
        -- Check if cell has any content
        if cell.contents and #cell.contents > 0 then
          for _, block in ipairs(cell.contents) do
            if block.content and #block.content > 0 then
              -- Found non-empty content
              has_empty_header = false
              break
            end
          end
        end
        if not has_empty_header then break end
      end
    end
  else
    -- No header at all
    has_empty_header = true
  end
  
  -- If header is not empty, let pandoc handle it normally
  if not has_empty_header then
    return nil
  end
  
  -- Get number of columns from first body row
  local num_cols = 0
  if tbl.bodies and #tbl.bodies > 0 then
    local first_body = tbl.bodies[1]
    if first_body.body and #first_body.body > 0 then
      local first_row = first_body.body[1]
      if first_row.cells then
        num_cols = #first_row.cells
      end
    end
  end
  
  if num_cols == 0 then
    return nil  -- Empty table, let pandoc handle it
  end
  
  -- Build column spec: use 'l' for each column (left-aligned, auto-width)
  local col_spec = string.rep('l', num_cols)
  
  -- Start building LaTeX code
  local latex = {}
  
  -- Begin table environment
  table.insert(latex, '\\begin{table}[ht]')
  table.insert(latex, '\\centering')
  table.insert(latex, '\\begin{tabular}{@{}' .. col_spec .. '@{}}')
  table.insert(latex, '\\toprule')
  
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
  
  -- Add caption if present
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
  
  table.insert(latex, '\\end{table}')
  
  -- Return as raw LaTeX block
  return pandoc.RawBlock('latex', table.concat(latex, '\n'))
end

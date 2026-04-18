--[[
linguistic-markup.lua - Pandoc Lua filter for linguistic semantic markup

Converts span classes to appropriate formatting:
- .gl or .gloss → smallcaps (for grammatical glosses)
- .ob → italics (for object language)
- .rc → asterisk + italics (for reconstructed forms)
- .pnt → [content] (for phonetic notation)
- .pnm → /content/ (for phonemic notation)

For LaTeX output, these are converted to semantic commands (\gl, \ob, \rc, \pnt, \pnm)
which are defined in the template and can be customized by users.
]]

-- Helper function to convert inlines to LaTeX, preserving subscripts/superscripts
local function inlines_to_latex(inlines)
  local result = {}
  for _, inline in ipairs(inlines) do
    if inline.t == 'Str' then
      table.insert(result, inline.text)
    elseif inline.t == 'Space' then
      table.insert(result, ' ')
    elseif inline.t == 'Subscript' then
      table.insert(result, '\\textsubscript{' .. inlines_to_latex(inline.content) .. '}')
    elseif inline.t == 'Superscript' then
      table.insert(result, '\\textsuperscript{' .. inlines_to_latex(inline.content) .. '}')
    else
      -- For other inline types, just stringify
      table.insert(result, pandoc.utils.stringify({inline}))
    end
  end
  return table.concat(result)
end

function Span(el)
  -- Convert .gl and .gloss to smallcaps (for grammatical glosses)
  if el.classes:includes('gl') or el.classes:includes('gloss') then
    if FORMAT:match 'latex' then
      return pandoc.RawInline('latex', '\\gl{' .. inlines_to_latex(el.content) .. '}')
    else
      -- For HTML/other formats, let CSS handle it
      return el
    end
  end
  
  -- Convert .smallcaps to generic smallcaps (stays as \textsc in LaTeX)
  if el.classes:includes('smallcaps') then
    if FORMAT:match 'latex' then
      return pandoc.RawInline('latex', '\\textsc{' .. pandoc.utils.stringify(el.content) .. '}')
    else
      return el
    end
  end
  
  -- Convert .ob to object language markup
  if el.classes:includes('ob') then
    if FORMAT:match 'latex' then
      return pandoc.RawInline('latex', '\\ob{' .. inlines_to_latex(el.content) .. '}')
    else
      return el
    end
  end
  
  -- Convert .rc to reconstructed form markup
  if el.classes:includes('rc') then
    if FORMAT:match 'latex' then
      return pandoc.RawInline('latex', '\\rc{' .. inlines_to_latex(el.content) .. '}')
    else
      -- For non-LaTeX formats, prepend asterisk and set to italic
      local content = pandoc.List:new(el.content)
      local text = pandoc.utils.stringify(content)
      -- Check if content already starts with asterisk
      if not text:match('^%*') then
        -- Prepend asterisk to the content list
        content:insert(1, pandoc.Str('*'))
      end
      -- Return span with italic emph
      return pandoc.Emph(content)
    end
  end
  
  -- Convert .pnt to phonetic notation [content]
  if el.classes:includes('pnt') then
    if FORMAT:match 'latex' then
      return pandoc.RawInline('latex', '\\pnt{' .. inlines_to_latex(el.content) .. '}')
    else
      -- For HTML/other formats, wrap with [ ]
      local content = pandoc.List:new(el.content)
      content:insert(1, pandoc.Str('['))
      content:insert(pandoc.Str(']'))
      return pandoc.Span(content)
    end
  end
  
  -- Convert .pnm to phonemic notation /content/
  if el.classes:includes('pnm') then
    if FORMAT:match 'latex' then
      return pandoc.RawInline('latex', '\\pnm{' .. inlines_to_latex(el.content) .. '}')
    else
      -- For HTML/other formats, wrap with / /
      local content = pandoc.List:new(el.content)
      content:insert(1, pandoc.Str('/'))
      content:insert(pandoc.Str('/'))
      return pandoc.Span(content)
    end
  end
  
  return el
end

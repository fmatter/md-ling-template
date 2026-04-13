--[[
linguistic-markup.lua - Pandoc Lua filter for linguistic semantic markup

Converts span classes to appropriate formatting:
- .gl or .gloss → smallcaps (for grammatical glosses)
- .ob → italics (for object language)
- .rc → asterisk + italics (for reconstructed forms)

For LaTeX output, these are converted to semantic commands (\gl, \ob, \rc)
which are defined in the template and can be customized by users.
]]

function Span(el)
  -- Convert .gl and .gloss to smallcaps (for grammatical glosses)
  if el.classes:includes('gl') or el.classes:includes('gloss') then
    if FORMAT:match 'latex' then
      return pandoc.RawInline('latex', '\\gl{' .. pandoc.utils.stringify(el.content) .. '}')
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
      return pandoc.RawInline('latex', '\\ob{' .. pandoc.utils.stringify(el.content) .. '}')
    else
      return el
    end
  end
  
  -- Convert .rc to reconstructed form markup
  if el.classes:includes('rc') then
    if FORMAT:match 'latex' then
      return pandoc.RawInline('latex', '\\rc{' .. pandoc.utils.stringify(el.content) .. '}')
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
  
  return el
end

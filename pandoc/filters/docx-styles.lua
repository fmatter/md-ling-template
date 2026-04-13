--[[
DOCX Character Styles Filter

Ensures custom character styles (.gl, .ob, .rc) work properly in DOCX output.
Pandoc needs character styles to be defined in the output, which this filter helps with.

For DOCX output:
- .gl (gloss) → small caps character style
- .ob (object language) → italic character style  
- .rc (reconstructed) → italic character style

The fix_docx.py script will ensure these styles are properly defined post-build.
]]

-- Only run for DOCX output
if FORMAT:match 'docx' then
  function Span(elem)
    -- Check if this span has one of our custom classes
    if elem.classes:includes('gl') or elem.classes:includes('gloss') then
      -- Mark as small caps for DOCX
      -- Pandoc will convert this to a character style
      elem.attributes['custom-style'] = 'gl'
      return elem
    elseif elem.classes:includes('ob') then
      -- Object language: italic
      elem.attributes['custom-style'] = 'ob'
      return elem
    elseif elem.classes:includes('rc') then
      -- Reconstructed: italic
      elem.attributes['custom-style'] = 'rc'
      return elem
    end
  end
end

(jsx_opening_element ["<" ">"] @jsx_brackets)
(jsx_closing_element ["</" ">"] @jsx_brackets)
(jsx_self_closing_element ["<" "/>"] @jsx_brackets)

(jsx_attribute (property_identifier) @jsx_attribute)

; inherits: _jsx,_typescript,ecma

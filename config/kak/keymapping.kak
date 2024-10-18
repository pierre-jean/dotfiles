map global normal <c-e> :edit<space> -docstring "Edit file"
map global normal <c-.> :bn<ret> -docstring "Next buffer"
map global normal <c-,> :bp<ret> -docstring "Previous buffer"
map global normal <c-q> :db<ret> -docstring "Delete file"

map global normal <c-/> alt-s:comment-line<ret>
map global normal <c-?> comment-block<ret>

map global user l '%{:enter-user-mode lsp<ret>}' -docstring "LSP mode"
map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'
map global object a '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
map global object <a-a> '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
map global object e '<a-semicolon>lsp-object Function Method<ret>' -docstring 'LSP function or method'
map global object k '<a-semicolon>lsp-object Class Interface Struct<ret>' -docstring 'LSP class interface or struct'

map global user y '<a-|>wl-copy<ret>' -docstring "Copy to clipboard"
map global user p '!wl-paste --no-newline<ret>' -docstring "Paste from clipboard (before)"
map global user P '<a-!>wl-paste --no-newline<ret>' -docstring "Paste from clipboard (after)"


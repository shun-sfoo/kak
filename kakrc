set global indentwidth 2
set global tabstop 2
set global indentwidth 2

add-highlighter global/number-lines number-lines -hlcursor

## Some pickers
define-command -hidden open_file_picker %{
  prompt file: -menu -shell-script-candidates 'fd --type=file' %{
    edit -existing %val{text}
  }
}

# Tree-sitter
eval %sh{ kak-tree-sitter -dks --init "$kak_session" --with-highlighting --with-text-objects -vvv }
colorscheme catppuccin_macchiato

# LSP
eval %sh{ kak-lsp --kakoune -s $kak_session }
lsp-enable
lsp-inlay-code-lenses-enable global
lsp-inlay-diagnostics-enable global
lsp-inlay-hints-enable global
lsp-diagnostic-lines-disable global
lsp-auto-signature-help-enable
set-option global lsp_auto_show_code_actions true

# keybindings

hook global InsertChar k %{ try %{
  exec -draft hH <a-k>jk<ret> d
  exec -with-hooks <esc>
}}

## prompt
map global prompt <c-p> <s-tab>
map global prompt <c-n> <tab>

## insert mode C-w
map global insert <c-w> '<esc>:execute-keys bd<ret>i'

## convenience
map global user $ ':e -existing ~/.config/kak/kakrc<ret>' -docstring 'edit Kakoune configuration'

# comment
map global user c ':comment-line<ret>' -docstring 'comment line'

map global user f ':open_file_picker<ret>'   -docstring 'pick file'

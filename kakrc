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

## kitty integration need set `allow_remote_control yes` ctrl+shift+{1, 2,,3} focous specif window to switch window
define-command kitty-split -params 1 -docstring 'split the current window according to  the param (vsplit /hsplit)' %{
  nop %sh{
    kitty @ launch --no-response --location $1 kak -c $kak_session
  }
}


## tmux integration
define-command tmux-split -params 1 -docstring 'split (down / right)' %{
  nop %sh{
    tmux split-window $1 kak -c $kak_session
  }
}

define-command tmux-select-pane -params 1 -docstring 'select pane' %{
  nop %sh{
    tmux select-pane $1
  }
}

map global user w ':enter-user-mode window-tmux<ret>' -docstring 'window mode'

declare-user-mode window-tmux
map global window-tmux Q ':q!<ret>'                  -docstring 'close window (force)'
map global window-tmux c ':tmux-select-pane -L<ret>' -docstring 'move left'
map global window-tmux o ':tmux-split -v<ret>'       -docstring 'horizontal split'
map global window-tmux q ':q<ret>'                   -docstring 'close window'
map global window-tmux r ':tmux-select-pane -R<ret>' -docstring 'move right'
map global window-tmux s ':tmux-select-pane -U<ret>' -docstring 'move up'
map global window-tmux t ':tmux-select-pane -D<ret>' -docstring 'move down'
map global window-tmux v ':tmux-split -h<ret>'       -docstring 'vertical split'


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

# faces / colorschemes
## inlay hints (type annotations, etc.)
set-face global PrimaryCursor "black,%opt{mauve}"
set-face global PrimarySelection default,bright-black
set-face global PrimaryCursorEol "black,%opt{mauve}"

set-face global SecondaryCursor black,white
set-face global SecondarySelection default,black
set-face global SecondaryCursorEol black,white

set-face global MenuForeground "black,%opt{mauve}"
set-face global MenuInfo "%opt{mauve},black"
set-face global Information "%opt{mauve},default"
set-face global StatusLine "%opt{white},%opt{black1}"
set-face global StatusLineMode "%opt{red}+i"
set-face global StatusLineInfo "%opt{mauve}"
set-face global StatusLineValue "%opt{orange}"
set-face global StatusCursor "black,%opt{mauve}"
set-face global Prompt "%opt{mauve}"
set-face global InlayHint black+i
set-face global InlayCodeLens comment
set-face global DiagnosticInfo "%opt{blue}"
set-face global DiagnosticHint "%opt{mauve}"
set-face global DiagnosticWarning "%opt{orange}"
set-face global DiagnosticError "%opt{red}"


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

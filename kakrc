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

define-command  open_buffer_picker %{
  prompt buffer: -menu -buffer-completion %{
    buffer %val{text}
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
map global window-tmux h ':tmux-select-pane -L<ret>' -docstring 'move left'
map global window-tmux l ':tmux-select-pane -R<ret>' -docstring 'move right'
map global window-tmux j ':tmux-select-pane -U<ret>' -docstring 'move up'
map global window-tmux k ':tmux-select-pane -D<ret>' -docstring 'move down'
map global window-tmux p ':tmux-split -v<ret>'       -docstring 'horizontal split'
map global window-tmux v ':tmux-split -h<ret>'       -docstring 'vertical split'
map global window-tmux q ':q<ret>'                   -docstring 'close window'


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

## buffers
declare-user-mode user-buffer
map global user b ':enter-user-mode user-buffer<ret>' -docstring 'buffers'
map global user-buffer b ':open_buffer_picker<ret>'   -docstring 'pick buffer'
map global user-buffer d ':db<ret>'                   -docstring 'delete buffer'
map global user-buffer D ':db!<ret>'                  -docstring 'force-delete buffer'
map global user-buffer ( ':buffer-previous<ret>'      -docstring 'previous buffer'
map global user-buffer ) ':buffer-next<ret>'          -docstring 'next buffer'

## LSP
declare-user-mode user-lsp
map global user l ':enter-user-mode user-lsp<ret>'      -docstring 'lsp mode'
map global user-lsp a ':lsp-code-actions<ret>'          -docstring 'code action'
map global user-lsp c ':lsp-code-lens<ret>'             -docstring 'execute code lens'
map global user-lsp d ':lsp-diagnostics<ret>'           -docstring 'list diagnostics'
map global user-lsp h ':lsp-highlight-references<ret>'  -docstring 'highlight references'
map global user-lsp I ':lsp-implementation<ret>'        -docstring 'list implementations'
map global user-lsp i ':lsp-incoming-calls<ret>'        -docstring 'incoming calls'
map global user-lsp K ':lsp-hover-buffer<ret>'          -docstring 'hover in a dedicated buffer'
map global user-lsp k ':lsp-hover<ret>'                 -docstring 'hover'
map global user-lsp l ':lsp-code-lens<ret>'             -docstring 'run a code lens'
map global user-lsp ) ':lsp-next-function<ret>'         -docstring 'jump to the next function'
map global user-lsp ( ':lsp-previous-function<ret>'     -docstring 'jump to the previous function'
map global user-lsp o ':lsp-outgoing-calls<ret>'        -docstring 'outgoing calls'
map global user-lsp p ':lsp-workspace-symbol-incr<ret>' -docstring 'pick workspace symbol'
map global user-lsp P ':lsp-workspace-symbol<ret>'      -docstring 'list workspace symbols'
map global user-lsp r ':lsp-references<ret>'            -docstring 'list references'
map global user-lsp R ':lsp-rename-prompt<ret>'         -docstring 'rename'
map global user-lsp S ':lsp-document-symbol<ret>'       -docstring 'list workspace symbols'
map global user-lsp s ':lsp-goto-document-symbol<ret>'  -docstring 'pick document symbol'
map global user-lsp x ':lsp-find-error<ret>'            -docstring 'jump to the prev/next error'
map global insert <c-h> '<a-;>:lsp-signature-help<ret>'    -docstring 'show signature help'
map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'

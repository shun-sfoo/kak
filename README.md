# kak

my kakoune editor config

## theme

catppuccin_macchiato

use `kitty +kitten themes` choose catppuccin_macchiato theme


## Outdoor executor

```bash
sudo pacman -S --need llvm ripgrep fd kakoune kakoune-lsp
```

### Rust Executor

```bash
cargo install kak-tree-sitter ktsctl
# usage
ktsctl sync -a # to install all ts language
ktsctl query -a
```



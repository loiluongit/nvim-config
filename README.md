# nvim-config

Personal Neovim configuration, managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

## Requirements

- Neovim >= 0.11 (built and tested on 0.12)
- `git`
- `ripgrep` (Telescope live grep)
- `make` + a C compiler (builds `telescope-fzf-native`)
- [`lazygit`](https://github.com/jesseduffield/lazygit) (git TUI, opened from inside Neovim)
- A [Nerd Font](https://www.nerdfonts.com/) set in your terminal (icons in neo-tree, lualine, telescope)

## Setup

### New machine (macOS + Homebrew)

```bash
git clone <your-repo-url> ~/projects/loiluongit-newvim
cd ~/projects/loiluongit-newvim
./install.sh
```

[`install.sh`](install.sh) is idempotent — it checks each dependency and the `~/.config/nvim` symlink individually and skips anything already present, installing only what's missing, then syncs plugins/LSP servers/treesitter parsers.

### Manual

```bash
git clone <your-repo-url> ~/.config/nvim
nvim
```

`lazy.nvim` bootstraps itself on first launch and installs the exact plugin versions pinned in `lazy-lock.json`.

## Structure

```
init.lua                  # entry point: loads core, bootstraps lazy.nvim, imports plugins/
lazy-lock.json            # pinned plugin versions
install.sh                # idempotent setup script for a new machine
ghostty/
  config                  # Ghostty terminal config, symlinked to ~/.config/ghostty/config
lua/
  core/
    options.lua            # vim.o settings
    keymaps.lua             # leader key + general keymaps
  plugins/                 # one file per plugin, auto-imported by init.lua
    colortheme.lua          # nord.nvim
    neotree.lua              # file explorer
    treesitter.lua           # syntax highlighting/indent (master branch)
    lsp.lua                  # mason.nvim + native vim.lsp.config/enable
    blink.lua                # completion
    telescope.lua            # fuzzy finder
    lualine.lua               # statusline
    gitsigns.lua              # git gutter signs
    lazygit.lua                # lazygit floating terminal
    editor.lua                # autopairs + Comment.nvim
```

Adding a new plugin means dropping a new file in `lua/plugins/` — no other wiring needed.

## Keymaps

Leader key is `<Space>`.

### General

| Keys | Action |
|---|---|
| `<C-s>` | Save file |
| `<leader>sn` | Save without auto-formatting |
| `<C-q>` | Quit |
| `<Tab>` / `<S-Tab>` | Next / previous buffer |
| `<leader>b` | New buffer |
| `<leader>x` | Close buffer |
| `<leader>v` / `<leader>h` | Split vertically / horizontally |
| `<C-h/j/k/l>` | Navigate splits |
| `<leader>to/tx/tn/tp` | New / close / next / previous tab |
| `<leader>lw` | Toggle line wrap |
| `<leader>bg` | Toggle background transparency |
| `<D-Left>` / `<D-Right>` | Start / end of line (VSCode-style, needs Ghostty — see below) |
| `<D-Up>` / `<D-Down>` | Top / bottom of file |

### Files / search (Telescope)

| Keys | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fo` | Recent files |
| `<leader>fk` | Search keymaps |

### Git (lazygit)

| Keys | Action |
|---|---|
| `<leader>gg` | Open lazygit (floating) |
| `<leader>gf` | Open lazygit filtered to current file |

### File explorer (neo-tree)

| Keys | Action |
|---|---|
| `<leader>e` | Toggle explorer |
| `\` | Reveal current file |
| `<leader>ngs` | Git status (float) |

### LSP

| Keys | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover docs |
| `<leader>rn` | Rename |
| `<leader>ca` | Code action |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>d` | Line diagnostics (float) |
| `<leader>q` | Diagnostics list |

## Ghostty (Cmd-key navigation)

Terminal Neovim never sees the macOS Cmd key by default — the terminal emulator
swallows it. [`ghostty/config`](ghostty/config) forwards `Cmd`+arrow to the running
program as CSI-u sequences with the super modifier (`1;9<dir>`), which Neovim 0.11
decodes as `<D-Left>`, `<D-Right>`, `<D-Up>`, `<D-Down>`. The maps themselves live in
[`lua/core/keymaps.lua`](lua/core/keymaps.lua).

`install.sh` symlinks `~/.config/ghostty/config` to this file (backing up any existing
one). After a change, reload with `Cmd+Shift+,` or restart Ghostty.

Requires Ghostty >= 1.3 and Neovim >= 0.11 (kitty keyboard protocol).

`Cmd+C` / `Cmd+V` are deliberately **not** remapped: Ghostty has no per-app keybinds, so
forwarding them would break normal terminal copy/paste in every other program. Since
`vim.o.clipboard = 'unnamedplus'` is set, plain `y` and `p` already use the macOS
clipboard.

Not on Ghostty? Skip it — everything else works, only the `<D-...>` maps go dead.

## Updating plugins

```vim
:Lazy sync
```

Updates `lazy-lock.json` — commit that file after upgrading so other machines pick up the same versions.

## Adding an LSP server

Edit [`lua/plugins/lsp.lua`](lua/plugins/lsp.lua):

1. Add the server name to `ensure_installed` in the `mason-lspconfig` opts
2. Add a `vim.lsp.config('<server>', { ... })` call if it needs custom settings
3. Add the server name to the `vim.lsp.enable { ... }` list

# loiluongit-newvim

Personal Neovim configuration, managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

## Requirements

- Neovim >= 0.11 (built and tested on 0.12)
- `git`
- `ripgrep` (Telescope live grep)
- `make` + a C compiler (builds `telescope-fzf-native`)
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

### Files / search (Telescope)

| Keys | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fo` | Recent files |
| `<leader>fk` | Search keymaps |

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

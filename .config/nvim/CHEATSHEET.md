# Neovim Cheatsheet

Personal reference for my `init.lua` (kickstart-based, using `vim.pack`).
Leader key: `<Space>`

---

## 🗂️ File Explorer

| Keymap | Action |
|---|---|
| `<leader>e` | Toggle default file explorer (currently **oil**) |
| `<leader>eo` | Open **oil.nvim** (buffer-style explorer) |
| `<leader>en` | Toggle **neo-tree** (sidebar tree) |
| `-` | Open parent directory (oil) |
| `` ` `` | Set cwd to current explored folder |

**Oil tips:** edit the buffer like text to rename/create/delete files, then `:w` to apply. `-` goes up a directory.

---

## 🌿 Git

| Keymap | Action |
|---|---|
| `<leader>j` | Open **LazyGit** floating window |
| `<leader>gd` | `DiffviewOpen` — open Git diff view |
| `<leader>gc` | `DiffviewClose` — close Git diff view |

Gitsigns is enabled with inline current-line blame (gutter signs for add/change/delete are on by default; no custom keymaps set yet — `<leader>h` is reserved as the "Git Hunk" group in which-key for when you add them).

---

##  Search (Telescope)

| Keymap | Action |
|---|---|
| `<leader>sf` | Search **f**iles |
| `<leader>sa` | Search **a**ll files, including hidden/`.env` |
| `<leader>sg` | Search by **g**rep (live grep) |
| `<leader>s/` | Live grep in open files only |
| `<leader>sw` | Search current **w**ord under cursor (normal + visual) |
| `<leader>sd` | Search **d**iagnostics |
| `<leader>sh` | Search **h**elp tags |
| `<leader>sk` | Search **k**eymaps |
| `<leader>sc` | Search **c**ommands |
| `<leader>ss` | Search/**s**elect a Telescope picker (builtin) |
| `<leader>sr` | **R**esume last search |
| `<leader>s.` | Search recent files (oldfiles) |
| `<leader>sn` | Search **N**eovim config files |
| `<leader><leader>` | Find existing buffers |
| `<leader>/` | Fuzzy search in current buffer |

---

## 🧠 LSP

### Navigation (via Telescope, on `LspAttach`)
| Keymap | Action |
|---|---|
| `gd` | Goto **D**efinition |
| `gr` | Goto **R**eferences |
| `gi` | Goto **I**mplementation |
| `gt` | Goto **T**ype definition |
| `gO` | Document symbols (current file) |
| `gW` | Workspace symbols (whole project) |

### Actions
| Keymap | Action |
|---|---|
| `grn` | **R**e**n**ame symbol (LSP, updates imports) |
| `<leader>rn` | Rename symbol and updates imports (alt binding) |
| `gra` | Goto Code **A**ction (normal + visual) |
| `grD` | Goto **D**eclaration |
| `<leader>oi` | **O**rganize **I**mports |
| `<leader>th` | **T**oggle inlay **h**ints (if LSP supports it) |
| `<C-l>` *(insert mode)* | Manually trigger completion menu (blink.cmp) |

Cursor resting on a symbol auto-highlights other references in the buffer.

---

## ⚠️ Diagnostics

| Keymap | Action |
|---|---|
| `<leader>q` | Open diagnostics in the quickfix list |
| `]d` / `[d` | Jump to next/previous diagnostic (opens a float automatically) |
| `*` | Find word under cursor (builtin vim) |

---

## 🎨 Formatting

| Keymap | Action |
|---|---|
| `<leader>f` | Format buffer (conform.nvim — Lua via stylua, JS/TS via prettierd/prettier) |

---

## ✂️ Text Objects & Surround (mini.nvim)

| Keymap | Action |
|---|---|
| `va)` | **V**isually select **a**round `()` |
| `yiiq` | **Y**ank **i**nside next quote |
| `ci'` | **C**hange **i**nside `'quote'` |
| `aa` / `ii` | Around/inside *next* textobject (mini.ai custom mapping) |
| `saiw)` | **S**urround **a**dd **i**nner **w**ord with `()` |
| `sd'` | **S**urround **d**elete `'quotes'` |
| `sr)'` | **S**urround **r**eplace `()` → `''` |

---

## 📝 Markdown

| Keymap | Action |
|---|---|
| `<leader>mt` | **T**oggle markdown rendering globally (`RenderMarkdown toggle`) |
| `<leader>md` | Toggle markdown rendering for current **b**uffer only (`RenderMarkdown buf_toggle`) |

---

## 🪟 Windows, Buffers & Folds

| Keymap | Action |
|---|---|
| `<M-h>` / `<M-l>` / `<M-j>` / `<M-k>` | Move focus left/right/down/up between windows |
| `bd` | Delete (close) current buffer |
| `za` | Toggle fold |
| `zo` / `zc` | Open / close fold |

---

## 💬 Misc

| Keymap | Action |
|---|---|
| `<leader>w` | Save file (`:update`) |
| `<Esc>` | Clear search highlight |
| `<Esc><Esc>` *(terminal mode)* | Exit terminal mode back to normal |
| `yap` | Yank a paragraph (also flashes a highlight on any yank) |

---

## 🔧 Ex Commands

| Command | Action |
|---|---|
| `:g/console.log/d` | Delete every line containing `console.log` |
| `:Mason` | Open Mason UI to manage installed LSPs/formatters |
| `:TSUpdate` | Update Treesitter parsers |
| `:lua vim.pack.update(nil, { offline = true })` | Check pending plugin updates |
| `:lua vim.pack.update()` | Update all plugins |
| `:Telescope colorscheme` | Preview/switch installed colorschemes |

---

## 🔌 Plugin Stack (quick reference)

- **Explorer:** oil.nvim, neo-tree.nvim
- **Git:** gitsigns.nvim, diffview.nvim, lazygit.nvim
- **UI:** which-key.nvim, tokyonight.nvim, todo-comments.nvim, fidget.nvim, mini.icons, mini.statusline
- **Markdown:** render-markdown.nvim
- **Search:** telescope.nvim (+ fzf-native, ui-select)
- **LSP:** nvim-lspconfig, mason.nvim, mason-lspconfig.nvim, mason-tool-installer.nvim
- **Formatting:** conform.nvim (stylua, prettierd)
- **Completion:** blink.cmp, LuaSnip
- **Treesitter:** nvim-treesitter (main branch)
- **Editing:** mini.ai, mini.surround, guess-indent.nvim

---

*Generated from `init.lua` — update this file as you add new keymaps.*

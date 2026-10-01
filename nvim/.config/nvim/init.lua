vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- Appearance ------------------------------------------------------------
opt.number = true            -- line numbers
opt.relativenumber = true    -- ...counted from the cursor, so "5j" is easy to read
opt.cursorline = true        -- highlight the current line
opt.termguicolors = true     -- full colour (needs tmux's RGB setting inside tmux)
opt.scrolloff = 8            -- keep 8 lines visible above and below the cursor
opt.wrap = false             -- long lines scroll sideways instead of wrapping
opt.list = true              -- make tabs and trailing spaces visible...
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
                             -- ...which matters for YAML, where a tab is an error

-- Editing ---------------------------------------------------------------
opt.expandtab = true         -- Tab inserts spaces
opt.shiftwidth = 2           -- indent by 2
opt.tabstop = 2
opt.smartindent = true
opt.undofile = true          -- undo history survives closing the file
opt.mouse = "a"              -- click, scroll and select with the mouse
opt.confirm = true           -- :q with unsaved changes asks instead of refusing
opt.timeoutlen = 500         -- how long Neovim waits for the second key of
                             -- hh, vv and Space sequences (default 1000 ms)

-- Search ----------------------------------------------------------------
opt.ignorecase = true        -- case-insensitive search...
opt.smartcase = true         -- ...unless you type a capital letter

-- Windows ---------------------------------------------------------------
opt.splitright = true        -- new vertical splits open on the right
opt.splitbelow = true        -- new horizontal splits open below

-- Finding files ---------------------------------------------------------
opt.path:append("**")        -- :find searches subdirectories
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*/node_modules/*", "*/.git/*" })

if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end

-- Built-in file explorer (netrw) ----------------------------------------
vim.g.netrw_banner = 0       -- hide the help banner
vim.g.netrw_liststyle = 3    -- tree view

-- Clipboard -------------------------------------------------------------
-- Locally (Mac, Windows, a Linux desktop) "+ is the system clipboard and
-- needs nothing here. Over SSH there's no local clipboard, so copies are
-- sent through the terminal to the machine you're connecting from (OSC 52).
-- Pasting from that machine: Cmd-V / Ctrl-Shift-V in Insert mode as usual.
local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
if ok and vim.env.SSH_TTY then
  local function paste()
    return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end

-- Autocommands ----------------------------------------------------------
local group = vim.api.nvim_create_augroup("config", { clear = true })

-- Briefly highlight whatever you just copied
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function() (vim.hl or vim.highlight).on_yank() end,
})

-- Reopen files at the line you left them
vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- sudoedit edits temporary copies of root-owned files. Don't write undo
-- history or swap files for them — they'd leave copies of files like
-- WireGuard private keys readable in your home directory.
-- (/private/... covers macOS, where /tmp and /var are symlinks.)
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = group,
  pattern = { "/tmp/*", "/var/tmp/*", "/private/tmp/*", "/private/var/tmp/*" },
  callback = function()
    vim.opt_local.undofile = false
    vim.opt_local.swapfile = false
  end,
})

-- netrw has its own "i" key (it cycles the listing style). Give "i" its
-- movement meaning back inside the file explorer.
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "netrw",
  callback = function(ev)
    vim.keymap.set("n", "i", "k", { buffer = ev.buf, nowait = true })
  end,
})

-- Keys ------------------------------------------------------------------
local map = vim.keymap.set

-- Layout: i j k l = up left down right, h = insert ----------------------
-- Applied in Normal, Visual and operator-pending modes, so "dk" deletes
-- downwards and counts work ("5i" moves up 5). h takes over everything i
-- did, including "inner" text objects: ciw becomes chw.
for _, mode in ipairs({ "n", "x", "o" }) do
  map(mode, "i", "k")
  map(mode, "j", "h")
  map(mode, "k", "j")
  map(mode, "h", "i")
end
map("n", "H", "I", { desc = "Insert at start of line" })

-- hh leaves Insert mode, vv leaves Visual mode
map("i", "hh", "<Esc>", { desc = "Exit insert mode" })
map("x", "vv", "<Esc>", { desc = "Exit visual mode" })

map("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>", { desc = "Clear search highlight" })
map({ "n", "i", "x" }, "<C-s>", "<cmd>w<cr><Esc>", { desc = "Save" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Files
map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "File explorer" })
map("n", "<leader><space>", ":find ", { desc = "Find file" })
map("n", "<leader>ff", ":find ", { desc = "Find file" })
map("n", "<leader>fb", ":buffer ", { desc = "Switch to open file" })
map("n", "<leader>sg", ":grep ", { desc = "Search text in files" })

-- Open files (buffers)
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous file" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next file" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close file" })

-- Windows (splits)
-- Ctrl-i can't be used: terminals send the same signal for Ctrl-i and Tab
map("n", "<leader>wi", "<C-w>k", { desc = "Window up" })
map("n", "<leader>wj", "<C-w>h", { desc = "Window left" })
map("n", "<leader>wk", "<C-w>j", { desc = "Window down" })
map("n", "<leader>wl", "<C-w>l", { desc = "Window right" })
map("n", "<leader>-", "<C-w>s", { desc = "Split below" })
map("n", "<leader>|", "<C-w>v", { desc = "Split right" })
map("n", "<leader>wd", "<C-w>c", { desc = "Close window" })

-- Keep the selection after indenting
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Copy to the system clipboard
map({ "n", "x" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })

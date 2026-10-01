vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- Appearance ------------------------------------------------------------
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.scrolloff = 8
opt.wrap = false
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Editing ---------------------------------------------------------------
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.undofile = true
opt.mouse = "a"
opt.confirm = true
opt.timeoutlen = 250

-- Search ----------------------------------------------------------------
opt.ignorecase = true
opt.smartcase = true

-- Windows ---------------------------------------------------------------
opt.splitright = true
opt.splitbelow = true

-- Finding files ---------------------------------------------------------
opt.path:append("**")
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*/node_modules/*", "*/.git/*" })

if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end

-- Built-in file explorer (netrw) ----------------------------------------
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

-- Clipboard -------------------------------------------------------------
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

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function() (vim.hl or vim.highlight).on_yank() end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = group,
  pattern = { "/tmp/*", "/var/tmp/*", "/private/tmp/*", "/private/var/tmp/*" },
  callback = function()
    vim.opt_local.undofile = false
    vim.opt_local.swapfile = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "netrw",
  callback = function(ev)
    vim.keymap.set("n", "i", "k", { buffer = ev.buf, nowait = true })
  end,
})

-- Keys ------------------------------------------------------------------
local map = vim.keymap.set

for _, mode in ipairs({ "n", "x", "o" }) do
  map(mode, "i", "k")
  map(mode, "j", "h")
  map(mode, "k", "j")
  map(mode, "h", "i")
end
map("n", "H", "I", { desc = "Insert at start of line" })

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

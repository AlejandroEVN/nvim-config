local opt = vim.opt
local global_opt = vim.go
local window_opt = vim.wo

-- Set highlight on search
opt.hlsearch = false
-- Make line numbers default
window_opt.number = true

-- Enable mouse mode
opt.mouse = "a"
global_opt.number = true
opt.relativenumber = true

-- Sync clipboard between OS and Neovim.
opt.clipboard = "unnamedplus"

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
opt.ignorecase = true
opt.smartcase = true

-- Keep signcolumn on by default
window_opt.signcolumn = "yes"

opt.shada = { "'10", "<0", "s10", "h" }

-- Decrease update time
opt.updatetime = 250
opt.timeoutlen = 300

-- When opening a new window, it will be put below and to the right of the current one
opt.splitbelow = true
opt.splitright = true

-- Set completeopt to have a better completion experience
opt.completeopt = "menuone,noselect"

opt.termguicolors = true

-- A TAB character looks like 4 spaces
opt.tabstop = 4
-- Pressing the TAB key will insert spaces instead of a TAB character
opt.expandtab = true
-- Number of spaces inserted instead of a TAB character
opt.softtabstop = 4
-- Number of spaces inserted when indenting
opt.shiftwidth = 4

-- Don't insert comment automatically when hitting 'o' or 'O'
opt.formatoptions:remove("o")

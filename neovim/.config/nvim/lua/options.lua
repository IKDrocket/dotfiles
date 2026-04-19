-- エンコーディング
vim.opt.encoding = "utf-8"

-- ファイル管理
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.hidden = true

-- 表示
vim.opt.number = true
vim.opt.showcmd = true
vim.opt.virtualedit = "onemore"
vim.opt.smartindent = true
vim.opt.showmatch = true
vim.opt.laststatus = 2
vim.opt.wildmode = "list:longest"
vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.listchars = { tab = "▸-" }

-- タブ・インデント
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- 検索
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.wrapscan = true
vim.opt.hlsearch = true

-- クリップボード
vim.opt.clipboard = "unnamedplus"

-- ウィンドウ分割
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 行頭/行末で左右カーソルが前後の行に移動する
vim.opt.whichwrap = "b,s,<,>,[,]"

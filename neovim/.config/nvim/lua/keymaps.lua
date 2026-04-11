vim.g.mapleader = " "

-- j/k を表示行単位で移動（折り返し対応）
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- LSP基本操作
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gh", vim.lsp.buf.hover)
vim.keymap.set("n", "ga", vim.lsp.buf.code_action)
vim.keymap.set("n", "gf", vim.lsp.buf.format)
vim.keymap.set("n", "gn", vim.lsp.buf.rename)
vim.keymap.set("n", "go", vim.diagnostic.open_float)

-- nvim-tree
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>")

-- Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")

-- PlantUML
vim.keymap.set("n", "<leader>pu", "<cmd>PlantumlOpen<cr>", { desc = "PlantUML preview" })


vim.g.mapleader = " "

-- j/k を表示行単位で移動（折り返し対応）
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gh", vim.lsp.buf.hover)
vim.keymap.set("n", "ga", vim.lsp.buf.code_action)
vim.keymap.set("n", "gf", vim.lsp.buf.format)
vim.keymap.set("n", "gn", vim.lsp.buf.rename)
vim.keymap.set("n", "go", vim.diagnostic.open_float)

-- ファイルツリー / ファジーファインダー
vim.keymap.set("n", "<D-S-e>", "<cmd>NvimTreeFindFileToggle<cr>")
vim.keymap.set("n", "<D-p>", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<D-S-F>", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<D-b>", "<cmd>Telescope buffers<cr>")

-- Git
vim.keymap.set("n", "]g", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next git hunk" })
vim.keymap.set("n", "[g", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Previous git hunk" })
vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview git hunk" })
vim.keymap.set("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage git hunk" })
vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset git hunk" })
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Git blame" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", { desc = "Git diff (inline)" })
vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewOpen<cr>", { desc = "Git diff view" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File git history" })
vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close diff view" })

-- PlantUML
vim.keymap.set("n", "<leader>pu", "<cmd>PlantumlOpen<cr>", { desc = "PlantUML preview" })

return {
  -- カラースキーム
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- シンタックスハイライト
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "lua", "python", "go", "typescript", "javascript", "json", "yaml", "markdown", "bash" },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- LSP
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      -- capabilities をグローバルに設定（全サーバーに適用）
      vim.lsp.config('*', {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
      -- インストール済みサーバーは automatic_enable（デフォルト true）で自動的に vim.lsp.enable() される
      require("mason-lspconfig").setup({
        ensure_installed = { "bashls" },
        automatic_installation = false,
      })
    end,
  },
  { "neovim/nvim-lspconfig" },

  -- GitHub Copilot
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<Tab>",
            dismiss = "<C-]>",
          },
        },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- オートコンプリート
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "zbirenbaum/copilot-cmp" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "copilot", priority = 100 },
          { name = "nvim_lsp" },
        }),
      })
    end,
  },
  { "hrsh7th/cmp-nvim-lsp" },

  -- ファジーファインダー
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        pickers = {
          buffers = {
            mappings = {
              i = { ["<C-x>"] = require("telescope.actions").delete_buffer },
              n = { ["<C-x>"] = require("telescope.actions").delete_buffer },
            },
          },
        },
      })
    end,
  },

  -- 括弧の自動補完
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- ファイルツリー
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
      })
    end,
  },

  -- PlantUML
  {
    "tyru/open-browser.vim",
    lazy = true,
  },
  {
    "weirongxu/plantuml-previewer.vim",
    dependencies = { "tyru/open-browser.vim" },
    ft = { "plantuml" },
  },
  {
    "aklt/plantuml-syntax",
    ft = { "plantuml" },
  },

  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          component_separators = "|",
          section_separators = "",
        },
      })
    end,
  },
}

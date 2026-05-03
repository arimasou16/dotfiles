return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x", -- 安定版
    dependencies = {
      "nvim-lua/plenary.nvim", -- 必須の裏方ライブラリ
    },
    opts = {
      defaults = {
        initial_mode = "normal",
      },
    },
    keys = {
      -- <leader> はバックスラッシュに設定済みなので、\ff などで起動します
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "ファイル検索" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "文字列検索 (grep)" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "バッファ検索" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "ヘルプ検索" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "最近開いたファイル" },
      {
        "<leader>ml",
        function()
          require('telescope.builtin').find_files({
            cwd = vim.fn.expand(vim.g.hugo_directory .. "/content/post"),
            prompt_title = "Memo List",
          })
        end,
        desc = "Memo List",
      },
      {
        "<leader>mg",
        function()
          require('telescope.builtin').live_grep({
            cwd = vim.fn.expand(vim.g.hugo_directory .. "/content/post"),
            prompt_title = "Memo Grep",
          })
        end,
        desc = "Memo Grep",
      },
      { "<leader>mn", "<cmd>HugoNewPost<CR>", desc = "Hugo New Post" },
    },
  },
}

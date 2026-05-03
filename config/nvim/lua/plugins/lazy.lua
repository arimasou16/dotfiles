local fn = vim.fn

return {
  "vim-jp/vimdoc-ja",

  -- === Deno依存プラグイン (skkeleton関連) ===
  {
    "vim-denops/denops.vim",
    -- denoコマンドがインストールされている場合のみ読み込む
    cond = fn.executable("deno") == 1,
  },

  -- === 編集・ユーティリティ ===
  {
    "dhruvasagar/vim-table-mode",
    -- Markdownのテーブル（角が `+` ではなく `|` ）に合わせる一般的な設定
    init = function()
      vim.g.table_mode_corner = "|"
    end,
    -- コマンドが打たれた時だけプラグインを読み込む（起動高速化）
    cmd = { "TableModeToggle", "TableModeEnable" },
  },
  {
    "mattn/vim-maketable",
    cmd = "MakeTable",
  },
  {
    "tyru/open-browser.vim",
    cmd = { "OpenBrowser", "OpenBrowserSearch" },
  },

  -- === Git関連 ===
  {
    "tpope/vim-fugitive",
    -- :G や :Git などのコマンド実行時に遅延読み込み
    cmd = { "G", "Git", "Gdiffsplit", "Gvdiffsplit", "Gblame" },
  },

  -- === UI・ファイラー ===
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- アイコン用（不要なら削除可）
    -- opts = {} を書くことで setup() が走り、ステータスラインが表示されます
    opts = {
      options = {
        theme = "auto", -- 現在のカラースキームに自動で色を合わせる
      },
    },
  },
  {
    "stevearc/oil.nvim",
    -- Neovim標準のファイラー(netrw)をoilに置き換える必須設定
    opts = {
      default_file_explorer = true,
    },
    -- `-` (ハイフン) で親ディレクトリを開くのがデファクトスタンダードの操作です
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "親ディレクトリを開く (oil)" },
    },
  },

  -- === スニペットエンジン ===
  {
    "L3MON4D3/LuaSnip",
    -- バージョン指定が推奨されています
    version = "v2.*",
    -- 有効化
    opts = {},
  },

  -- === 自作/個人設定 ===
  {
    "arimasou16/functions.vim",
    -- 特に初期設定が不要なものは、文字列のままでそのまま読み込ませます
  },

  -- Markdown関連
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      -- 先にプラグインを強制ロードしてから関数を呼ぶ
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
  },
}

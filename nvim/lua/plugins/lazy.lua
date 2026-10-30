local fn = vim.fn

return {
  "vim-jp/nvimdoc-ja",
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
    build = "make install_jsregexp",
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
    build = "cd app && yarn install && git checkout app/yarn.lock",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },
  {
    "subnut/nvim-ghost.nvim",
    init = function()
      vim.g.nvim_ghost_server_port = 4001 -- デフォルトは 4001
      vim.g.nvim_ghost_super_quiet = 1  -- 通知ログを抑える場合
      vim.g.nvim_ghost_disabled = 0 -- 有効/無効
    end,
    config = function()
      -- 接続する Web サイトごとにファイルタイプ（filetype）などを変更する自動コマンド
      local group = vim.api.nvim_create_augroup("nvim_ghost_user_autocommands", { clear = false })

      -- 例: GitHub や Stack Overflow、Reddit では Markdown モードにする
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = { "*github.com", "*stackoverflow.com", "*reddit.com" },
        callback = function(ev)
          vim.opt_local.filetype = "mail"
          -- :w や :wq の書き込みエラーを防ぐ設定
          vim.opt_local.buftype = "acwrite"
          vim.api.nvim_create_autocmd("BufWriteCmd", {
            buffer = ev.buf,
            callback = function()
              -- 保存処理の代わりに「未保存フラグ」を下ろして正常終了させる
              vim.bo[ev.buf].modified = false
            end,
          })
        end,
      })
    end,
  },
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = {
      "hrsh7th/nvim-cmp", -- nvim-cmp を追加
    },
    config = function()
      require("minuet").setup({
        provider = "gemini",
        provider_options = {
          gemini = {
            model ="gemini-flash-lite-latest", -- 高速かつ無料枠が広いモデル
            api_key = "GEMINI_API_KEY",        -- 環境変数から読み込み
            -- 思考バジェット（トークン数）を 0 に設定してオフにする
            thinking_config = {
                thinking_budget = 0,
            },
          },
        },
        virtualtext = {
          -- 自動補完したいファイルタイプ（全指定は "*"、手動のみにする場合は空文字列 {}）
          auto_trigger_ft = {},
          keymap = {
            -- next や prev に設定したキーを押すと、補完が手動で呼び出されます
            next = "<C-y>",        -- 手動で補完を呼び出す / 次の候補へ
            prev = "<A-p>",        -- 前の候補へ
            accept = "<A-y>",      -- AIの提案を採用（確定）
            accept_line = "<A-l>", -- 1行だけ採用
            dismiss = "<A-e>",     -- 提案を消去
          },
        },
      })
    end,
  },
}

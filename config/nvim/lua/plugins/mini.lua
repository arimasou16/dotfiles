return {
  { "echasnovski/mini.align", version = false, opts = {} },
  { "echasnovski/mini.bufremove", version = false, opts = {} },
  { "echasnovski/mini.surround", version = false, opts = {} },
  -- 補完メニュー
  {
    "echasnovski/mini.completion",
    version = false,
    config = function()
      require("mini.completion").setup()

      -- スニペットセッション中は補完を無効化（extmarks破損防止）
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniSnippetsSessionStart",
        callback = function() vim.b.minicompletion_disable = true end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniSnippetsSessionStop",
        callback = function() vim.b.minicompletion_disable = false end,
      })
    end,
  },

  -- スニペットエンジン
  {
    "echasnovski/mini.snippets",
    version = false,
    config = function()
      local minisnip = require("mini.snippets")

      -- スニペット展開・ジャンプのキーマップ
      local expand_or_jump = function()
        local session = minisnip.session.get()
        if session ~= nil then
          minisnip.session.jump("next")
        else
          -- expand() より前に補完を止める（extmarks破損防止）
          vim.b.minicompletion_disable = true
          minisnip.expand()
        end
      end
      vim.keymap.set("i", "<C-l>", expand_or_jump, { desc = "Expand snippet or jump next" })
      vim.keymap.set("s", "<C-l>", expand_or_jump, { desc = "Jump to next snippet node" })
      vim.keymap.set({ "i", "s" }, "<C-h>", function()
        minisnip.session.jump("prev")
      end, { desc = "Jump to prev snippet node" })

      -- i/s モードを抜けてノーマルモード等に入ったらセッションを確実に終了
      -- （mini.snippets の stop_if_final は cur_tabstop=='0' 以外を止めないため）
      vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = { "s:*", "*:n" },
        callback = function()
          local new_mode = vim.v.event.new_mode
          if new_mode ~= "i" and new_mode ~= "s" then
            local session = minisnip.session.get()
            if session then
              minisnip.session.stop()
            end
          end
        end,
      })

      minisnip.setup({
        -- mini.snippets が勝手に <C-j> を登録するのを防ぐ（SKKのため）
        mappings = {
          expand = '',
          jump_next = '',
          jump_prev = '',
        },

        snippets = {
          minisnip.gen_loader.from_file(vim.fn.stdpath("config") .. "/snippets/hugo.json"),
          -- ${VIM:strftime(...)} は mini.snippets 非対応のため Lua で動的定義
          -- body は文字列のみ有効。expand() 時にローダーが再呼び出しされるので日時は常に新鮮
          function()
            return {
              {
                prefix = "mod",
                body = "lastmod: " .. os.date("%Y-%m-%dT%H:%M:%S+09:00"),
                desc = "更新日",
              },
            }
          end,
        },
      })
    end,
  },
}

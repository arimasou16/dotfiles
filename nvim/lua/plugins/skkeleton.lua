local fn = vim.fn
return {
  "vim-skk/skkeleton",
  cond = fn.executable("deno") == 1,
  dependencies = { "vim-denops/denops.vim" },
  config = function()
    -- skkeleton をトグルする一般的なキーバインド (Ctrl+j)
    vim.keymap.set({ "i", "c" }, "<C-j>", "<Plug>(skkeleton-toggle)")

    -- SKK辞書の初期設定（必要な場合）
    vim.api.nvim_create_autocmd("User", {
      pattern = "skkeleton-initialize-pre",
      callback = function()
      local skk_global = {}
      local skk_user = ""

      if fn.executable('fcitx5') == 1 then
        skk_global = { "/usr/share/skk/SKK-JISYO.L", fn.expand("~/.config/fcitx5/skk/user.dict.utf8") }
        skk_user = fn.expand("~/.config/fcitx5/skk/user.dict.skkeleton")
        fn.system('fcitx5-remote -c')
      elseif fn.executable('ibus') == 1 then
        skk_global = { "/usr/share/skk/SKK-JISYO.L", fn.expand("~/.config/ibus-skk/user.dict.utf8") }
        skk_user = fn.expand("~/.config/ibus-skk/user.dict.skkeleton")
        fn.system('ibus engine "xkb:us::eng"')
      end

      fn["skkeleton#config"]({
        globalDictionaries = skk_global,
        userDictionary = skk_user,
        eggLikeNewline = true,
        keepState = true,
        sources = {"skk_dictionary", "skk_server"},
        skkServerHost = "127.0.0.1",
        skkServerPort = 1178,
        skkServerResEnc = "euc-jp",
        skkServerReqEnc = "euc-jp",
      })
      end,
    })
    -- skkeleton利用のため、Neovim内ではシステムIME(fcitx)を常に英数に固定する
    vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained", "InsertEnter", "InsertLeave" }, {
      pattern = "*",
      callback = function()
        -- fcitx5 の場合
        if vim.fn.executable("fcitx5-remote") == 1 then
          vim.fn.system("fcitx5-remote -c")
        -- fcitx (v4) の場合
        elseif vim.fn.executable("fcitx-remote") == 1 then
          vim.fn.system("fcitx-remote -c")
        end
      end,
    })
  end,
}

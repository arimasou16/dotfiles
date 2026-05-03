-- init.lua
-- 既存のVimscript設定を読み込む
--vim.cmd('source ~/.config/nvim/legacy.vim')
--=============================================================================
-- 1. 基本設定 (Options)
--=============================================================================
-- オプション
local opt = vim.opt
-- グローバル変数
local g = vim.g
-- ファンクション
local fn = vim.fn
-- クリップボード
opt.clipboard:append('unnamedplus')
-- タイトル・バックアップ・スワップ
opt.title = true
opt.swapfile = false
opt.directory = fn.expand("~/.vim/swp")
opt.backup = true
opt.backupdir = fn.expand("~/.vim/bak")
opt.undofile = true
opt.undodir = fn.expand("~/.vim/undo")
-- エディタの挙動
opt.virtualedit:append("block")
opt.number = true
opt.expandtab = true
opt.showtabline = 2
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.autoindent = true
opt.smartindent = true
opt.laststatus = 2
opt.cmdheight = 2
opt.showcmd = true
opt.wrap = true
opt.textwidth = 0
opt.ignorecase = true
opt.smartcase = true
opt.wrapscan = false
opt.incsearch = true
opt.hlsearch = true
opt.list = true
opt.listchars = { tab = "> ", trail = "~" }
opt.backspace = { "start", "eol", "indent" }
opt.display:append("uhex")
opt.display:append("lastline")
opt.wildmenu = true
opt.whichwrap = "b,s,[,],<,>"
opt.ambiwidth = "double"
opt.autoread = true
opt.autochdir = true
opt.hidden = true
opt.helplang = { "ja", "en" }
opt.dictionary = fn.expand("~/.config/nvim/dict/completion.dict")
opt.complete = ".,w,b,u,t,i,k"
opt.iminsert = 0
opt.imsearch = 0

-- 文字エンコーディング
opt.encoding = "utf-8"
opt.fileencodings = { "utf-8", "euc-jp", "iso-2022-jp", "cp932", "ucs-bom" }
if fn.has('win32') == 1 or fn.has('win64') == 1 then
  opt.fileformats = { "dos", "unix" }
  vim.cmd([[
    source $VIMRUNTIME/delmenu.vim
    set langmenu=ja_jp.utf-8
    source $VIMRUNTIME/menu.vim
  ]])
  opt.wildignore:append("*\\tmp\\*,*.swp,*.zip,*.xe")
else
  opt.fileformats = { "unix", "dos" }
  opt.wildignore:append("*/tmp/*,*.so,*.swp,*.zip")
end

if fn.executable('rg') == 1 then
  opt.grepprg = "rg --vimgrep --no-heading"
end

require("config.lazy")

-- QFix / QFixGrep
g.QFixWin_EnableMode = 1
g.QFix_UseLocationList = 1

-- vim-table-mode
g.table_mode_corner = "|"

-- vim-markdown
g.vim_markdown_conceal = 0

-- open-browser
g.netrw_nogx = 1

-- function.vim
g.hugo_directory = '~/Seafile/hugo-site'

--=============================================================================
-- 4. キーマップ (Keymaps)
--=============================================================================
local keymap = vim.keymap.set
local opts_silent = { silent = true }
local opts_expr_silent = { expr = true, silent = true }

-- 削除時はクリップボードにコピーしない
keymap({'n', 'v'}, 'd', '"_d')
keymap({'n', 'v'}, 'D', '"_D')

-- バッファリスト操作
keymap('n', '[b', ':bprevious<CR>', opts_silent)
keymap('n', ']b', ':bnext<CR>', opts_silent)
keymap('n', '[B', ':bfirst<CR>', opts_silent)
keymap('n', ']B', ':blast<CR>', opts_silent)
keymap('n', '<Leader>e', ':enew<CR>', opts_silent)
keymap('n', '<Leader>v', ':vnew<CR>', opts_silent)
keymap('n', '<Leader>c', ':close<CR>', opts_silent)
keymap('n', '<Leader>D', ':bdelete!<CR>', opts_silent)

-- タブ操作
keymap('n', '<Leader>t', ':<C-u>tabnew<CR>', opts_silent)
keymap('n', '<Leader>s', ':<C-u>tab split<CR>gT<CR><C-^><CR>', opts_silent)
keymap('n', '<Leader>T', ':<C-u>tabnew<CR>:terminal<CR>', opts_silent)

-- ペーストモード
keymap('n', '<Leader>p', ':<C-u>set paste<CR>')
-- ハイライト消去
keymap('n', '<Esc><Esc>', ':<C-u>set nohlsearch!<CR>', opts_silent)

-- :CopyMsg コマンドでクリップボードにコピー
vim.api.nvim_create_user_command("CopyMsg", function()
  local messages = vim.fn.execute("messages")
  vim.fn.setreg("+", messages)
  print("メッセージをクリップボードにコピーしました！")
end, {})

-- 各種プラグイン呼び出し
keymap('n', '<Leader>fn', ':<C-u>tabedit $HOME/.local/share/nvim/lazy/functions.vim/plugin/functions.vim<CR>', opts_silent)
keymap({'n', 'v'}, 'gx', '<Plug>(openbrowser-smart-search)')
keymap("n", "<leader>oh", "<cmd>OpenHugo<CR>", opts_silent)

if g.vscode == nil then
  keymap('x', '<Enter>', '<Plug>(EasyAlign)')
end
-- 再読み込みと設定ファイルを開く
keymap('i', '<S-Insert>', '<C-R>+', { remap = true })
keymap('n', '<Leader>rc', ':<C-u>tabedit $HOME/.config/nvim/init.lua<CR>', opts_silent)

-- ランダムな数値 / 日付挿入
keymap('i', 'ncm<Tab>', function() return fn.str2nr(fn.matchstr(fn.reltimestr(fn.reltime()), '\\v\\.@<=\\d+')[2]) end, opts_expr_silent)
keymap('i', 'hex<Tab>', function() return string.format('%x', fn.matchstr(fn.reltimestr(fn.reltime()), '\\v\\.@<=\\d+')[2]) end, opts_expr_silent)
keymap('i', 'date<Tab>', '<C-R>=strftime("%Y-%m-%d")<CR>', opts_silent)
keymap('i', 'time<Tab>', '<C-R>=strftime("%Y-%m-%dT%H:%M:%S+09:00")<CR>', opts_silent)
keymap('n', '<Leader>cp', function() vim.fn.setreg('+', vim.fn.expand('%:p')) end)

--=============================================================================
-- 5. カラースキーム・表示関連
--=============================================================================
vim.cmd("syntax on")
opt.termguicolors = true -- 近年のカラースキームはTrue Color必須なため推奨

if fn.has('gui_running') == 0 then
  -- vim透明化
  vim.cmd([[
    highlight Normal ctermbg=NONE guibg=NONE
    highlight NonText ctermbg=NONE guibg=NONE
    highlight SpecialKey ctermbg=NONE guibg=NONE
    highlight EndOfBuffer ctermbg=NONE guibg=NONE
  ]])

  -- カラースキームの適用
  pcall(vim.cmd, "colorscheme everforest")
end

--=============================================================================
-- 6. 自動コマンド (Autocmd)
--=============================================================================
-- joplin同期処理 (Lua関数として再定義)
local function sync_joplin()
  local cwd = fn.expand('%:p:h')
  if cwd == fn.expand('~/.config/joplin/tmp') then
    local src = fn.expand('%:p')
    local dest = fn.expand('~') .. '/Sync/PocketMark/' .. fn.getline(1) .. '.md'
    -- エラーハンドリングを簡略化しつつシステムコマンド実行
    fn.system({'cp', src, dest})
  end
end

local my_group = vim.api.nvim_create_augroup("my_vimrc", { clear = true })

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*",
  command = "set filetype=markdown",
  group = my_group,
})
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "*grep*",
  command = "cwindow",
  group = my_group,
})
if vim.g.vscode then
    -- インサートモードを抜けた時に、fcitx5を強制的に英語(直接入力)に戻す
    vim.api.nvim_create_autocmd("InsertLeave", {
        group = vim.api.nvim_create_augroup("Fcitx5AutoOff", { clear = true }),
        callback = function()
            -- fcitx5-remote -c は「IMEをオフにする」というコマンドです
            vim.fn.system("fcitx5-remote -c")
        end
    })
end

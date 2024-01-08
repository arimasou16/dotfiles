scriptencoding utf-8
"----------------------------------------
" ユーザー設定
"----------------------------------------
" $VIM直下のvimrcを読み込まない
let g:vimrc_local_finish = 1
" クリップボード
set clipboard&
if has('win32') || has('win64')
  set clipboard^=unnamed "※Windows設定
else
  set clipboard^=unnamedplus
endif
" タイトルを表示
set title
" スワップファイルを作る
set noswapfile
" スワップファイル作成場所
set directory=~/.vim/swp
" バックアップファイルを作る
set backup
" バックアップ作成場所
set backupdir=~/.vim/bak
" アンドゥファイルを作る
set undofile
" undofileをまとめる
set undodir=~/.vim/undo
" 矩形選択で行末を超えてブロックを選択できるようにする
set virtualedit+=block
" 文字エンコーディング設定
set encoding=utf-8
" 自動判別設定
set fileencodings=utf-8,euc-jp,iso-2022-jp,cp932,ucs-bom
if has('win32') || has('win64')
  set fileformats=dos,unix " ※Windows設定
else
  set fileformats=unix,dos
endif
" メニュー文字エンコーディング設定 ※Windows設定
if has('win32') || has('win64')
  source $VIMRUNTIME/delmenu.vim
  set langmenu=ja_jp.utf-8
  source $VIMRUNTIME/menu.vim
endif
" 行番号の設定
set number
" TABキーを押した際にタブ文字の代わりにスペースを入れる
set expandtab
" タブの数設定
set showtabline=2
"画面上でタブ文字が占める幅
set tabstop=4
"自動インデントでずれる幅
set shiftwidth=4
"連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set softtabstop=4
"改行時に前の行のインデントを継続する
set autoindent
"改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent
" ステータスラインにファイル名、文字コード、改行コード、コードポイント、ルーラを表示
"set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=CP[%b\ 0x%B]\ %l,%c%V%8P
" ステータス表示
set laststatus=2
" コマンドラインの高さ
set cmdheight=2
" コマンド表示
set showcmd
" 折り返し設定
set wrap
set tw=0
" Windows環境においてもフォルダ区切りをバックスラッシュでなくスラッシュにする
"set shellslash
"検索時に大文字小文字の区別をしない
set ignorecase
"大文字で検索時には大文字小文字の区別をする
set smartcase
"検索時にファイルの最後まで行ったら最初に戻らない
set nowrapscan
"インクリメンタルサーチ
set incsearch
set hlsearch
" タブ、行末を表示
set list
set listchars=tab:>\ ,trail:~
" BACKSPACEキーでの挿入モードでの文字削除、行連結、インデント削除を可能にする
set backspace=start,eol,indent
"バイナリファイルの非印字可能文字を16進数で表示
set display=uhex
"補完メニューを見やすくする
set wildmenu
"[Backspace][Space]←→(ノーマルビジュアル、そして挿入、置換モード)~で行頭、行末から移動を可能とする
set whichwrap=b,s,[,],<,>
" 文脈依存な文字幅の問題
if has('nvim')
  set ambiwidth=single
else
  set ambiwidth=double
end
"画面最後の行をできる限り表示する。
set display+=lastline
" ファイル自動読み込み
set autoread
" 保存されていないファイルがあるときでも別のファイルを開くことが出来る
set hidden
" ヘルプは日本語優先
set helplang=ja,en
" ファイルと同じディレクトリ移動
function! s:setcwd()
  let cph = expand('%:p:h', 1)
  if cph =~ '^.\+://' | retu | en
  for mkr in ['.git/', '.hg/', '.svn/', '.bzr/', '_darcs/', '.vimprojects']
    let wd = call('find'.(mkr =~ '/$' ? 'dir' : 'file'), [mkr, cph.';'])
    if wd != '' | let &acd = 0 | brea | en
  endfo
  exe 'lc!' fnameescape(wd == '' ? cph : substitute(wd, mkr.'$', '.', ''))
endfunction
" ファイルタイプが未設定ならデフォルトのファイルタイプを設定する
function! s:NoneFileTypeSetMarkdown()
  if len(&filetype) == 0
    set filetype=markdown
  endif
endfunction
" ランダムな数値を出力
imap num<Tab> <ESC>i<C-R>=str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:])<CR>
imap hex<Tab> <ESC>i<C-R>=printf('%x',matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:])<CR>
" autocmd を "vimrc" という名前でグループ化
augroup my_vimrc
  " グループ内の autocmd をリセットする
  autocmd!
  " 開いたファイルのカレントディレクトリに移動
  autocmd BufEnter * call s:setcwd()
  " 新しいバッファの編集を始めたときのファイルタイプを設定する
  autocmd BufEnter * call s:NoneFileTypeSetMarkdown()
  " 自動的にquickfix-windowを開く
  autocmd QuickFixCmdPost *grep* cwindow
  "挿入モードを抜けるとき、set nopaste を実行する。
  autocmd InsertLeave * set nopaste
  autocmd BufNewFile,BufRead *.sql,*.bat,*.vim,*vimrc,*.js,*.gs setlocal tabstop=2 softtabstop=2 shiftwidth=2
  " *.mdファイル自動保存
  "autocmd TextChanged,TextChangedI *.md silent write
augroup END
""""""""""""""""""""""""""""""
"キーマップ
""""""""""""""""""""""""""""""
" キーマップ設定 削除時はクリップボードにコピーしない
nnoremap d  "_d
vnoremap d  "_d
nnoremap D  "_D
vnoremap D  "_D
" バッファリスト操作
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
nnoremap <silent> <Leader>e :enew<CR>
nnoremap <silent> <Leader>v :vnew<CR>
nnoremap <silent> <Leader>c :close<CR>
nnoremap <silent> <Leader>D :bdelete!<CR>
nnoremap <silent> <Leader>t :<C-u>tabnew<CR>
nnoremap <silent> <Leader>s :<C-u>tab split<CR>gT<CR><C-^><CR>
nnoremap <silent> <Leader>T :<C-u>tabnew<CR>:terminal<CR>
"勝手なインデントを回避してペースト <Leader>pと打つと ペーストモードになる
nnoremap <Leader>p :<C-u>set paste<CR>
" マークダウン文書のHTML化
"nnoremap <silent> ,md :<C-u>call execute("!pandoc -f markdown -t html -o %:r.html %")<CR>
let g:pandoc_css = '~/.vim/css/pandoc.css'
nnoremap <silent> ,mh :<C-u>ConvertWithPandoc html<CR>
nnoremap <silent> ,md :<C-u>ConvertWithPandoc docx<CR>
nnoremap <silent> ,mp :<C-u>MarkdownPreview<CR>
" ESCキー2度押しでハイライトの切り替え
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>
" function.vimを開く
nnoremap <silent> <Leader>fn :<C-u>tabedit $HOME/.vim/plugged/functions.vim/plugin/functions.vim<CR>
if has('win32') || has('win64')
  if has('nvim')
    nnoremap <F5> :<C-u>source $HOME/_vimrc<CR> :source $HOME/_gvimrc<CR>
    nnoremap <Leader>rc :<C-u>tabedit $HOME/_vimrc<CR>
  else
    nnoremap <F5> :<C-u>source $HOME\Appdata\Local\nvim\init.vim<CR> :source $HOME\Appdata\Local\nvim\ginit.vim<CR>
    nnoremap <Leader>rc :<C-u>tabedit $HOME\Appdata\Local\nvim\init.vim<CR>
  endif
else
  if has('nvim')
    " Shift + Insertでペイスト
    noremap! <S-Insert> <C-R>+
    nnoremap <F5> :<C-u>source $HOME/.config/nvim/init.vim<CR>
    nnoremap <Leader>rc :<C-u>tabedit $HOME/.config/nvim/init.vim<CR>
  else
    nnoremap <F5> :<C-u>source $HOME/.vimrc<CR>
    nnoremap <Leader>rc :<C-u>tabedit $HOME/.vimrc<CR>
  endif
endif
" タイムスタンプ挿入
imap date<Tab> <C-R>=strftime("%Y-%m-%d")<CR>
imap time<Tab> <C-R>=strftime("%Y-%m-%dT%H:%M:%S+09:00")<CR>
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')
Plug 'vim-jp/vimdoc-ja'
Plug 'vim-denops/denops.vim'
Plug 'vim-skk/skkeleton'
Plug 'dhruvasagar/vim-table-mode'
Plug 'junegunn/vim-easy-align'
Plug 'hrsh7th/vim-vsnip'
Plug 'vim-scripts/BufOnly.vim'
Plug 'vim-scripts/copypath.vim'
Plug 'fuenor/qfixgrep'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'tyru/open-browser.vim'
Plug 'thinca/vim-qfreplace'
Plug 'cocopon/vaffle.vim'
Plug 'glidenote/memolist.vim'
Plug 'itchyny/lightline.vim'
Plug 'thinca/vim-quickrun'
Plug 't9md/vim-quickhl'
Plug 'tyru/caw.vim'
Plug 'yukimemi/dps-hitori'
Plug 'tpope/vim-fugitive'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/vim-fz'
Plug 'mattn/ctrlp-matchfuzzy'
Plug 'arimasou16/functions.vim'
if !has('nvim')
  Plug 'thinca/vim-singleton'
endif
"syntax
Plug 'plasticboy/vim-markdown'
Plug 'PProvost/vim-ps1'
"colorscheme
Plug 'tomasr/molokai'
Plug 'icymind/NeoSolarized'
Plug 'altercation/vim-colors-solarized'
Plug 'jdkanani/vim-material-theme'
Plug 'raphamorim/lucario'
Plug 'gosukiwi/vim-atom-dark'
Plug 'jonathanfilip/vim-lucius'
Plug 'jacoborus/tender.vim'
" Initialize plugin system
call plug#end()
if has('win32') || has('win64')
  set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
else
  set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
endif
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
endif
" skkeleton
" skkeletonの有効、無効を切り替え
imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)
if has('win32') || has('win64')
  call skkeleton#config({
    \'globalJisyo':"~/Appdata/Roaming/SKKFEP/DICTS/SKK-JISYO.L",
    \'userJisyo':"~/.skkeleton",
  \})
else
  call skkeleton#config({
    \'globalJisyo':"/usr/share/skk/SKK-JISYO.L",
  \})
  if executable('fcitx')
    call skkeleton#config({
      \'userJisyo':"~/.config/fcitx/skk/user.dict.utf8",
    \})
    call system('fcitx-remote -c')
  elseif executable('fcitx5')
    call skkeleton#config({
      \'userJisyo':"~/.config/fcitx5/skk/user.dict",
    \})
    call system('fcitx5-remote -c')
  elseif executable('ibus')
    call skkeleton#config({
      \'userJisyo':"~/.config/ibus-skk/user.dict",
    \})
    call system('ibus engine "xkb:us::eng"')
  endif
endif
call skkeleton#config({
  \'eggLikeNewline':v:true,
  \'keepState':v:true,
  \'useSkkServer':v:true,
  \'skkServerHost':"127.0.0.1",
  \'skkServerPort':1178,
  \'skkServerResEnc':"euc-jp",
  \'skkServerReqEnc':"euc-jp",
\})
set iminsert=0
set imsearch=0
set imdisable
" openbrowser
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
nnoremap <silent> <Leader>oh :OpenHugo<CR>
" vim-table-mode
" For Markdown-compatible tables use
let g:table_mode_corner="|"
"python
if has('win32') || has('win64')
  let g:python3_host_prog = '~/AppData/Local/Programs/Python/Python37/python'
else
  let g:python3_host_prog ='/usr/bin/python3'
endif
" QuickFixウィンドウでもプレビューや絞り込みを有効化
let QFixWin_EnableMode = 1
" QFixHowm/QFixGrepの結果表示にロケーションリストを使用する/しない
let QFix_UseLocationList = 1
" vsnip
let g:vsnip_snippet_dir = expand('~/.vim/vsnip')
"Expand
imap <expr> <C-S-j> vsnip#expandable() ? '<Plug>(vsnip-expand)'         : '<C-S-j>'
smap <expr> <C-S-j> vsnip#expandable() ? '<Plug>(vsnip-expand)'         : '<C-S-j>'
" Expand or jump
imap <expr> <C-l>   vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap s      <Plug>(vsnip-select-text)
xmap s      <Plug>(vsnip-select-text)
nmap S      <Plug>(vsnip-cut-text)
xmap S      <Plug>(vsnip-cut-text)
" If you want to use snippet for multiple filetypes, you can `g:vsnip_filetypes` for it.
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.markdown = ['hugo']
" vaffle
nnoremap <silent> <Leader>va :<C-u>Vaffle<CR>
let g:vaffle_auto_cd = 1
" vim-markdown
" 隠蔽をしない
let g:vim_markdown_conceal = 0
" memolist
nnoremap <silent> <Leader>mn  :MemoNew<CR>
nnoremap <silent> <Leader>ml  :MemoList<CR>
nnoremap <silent> <Leader>mg  :MemoGrep<CR>
let g:memolist_memo_suffix = "md"
if isdirectory('E:\\Nextcloud\\hugo-site\\content\\post')
  let g:memolist_path = "E:\\Nextcloud\\hugo-site\\content\\post"
elseif isdirectory(expand('$HOME/Nextcloud/hugo-site/content/post'))
  let g:memolist_path = "~/Nextcloud/hugo-site/content/post"
endif
" easy_align
vmap <Enter> <Plug>(EasyAlign)
let g:easy_align_delimiters = {
\ "-": { 'filter': 'v/^\s*--/', 'pattern': '[-]\{2,\}', 'left_margin': 1, 'right_margin': 1, 'ignore_groups': ['String']},
\ '\': { 'pattern': '\s\{2,\}' },
\ }
" function
if has('win32') || has('win64')
  let g:hugo_directory = 'E:\Nextcloud\hugo-site'
else
  let g:hugo_directory = '~/Nextcloud/hugo-site'
endif
" markdown-preview
nnoremap <silent> <Leader>mp :<C-u>MarkdownPreview<CR>
" lightline.vim
if !has('gui_running')
  "set t_Co=256
  let g:lightline = {
        \ 'colorscheme': 'solarized',
        \ }
  syntax on
  "set background=dark
  if has('nvim')
    "colorscheme NeoSolarized
    "colorscheme lucius
    "colorscheme atom-dark
    "colorscheme lucario
    "colorscheme material-theme
    colorscheme tender
    hi Comment ctermfg=lightgrey
  elseif exists('#lightline') && (has('win32') || has('win64'))
    let g:solarized_termcolors=256
    colorscheme solarized
  else
    colorscheme molokai
  endif
endif
" caw.vim
" 行頭にコメントをトグル
nmap <Leader>/ <Plug>(caw:zeropos:toggle)
vmap <Leader>/ <Plug>(caw:zeropos:toggle)
"ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|go|aws)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
"vim-fz
command! FzColors call fz#run({
    \ 'type': 'list',
    \ 'list': uniq(map(split(globpath(&rtp, "colors/*.vim"), "\n"), "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')")),
    \ 'accept': {result->execute('colorscheme ' . result['items'][0])},
    \ })
"ctrlp-matchfuzzy
let g:ctrlp_match_func = {'match': 'ctrlp_matchfuzzy#matcher'}
" dps-hitori
"g:hitori_debug = false
"g:hitori_opener = 'tab drop'
"" 既に起動中の Neovim にパスを送信した後に Neovim を終了するかどうか
"g:hitori_quit = true
"" Websocket サーバの port
"g:hitori_port = 7070
"" 除外するファイルパターン。デフォルトは [] です。
"g:hitori_ignore_patterns = { "\\.tmp$", "\\.diff$", "(COMMIT_EDIT|TAG_EDIT|MERGE_|SQUASH_)MSG$" }
"g:hitori_wsl = v:false
" vim透明化
if !has('gui_running')
  " ターミナル設定で透過させる
  highlight Normal ctermbg=NONE guibg=NONE
  highlight NonText ctermbg=NONE guibg=NONE
  highlight SpecialKey ctermbg=NONE guibg=NONE
  highlight EndOfBuffer ctermbg=NONE guibg=NONE
endif

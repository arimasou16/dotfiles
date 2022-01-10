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
function! s:ChangeCurrentDirectory()
  let l:dir = expand("%:p:h")
  if isdirectory(fnamemodify(l:dir, ":p"))
    execute printf('lcd `=%s`', string(fnamemodify(l:dir, ":p")))
  endif
endfunction
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
function! s:Rand()
  "return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:])
  echo str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:])
endfunction
" autocmd を "vimrc" という名前でグループ化
augroup my_vimrc
  " グループ内の autocmd をリセットする
  autocmd!
  " 開いたファイルのカレントディレクトリに移動
  "autocmd BufEnter * call s:ChangeCurrentDirectory()
  autocmd BufEnter * call s:setcwd()
  " 新しいバッファの編集を始めたときのファイルタイプを設定する
  autocmd BufEnter * call s:NoneFileTypeSetMarkdown()
  " 自動的にquickfix-windowを開く
  autocmd QuickFixCmdPost *grep* cwindow
  "挿入モードを抜けるとき、set nopaste を実行する。
  autocmd InsertLeave * set nopaste
  autocmd BufNewFile,BufRead *.sql,*.bat,*.vim,*vimrc,*.js,*.gs setlocal tabstop=2 softtabstop=2 shiftwidth=2
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
if has('nvim')
  " Shift + Insertでペイスト
  noremap! <S-Insert> <C-R>+
  " 設定ファイルの再ロード
  nnoremap <F5> :<C-u>source $HOME/.config/nvim/init.vim<CR>
  nnoremap <Leader>rc :<C-u>tabedit $HOME/.config/nvim/init.vim<CR>
elseif has('win32') || has('win64')
  nnoremap <F5> :<C-u>source $HOME/_vimrc<CR> :source $HOME/_gvimrc<CR>
  nnoremap <Leader>rc :<C-u>tabedit $HOME/_vimrc<CR>
endif
"--- <F6>  タイムスタンプを挿入してinsertモードへ移行 ----
"nmap <F6> <ESC>i<C-R>=strftime("%Y-%m-%d (%a) %H:%M")<CR><CR>
imap date<Tab> <C-R>=strftime("%Y-%m-%d")<CR>
"nmap date<Tab> <ESC>i<C-R>=strftime("%Y-%m-%d")<CR>
imap time<Tab> <C-R>=strftime("%Y-%m-%dT%H:%M:%S+09:00")<CR>
"nmap time<Tab> <ESC>i<C-R>=strftime("%Y-%m-%dT%H:%M:%S+09:00")<CR>
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')
Plug 'vim-jp/vimdoc-ja'
Plug 'tyru/eskk.vim'
"Plug 'fuenor/im_control.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'junegunn/vim-easy-align'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-matchfuzzy'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'vim-scripts/BufOnly.vim'
Plug 'vim-scripts/copypath.vim'
Plug 'fuenor/qfixgrep'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'mrtazz/simplenote.vim'
Plug 'thinca/vim-qfreplace'
Plug 'cocopon/vaffle.vim'
Plug 'glidenote/memolist.vim'
Plug 'dbeniamine/todo.txt-vim'
Plug 'itchyny/lightline.vim'
Plug 'thinca/vim-quickrun'
Plug 't9md/vim-quickhl'
Plug 'tyru/caw.vim'
"Plug 'mattn/vim-lexiv'
Plug 'jamessan/vim-gnupg'
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
" Initialize plugin system
call plug#end()

"vim-singleton
if has('clientserver')
  call singleton#enable()
endif
" ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_working_path_mode = 'ra'
" 終了時にキャッシュファイルを削除しない
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_use_caching = 1
let g:ctrlp_match_func = {'match': 'ctrlp_matchfuzzy#matcher'}
if has('win32') || has('win64')
  set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
else
  set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
endif
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
" 検索の際に200[ms]のウェイトを入れる（１文字入力の度に検索結果がコロコロ変わるのが気に入らないため）
let g:ctrlp_lazy_update = 200
nmap <C-p> [ctrlp]
nnoremap <silent> [ctrlp]  :<C-u>CtrlP<CR>
nnoremap <silent> <c-p>m :<C-u>CtrlPMixed<CR>           " ファイル、バッファ、履歴を一度に絞り込みます。ぶっちゃけこれで大体足りるといえば足りる。
nnoremap <silent> <c-p>b :<C-u>CtrlPBookmarkDir<CR>     " ブックマークしたディレクトリを絞り込む
nnoremap <silent> <c-p>a :<C-u>CtrlPBookmarkDirAdd!<CR> " ディレクトリをブックマークする
nnoremap <silent> <c-p>q :<C-u>CtrlPQuickfix<CR>        " vimのquickfixと連携出来ます。:grepとかと組み合わせて使うのがメインかも。
nnoremap <silent> <c-p>t :<C-u>CtrlPTag<CR>             " タグ一覧を表示、絞り込みできます。
nnoremap <silent> <c-p>l :<C-u>:CtrlPChange<CR>         " 現在のファイル内の各行を対象に絞り込みます。
nnoremap <silent> <c-p>d :<C-u>CtrlPDir<CR>             " ディレクトリを検索してカレントディレクトリを切り替えたりできます。
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
  let g:ctrlp_user_command = '[ $PWD == $HOME ] && echo "In HOME Directory" || rg %s --files --color=never --glob ""'
endif
" starting
if has('vim_starting')
  if filewritable(expand("~/AppData/Roaming/SKKFEP/skkuser.txt"))
    " 何故かutf8じゃないと読み込みが上手くいかない
    call execute (":!echo ;;; -*- coding: utf-8 -*- > \\%APPDATA\\%/SKKFEP/skkuser8.txt")
    call execute (":!nkf -w \\%APPDATA\\%/SKKFEP/skkuser.txt >> \\%APPDATA\\%/SKKFEP/skkuser8.txt")
  endif
  " simplenote 更新が上手くいかないことがあるので
  "if filewritable(expand("~/.snvim"))
  "  if has('win32') || has('win64')
  "    call execute (":!del /q /f \\%USERPROFILE\\%\\.snvim")
  "  else
  "    call execute (":!rm ~/.snvim")
  "  endif
  "endif
endif
" eskk
let g:eskk#auto_save_dictionary_at_exit = 0
if has('win32') || has('win64')
  let g:eskk#directory = "~/AppData/Roaming/SKKFEP"
  let g:eskk#dictionary = { 'path': "~/AppData/Roaming/SKKFEP/skkuser8.txt", 'sorted': 0, 'encoding': 'utf-8', }
  let g:eskk#large_dictionary = { 'path': "~/Appdata/Roaming/SKKFEP/DICTS/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp', }
elseif executable('ibus')
  let g:eskk#directory = "~/.config/ibus-skk"
  let g:eskk#dictionary = { 'path': "~/.config/ibus-skk/user.dict", 'sorted': 0, 'encoding': 'utf-8', }
  let g:eskk#large_dictionary = { 'path': "/usr/share/skk/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp', }
elseif executable('fcitx')
  let g:eskk#directory = "~/.config/fcitx/skk"
  let g:eskk#dictionary = { 'path': "~/.config/fcitx/skk/user.dict", 'sorted': 0, 'encoding': 'utf-8', }
  let g:eskk#large_dictionary = { 'path': "/usr/share/skk/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp', }
elseif executable('fcitx5')
  let g:eskk#directory = "~/.config/fcitx5/skk"
  let g:eskk#dictionary = { 'path': "~/.config/fcitx5/skk/user.dict", 'sorted': 0, 'encoding': 'utf-8', }
  let g:eskk#large_dictionary = { 'path': "/usr/share/skk/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp', }
endif
" Use yaskkserv
"let g:eskk#server = {
"\  'host': 'localhost',
"\  'port': 1178,
"\}
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
  let g:python_host_prog = expand('~/AppData/Local/Programs/Python/Python37')
  let g:python3_host_prog = expand('~/AppData/Local/Programs/Python/Python37')
else
  let g:python3_host_prog ='/usr/bin/python3'
endif
if filereadable(expand('~/.simplenoterc'))
  source ~/.simplenoterc
endif
" simplenote
let g:SimplenoteSingleWindow = 1
let g:SimplenoteSortOrder = "pinned, modifydate, tags"
let g:SimplenoteFiletype = "markdown"
nnoremap <silent> <Leader>sl :<C-u>SimplenoteList<CR>
nnoremap <silent> <Leader>su :<C-u>SimplenoteUpdate<CR>
nnoremap <silent> <Leader>si :<C-u>SimplenoteVersionInfo<CR>
nnoremap <silent> <Leader>sv :<C-u>SimplenoteVersion<CR>
nnoremap <silent> <Leader>sn :<C-u>SimplenoteNew<CR>
nnoremap <silent> <Leader>st :<C-u>SimplenoteTag<CR>
nnoremap <silent> <Leader>sp :<C-u>SimplenotePin<CR>
" QuickFix
" QuickFixウィンドウでもプレビューや絞り込みを有効化
let QFixWin_EnableMode = 1
" QFixHowm/QFixGrepの結果表示にロケーションリストを使用する/しない
let QFix_UseLocationList = 1
" ultisnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
if has('win32') || has('win64')
  " vimfilesと.vimをリンク貼っているのだが.vimで設定すると.vimとvimfilesどちらか選択する必要がある
  let g:UltiSnipsSnippetDirectories=[$HOME.'/vimfiles/UltiSnips', 'UltiSnips']
else
  let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips', 'UltiSnips']
endif
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
" todo.txt
let g:maplocalleader = "\<Space>"
" Windowsでは"Google ドライブ"というフォルダ名だと起動時にはSJISで読み込もうとして正しく判定できないのでフォルダ名を英字にして設定すること
if isdirectory(expand('~/Dropbox/Tasks/'))
  let g:doneTaskFile = expand('~/Dropbox/Tasks/done.txt')
  let g:todoTaskFile = expand('~/Dropbox/Tasks/todo.txt')
endif
" autocmd を "todo" という名前でグループ化
augroup todo
  " Use todo#Complete as the omni complete function for todo files
  au filetype todo setlocal omnifunc=todo#Complete
  " Auto complete projects
  au filetype todo imap <buffer> + +<C-X><C-O>
  " Auto complete contexts
  au filetype todo imap <buffer> @ @<C-X><C-O>
augroup END
nnoremap <silent> <LocalLeader>to :<C-u>Todo<CR>
nnoremap <silent> <LocalLeader>do :<C-u>Done<CR>
" function
if has('win32') || has('win64')
  let g:hugo_directory = 'E:\Nextcloud\hugo-site'
else
  let g:hugo_directory = '~/Nextcloud/hugo-site'
endif
if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1 " forces true color
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1 " Changes cursor to a line on insert mode
  set termguicolors
endif
" markdown-preview
nnoremap <silent> <Leader>mp :<C-u>MarkdownPreview<CR>
" lightline.vim
if !has('gui_running')
  set t_Co=256
  let g:lightline = {
        \ 'colorscheme': 'solarized',
        \ }
  " battery
  let g:battery#update_statusline = 1 " For statusline.
  syntax on
  set background=dark
  if exists('#lightline') && (has('win32') || has('win64'))
    let g:solarized_termcolors=256
    colorscheme solarized
  elseif has('nvim')
    colorscheme NeoSolarized
  else
    colorscheme molokai
  endif
endif
" caw.vim
" 行頭にコメントをトグル
nmap <Leader>/ <Plug>(caw:zeropos:toggle)
vmap <Leader>/ <Plug>(caw:zeropos:toggle)
"endif
" vim透明化
if has('nvim')
  " ターミナル設定で透過させる
  highlight Normal ctermbg=NONE guibg=NONE
  highlight NonText ctermbg=NONE guibg=NONE
  highlight SpecialKey ctermbg=NONE guibg=NONE
  highlight EndOfBuffer ctermbg=NONE guibg=NONE
endif

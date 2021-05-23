"" $VIM直下のgvimrcを読み込まない
let g:gvimrc_local_finish = 1
"" vim透明化
""set transparency=220
syntax on
set background=dark
if exists('#lightline') && (has('win32') || has('win64'))
  " lightline.vim
  let g:lightline = {
        \ 'colorscheme': 'solarized',
        \ 'component_function': {
        \   'battery': 'battery#component'
        \ },
        \ }
  " battery
  let g:battery#update_statusline = 1 " For statusline.
  colorscheme solarized
  call lightline#init()
else
  colorscheme NeoSolarized
endif
" autocmd を "gvimrc" という名前でグループ化
augroup my_gvimrc
  " グループ内の autocmd をリセットする
  autocmd!
  " ウインドウに関する設定:
  "起動時全画面
  if has('win32') || has('win64')
    set guifont=Ricty_Discord:h14:cSHIFTJIS
    set printfont=Ricty_Discord:h12:cSHIFTJIS
    set rop=type:directx,renmode:5
    autocmd GUIEnter * simalt ~x "※Windows設定
  elseif has('nvim')
    execute "GuiFont! Illusion N:h14"
    "highlight Normal guibg=none
    "highlight NonText guibg=none
  endif
augroup END

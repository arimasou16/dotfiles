function! s:migemogrep(...)
  let old = &grepprg
  try
    let &grepprg = 'migemogrep'
    exec 'grep' join(a:000, ' ')
  finally
    let &grepprg = old
  endtry
endfunction
command! -nargs=+ MigemoGrep call s:migemogrep(<f-args>)

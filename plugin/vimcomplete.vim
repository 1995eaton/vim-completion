if exists('g:vimcomplete#loaded') && g:vimcomplete#loaded == 1
  finish
endif

let g:vimcomplete#loaded = 1

if !exists('g:vimcomplete#matchstartlength')
  let g:vimcomplete#matchstartlength = 2
endif

if !exists('g:vimcomplete#tabcompletion')
  let g:vimcomplete#tabcompletion = 1
endif

if g:vimcomplete#tabcompletion == 1
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : (&omnifunc != '' ? "\<C-x>\<C-o>\<C-p>" : "\<C-n>\<C-p>")
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : (&omnifunc != '' ? "\<C-x>\<C-o>\<C-p>" : "\<C-n>\<C-p>")
endif

function! vimcomplete#complete()
  if (pumvisible() && v:char != '.')
    return
  endif
  let context = getline('.')[0:col('.') - 2]
  if len(matchstr(context, '[a-zA-Z_#$\\\/]*$')) < g:vimcomplete#matchstartlength
    return
  endif
  let rootdir = matchstr(context, '\([\n\s]\|^\)\/[^ ]*$')
  let rootdir = substitute(rootdir, '[^/]*$', '', '')
  if isdirectory(rootdir)
    call feedkeys("\<Plug>(vim_complete_file)")
  elseif v:char =~ '[a-zA-Z._#$]' || len(v:char) == 0
    if &omnifunc != ''
      if g:vimcomplete#complmethod == "word" && v:char == "."
        return
      endif
      call feedkeys("\<Plug>(vim_complete_".g:vimcomplete#complmethod.")")
    else
      call feedkeys("\<Plug>(vim_complete_word)")
    endif
  endif
endfunction

let g:vimcomplete#complmethod = "omni"
function! vimcomplete#switch_methods()
  let g:vimcomplete#complmethod = g:vimcomplete#complmethod == "omni" ? "word" : "omni"
  call vimcomplete#complete()
endfunction

inoremap <C-e> <C-\><C-o>:call vimcomplete#switch_methods()<CR>

inoremap <BS> <BS><C-\><C-o>:call vimcomplete#complete()<CR>
inoremap <silent> <Plug>(vim_complete_omni) <C-x><C-o><C-p>
inoremap <silent> <Plug>(vim_complete_word) <C-x><C-n><C-p>
inoremap <silent> <Plug>(vim_complete_file) <C-x><C-f><C-p>

autocmd InsertChange,InsertCharPre * call vimcomplete#complete()

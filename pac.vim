scriptencoding utf-8

" wrapper function, implementing `for: filetype` option
function! pac#add_for(repo, ...) abort
    let l:opts = get(a:000, 0, {})
    if has_key(l:opts, 'for')
        let l:name = substitute(a:repo, '^.*/', '', '')
        let l:ft = type(l:opts.for) == type([]) ? join(l:opts.for, ',') : l:opts.for
        execut printf('autocmd FileType %s packadd %s', l:ft, l:name)
    endif
endfunction

function! pac#reset_loaded()
  let g:pac#installed_pacs = keys(filter(copy(g:minpac#pluglist), {-> isdirectory(v:val.dir . '/.git')}))
endfunction

" inefficient, can be cached (and maybe is not needed at all)
function! pac#loaded(name)
  return index( get(g:, 'pac#installed_pacs', []), a:name ) != -1
endfunction

call minpac#add('itchyny/lightline.vim')
call minpac#add('w0rp/ale')
call minpac#add('maximbaz/lightline-ale')
call minpac#add('arcticicestudio/nord-vim')

call minpac#add('andymass/vim-matchup')
call minpac#add('wsdjeg/vim-fetch')

call minpac#add('neoclide/coc.nvim', { 'do': {-> system('yarn install --frozen-lockfile') } })

call minpac#add('tpope/vim-characterize')
call minpac#add('kassio/neoterm')
call minpac#add('othree/html5.vim')

call minpac#add('ryanoasis/vim-devicons')
call minpac#add('t9md/vim-choosewin')

call minpac#add('godlygeek/tabular')
call minpac#add('nelstrom/vim-visual-star-search')
call minpac#add('mbbill/undotree')
call minpac#add('tpope/vim-repeat')

call minpac#add('vim-scripts/camelcasemotion')
call minpac#add('itchyny/vim-qfedit')
call minpac#add('chrisbra/NrrwRgn')

call minpac#add('rrethy/vim-hexokinase', { 'do': {-> system('make hexokinase') } })

call minpac#add('tpope/vim-dispatch')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('tpope/vim-fugitive')
call minpac#add('idanarye/vim-merginal')

call minpac#add('junegunn/fzf', { 'do': {-> system('./install --all') } })
call minpac#add('junegunn/fzf.vim')

call minpac#add('mattn/emmet-vim')
call minpac#add('cespare/vim-toml')
call minpac#add('vim-scripts/xml.vim')
call minpac#add('elzr/vim-json')

call minpac#add('Shougo/context_filetype.vim')
call minpac#add('joker1007/vim-ruby-heredoc-syntax')
call minpac#add('vim-ruby/vim-ruby')
call minpac#add('tpope/vim-rails')
call minpac#add('slim-template/vim-slim')

call minpac#add('slashmili/alchemist.vim')
call minpac#add('elixir-editors/vim-elixir')

call minpac#add('kchmck/vim-coffee-script')

call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-endwise')

call minpac#add('liuchengxu/vista.vim')

call minpac#add('Yggdroot/indentLine')
call minpac#add('luochen1990/rainbow')
call minpac#add('terryma/vim-expand-region')

call minpac#add('pangloss/vim-javascript')    " JavaScript support
call minpac#add('leafgarland/typescript-vim') " TypeScript syntax
call minpac#add('maxmellon/vim-jsx-pretty')   " JS and JSX syntax
call minpac#add('posva/vim-vue')

call minpac#add('Shougo/echodoc.vim')

" - repo: liuchengxu/vim-which-key
"   on_cmd: [Whichkey, Whichkey!]
"   hook_source: source  $VIM_PATH/core/plugins/whichkey.vim
"   hook_post_source: |
"         call which_key#register('<Space>', 'g:which_key_map')
"         call which_key#register(';', 'g:which_key_localmap')
"         call which_key#register(']', 'g:which_key_rsbgmap')
"         call which_key#register('[', 'g:which_key_lsbgmap')

call pac#reset_loaded()

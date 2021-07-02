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
call minpac#add('josa42/vim-lightline-coc')

call minpac#add('arcticicestudio/nord-vim')
call minpac#add('wadackel/vim-dogrun')
call minpac#add('cocopon/iceberg.vim')
call minpac#add('gkeep/iceberg-dark')
call minpac#add('rakr/vim-two-firewatch')
call minpac#add('tyrannicaltoucan/vim-deep-space')
call minpac#add('ghifarit53/tokyonight-vim')
call minpac#add('davidklsn/vim-sialoquent')
call minpac#add('adrian5/oceanic-next-vim')
call minpac#add('ulwlu/elly.vim')
call minpac#add('kyazdani42/blue-moon')
call minpac#add('NLKNguyen/papercolor-theme')

call minpac#add('pedrohdz/vim-yaml-folds')
call minpac#add('sheerun/vim-polyglot')

call minpac#add('andymass/vim-matchup')
call minpac#add('wsdjeg/vim-fetch')

call minpac#add('junegunn/fzf', { 'do': {-> system('./install --all') } })
call minpac#add('junegunn/fzf.vim')

call minpac#add('neoclide/coc.nvim', { 'do': {-> system('yarn install --frozen-lockfile') } })
call minpac#add('antoinemadec/coc-fzf')

call minpac#add('tpope/vim-characterize')
call minpac#add('kassio/neoterm')

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

call minpac#add('mattn/emmet-vim')

call minpac#add('Shougo/context_filetype.vim')
call minpac#add('joker1007/vim-ruby-heredoc-syntax')
call minpac#add('tpope/vim-rails')
call minpac#add('airblade/vim-localorie')

call minpac#add('slashmili/alchemist.vim')

call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-endwise')

call minpac#add('liuchengxu/vista.vim')

call minpac#add('Yggdroot/indentLine')
call minpac#add('luochen1990/rainbow')
call minpac#add('terryma/vim-expand-region')

call minpac#add('Shougo/echodoc.vim')

call minpac#add('antoinemadec/FixCursorHold.nvim')

call minpac#add('rickhowe/diffchar.vim')

call pac#reset_loaded()

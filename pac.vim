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
  let load_index = index( get(g:, 'pac#installed_pacs', []), a:name )
  if load_index == -1
    return v:false
  else
    return v:true
  endif
endfunction

" Basics
call minpac#add('nvim-treesitter/nvim-treesitter', { 'do': 'TSUpdate' })
call minpac#add('nvim-treesitter/playground')
call minpac#add('neovim/nvim-lspconfig')
call minpac#add('williamboman/nvim-lsp-installer')
call minpac#add('weilbith/nvim-lsp-smag')

" Commonly used library
call minpac#add('nvim-lua/plenary.nvim')

" File navigation
call minpac#add('kyazdani42/nvim-web-devicons') " for file icons
call minpac#add('kyazdani42/nvim-tree.lua')

" Completion engine
call minpac#add('hrsh7th/cmp-nvim-lsp')
call minpac#add('hrsh7th/cmp-buffer')
call minpac#add('hrsh7th/cmp-path')
call minpac#add('ray-x/cmp-treesitter')
call minpac#add('kdheepak/cmp-latex-symbols')
call minpac#add('hrsh7th/cmp-cmdline')
call minpac#add('hrsh7th/nvim-cmp')
call minpac#add('hrsh7th/vim-vsnip')
call minpac#add('hrsh7th/vim-vsnip-integ')

call minpac#add('onsails/lspkind-nvim')

" Status and tab lines
call minpac#add('nvim-lualine/lualine.nvim')
call minpac#add('nvim-lua/lsp-status.nvim')
call minpac#add('alvarosevilla95/luatab.nvim')

" LSP tricks
call minpac#add('folke/trouble.nvim')

" Git signs
call minpac#add('lewis6991/gitsigns.nvim')

" Colorschemes
call minpac#add('shaunsingh/nord.nvim')
call minpac#add('rmehri01/onenord.nvim')
call minpac#add('wadackel/vim-dogrun')
call minpac#add('cocopon/iceberg.vim')
call minpac#add('gkeep/iceberg-dark')
call minpac#add('tyrannicaltoucan/vim-deep-space')
call minpac#add('folke/tokyonight.nvim')
call minpac#add('Slotos/calvera-dark.nvim')
call minpac#add('Slotos/moonlight.nvim')
call minpac#add('rose-pine/neovim', {'name': 'rose-pine'})
call minpac#add('EdenEast/nightfox.nvim')
call minpac#add('FrenzyExists/aquarium-vim')
call minpac#add('rebelot/kanagawa.nvim')
call minpac#add('bluz71/vim-nightfly-guicolors')

" Colorscheme patches
call minpac#add('folke/lsp-colors.nvim')

" Syntax dump
call minpac#add('pedrohdz/vim-yaml-folds')
call minpac#add('andymass/vim-matchup')

" Open file:lineno
call minpac#add('wsdjeg/vim-fetch')

" FZF alternative
call minpac#add('nvim-lua/popup.nvim')
call minpac#add('nvim-telescope/telescope.nvim')
call minpac#add('nvim-telescope/telescope-fzf-native.nvim', { 'do': {-> system('make') } })
call minpac#add('gbrlsnchs/telescope-lsp-handlers.nvim')

" Terminals and REPLs interactions
call minpac#add('kassio/neoterm')

" Handy window selector
call minpac#add('t9md/vim-choosewin')

" Alignment hacker
call minpac#add('godlygeek/tabular')

" Search visual selections
call minpac#add('nelstrom/vim-visual-star-search')

call minpac#add('mbbill/undotree')

call minpac#add('vim-scripts/camelcasemotion')
call minpac#add('itchyny/vim-qfedit')
call minpac#add('chrisbra/NrrwRgn')

call minpac#add('rrethy/vim-hexokinase', { 'do': {-> system('make hexokinase') } })

" Git tools
call minpac#add('tpope/vim-dispatch')
call minpac#add('radenling/vim-dispatch-neovim')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('tpope/vim-fugitive')
call minpac#add('idanarye/vim-merginal')
call minpac#add('f-person/git-blame.nvim')

" DB tools
call minpac#add('tpope/vim-dadbod')
call minpac#add('kristijanhusak/vim-dadbod-ui')
call minpac#add('kristijanhusak/vim-dadbod-completion')

call minpac#add('mattn/emmet-vim')

call minpac#add('Shougo/context_filetype.vim')
call minpac#add('tpope/vim-rails')
call minpac#add('airblade/vim-localorie')

call minpac#add('slashmili/alchemist.vim')

call minpac#add('tpope/vim-commentary')
call minpac#add('JoosepAlviste/nvim-ts-context-commentstring')
call minpac#add('tpope/vim-endwise')

call minpac#add('stevearc/aerial.nvim')

call minpac#add('lukas-reineke/indent-blankline.nvim')
call minpac#add('p00f/nvim-ts-rainbow')
call minpac#add('terryma/vim-expand-region')

call minpac#add('Shougo/echodoc.vim')

call minpac#add('antoinemadec/FixCursorHold.nvim')

call minpac#add('rickhowe/diffchar.vim')

call pac#reset_loaded()

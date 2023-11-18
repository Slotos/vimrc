scriptencoding utf-8

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

" Tree-sitter
call minpac#add('nvim-treesitter/nvim-treesitter', { 'do': 'packloadall! | TSUpdate' })
call minpac#add('nvim-treesitter/nvim-treesitter-context')
call minpac#add('stevearc/aerial.nvim')
call minpac#add('folke/twilight.nvim') " Tree-sitter powered context highlighting

" LSP
call minpac#add('neovim/nvim-lspconfig')
call minpac#add('williamboman/mason.nvim')
call minpac#add('weilbith/nvim-code-action-menu')
call minpac#add('kosayoda/nvim-lightbulb')
call minpac#add('onsails/lspkind-nvim')
call minpac#add('folke/trouble.nvim')
call minpac#add('https://git.sr.ht/~whynothugo/lsp_lines.nvim')
call minpac#add('https://git.sr.ht/~p00f/clangd_extensions.nvim')
call minpac#add('mrcjkb/rustaceanvim')
" Configure efmls (null-ls is being archived)
" See https://github.com/creativenull/efmls-configs-nvim

" Commonly used library
call minpac#add('nvim-lua/plenary.nvim')

" File navigation
call minpac#add('nvim-tree/nvim-web-devicons') " for file icons
call minpac#add('MunifTanjim/nui.nvim')
call minpac#add('nvim-neo-tree/neo-tree.nvim')
call minpac#add('s1n7ax/nvim-window-picker')

" Completion engine
call minpac#add('hrsh7th/cmp-nvim-lsp')
call minpac#add('hrsh7th/cmp-nvim-lsp-signature-help')
call minpac#add('hrsh7th/cmp-buffer')
call minpac#add('hrsh7th/cmp-path')
call minpac#add('ray-x/cmp-treesitter')
call minpac#add('kdheepak/cmp-latex-symbols')
call minpac#add('hrsh7th/cmp-emoji')
call minpac#add('chrisgrieser/cmp-nerdfont')
call minpac#add('hrsh7th/cmp-cmdline')
call minpac#add('hrsh7th/nvim-cmp')
call minpac#add('hrsh7th/vim-vsnip')
call minpac#add('hrsh7th/vim-vsnip-integ')
call minpac#add('mattn/emmet-vim')
call minpac#add('dcampos/cmp-emmet-vim')
call minpac#add('hrsh7th/cmp-omni')

" Status and tab lines
call minpac#add('Slotos/lualine.nvim', {'branch': 'tabs-highlight-formatting'})

" Notification library
call minpac#add('rcarriga/nvim-notify')

" Colorschemes
call minpac#add('rose-pine/neovim', { 'name': 'rose-pine' })
call minpac#add('catppuccin/nvim', { 'name': 'catppuccin' })
call minpac#add('Mofiqul/adwaita.nvim')

" Colorscheme patches
call minpac#add('folke/lsp-colors.nvim')

" Syntax dump
call minpac#add('pedrohdz/vim-yaml-folds')
call minpac#add('cuducos/yaml.nvim')

" matchit/matchup replacement
call minpac#add('andymass/vim-matchup')

" Open file:lineno
call minpac#add('wsdjeg/vim-fetch')

" FZF alternative
call minpac#add('nvim-telescope/telescope.nvim')
call minpac#add('nvim-telescope/telescope-fzf-native.nvim', { 'do': {-> system('make') } })
call minpac#add('stevearc/dressing.nvim')
call minpac#add('Slotos/telescope-lsp-handlers.nvim')

" Terminals and REPLs interactions
call minpac#add('kassio/neoterm')

" Alignment hacker
call minpac#add('godlygeek/tabular')

" Search visual selections
call minpac#add('bronson/vim-visual-star-search')

call minpac#add('mbbill/undotree')

call minpac#add('itchyny/vim-qfedit')

call minpac#add('chrisbra/NrrwRgn')

" Git tools
call minpac#add('tpope/vim-fugitive')
call minpac#add('idanarye/vim-merginal')
call minpac#add('sindrets/diffview.nvim')
call minpac#add('akinsho/git-conflict.nvim')
call minpac#add('junegunn/gv.vim')
call minpac#add('lewis6991/gitsigns.nvim')

" DB tools
call minpac#add('tpope/vim-dadbod')
call minpac#add('kristijanhusak/vim-dadbod-ui')
call minpac#add('kristijanhusak/vim-dadbod-completion')

call minpac#add('tpope/vim-unimpaired')

" Relnumber shenanigans
call minpac#add('jeffkreeftmeijer/vim-numbertoggle')

" Debug Adapter Protocol
call minpac#add('mfussenegger/nvim-dap')
call minpac#add('rcarriga/nvim-dap-ui')
call minpac#add('leoluz/nvim-dap-go')
call minpac#add('theHamsta/nvim-dap-virtual-text')
call minpac#add('jbyuki/one-small-step-for-vimkind')

call minpac#add('tpope/vim-commentary')
call minpac#add('JoosepAlviste/nvim-ts-context-commentstring')
call minpac#add('tpope/vim-endwise') " when using syntax

call minpac#add('lukas-reineke/indent-blankline.nvim')
call minpac#add('terryma/vim-expand-region')

call minpac#add('rickhowe/diffchar.vim')

call minpac#add('jbyuki/venn.nvim')

call minpac#add('jbyuki/nabla.nvim')

call minpac#add('AndrewRadev/bufferize.vim')

call minpac#add('ThePrimeagen/refactoring.nvim')

call minpac#add('anuvyklack/pretty-fold.nvim')

" Translation tool
call minpac#add('uga-rosa/translate.nvim')

" Test wrappers
call minpac#add('nvim-neotest/neotest')
call minpac#add('olimorris/neotest-rspec')

call minpac#add('antoinemadec/FixCursorHold.nvim')

" QoL
call minpac#add('folke/which-key.nvim')

call pac#reset_loaded()

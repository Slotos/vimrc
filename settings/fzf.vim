autocmd! FileType fzf
autocmd  FileType fzf setlocal nonu nornu
" autocmd BufLeave <buffer> set laststatus=0 showmode ruler

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_commits_log_options = '--graph --color=always
  \ --format="%C(yellow)%h%C(red)%d%C(reset)
  \ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'

let g:fzf_preview_window = 'right:50%'

" ripgrep
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
endif

let $FZF_DEFAULT_OPTS='--layout=reverse --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up,ctrl-]:toggle-preview'

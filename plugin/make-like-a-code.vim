fun! MakeLikeACodeStart(githubRepo, commitHash)
    lua require('make-like-a-code').start(vim.api.nvim_eval('a:githubRepo'), vim.api.nvim_eval('a:commitHash'))
endfun

" Alternative: nvim_create_user_command()
" Also see: :help user-commands, :help command-attributes, :help <args>, :help <q-args>, :help <f-args>, :help com
com! -nargs=* MakeLikeACode call MakeLikeACodeStart(<f-args>)

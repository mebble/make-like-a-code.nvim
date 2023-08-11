fun! MakeLikeACodeStart(commitHash)
    echo 'Fetching' commitHash
    lua require('make-like-a-code').greet()
endfun

" Alternative: nvim_create_user_command()
" Also see: :help user-commands, :help command-attributes, :help <args>, :help <q-args>, :help <f-args>, :help com
com! -nargs=1 MakeLikeACode call MakeLikeACodeStart(<args>)

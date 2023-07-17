# make-like-a-code.nvim

_Inspired by [vim-be-good](https://github.com/ThePrimeagen/vim-be-good)_

## Development

In terminal:

```
nvim -c "set rtp+=."  
```

In neovim:

```
# Either do this:
lua require("make-like-a-code")

# Or open lua/make-like-a-code/init.lua, then do:
source %
```

### Testing

In neovim:

```
PlenaryBustedDirectory tests
```

More information on testing at [plenary.nvim](https://github.com/nvim-lua/plenary.nvim/blob/master/TESTS_README.md).

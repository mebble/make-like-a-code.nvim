# make-like-a-code.nvim

_Inspired by [vim-be-good](https://github.com/ThePrimeagen/vim-be-good)_

## Development

In terminal:

```
nvim -c "set rtp+=."  
```

In neovim:

```
# Open plugin/make-like-a-code.vim, then do:
source %
# or
so

# Then run the make-like-a-code command:
MakeLikeACode mebble/mcj 8f091af
```

### Testing

In neovim:

```
PlenaryBustedDirectory tests
```

More information on testing at [plenary.nvim](https://github.com/nvim-lua/plenary.nvim/blob/master/TESTS_README.md).

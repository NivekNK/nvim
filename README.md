# nvim
My config of neovim for windows and linux.

## Requirements:

### LSP:

* Install lua-language-server:
    - Windows [Scoop](https://scoop.sh/)

            scoop install lua-language-server

    - Linux: TODO

### treesitter:

* Install tree-sitter-cli

        npm install tree-sitter-cli

* Install gcc and clang:
    - Windows [Scoop](https://scoop.sh/):

            scoop bucket add versions
            scoop install tdm-gcc

            scoop bucket add main
            scoop install llvm

        For **Windows** you need to Enable Developer Mode.

    - Linux: TODO

### Telescope:

* Install ripgrep
    - Windows [Scoop](https://scoop.sh/):

            scoop install ripgrep

    - Linux: TODO

* Install fd
    - Windows [Scoop](https://scoop.sh/):

            scoop install fd

    - Linux: TODO

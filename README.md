# nvim
My config of neovim for windows and linux.

## Requirements:

### markdown-preview:

* Install node.js:

    - Windows [Scoop](https://scoop.sh/)

            // LTS version (Recommended):
            scoop bucket add main
            scoop install main/nodejs-lts

            // Up to date version:
            scoop bucket add main
            scoop install main/nodejs

    - Linux **TODO**

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

    - Linux **TODO**

* Install gcc and clang: Already installed with treesitter.

* Install fd
    - Windows [Scoop](https://scoop.sh/):

            scoop install fd

    - Linux **TODO**

### todo-comments:

* Install ripgrep: Already installed with Telescope.

### Copilot:

* On a fresh install run the following command inside neovim

        :Copilot auth

### LSP:

* Install lua-language-server:
    - Windows [Scoop](https://scoop.sh/)

            scoop install lua-language-server

    - Linux **TODO**

### Mason:

* Install 7zip:
    - Windows [Scoop](https://scoop.sh/)

            scoop bucket add main
            scoop install main/7zip

    - Linux **TODO**

### toggleterm:

Using **PowerShell** on Windows and **zsh** on Linux.



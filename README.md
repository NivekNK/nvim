# nvim
My config of neovim for windows and linux.

## Requirements:

### markdown-preview:

* Install Node.js:

    - Windows [Scoop](https://scoop.sh/)

            // LTS version (Recommended):
            scoop bucket add main
            scoop install main/nodejs-lts

            // Up to date version:
            scoop bucket add main
            scoop install main/nodejs

    - Linux **TODO**

### treesitter:

* Install tree-sitter-cli:
    - Using Node.js

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

### Mason:

* Install 7zip:
    - Windows [Scoop](https://scoop.sh/)

            scoop bucket add main
            scoop install main/7zip

    - Linux **TODO**

### efm-langserver:

* Install go and then the efm-langserver:
    - Windows Winget

            winget install GoLang.Go
            go install github.com/mattn/efm-langserver@latest

    - Linux **TODO**

* Install prettierd:
    - Using Node.js

            npm install -g @fsouza/prettierd

* Install eslint_d:
    - Using Node.js

            npm install -g eslint_d

### LSP:

* Install ripgrep: Already installed with Telescope.

* Install clang: Already installed with treesitter.

* Install lua-language-server:
    - Windows [Scoop](https://scoop.sh/)

            scoop install lua-language-server

    - Linux **TODO**

* Install vscode-json-language-server:
    - Using Node.js

            npm i -g vscode-langservers-extracted

* Install typescript and typescript-language-server:
    - Using Node.js

            npm install -g typescript typescript-language-server

* Install astro:
    - Using Node.js

            npm install -g @astrojs/language-server

* Install cmake-language-server:
    - Windows [Scoop](https://scoop.sh/)

            scoop bucket add main
            scoop install main/python

            pip install cmake-language-server

    - Linux **TODO**

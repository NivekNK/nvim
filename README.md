# nvim
My config of neovim for windows and linux.

## Requirements:

### markdown-preview:

* Install Node.js:

    - Windows [Scoop](https://scoop.sh/):

            // LTS version (Recommended):
            scoop bucket add main
            scoop install main/nodejs-lts

            // Up to date version:
            scoop bucket add main
            scoop install main/nodejs

    - Linux: **TODO**

### treesitter:

* Install tree-sitter-cli:

        npm install tree-sitter-cli

* Install zig:
    - Windows:

            winget install -e --id zig.zig

        or [Scoop](https://scoop.sh/):

            scoop install zig

    - Linux: TODO

### Telescope:

* Install ripgrep
    - Windows [Scoop](https://scoop.sh/):

            scoop install ripgrep

    - Linux: **TODO**

* Install gcc:
    - Windows [Scoop](https://scoop.sh/):

            scoop bucket add versions
            scoop install tdm-gcc

    - Linux: **TODO*+

* Install fd
    - Windows [Scoop](https://scoop.sh/):

            scoop install fd

    - Linux: **TODO**

### todo-comments:

* Install ripgrep: Already installed with Telescope.

### Copilot:

* On a fresh install run the following command inside neovim

        :Copilot auth

### Mason:

* Install 7zip:
    - Windows [Scoop](https://scoop.sh/):

            scoop bucket add main
            scoop install main/7zip

    - Linux: **TODO**

### efm-langserver:

* Install go and then the efm-langserver:
    - Windows:

            winget install GoLang.Go
            go install github.com/mattn/efm-langserver@latest

    - Linux: **TODO**

* Install prettierd:

        npm install -g @fsouza/prettierd

* Install eslint_d:

        npm install -g eslint_d

### LSP:

* Install ripgrep: Already installed with Telescope.

* Install clang:

    - Windows [Scoop](https://scoop.sh/):

            scoop bucket add main
            scoop install llvm

        For Windows you need to Enable Developer Mode.

    - Linux: **TODO**

* Install lua-language-server:
    - Windows [Scoop](https://scoop.sh/):

            scoop install lua-language-server

    - Linux: **TODO**

* Install vscode-json-language-server:

        npm i -g vscode-langservers-extracted

* Install typescript and typescript-language-server:

        npm install -g typescript typescript-language-server

* Install astro:

        npm install -g @astrojs/language-server

* Install tailwind-language-server:

        npm install -g @tailwindcss/language-server

* Install cmake-language-server:
    - Windows [Scoop](https://scoop.sh/):

            scoop bucket add main
            scoop install main/python

            pip install cmake-language-server

    - Linux: **TODO**

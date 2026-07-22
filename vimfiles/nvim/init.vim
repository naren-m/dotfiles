set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua << EOF
vim.lsp.enable({ "gopls", "pyright", "yamlls", "bashls" })
EOF

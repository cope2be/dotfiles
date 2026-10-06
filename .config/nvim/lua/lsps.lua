local config = vim.lsp.config

vim.g.c_syntax_for_h = 1
vim.filetype.add({ extension = { h = "c" } })

config("clangd", {
  capabilities = { offsetEncoding = { "utf-16" } },
  cmd = {
    "clangd",
    "--clang-tidy=false",
    "--background-index=false",
    "--header-insertion=never",
    "--j=2",
  },
})

config("lua_ls", {
  settings = {
    Lua = { diagnostics = { globals = { "vim" } } },
  },
})

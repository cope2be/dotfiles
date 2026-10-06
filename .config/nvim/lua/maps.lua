local function map(mode, key, cmd, desc, not_silent, buffer)
  vim.keymap.set(mode, key, cmd, { buffer = buffer, desc = desc, silent = not not_silent })
end

vim.g.mapleader = " "
vim.g.localmapleader = " "

map("n", "x", '"_x')
map("v", "p", '"_dP')

map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "<esc>", "<cmd>noh<cr><esc>")

map(
  "n",
  "<leader>fr",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  "Replace string under cursor"
)

map("n", "<leader>xe", ":!chmod +x %", "Make file executable", true)

map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")

map("n", "+", "<C-a>")
map("n", "_", "<C-x>")

map("v", "<C-j>", ":m '>+1<CR>gv=gv")
map("v", "<C-k>", ":m '<-2<CR>gv=gv")

map("n", "<leader>s|", "<cmd>split<cr>", "Split window horizontally")
map("n", "<leader>s-", "<cmd>vsplit<cr>", "Split window vertically")

map("n", "<leader>sh", "<C-W>h", "Move to left split")
map("n", "<leader>sj", "<C-W>j", "Move to lower split")
map("n", "<leader>sk", "<C-W>k", "Move to upper split")
map("n", "<leader>sl", "<C-W>l", "Move to right split")

do
  local diag = vim.diagnostic

  map("n", "[d", diag.goto_prev, "Goto previous diagnostic")
  map("n", "]d", diag.goto_next, "Goto next diagnostic")

  map("n", "gl", diag.open_float, "Toggle diagnostic window")
end

do
  local lsp = vim.lsp
  vim.api.nvim_create_autocmd("LspAttach", { callback = function(args)
    do
      local client = lsp.get_client_by_id(args.data.client_id)
      if client ~= nil then client.server_capabilities.semanticTokensProvider = nil end
    end

    local buf = args.buf
    -- map("i", "K", lsp.buf.hover, nil, nil, buf)
    -- map("i", "<c-k>", lsp.buf.signature_help, nil, nil, buf)
    map("n", "<leader>cr", lsp.buf.rename, "Rename symbols", nil, buf)
  end })
end

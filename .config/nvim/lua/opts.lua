local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

opt.autoindent = true
opt.smartindent = true

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true

opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 8
-- opt.signcolumn = "yes"
opt.isfname:append("@-@")

opt.updatetime = 1000

opt.clipboard:append({ "unnamedplus" })

opt.list = true
opt.listchars:append("space:·,eol:↴")

opt.timeout = true
opt.timeoutlen = 500

opt.cursorline = true
opt.conceallevel = 1

do
  local diag = vim.diagnostic
  local severity = diag.severity

  diag.config({
    update_in_insert = true,

    signs = {
      text = {
        [severity.ERROR] = "",
        [severity.WARN] = "",
        [severity.HINT] = "",
        [severity.INFO] = "",
      },
      numhl = {
        [severity.ERROR] = "DiagnosticSignError",
        [severity.WARN] = "DiagnosticSignWarn",
        [severity.HINT] = "DiagnosticSignHint",
        [severity.INFO] = "DiagnosticSignInfo",
      },
    },
    underline = false,
    virtual_text = false,
  })
end

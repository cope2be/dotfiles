do
  local lazypath = (vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end

  vim.opt.rtp:prepend(lazypath)
end

local MASON_ENSURE_INSTALLED = { "clangd", "neocmake", "lua_ls" }
local TS_ENSURE_INSTALLED = { "c", "cpp", "lua" }

local OIL_IGNORED_EXTS = {
  [".."] = true,
  [".git"] = true,
  [".DS_Store"] = true,
  [".localized"] = true,
}

require("lazy").setup(
  {
    {
      "saghen/blink.cmp",
      dependencies = { "saghen/blink.lib" },
      event = { "CmdlineEnter", "InsertEnter" },
      opts = {
        keymap = {
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<C-e>"] = { "hide", "fallback" },
          ["<CR>"] = { "accept", "fallback" },

          ["<S-Tab>"] = { "select_prev", "fallback_to_mappings" },
          ["<Tab>"] = { "select_next", "fallback_to_mappings" },

          ["<C-n>"] = { "scroll_documentation_up", "fallback" },
          ["<C-p>"] = { "scroll_documentation_down", "fallback" },
        },
        cmdline = { completion = { menu = { auto_show = false } } },
        completion = { documentation = { auto_show = false }, list = { max_items = 20 } },
        sources = { default = { "lsp", "path", "buffer" } },
        fuzzy = { implementation = "lua" },
      },
    },
    {
      "catgoose/nvim-colorizer.lua",
      event = "BufReadPre",
      opts = { parsers = { names = { enable = false } } },
    },
    {
      "numToStr/Comment.nvim",
      keys = {
        { "gcc", mode = "n", desc = "Comment toggle current line" },
        { "gc", mode = { "n", "v" }, desc = "Comment toggle linewise" },
        { "gbc", mode = "n", desc = "Comment toggle current block" },
        { "gb", mode = { "n", "v" }, desc = "Comment toggle blockwise" },
      },
      opts = {},
    },
    {
      "ibhagwan/fzf-lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      cmd = "FzfLua",
      keys = {
        { "<leader>cA", "<cmd>FzfLua lsp_code_actions<cr>", desc = "Open code actions" },

        { "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Find file's diagnostics" },
        { "<leader>fD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Find workspace's diagnostics" },
        { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
        { "<leader>fg", "<cmd>FzfLua grep<cr>", desc = "Live grep" },

        { "gd", "<cmd>FzfLua lsp_definitions<cr>", desc = "Find definitions" },
        { "gI", "<cmd>FzfLua lsp_implementations<cr>", desc = "Find implementations" },
        { "gR", "<cmd>FzfLua lsp_references<cr>", desc = "Find references" },
      },
      config = function()
        local fzf = require("fzf-lua")
        fzf.setup({
          winopts = {
            border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
            title_flags = false,

            height = 0.5,
            width = 0.5,

            preview = { hidden = true },
          },
          files = {
            find_opts = [[-type f \! -path '*/.git/*' \! -path '*/.jj/*' \! -name '.localized' \! -name '.DS_Store']],
            rg_opts = [[--color=never --files -g "!.git" -g "!.jj" -g "!.localized" -g "!.DS_Store"]],
            fd_opts = [[--color=never --type f --type l --exclude .git --exclude .jj --exclude .localized --exclude .DS_Store]],
          },
        })
        fzf.register_ui_select()
      end,
    },
    -- {
    --   "ThePrimeagen/harpoon",
    --   branch = "harpoon2",
    --   dependencies = { "nvim-lua/plenary.nvim" },
    --   keys = {
    --     { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon file" },
    --     { "<leader>hx", function()
    --       local harpoon = require("harpoon")
    --       harpoon.ui:toggle_quick_menu(harpoon:list())
    --     end, desc = "Toggle Harpoon menu" },
    --     { "<leader>hq", function() require("harpoon"):list():select(1) end, desc = "Harpoon to file 1" },
    --     { "<leader>hw", function() require("harpoon"):list():select(2) end, desc = "Harpoon to file 2" },
    --     { "<leader>he", function() require("harpoon"):list():select(3) end, desc = "Harpoon to file 3" },
    --     { "<leader>hr", function() require("harpoon"):list():select(4) end, desc = "Harpoon to file 4" },
    --   },
    --   opts = {},
    -- },
    {
      "lukas-reineke/indent-blankline.nvim",
      event = { "BufReadPost", "BufNewFile", "BufWritePre" },
      main = "ibl",
      opts = {
        indent = { char = "│" },
        whitespace = { remove_blankline_trail = true },
        scope = { enabled = false },
      },
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      event = "VeryLazy",
      opts = {
        options = {
          icons_enabled = true,
          component_separators = "",
          section_separators = "",
          theme = "auto",
        },
        sections = {
          lualine_a = { "mode", "buffer" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "filetype" },
          lualine_y = {},
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "lazy", "oil" },
      },
    },
    {
      "mason-org/mason.nvim",
      cmd = { "Mason", "MasonInstall", "MasonLog", "MasonUninstall", "MasonUninstallAll", "MasonUpdate" },
      opts = {
        ui = {
          icons = {
            package_installed = "●",
            package_pending = "➜",
            package_uninstalled = "○",
          }
        },
      },
    },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      opts = {},
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = { { "mason-org/mason-lspconfig.nvim", opts = { ensure_installed = MASON_ENSURE_INSTALLED } } },
      event = { "BufReadPre", "BufNewFile" },
    },
    {
      "stevearc/oil.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      lazy = false,
      keys = { { "-", "<cmd>Oil<cr>", desc = "Toggle Oil" } },
      opts = {
        columns = { "icon" },
        keymaps = {
          ["?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["\\"] = "actions.select_vsplit",
          ["|"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-q>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-w"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["~"] = "actions.cd",
          ["s"] = "actions.change_sort",
          ["x"] = "actions.open_external",
          ["."] = "actions.toggle_hidden",
          ["<C-.>"] = "actions.toggle_trash",
        },
        view_options = {
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name, _)
            return OIL_IGNORED_EXTS[name] == true
          end,
        },

        delete_to_trash = true,
        default_file_explorer = true,
        use_default_keymaps = false,
        skip_confirm_for_simple_edits = true,
      },
    },
    {
      "rose-pine/neovim",
      lazy = false,
      priority = 1000,
      config = function()
        require("rose-pine").setup({
          variant = "moon",
          styles = { italic = false },
        })

        vim.cmd("colorscheme rose-pine")
      end,
    },
    {
      "romus204/tree-sitter-manager.nvim",
      cmds = { "TSInstall", "TSManager", "TsUninstall" },
      opts = { border = "single", ensure_installed = TS_ENSURE_INSTALLED },
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {},
    },
  },
  {
    checker = { enabled = true, notify = false },
    change_detection = { notify = false },

    performance = {
      rtp = {
        disabled_plugins = {
          "netrw",
          "netrwPlugin",
          "netrwSettings",
          "netrwFileHandlers",
        },
      },
    },
    rocks = { enabled = false },
  }
)

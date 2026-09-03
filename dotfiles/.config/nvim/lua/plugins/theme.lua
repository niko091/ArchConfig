return {
  {
    "AvengeMedia/base46",
    branch = "v3.0",
    lazy = false,
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        if vim.fn.filereadable(vim.fn.stdpath("config") .. "/colors/dms.lua") == 1 then
          local ok = pcall(vim.cmd.colorscheme, "dms")
          if ok then
            return
          end
        end
        require("tokyonight").load({ style = "night" })
      end,
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/lualine/themes/dms.lua") == 1
          and "dms"
        or "auto"
      opts.options.component_separators = { left = "│", right = "│" }
      opts.options.section_separators = { left = "", right = "" }
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        separator_style = "slant",
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
      },
    },
  },
}

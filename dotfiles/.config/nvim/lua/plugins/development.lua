return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
        severity_sort = true,
        float = { border = "rounded", source = true },
      },
      inlay_hints = { enabled = true },
      codelens = { enabled = true },
      servers = {
        -- Prefer the up-to-date native Arch/rustup binaries already on this machine.
        clangd = { mason = false },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "basedpyright",
        "bash-language-server",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "eslint-lsp",
        "gopls",
        "json-lsp",
        "lua-language-server",
        "marksman",
        "ruff",
        "svelte-language-server",
        "tailwindcss-language-server",
        "taplo",
        "vtsls",
        "yaml-language-server",
      },
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 250 },
        ghost_text = { enabled = true },
        menu = { border = "rounded", draw = { treesitter = { "lsp" } } },
      },
      signature = { enabled = true, window = { border = "rounded" } },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      default_format_opts = { timeout_ms = 3000, async = false, quiet = false, lsp_format = "fallback" },
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        lua = { "stylua" },
        python = { "ruff_format" },
        rust = { "rustfmt", lsp_format = "fallback" },
        sh = { "shfmt" },
        zsh = { "shfmt" },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { delay = 500, virt_text_pos = "eol" },
      preview_config = { border = "rounded" },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    opts = { floating = { border = "rounded" } },
  },
}

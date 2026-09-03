local nike = [[
      ✦  Ν Ι Κ Η  ✦

███╗   ██╗██╗██╗  ██╗██╗
████╗  ██║██║██║ ██╔╝██║
██╔██╗ ██║██║█████╔╝ ██║
██║╚██╗██║██║██╔═██╗ ██║
██║ ╚████║██║██║  ██╗██║
╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝╚═╝
  victory favours the prepared
]]

return {
  {
    "folke/snacks.nvim",
    opts = {
      animate = { enabled = true },
      dashboard = {
        preset = {
          header = nike,
          keys = {
            { icon = " ", key = "f", desc = "Find file", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New file", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Configuration", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Plugins", action = ":Lazy" },
            { icon = " ", key = "x", desc = "Language extras", action = ":LazyExtras" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      indent = {
        enabled = true,
        animate = { enabled = true },
        chunk = { enabled = true, char = { corner_top = "╭", corner_bottom = "╰", horizontal = "─", vertical = "│", arrow = "─" } },
      },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      picker = {
        enabled = true,
        layout = { preset = "ivy" },
      },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      preset = "modern",
      delay = 250,
      win = { border = "rounded" },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
  },
}

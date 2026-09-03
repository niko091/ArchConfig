local map = vim.keymap.set

-- Ergonomic editing and navigation.
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<C-s>", "<cmd>write<cr>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>write<cr>a", { desc = "Save file" })
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

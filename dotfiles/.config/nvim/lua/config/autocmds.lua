local group = vim.api.nvim_create_augroup("ArchConfig", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Briefly highlight copied text",
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 160 })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "gitcommit", "markdown", "text" },
  desc = "Wrap prose and keep it readable",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  desc = "Return to the last edit position",
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local count = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

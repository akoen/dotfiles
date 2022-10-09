-- Keep cursor centred
vim.keymap.set('n', 'k', "v:count == 0 ? 'gkzz' : 'kzz'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gjzz' : 'jzz'", { expr = true, silent = true })

vim.api.nvim_create_autocmd(
  { "InsertLeave" },
  { pattern = "*", command = "write" }
)

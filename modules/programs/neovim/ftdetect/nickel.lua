vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.ncl',
  callback = function() vim.bo.filetype = 'nickel' end,
})

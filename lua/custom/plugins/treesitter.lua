return {
  'nvim-treesitter/nvim-treesitter',
  config = function()
    local filetypes = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'typescript', 'tsx', 'vim', 'vimdoc' }
    require('nvim-treesitter').install(filetypes)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = filetypes,
      callback = function(args)
        -- Skip scratch/float buffers (handled by LSP's open_floating_preview)
        if vim.bo[args.buf].buftype == '' then vim.treesitter.start(args.buf) end
      end,
    })
  end,
}

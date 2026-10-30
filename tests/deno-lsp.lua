-- Regression coverage for Deno projects nested inside Node monorepos.
-- Run: nvim --headless -u NONE -l tests/deno-lsp.lua
vim.opt.rtp:prepend(vim.fn.getcwd())
local plugins = vim.fn.stdpath 'data' .. '/lazy/'
for _, name in ipairs { 'nvim-lspconfig', 'blink.cmp', 'mason.nvim', 'mason-tool-installer.nvim' } do
  vim.opt.rtp:append(plugins .. name)
end
require('mason').setup {}
require('custom.plugins.lspconfig').config()

local root = vim.fn.tempname()
local function file(path, contents)
  vim.fn.mkdir(vim.fs.dirname(root .. '/' .. path), 'p')
  vim.fn.writefile({ contents or '' }, root .. '/' .. path)
end
local function selected_root(server, path)
  local buf = vim.fn.bufadd(root .. '/' .. path)
  local selected
  vim.lsp.config[server].root_dir(buf, function(dir) selected = dir end)
  return selected
end

local ok, err = pcall(function()
  assert(vim.lsp.is_enabled 'denols', 'Deno language server must be enabled')
  file('package.json', '{}')
  file 'pnpm-lock.yaml'
  file('apps/edge/package.json', '{}')
  file('apps/edge/functions/deno.json', '{}')
  file('apps/edge/functions/account-status/index.ts', 'export const status = true')
  file('apps/web/index.ts', 'export const web = true')
  assert(
    selected_root('denols', 'apps/edge/functions/account-status/index.ts') == root .. '/apps/edge/functions',
    'Deno config must define the root without a deno.lock'
  )
  assert(selected_root('ts_ls', 'apps/edge/functions/account-status/index.ts') == nil, 'Node server must skip Deno files')
  assert(selected_root('denols', 'apps/web/index.ts') == nil, 'Deno server must skip Node files')
  assert(selected_root('ts_ls', 'apps/web/index.ts') == root, 'Node server must still serve web files')
end)
vim.fn.delete(root, 'rf')
if not ok then
  io.stderr:write(tostring(err) .. '\n')
  vim.cmd 'cquit 1'
end
print 'Deno/Node LSP routing passed'
vim.cmd 'qa!'

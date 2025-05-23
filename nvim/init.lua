----------------------------------------------------------------------------------------------------------------                                                paq                                                         --
----------------------------------------------------------------------------------------------------------------

local PACKAGES = {
  'savq/paq-nvim',
  'alexghergh/nvim-tmux-navigation',
  'navarasu/onedark.nvim',
  'tpope/vim-repeat',
  'justinmk/vim-sneak',
  'ibhagwan/fzf-lua',
  'terrortylor/nvim-comment',
  'PeterRincker/vim-argumentative',
  'neovim/nvim-lspconfig',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/vim-vsnip',
  'hrsh7th/vim-vsnip-integ',
  'onsails/lspkind.nvim',
  'ojroques/nvim-hardline',
  'nvim-lua/plenary.nvim',
  'filipdutescu/renamer.nvim',
  'RRethy/vim-illuminate',
  'lewis6991/gitsigns.nvim',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  'nvim-treesitter/nvim-treesitter',
  'elihunter173/dirbuf.nvim',
  'j-hui/fidget.nvim',
  'johngkhs/quickfix-reflector.vim',
  'milkypostman/vim-togglelist',
  'AndrewRadev/sideways.vim',
  'kana/vim-textobj-user',
  'johngkhs/vim-textobj-variable-segment',
}

local function bootstrap_paq()
    local path = vim.fn.stdpath 'data' .. '/site/pack/paqs/start/paq-nvim'
    if vim.fn.empty(vim.fn.glob(path)) > 0 then
        vim.fn.system { 'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', path }
        vim.cmd('packadd paq-nvim')
        require('paq')(PACKAGES).install()
    end
end

bootstrap_paq()
require('paq')(PACKAGES)

----------------------------------------------------------------------------------------------------------------
--                                             functions                                                      --
----------------------------------------------------------------------------------------------------------------

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

----------------------------------------------------------------------------------------------------------------
--                                          general settings                                                  --
----------------------------------------------------------------------------------------------------------------

vim.g.mapleader = ' '
vim.api.nvim_set_option('clipboard', 'unnamedplus')
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.wildignore = '*.o,*.a,*/bin/*'
vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case --column --line-number'

local onedark = require('onedark')
onedark.setup { transparent = true }
onedark.load()

----------------------------------------------------------------------------------------------------------------
--                                          general mappings                                                  --
----------------------------------------------------------------------------------------------------------------

map('v', '<tab>', '>gv')
map('v', '<s-tab>', '<gv')
map('n', '<tab>', '>>')
map('n', '<s-tab>', '<<')

map('i', 'jk', '<esc>')
map('c', 'jk', '<c-c>')
map('i', 'jj', '()<esc>i')
map('i', 'kk', '()')
map('i', 'jl', '<esc>A<space>{<cr>}<esc><up>A<cr>')

map('n', 'J', '20j')
map('n', 'K', '20k')
map('v', 'J', '20j')
map('v', 'K', '20k')

map('n', '<leader>w', '<cmd>w<cr>')
map('n', '<leader><leader>w', '<cmd>wa<cr>')
map('n', '<leader>q', '<cmd>q<cr>')
map('n', '<leader><leader>q', '<cmd>qa!<cr>')

map('n', 'H', '<c-o>')
map('n', 'L', '<c-i>')

map('n', '<leader>r', ':%s@<c-r><c-w>@@gcI<left><left><left><left>')
map('v', '<leader>r', 'y:%s@<C-r>\"@@gcI<left><left><left><left>')

map('n', '<leader>R', ':%s@\b<c-r><c-w>\b@@gI<left><left><left>')
map('v', '<leader>R', 'y:%s@<C-r>\"@@gI<left><left><left>')

map('n', '<leader>j', 'mzJ`z')

map('n', '<leader>h', ':e %:p:s,.h$,.XZXZX,:s,.cpp$,.h,:s,.XZXZX$,.cpp,<cr>', {silent = true})

map('n', '<leader>E', ':vsplit $MYVIMRC<cr>')
map('n', '<leader>S', ':source $MYVIMRC<cr>')

----------------------------------------------------------------------------------------------------------------
--                                        nvim-tmux-navigation                                                --
----------------------------------------------------------------------------------------------------------------

require('nvim-tmux-navigation')

map('n', '<c-h>', '<cmd>NvimTmuxNavigateLeft<cr>', {silent = true})
map('n', '<c-j>', '<cmd>NvimTmuxNavigateDown<cr>', {silent = true})
map('n', '<c-k>', '<cmd>NvimTmuxNavigateUp<cr>', {silent = true})
map('n', '<c-l>', '<cmd>NvimTmuxNavigateRight<cr>', {silent = true})

----------------------------------------------------------------------------------------------------------------
--                                             hardline                                                       --
----------------------------------------------------------------------------------------------------------------

require('hardline').setup {}

----------------------------------------------------------------------------------------------------------------
--                                          nvim-treesitter                                                   --
----------------------------------------------------------------------------------------------------------------


require('nvim-treesitter.configs').setup {
  ensure_installed = { 'vim', 'lua', 'cpp', 'python' },
  highlight = { enable = true },
}

----------------------------------------------------------------------------------------------------------------
--                                             renamer                                                        --
----------------------------------------------------------------------------------------------------------------

require('renamer').setup {}

map('n', '<leader><leader>r', '<cmd>lua require("renamer").rename({ empty = true })<cr>', {silent = true})
map('v', '<leader><leader>r', '<cmd>lua require("renamer").rename({ empty = true })<cr>', {silent = true})

----------------------------------------------------------------------------------------------------------------
--                                            illuminate                                                      --
----------------------------------------------------------------------------------------------------------------

require('illuminate').configure { delay = 0 }

----------------------------------------------------------------------------------------------------------------
--                                             gitsigns                                                       --
----------------------------------------------------------------------------------------------------------------

require('gitsigns').setup {}

----------------------------------------------------------------------------------------------------------------
--                                              fzf-lua                                                       --
----------------------------------------------------------------------------------------------------------------

require('fzf-lua').setup {
  winopts = {
    fullscreen = true,
    preview = { layout = 'vertical', vertical = 'up:45%' },
  },
  fzf_opts = {
    ['-m --bind'] = 'ctrl-a:toggle-all',
  }
}

map('n', '<enter>', '<cmd>lua require("fzf-lua").lsp_definitions({ jump_to_single_result = true })<cr>')
map('n', '<leader>f', '<cmd>FzfLua files<cr>')
map('n', '<leader>b', '<cmd>FzfLua buffers<cr>')
map('n', '<leader>s', '<cmd>FzfLua grep_cword<cr>' )
map('n', '<leader>t', '<cmd>FzfLua grep<cr>' )
map('n', '<leader><leader>s', '<cmd>FzfLua lsp_references<cr>')
map('n', '<leader><leader>a', '<cmd>FzfLua grep_last<cr>' )
map('n', '<leader>g', '<cmd>FzfLua lsp_live_workspace_symbols<cr>' )
map('n', '<leader><leader>g', '<cmd>FzfLua live_grep_native<cr>' )
map('n', '<leader><leader>f', '<cmd>lua require("fzf-lua").lsp_code_actions({ winopts = { fullscreen = false } })<cr>')

----------------------------------------------------------------------------------------------------------------
--                                          lspconfig and nvim-cmp                                            --
----------------------------------------------------------------------------------------------------------------

require('cmp_nvim_lsp_signature_help')
local lspkind = require('lspkind')
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = { 'pyright', 'ccls' }
local lspconfig = require('lspconfig')
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

local cmp = require('cmp')
cmp.setup {
  snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },
  mapping = cmp.mapping.preset.insert({
    ['<cr>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
    ['<c-space>'] = cmp.mapping.complete(),
    ['<tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item() else fallback() end
    end, { 'i', 's' }),
    ['<s-tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item() else fallback() end
    end, { 'i', 's' }),
  }),
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  sources = cmp.config.sources({
      { name = 'nvim_lsp', group_index = 1 },
      { name = 'vsnip', group_index = 1 },
      { name = 'buffer', group_index = 2 },
      { name = 'nvim_lsp_signature_help', group_index = 3 },
      { name = 'path', group_index = 4 },
  }),
  formatting = { format = lspkind.cmp_format() },
}

map('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float({focus = false})<cr>')
map('n', '<leader>i', '<cmd>lua vim.lsp.buf.hover()<cr>')

----------------------------------------------------------------------------------------------------------------
--                                            nvim-comment                                                    --
----------------------------------------------------------------------------------------------------------------

require('nvim_comment').setup {create_mappings = false}
vim.cmd('autocmd BufEnter *.cpp,*.h :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")')
map('n', '<leader>,', ':CommentToggle<cr>')
map('v', '<leader>,', ':\'<,\'>CommentToggle<cr>')

----------------------------------------------------------------------------------------------------------------
--                                             vim-sneak                                                      --
----------------------------------------------------------------------------------------------------------------

map('', 'f', '<Plug>Sneak_f')
map('', 'F', '<Plug>Sneak_F')
map('', 't', '<Plug>Sneak_t')
map('', 'T', '<Plug>Sneak_T')
map('', 's', '<Plug>Sneak_s')
map('', 'S', '<Plug>Sneak_S')

----------------------------------------------------------------------------------------------------------------
--                                           dirbuf.nvim                                                      --
----------------------------------------------------------------------------------------------------------------

require('dirbuf').setup {}
map('n', '<leader>-', '<cmd>DirbufQuit<cr>')

----------------------------------------------------------------------------------------------------------------
--                                              fidget                                                        --
----------------------------------------------------------------------------------------------------------------

require('fidget').setup {}

----------------------------------------------------------------------------------------------------------------
--                                           vim-togglelist                                                   --
----------------------------------------------------------------------------------------------------------------

vim.g.toggle_list_no_mappings = true
map('n', '<leader>a', '<cmd>call ToggleQuickfixList()<cr>')
vim.cmd('autocmd FileType qf wincmd J')
vim.cmd('autocmd FileType qf set winheight=30')

----------------------------------------------------------------------------------------------------------------
--                                            sideways.vim                                                    --
----------------------------------------------------------------------------------------------------------------

map('n', '<left>', '<cmd>SidewaysLeft<cr>')
map('n', '<right>', '<cmd>SidewaysRight<cr>')

----------------------------------------------------------------------------------------------------------------
--                                             clipboard                                                      --
----------------------------------------------------------------------------------------------------------------

function refresh_DISPLAY()
  local command=vim.api.nvim_exec2('![ -n "$TMUX" ] && tmux showenv -s', {output = true})
  local display = string.match(command.output, 'DISPLAY="([^"]+)"')
  if display ~= nil and display ~= '' then
    vim.api.nvim_command('let $DISPLAY="' .. display .. '"')
  end
end

map('n', '<leader><leader>c', '', {callback = refresh_DISPLAY})

----------------------------------------------------------------------------------------------------------------
--                                                paq                                                         --
----------------------------------------------------------------------------------------------------------------

local PKGS = {
  "savq/paq-nvim",
  "alexghergh/nvim-tmux-navigation",
  "navarasu/onedark.nvim",
  "tpope/vim-repeat",
  "ggandor/flit.nvim",
  "ggandor/leap.nvim",
  "ibhagwan/fzf-lua",
  "terrortylor/nvim-comment",
  "PeterRincker/vim-argumentative",
  "derekwyatt/vim-fswitch",
  "neovim/nvim-lspconfig",
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'ojroques/nvim-hardline',
  'nvim-lua/plenary.nvim',
  'filipdutescu/renamer.nvim',
  'RRethy/vim-illuminate',
  'lewis6991/gitsigns.nvim',
}

local function bootstrap_paq()
    local path = vim.fn.stdpath 'data' .. '/site/pack/paqs/start/paq-nvim'
    if vim.fn.empty(vim.fn.glob(path)) > 0 then
        vim.fn.system { 'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', path, }
        vim.cmd('packadd paq-nvim')
        require("paq")(PKGS).install()
    end
end

bootstrap_paq()
require("paq")(PKGS)

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = " "

----------------------------------------------------------------------------------------------------------------
--                                             hardline                                                       --
----------------------------------------------------------------------------------------------------------------

require('hardline').setup {}

require('renamer').setup {}

require('illuminate').configure {
  delay = 0 
}

require('gitsigns').setup()

map("n", "<leader><leader>r", '<cmd>lua require("renamer").rename()<cr>', {silent = true})
map("v", "<leader><leader>r", '<cmd>lua require("renamer").rename()<cr>', {silent = true})

-- require("nvim-web-devicons").setup {}
-- require("trouble").setup {
--   height = 40,
--   action_keys = {
--     jump = "<tab>",
--     jump_close = "<cr>",
--     hover = {},
--   },
-- }
--
-- map("n", "<leader>a", "<cmd>TroubleToggle quickfix<cr>")
-- map("n", "<leader>e", "<cmd>TroubleToggle document_diagnostics<cr>")
-- map("n", "gr", "<cmd>Trouble lsp_references<cr>")
----------------------------------------------------------------------------------------------------------------
--                                        nvim-tmux-navigation                                                --
----------------------------------------------------------------------------------------------------------------

require('nvim-tmux-navigation')

map("n", "<c-h>", "<cmd>NvimTmuxNavigateLeft<cr>", {silent = true})
map("n", "<c-j>", "<cmd>NvimTmuxNavigateDown<cr>", {silent = true})
map("n", "<c-k>", "<cmd>NvimTmuxNavigateUp<cr>", {silent = true})
map("n", "<c-l>", "<cmd>NvimTmuxNavigateRight<cr>", {silent = true})

----------------------------------------------------------------------------------------------------------------
--                                              fzf-lua                                                       --
----------------------------------------------------------------------------------------------------------------

require('fzf-lua').setup {
  winopts = {
    fullscreen = true,
    preview = {
      layout = 'vertical',
      vertical = "up:45%",
    }
  }
}

map("n", "<enter>", "<cmd>lua vim.lsp.buf.definition()<cr>")
map("n", "<leader>f", "<cmd>FzfLua files<cr>")
map("n", "<leader>b", "<cmd>FzfLua buffers<cr>")
map("n", "<leader>s", "<cmd>FzfLua grep_cword<cr>" )
map("n", "<leader>t", "<cmd>FzfLua grep<cr>" )
map("n", "gr", "<cmd>FzfLua lsp_references<cr>")
-- map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
-- map("n", "gR", "<cmd>lua vim.lsp.buf.references()<cr>")

----------------------------------------------------------------------------------------------------------------
--                                          lspconfig and nvim-cmp                                            --
----------------------------------------------------------------------------------------------------------------

local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = { 'pyright', 'clangd' }
local lspconfig = require('lspconfig')
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

local cmp = require('cmp')
cmp.setup {
  mapping = cmp.mapping.preset.insert({
    ['<cr>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
  },
}


----------------------------------------------------------------------------------------------------------------
--                                            nvim-comment                                                    --
----------------------------------------------------------------------------------------------------------------

require('nvim_comment').setup({create_mappings = false})
map("n", "<leader>,", ":CommentToggle<cr>")
map("v", "<leader>,", ":'<,'>CommentToggle<cr>")

----------------------------------------------------------------------------------------------------------------
--                                           flit and leap                                                    --
----------------------------------------------------------------------------------------------------------------

require('leap').add_default_mappings()
require("flit").setup {}

----------------------------------------------------------------------------------------------------------------
--                                            vim-fswitch                                                     --
----------------------------------------------------------------------------------------------------------------

map("n", "<leader>h", "<cmd>FSHere<cr>")

----------------------------------------------------------------------------------------------------------------
--                                          general settings                                                  --
----------------------------------------------------------------------------------------------------------------

vim.api.nvim_set_option("clipboard", "unnamedplus")
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.cmd("set nohlsearch")
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.wildignore = '*.o,*.a,*/bin/*'
vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case --column --line-number'

require('onedark').setup {
  transparent = true
}
require('onedark').load()

----------------------------------------------------------------------------------------------------------------
--                                          general mappings                                                  --
----------------------------------------------------------------------------------------------------------------

map("v", "<tab>", ">gv")
map("v", "<s-tab>", "<gv")
map("n", "<tab>", ">>")
map("n", "<s-tab>", "<<")

map("i", "jk", "<esc>")
map("c", "jk", "<c-c>")
map("i", "jj", "()<esc>i")
map("i", "kk", "()")
map("i", "jl", "<esc>A<space>{<cr>}<esc><up>A<cr>")

map("n", "J", "20j")
map("n", "K", "20k")
map("v", "J", "20j")
map("v", "K", "20k")

map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader><leader>w", "<cmd>wa<cr>")
map("n", "<leader>q", "<cmd>q<cr>")
map("n", "<leader><leader>q", "<cmd>qa!<cr>")

map("n", "H", "<c-o>")
map("n", "L", "<c-i>")

map("n", "<leader>r", ":%s@<c-r><c-w>@@gc<left><left><left>")
map("v", "<leader>r", "y:%s@<C-r>\"@@gc<left><left><left>")

map("n", "<leader>R", ":%s@<c-r><c-w>@@g<left><left>")
map("v", "<leader>R", "y:%s@<C-r>\"@@g<left><left>")

map("n", "<leader>j", "mzJ`z")

map("n", "<leader>E", ":vsplit $MYVIMRC<cr>")
map("n", "<leader>S", ":source $MYVIMRC<cr>")

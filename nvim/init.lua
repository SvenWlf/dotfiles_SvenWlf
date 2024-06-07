local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local uv = vim.uv or vim.loop

--Auto-install lazy.nvim if not present
if not uv.fs_stat(lazypath) then
    print('Installing lazy.nvim....')
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
    print('Done.')
end

--
--Options
--

--Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.breakindentopt = { sbr = true }
vim.opt.expandtab = true
vim.opt.cindent = true

--Optic stuff
vim.opt.cursorline = true
vim.opt.cursorlineopt = "both"
vim.opt.number = true
vim.opt.ruler = true
vim.opt.scrolloff = 8

--Behaviour
vim.opt.autoread = true
vim.opt.clipboard = 'unnamedplus'

--Commands
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,full"

--Undo options
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.expand("~/config/nvim/undo//")
vim.opt.undofile = true

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    {'integrate-with-mason-nvim'},
    {'github/copilot.vim'},
    {'mbbill/undotree'},
    {'ggandor/leap.nvim',
        dependencies = {
            {'tpope/vim-repeat'},
        },
    },
    {'tpope/vim-fugitive'},
    {'folke/which-key.nvim',
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 50
    end,
        opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        },
    },
    {'nvim-telescope/telescope.nvim',
        dependencies = {
            {'nvim-lua/plenary.nvim'},
            {'BurntSushi/ripgrep'},
            {'nvim-telescope/telescope-fzy-native.nvim'},
            {'nvim-tree/nvim-web-devicons'},
            {'AckslD/nvim-neoclip.lua',
            config = function ()
                require('neoclip').setup()
            end
            },
    },
    },
    {'nvim-treesitter/nvim-treesitter'},
    {'EdenEast//nightfox.nvim'},
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
    {'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
   config = false,
   },
  -- LSP Support
    {'neovim/nvim-lspconfig',
    dependencies = {
        {'hrsh7th/cmp-nvim-lsp'},}
    },
  -- Autocompletion
    {'hrsh7th/nvim-cmp',
    dependencies = {
        {'L3MON4D3/LuaSnip',
            dependencies = {
                {"rafamadriz/friendly-snippets"},
                {'saadparwaiz1/cmp_luasnip'},
            },
        },
        {'hrsh7th/cmp-buffer'},
    },
    },
    {
    'saecki/crates.nvim',
    tag = 'stable',
    config = function()
        require('crates').setup()
    end,
    }
})

-- Set colorscheme
vim.opt.termguicolors = true
vim.cmd.colorscheme('carbonfox')

---
-- LSP setup
---
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({buffer = bufnr})
end)

--- if you want to know more about lsp-zero and mason.nvim
--- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
            -- (Optional) configure lua language server
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
        end,
    }
})

---
-- Autocompletion config
---
local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()
local cmp_format = require('lsp-zero').cmp_format({details = true})

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  sources = {
  { name = "cmp_luasnip" },
  { name = "nvim_lsp" },
  { name = "luasnip" },
  { name = "buffer" },
  { name = "path" },
  },
  --- (Optional) Show source name in completion menu
  formatting = cmp_format,
})

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        -- `Enter` key to confirm completion
        ['<CR>'] = cmp.mapping.confirm({select = false}),

        -- Ctrl+Space to trigger completion menu
        ['<C-Space>'] = cmp.mapping.complete(),

        -- Navigate between snippet placeholder
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),

        -- Scroll up and down in the completion documentation
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
    })
})

--
--Treesitter
--
require'nvim-treesitter.configs'.setup {
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    highlight = {
        enable = true,
        disable = { "vimdoc" },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also
        additional_vim_regex_highlighting = false,
    },
}

--
--Normal Keybinds
--
vim.g.mapleader = ' '
vim.keymap.set("n", "<leader>c", vim.cmd.Ex)

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

--
--Telescope
--
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

--
--NeoClip
--
vim.keymap.set('n', '<leader>v', '<cmd>lua require("telescope").extensions.neoclip.default()<cr>')
require('telescope').setup {
  extensions = {
    neoclip = {
      mappings = {
        paste = function()
          vim.keymap.set({'n', 'v', 'o'}, '<Enter>', '<cmd>lua require("telescope").extensions.neoclip.paste()<cr>', {noremap = true, silent = true})
        end,
      },
    },
  },
}

--
--Undotree
--
vim.g.undotree_WindowLayout = 4
vim.keymap.set('n', '<leader>z', vim.cmd.UndotreeToggle)

--
--Leap
--
vim.keymap.set({'n', 'x', 'o'}, '<A-f>', '<Plug>(leap-forward)')
vim.keymap.set({'n', 'x', 'o'}, '<A-F>', '<Plug>(leap-backward)')
vim.keymap.set({'n', 'x', 'o'}, '<A-w>', '<Plug>(leap-from-window)')

--
----copilot
--
vim.keymap.set('i', '<C-a>', 'copilot#Accept()', {expr=true, silent=true})

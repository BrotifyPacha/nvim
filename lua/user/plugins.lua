
local gh = function(x) return 'https://github.com/' .. x end

vim.pack.add({

    gh('brotifypacha/vim-colors-pencil'),

    -- gh('~/workspace/personal/tabs-as-projects.nvim'),
    gh('brotifypacha/tabs-as-projects.nvim'),
    gh('petertriho/nvim-scrollbar'),

    -- Completion
    gh('hrsh7th/nvim-cmp'),
    gh('hrsh7th/cmp-path'),
    gh('hrsh7th/cmp-buffer'),
    gh('hrsh7th/cmp-cmdline'),
    gh('hrsh7th/cmp-nvim-lsp'),
    gh('Snikimonkd/cmp-go-pkgs'),
    gh('ray-x/lsp_signature.nvim'),

    -- AI
    gh('milanglacier/minuet-ai.nvim'),

    -- Snippets
    gh('dcampos/nvim-snippy'),
    gh('dcampos/cmp-snippy'),
    gh('michaelb/sniprun'), --run='bash ./install.sh'}

    -- Lsp stuff
    gh('neovim/nvim-lspconfig'),
    gh('lvimuser/lsp-inlayhints.nvim'),

    -- File explorer
    gh('kyazdani42/nvim-web-devicons'), -- optional, for file icon
    gh('kyazdani42/nvim-tree.lua'),
    gh('nvim-lualine/lualine.nvim'),

    -- Utils
    gh('nvim-lua/popup.nvim'),
    gh('nvim-lua/plenary.nvim'),
    gh('nvim-treesitter/nvim-treesitter'),
    gh('nvim-treesitter/nvim-treesitter-context'),
    gh('nvim-treesitter/nvim-treesitter-locals'),
    gh('nvim-treesitter/nvim-treesitter-textobjects'),
    gh('folke/which-key.nvim'),
    gh('editorconfig/editorconfig-vim'),

    -- DAP
    gh('mfussenegger/nvim-dap'),
    gh('nvim-neotest/nvim-nio'),
    gh('rcarriga/nvim-dap-ui'),
    gh('mfussenegger/nvim-dap-python'),

    -- General
    gh('nvim-telescope/telescope.nvim'),
    gh('nvim-telescope/telescope-live-grep-args.nvim'),
    gh('lewis6991/gitsigns.nvim'),
    gh('norcalli/nvim-colorizer.lua'),
    gh('junegunn/vim-easy-align'),
    gh('wellle/targets.vim'),
    gh('Raimondi/delimitMate'),
    gh('tpope/vim-commentary'),
    gh('tpope/vim-unimpaired'),
    gh('tpope/vim-surround'),
    gh('tpope/vim-fugitive'),
    gh('tpope/vim-repeat'),
    gh('easymotion/vim-easymotion'),
    gh('tommcdo/vim-exchange'),
    gh('LintaoAmons/scratch.nvim'),

    -- Filetype specific
    gh('baskerville/vim-sxhkdrc'),
    gh('towolf/vim-helm'),
    gh('iamcco/markdown-preview.nvim'), --run = 'cd app && yarn install',

    gh('fatih/vim-go'),
    gh('olexsmir/gopher.nvim'),

    -- require("gopher").setup {
    --   gotests = {
    --     -- path to a directory containing custom test code templates
    --     template_dir = "/Users/" .. vim.env.USER .. "/.config/nvim/go-templates",
    --     -- switch table tests from using slice to map (with test name for the key)
    --     -- works only with gotests installed from develop branch
    --     named = false,
    --   },
    -- }
    -- end

    -- Tools
    gh('qpkorr/vim-renamer')

})

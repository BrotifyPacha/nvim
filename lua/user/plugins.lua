local fn = vim.fn

local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path
    }
    print 'Installing packer close and Reopen Neovim...'
    vim.cmd [[packadd packer.nvim]]
end

vim.cmd [[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]]

-- Safely require packer
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
    return
end

packer.init {
    display = {
        open_fn = function()
            return require('packer.util').float({})
        end
    }
}

return packer.startup(function(use)

    -- Let packer manage itself
    use 'wbthomason/packer.nvim'

    use 'brotifypacha/vim-colors-pencil'

    -- Completion
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'ray-x/lsp_signature.nvim'
    use 'folke/neodev.nvim'

    -- Snippets
    use 'dcampos/nvim-snippy'
    use 'dcampos/cmp-snippy'

    -- Lsp stuff
    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'lvimuser/lsp-inlayhints.nvim'

    -- File explorer
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icon
        }
    }

    use 'nvim-lualine/lualine.nvim'

    -- Utils
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/nvim-treesitter-refactor'
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'SmiteshP/nvim-gps'
    use 'folke/which-key.nvim'
    use 'mfussenegger/nvim-dap'
    use {
        'rcarriga/nvim-dap-ui',
        requires = {
          'nvim-neotest/nvim-nio',
        }
    }
    use {
        'Pocco81/DAPInstall.nvim',
        branch = 'dev',
    }
    use 'nvim-treesitter/playground'
    use 'editorconfig/editorconfig-vim'
    -- General
    use 'nvim-telescope/telescope.nvim'
    use 'lewis6991/gitsigns.nvim'
    use 'norcalli/nvim-colorizer.lua'
    use 'junegunn/vim-easy-align'
    use 'wellle/targets.vim'
    use 'Raimondi/delimitMate'
    use 'tpope/vim-commentary'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-repeat'
    use 'easymotion/vim-easymotion'
    use 'tommcdo/vim-exchange'
    use 'LintaoAmons/scratch.nvim'
    use { 'michaelb/sniprun', run='bash ./install.sh'}
    -- Visual
    use 'brotifypacha/goyo.vim'
    -- Filetype specific
    use 'baskerville/vim-sxhkdrc'
    use {
        'StanAngeloff/php.vim',
        opt = true,
        ft = { 'php', 'html', 'blade.php' }
    }
    use 'nelsyeung/twig.vim'
    use 'jwalton512/vim-blade'
    use 'towolf/vim-helm'
    use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install' }
    use { 'fatih/vim-go' }
    use { 'olexsmir/gopher.nvim', branch="develop", config = function ()
    require("gopher").setup {
      gotests = {
        -- path to a directory containing custom test code templates
        template_dir = "/home/" .. vim.env.USER .. "/.config/nvim/go-templates",
        -- switch table tests from using slice to map (with test name for the key)
        -- works only with gotests installed from develop branch
        named = false,
      },
    }
    end }
    use { 'mfussenegger/nvim-dap-python' }
    -- Tools
    use { 'qpkorr/vim-renamer', cmd = 'Renamer' }

    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
end)


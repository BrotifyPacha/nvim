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

-- require('user.plugin-config.treesitter')
-- require('user.plugin-config.dap')
-- require('user.plugin-config.colorizer')
-- 
-- require 'gitsigns'.setup()
--
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

    -- Utils
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/nvim-treesitter-refactor'
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'SirVer/ultisnips'
    use 'liuchengxu/vim-which-key'
    use { 'neoclide/coc.nvim', run = 'yarn install --frozen-lockfile' }
    use 'mfussenegger/nvim-dap'
    use 'Pocco81/DAPInstall.nvim'
    use 'rcarriga/nvim-dap-ui'
    use { 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' }
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
    use 'tommcdo/vim-exchange'
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
    use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview' }
    -- Tools
    use { 'qpkorr/vim-renamer', cmd = 'Renamer' }

    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
end)

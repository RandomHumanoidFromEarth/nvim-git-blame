if vim.g.nvim_gi_blame_loaded then
    return
end

vim.g.nvim_git_blame_loaded = true

require("nvim-git-blame").setup()

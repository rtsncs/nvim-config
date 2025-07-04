return {
    "mfussenegger/nvim-lint",
    config = function()
        require('lint').linters_by_ft = {
            javascriptreact = { 'eslint_d' },
            typescript = { 'eslint_d' },
            typescriptreact = { 'eslint_d' },
            go = { 'golangcilint' },
        }

        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
                require("lint").try_lint()
            end,
        })
    end
}

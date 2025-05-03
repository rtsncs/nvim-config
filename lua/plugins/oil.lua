return {
    'stevearc/oil.nvim',
    keys = { { "-", "<CMD>Oil<CR>" } },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("oil").setup() end
}

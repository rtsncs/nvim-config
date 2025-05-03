return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    config = function() require("telescope").load_extension("fzf") end,
    keys = {
        {
            "<leader>,",
            "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
            desc = "Switch Buffer",
        },
        { "<leader>/",  "<cmd>Telescope live_grep<CR>",                                desc = "Grep (root dir)" },
        { "<leader>f",  "<cmd>Telescope find_files<CR>",                               desc = "Find Files (root dir)" },
        { "<leader>b",  "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
        -- git
        { "<leader>gf", "<cmd>Telescope git_files<CR>",                                desc = "Git files" },
        { "<leader>gc", "<cmd>Telescope git_commits<CR>",                              desc = "commits" },
        { "<leader>gs", "<cmd>Telescope git_status<CR>",                               desc = "status" },
        -- search
        { '<leader>s"', "<cmd>Telescope registers<cr>",                                desc = "Registers" },
        { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>",                desc = "Buffer" },
        { "<leader>d",  "<cmd>Telescope diagnostics bufnr=0<cr>",                      desc = "Document diagnostics" },
        { "<leader>D",  "<cmd>Telescope diagnostics<cr>",                              desc = "Workspace diagnostics" },
        { "<leader>sk", "<cmd>Telescope keymaps<cr>",                                  desc = "Key Maps" },
        { "<leader>M",  "<cmd>Telescope man_pages<cr>",                                desc = "Man Pages" },
        { "<leader>m",  "<cmd>Telescope marks<cr>",                                    desc = "Jump to Mark" },
        {
            "<leader>ss",
            function()
                require("telescope.builtin").lsp_document_symbols()
            end,
            desc = "Goto Symbol",
        },
        {
            "<leader>sS",
            function()
                require("telescope.builtin").lsp_dynamic_workspace_symbols({
                    symbols = require("lazyvim.config").get_kind_filter(),
                })
            end,
            desc = "Goto Symbol (Workspace)",
        },
    },
}

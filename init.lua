local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = false

vim.opt.list = true
vim.opt.listchars = {
    -- tab = "⇥ ",
    tab = "│ ",
    trail = "+",
    precedes = "<",
    extends = ">",
    space = "·",
    nbsp = "␣",
}

vim.g.c_syntax_for_h = 1

local function update_lead()
    local lcs = vim.opt_local.listchars:get()
    local tab = vim.fn.str2list(lcs.tab)
    -- local tab = "│ "
    local space = vim.fn.str2list(lcs.multispace or lcs.space)
    local lead = { tab[1] }
    for i = 1, vim.bo.tabstop - 1 do
        lead[#lead + 1] = space[i % #space + 1]
    end
    vim.opt_local.listchars:append({ leadmultispace = vim.fn.list2str(lead) })
end
vim.api.nvim_create_autocmd("OptionSet", { pattern = { "listchars", "tabstop", "filetype" }, callback = update_lead })
vim.api.nvim_create_autocmd("VimEnter", { callback = update_lead, once = true })

vim.keymap.set("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')

vim.keymap.set("n", "ga", "<cmd>b#<CR>")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.opt.guifont = "IosevkaTerm NF:h13.75"

require("lazy").setup({
    {
        "gbprod/nord.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require('nord').setup({})
            vim.cmd.colorscheme("nord")
        end,
    },
    {
        'stevearc/conform.nvim',
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                -- Customize or remove this keymap to your liking
                "<leader>cf",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        config = function()
            require("conform").setup {
                formatters_by_ft = {
                    javascript = { "prettierd" },
                    javascriptreact = { "prettierd" },
                    typescript = { "prettierd" },
                    typescriptreact = { "prettierd" },
                    json = { "prettierd" },
                    css = { "prettierd" },
                },
                formatters = {
                    injected = { options = { ignore_errors = true } },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true,
                },
            }
        end,
        init = function()
            -- If you want the formatexpr, here is the place to set it
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },
    {
        "mfussenegger/nvim-lint",
        config = function()
            require('lint').linters_by_ft = {
                javascriptreact = { 'eslint_d' },
                typescript = { 'eslint_d' },
                typescriptreact = { 'eslint_d' }
            }

            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")
            local servers = { "lua_ls", "rust_analyzer", "pylsp", "ts_ls", "emmet_ls", "clangd", "lexical", "cssls" }

            for _, lsp in ipairs(servers) do
                lspconfig[lsp].setup {
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" }
                            }
                        },
                        ["rust_analyzer"] = {
                            check = {
                                command = "clippy"
                            }
                        },
                    }
                }
            end
            lspconfig['tailwindcss'].setup {
                on_attach = function(client, bufnr)
                    if client.server_capabilities.inlayHintProvider then
                        vim.lsp.inlay_hint.enable(bufnr, true)
                    end
                end,
                capabilities = capabilities,
                filetypes = { "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "gohtmltmpl", "haml", "handlebars", "hbs", "html", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "pug", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte" },
                init_options = {
                    userLanguages = { pug = "html" }
                }
            }

            vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local opts = { buffer = ev.buf }

                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)
                end,
            })
        end
    },
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        version = false,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        },
        config = function()
            local kind_icons = {
                Text = "",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰇽",
                Variable = "󰂡",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "󰅲",
            }
            local cmp = require("cmp")

            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'cmdline' }
                }
            })

            cmp.setup {
                sources = cmp.config.sources {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                },
                formatting = {
                    format = function(entry, vim_item)
                        -- Kind icons
                        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
                        -- Source
                        vim_item.menu = ({
                            buffer = "[Buffer]",
                            nvim_lsp = "[LSP]",
                            nvim_lua = "[Lua]",
                            latex_symbols = "[LaTeX]",
                        })[entry.source.name]
                        return vim_item
                    end
                },
                mapping = {
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<CR>"] = cmp.mapping({
                        i = function(fallback)
                            if cmp.visible() and cmp.get_active_entry() then
                                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
                            else
                                fallback()
                            end
                        end,
                        s = cmp.mapping.confirm({ select = true }),
                        c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
                    }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            if #cmp.get_entries() == 1 then
                                cmp.confirm({ select = true })
                            else
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                            end
                        else
                            fallback()
                        end
                    end, { "i", "s", "c", }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            fallback()
                        end
                    end, { "i", "s", "c", }),
                },
                experimental = {
                    ghost_text = true
                },
            }
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
        dependencies = { "windwp/nvim-ts-autotag" },
        init = function(plugin)
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        config = function()
            require("nvim-treesitter.configs").setup({
                auto_install = true,
                highlight = { enable = true },
                autotag = { enable = true },
                -- indent = { enable = true },
            })
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            vim.opt.foldenable = false
        end,
    },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = { options = { globalstatus = true, theme = 'nord' } },
    },
    {
        'stevearc/oil.nvim',
        keys = { { "-", "<CMD>Oil<CR>" } },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function() require("oil").setup() end
    },
    {
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
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = { check_ts = true, }
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
    },
    {
        'kylechui/nvim-surround',
        opts = {},
    },
    {
        'lewis6991/gitsigns.nvim',
        opts = {},
    },
    {
        'nmac427/guess-indent.nvim',
        opts = {},
    }
})

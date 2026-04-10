return {
    'saghen/blink.cmp',
    version = '*',
    dependencies = { "xzbdmw/colorful-menu.nvim" },

    opts = {
        keymap = { preset = 'enter' },

        signature = { enabled = true },

        appearance = {
            nerd_font_variant = 'mono',
        },

        completion = {
            menu = {
                draw = {
                    columns = { { "kind_icon" }, { "label", gap = 1 }, { "source_name" }, },
                    components = {
                        label = {
                            text = function(ctx)
                                return require("colorful-menu").blink_components_text(ctx)
                            end,
                            highlight = function(ctx)
                                return require("colorful-menu").blink_components_highlight(ctx)
                            end,
                        }
                    }
                }
            }
        },

        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
    },
    opts_extend = { "sources.default" }
}

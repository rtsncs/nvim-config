return {
    -- { 'saghen/blink.indent' },
    {
        'saghen/blink.pairs',
        version = '*',
        dependencies = 'saghen/blink.download',
        opts = {
            mappings = {
                enabled = true,
            },
            highlights = {
                enabled = true,
                matchparen = {
                    enabled = true,
                    include_surrounding = true,
                }
            }
        },
    }
}

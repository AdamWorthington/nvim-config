return {
    {
        "zbirenbaum/copilot.lua",
        event = { "BufEnter" },
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = false,
                },
                panel = {
                    enabled = true,
                    keymap = {
                        jump_prev = "[[",
                        jump_next = "]]",
                        accept = "<CR>",
                        refresh = "gr",
                        open = "<C-CR>"
                    },
                    layout = {
                        position = "right",
                    },
                },
            })
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        event = { "BufEnter" },
        dependencies = { "zbirenbaum/copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end,
    },
}

---@diagnostic disable: missing-fields

return {
    {
        "hrsh7th/nvim-cmp",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            "onsails/lspkind.nvim",
            "windwp/nvim-ts-autotag",
            --"windwp/nvim-autopairs",
        },
        config = function()
            --local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

			--require("nvim-autopairs").setup()

			-- Integrate nvim-autopairs with cmp
			--cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			-- Load snippets
			require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                completion = {
                    completeopt = "menu,menuone,preview",
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    --completion = cmp.config.window.bordered(),
                    --documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                    ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
                    ["<C-u>"] = cmp.mapping.scroll_docs(4), -- scroll up preview
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4), -- scroll down preview
                    ["<C-Space>"] = cmp.mapping.complete({}), -- show completion suggestions
                    ["<C-e>"] = cmp.mapping.abort(), -- close completion window
                    --["<TAB>"] = cmp.mapping.confirm({ select = true }), -- select suggestion
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        local copilot = require 'copilot.suggestion'
                        if copilot.is_visible() then
                            copilot.accept()
                        elseif cmp.visible() then
                            local entry = cmp.get_selected_entry()
                            if not entry then
                                cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                            else
                                cmp.confirm()
                            end
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                -- sources for autocompletion
                sources = cmp.config.sources({
                    { name = "nvim_lsp" }, -- lsp
                    { name = "buffer", max_item_count = 5 }, -- text within current buffer
                    --{ name = "copilot" }, -- Copilot suggestions
                    { name = "path", max_item_count = 3 }, -- file system paths
                    { name = "luasnip", max_item_count = 3 }, -- snippets
                }),
                -- Enable pictogram icons for lsp/autocompletion
                formatting = {
                    expandable_indicator = true,
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "...",
                        symbol_map = {
                            Copilot = "",
                        },
                    }),
                },
                experimental = {
                    ghost_text = false,
                },
            })
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    {
                        name = 'cmdline',
                        option = {
                            ignore_cmds = { 'Man', '!' }
                        }
                    }
                })
            })
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })
        end,
    },
}

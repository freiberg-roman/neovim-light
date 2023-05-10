local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

return packer.startup({function(use)
	-- My plugins here
	use({ "wbthomason/packer.nvim" })
	use({ "nvim-lua/plenary.nvim" }) -- Helper functions
	use({ "windwp/nvim-autopairs" }) 
    use({ "karb94/neoscroll.nvim" })
    use({ "catppuccin/nvim", as = "catppuccin" })


    use ({ "hrsh7th/nvim-cmp"})
    use ({ "hrsh7th/cmp-nvim-lsp" })
    use ({ "hrsh7th/cmp-path" })
    use ({ "hrsh7th/cmp-buffer" })
    use ({ "hrsh7th/cmp-omni" })
    use ({ "neovim/nvim-lspconfig" })
    use ({"akinsho/toggleterm.nvim",
    tag = '*', config = function()
      require("toggleterm").setup()
    end})
    use ({
        "nvim-treesitter/nvim-treesitter",
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    })

    use ({'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'})

    use ({
      "williamboman/mason.nvim",
      run = ":MasonUpdate" -- :MasonUpdate updates registry contents
    })

    use ({
      "nvim-tree/nvim-tree.lua",
    })

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end

end,
})

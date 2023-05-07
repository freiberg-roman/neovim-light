local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

return packer.startup(function(use)
	-- My plugins here
	use({ "wbthomason/packer.nvim" })
	use({ "nvim-lua/plenary.nvim" }) -- Helper functions
	use({ "windwp/nvim-autopairs" }) 
    use({ "karb94/neoscroll.nvim" })

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)

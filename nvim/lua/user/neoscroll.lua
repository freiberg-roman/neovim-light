local status_ok, packer = pcall(require, "neoscroll")
if not status_ok then
	return
end

require('neoscroll').setup()

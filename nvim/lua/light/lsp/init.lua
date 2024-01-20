local M = {}
local utils = require "light.utils"

local lsp = require("light.lsp.config")
local function add_lsp_buffer_options(bufnr)
  for k, v in pairs(lsp.config.buffer_options) do
    vim.api.nvim_buf_set_option(bufnr, k, v)
  end
end

local function add_lsp_buffer_keybindings(bufnr)
  local mappings = {
    normal_mode = "n",
    insert_mode = "i",
    visual_mode = "v",
  }

  for mode_name, mode_char in pairs(mappings) do
    for key, remap in pairs(lsp.config.buffer_mappings[mode_name]) do
      local opts = { buffer = bufnr, desc = remap[2], noremap = true, silent = true }
      vim.keymap.set(mode_char, key, remap[1], opts)
    end
  end
end

function M.common_capabilities()
  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    return cmp_nvim_lsp.default_capabilities()
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }

  return capabilities
end

function M.common_on_init(client, bufnr)
  if lsp.config.on_init_callback then
    lsp.config.on_init_callback(client, bufnr)
    return
  end
end

function M.common_on_attach(client, bufnr)
  if lsp.config.on_attach_callback then
    lsp.config.on_attach_callback(client, bufnr)
  end
  local lu = require "light.lsp.utils"
  if lsp.config.document_highlight then
    lu.setup_document_highlight(client, bufnr)
  end
  if lsp.config.code_lens_refresh then
    lu.setup_codelens_refresh(client, bufnr)
  end
  add_lsp_buffer_keybindings(bufnr)
  add_lsp_buffer_options(bufnr)
  lu.setup_document_symbols(client, bufnr)
end

function M.get_common_opts()
  return {
    on_attach = M.common_on_attach,
    on_init = M.common_on_init,
    on_exit = M.common_on_exit,
    capabilities = M.common_capabilities(),
  }
end

function M.setup()
  local lspconfig = require("lspconfig")
  lspconfig.pyright.setup {}
  lspconfig.lua_ls.setup {}
  lspconfig.rust_analyzer.setup {
    filetypes = { "rust" },
    settings = {
      ['rust-analyzer'] = {
        cargo = {
          allFeatures = true,
        }
      }
    }
  }

  for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  local lsp = require("light.lsp.config")
  if not utils.is_directory(lsp.config.templates_dir) then
    require("light.lsp.templates").generate_templates()
  end

  pcall(function()
    require("nlspsettings").setup(lsp.nlsp_settings.setup)
  end)

  require("light.lsp.null-ls").setup()


  local function set_handler_opts_if_not_set(name, handler, opts)
    if debug.getinfo(vim.lsp.handlers[name], "S").source:match(vim.env.VIMRUNTIME) then
      vim.lsp.handlers[name] = vim.lsp.with(handler, opts)
    end
  end

  set_handler_opts_if_not_set("textDocument/hover", vim.lsp.handlers.hover, { border = "rounded" })
  set_handler_opts_if_not_set("textDocument/signatureHelp", vim.lsp.handlers.signature_help, { border = "rounded" })
end

return M

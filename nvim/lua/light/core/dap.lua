local M = {}

local icons = require("light.icons")
local dap_config = {
  active = true,
  on_config_done = nil,
  breakpoint = {
    text = icons.ui.Bug,
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
  },
  breakpoint_rejected = {
    text = icons.ui.Bug,
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
  },
  stopped = {
    text = icons.ui.BoldArrowRight,
    texthl = "DiagnosticSignWarn",
    linehl = "Visual",
    numhl = "DiagnosticSignWarn",
  },
  log = {
    level = "info",
  },
  ui = {
    auto_open = true,
    notify = {
      threshold = vim.log.levels.INFO,
    },
    config = {
      icons = { expanded = "", collapsed = "", circular = "" },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      -- Use this to override mappings for specific elements
      element_mappings = {},
      expand_lines = true,
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.33 },
            { id = "breakpoints", size = 0.17 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 0.33,
          position = "right",
        },
        {
          elements = {
            { id = "repl", size = 0.45 },
            { id = "console", size = 0.55 },
          },
          size = 0.27,
          position = "bottom",
        },
      },
      controls = {
        enabled = true,
        -- Display controls in this element
        element = "repl",
        icons = {
          pause = "",
          play = "",
          step_into = "",
          step_over = "",
          step_out = "",
          step_back = "",
          run_last = "",
          terminate = "",
        },
      },
      floating = {
        max_height = 0.9,
        max_width = 0.5, -- Floats will be treated as percentage of your screen.
        border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = { indent = 1 },
      render = {
        max_type_length = nil, -- Can be integer or nil.
        max_value_lines = 100, -- Can be integer or nil.
      },
    },
  },
}

M.setup = function()
  local status_ok, dap = pcall(require, "dap")
  if not status_ok then
    return
  end

  if true then
    vim.fn.sign_define("DapBreakpoint", dap_config.breakpoint)
    vim.fn.sign_define("DapBreakpointRejected", dap_config.breakpoint_rejected)
    vim.fn.sign_define("DapStopped", dap_config.stopped)
  end

  dap.set_log_level(dap_config.log.level)

  if dap_config.on_config_done then
    dap_config.on_config_done(dap)
  end
end

M.setup_ui = function()
  local dap = require("dap")
  local dapui = require("dapui")
  dap.adapters.python = {
    type = "executable",
    command = "python",
    args = { "-m", "debugpy.adapter"}
  }
  dap.configurations.python = {
    {
      type = 'python';
      request = 'launch';
      name = "Launch file";
      program = "${file}";
      pythonPath = function()
        local executable = os.getenv("CONDA_PREFIX")
        if executable then
          return executable .. "/bin/python"
        else
          print("No conda environment is active.")
        end
      end;
    },
  }
  dapui.setup(dap_config.ui.config)

  if dap_config.ui.auto_open then
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
  end


  -- until rcarriga/nvim-dap-ui#164 is fixed
  local function notify_handler(msg, level, opts)
    if level >= dap_config.ui.notify.threshold then
      return vim.notify(msg, level, opts)
    end

    opts = vim.tbl_extend("keep", opts or {}, {
      title = "dap-ui",
      icon = "",
      on_open = function(win)
        vim.api.nvim_buf_set_option(vim.api.nvim_win_get_buf(win), "filetype", "markdown")
      end,
    })

    -- vim_log_level can be omitted
    if not (level == nil) and type(level) == "string" then
      -- https://github.com/neovim/neovim/blob/685cf398130c61c158401b992a1893c2405cd7d2/runtime/lua/vim/lsp/log.lua#L5
      level = level + 1
    end

    msg = string.format("%s: %s", opts.title, msg)
  end
  -- Keybindings
  vim.api.nvim_set_keymap('n', '<space>dt', '<cmd>lua require("dap").toggle_breakpoint()<CR>', {noremap = true})
  vim.api.nvim_set_keymap('n', '<space>dd', '<cmd>lua require("dap").continue()<CR>', {noremap = true})
  vim.api.nvim_set_keymap('n', '<space>dc', '<cmd>lua require("dap").close(); require("dapui").close()<CR>', {noremap = true})

  local _, _ = xpcall(function()
    require("dapui.util").notify = notify_handler
  end, debug.traceback)
end

return M

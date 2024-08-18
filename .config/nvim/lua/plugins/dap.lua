return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
    },
    config = function()
      require("dapui").setup()
      local dap = require("dap")
      local dapui = require("dapui")
      -- Define sign icons for breakpoints
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition",
        { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStopped", numhl = "" })
      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>gb", dap.run_to_cursor)
      vim.keymap.set("n", "<leader>?", function()
        require("dapui").eval(nil, { enter = true })
      end)
      vim.keymap.set("n", "<F1>", dap.continue)
      vim.keymap.set("n", "<F2>", dap.step_into)
      vim.keymap.set("n", "<F3>", dap.step_over)
      vim.keymap.set("n", "<F4>", dap.step_out)
      vim.keymap.set("n", "<F5>", dap.step_back)
      vim.keymap.set("n", "<F10>", dap.restart)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      local function find_cargo_toml()
        local current_file = vim.fn.expand('%:p')
        local current_dir = vim.fn.fnamemodify(current_file, ':h')
        local cargo_toml = vim.fn.findfile("Cargo.toml", current_dir .. ";")

        -- If we're in the root of the monorepo, we might need to look for a Cargo.toml in subdirectories
        if cargo_toml == "" then
          for _, dir in ipairs(vim.fn.globpath(current_dir, "**/Cargo.toml", 0, 1)) do
            if string.match(current_file, vim.fn.fnamemodify(dir, ":h")) then
              cargo_toml = dir
              break
            end
          end
        end

        return cargo_toml ~= "" and vim.fn.fnamemodify(cargo_toml, ":p") or ""
      end


      -- dap.listeners.before.event_terminated["dapui_config"] = function()
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited["dapui_config"] = function()
      --   dapui.close()
      -- end

      dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. '/mason/bin/codelldb',
          args = { "--port", "${port}" },
        }
      }
      dap.configurations.rust = {
        {
          name = "Debug Rust",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
          end,
          cwd = function()
            local cargo_toml = find_cargo_toml()
            return cargo_toml ~= "" and vim.fn.fnamemodify(cargo_toml, ":p:h") or vim.fn.getcwd()
          end,
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
      }
    end
  }
}

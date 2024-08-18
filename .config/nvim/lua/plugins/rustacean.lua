return {
  "mrcjkb/rustaceanvim",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-lua/plenary.nvim",
  },
  version = "^4",
  ft = { "rust" },
  config = function()
    local map_lsp_keybinds = require("user.keymaps").map_lsp_keybinds

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
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(client, bufnr)
          map_lsp_keybinds(bufnr)
          -- Additional rustaceanvim specific keybinds
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "rust",
            callback = function()
              vim.keymap.set("n", "<leader>dr", function()
                local cargo_toml = find_cargo_toml()
                local crate_root = cargo_toml ~= "" and vim.fn.fnamemodify(cargo_toml, ":p:h") or vim.fn.getcwd()
                vim.cmd("lcd " .. crate_root)
                print("Set working directory to: " .. crate_root)
                vim.cmd.RustLsp('debuggables')
              end, { buffer = true, desc = "Rust: Run Debuggables" })
            end
          })
          vim.keymap.set("n", "<leader>rr", function()
            vim.cmd.RustLsp('runnables')
          end, { buffer = bufnr, desc = "Rust: Run Runnables" })
        end,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      },
      tools = {
        executor = require("rustaceanvim/executors").termopen,
        reload_workspace_from_cargo_toml = true,
        inlay_hints = {
          auto = true,
        },
        hover_actions = {
          auto_focus = true,
        },
        runnables = {
          use_telescope = true,
        },
      },
      debuggables = {
        settings = {
          exec = {
            -- This ensures the debugger uses the crate root as the working directory
            cwd = function()
              local current_file = vim.fn.expand('%:p')
              local current_dir = vim.fn.fnamemodify(current_file, ':h')
              local cargo_toml = vim.fn.findfile("Cargo.toml", current_dir .. ";")
              if cargo_toml ~= "" then
                return vim.fn.fnamemodify(cargo_toml, ":p:h")
              end
              return vim.fn.getcwd()
            end,
          },
        },
      },
    }
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "rust",
      callback = function()
        vim.keymap.set("n", "<leader>dr", function()
          local crate_root = vim.fn.fnamemodify(vim.fn.findfile("Cargo.toml", vim.fn.expand("%:p:h") .. ";"), ":h")
          vim.cmd("lcd " .. crate_root) -- Use lcd instead of cd to change directory only for the current window
          print("Set working directory to: " .. crate_root)
          vim.cmd.RustLsp('debuggables')
        end, { buffer = true, desc = "Rust: Run Debuggables" })
      end
    })
  end,
}

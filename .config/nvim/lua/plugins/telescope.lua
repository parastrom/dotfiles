return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build =
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        cond = vim.fn.executable("cmake") == 1,
      },
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      }
    },
    config = function()
      local actions = require("telescope.actions")
      local telescope = require("telescope")

      local border_chars_telescope_prompt_thin = { "▔", "▕", " ", "▏", "🭽", "🭾", "▕", "▏" }
      local border_chars_telescope_vert_preview_thin = { " ", "▕", "▁", "▏", "▏", "▕", "🭿", "🭼" }
      local border_chars_outer_thin_telescope = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" }

      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.5,
              results_width = 0.5,
            },
            width = 0.75,
            height = 0.6,
            preview_cutoff = 120,
          },
          borderchars = {
            prompt = border_chars_telescope_prompt_thin,
            preview = border_chars_telescope_vert_preview_thin,
            results = border_chars_outer_thin_telescope,
          },
          sorting_strategy = "ascending",
          border = true,
          multi_icon = "",
          entry_prefix = " ",
          prompt_prefix = " ",
          selection_caret = ">",
          results_title = "",
          preview_title = "",
          winblend = 0,
          wrap_results = true,
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-x>"] = actions.delete_buffer,
              ["<Esc>"] = actions.close,
            },
          },
          file_ignore_patterns = {
            "node_modules",
            "yarn.lock",
            ".git",
            ".sl",
            "_build",
            ".next",
          },
          hidden = true
        },
        pickers = {
          buffers = {
            preview = false,
            wrap_results = false,
            layout_config = {
              height = 0.4,
              width = 0.5,
            },
            sort_mru = true,
            ignore_current_buffer = true,
          },
          find_files = {
            preview_title = "",
          },
          live_grep = {
            preview_title = "",
          },
        }
      })

      -- Enable telescope fzf native, if installed
      require("telescope").load_extension("live_grep_args")
      require("telescope").load_extension("notify")
      pcall(require("telescope").load_extension, "fzf")

      -- Add line numbers to preview
      vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopePreviewerLoaded",
        callback = function() vim.opt_local.number = true end,
      })
    end,
  },
}

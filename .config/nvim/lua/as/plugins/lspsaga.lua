return function()
  local saga = require("lspsaga")
  local map = as_utils.map

  saga.init_lsp_saga {
    finder_action_keys = {
      open = "o",
      vsplit = "v",
      split = "s",
      quit = "q"
    }
  }
  map("n", "gp", "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>")
  map("n", "<leader>ca", [[<cmd>lua require('lspsaga.codeaction').code_action()<CR>]])
  map("n", "gh", [[<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>]])

  -- jump diagnostic
  map("n", "]c", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>")
  map("n", "[c", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>")
  map("i", "<c-k>", "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>")
  map("n", "<leader>rn", "<cmd>lua require('lspsaga.rename').rename()<CR>")
  map("n", "<leader>ca", "<cmd>lua require('lspsaga.codeaction').code_action()<CR>")
  map("x", "<leader>a", "<cmd>'<,'>lua require('lspsaga.codeaction').range_code_action()<CR>")
  map("n", "K", "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>")

  require("as.autocommands").create(
    {
      LspSagaCursorCommands = {
        {"CursorHold", "*", "lua require('lspsaga.diagnostic').show_line_diagnostics()"},
        {"CursorHoldI", "*", "lua require('lspsaga.signaturehelp').signature_help()"}
      }
    }
  )
end

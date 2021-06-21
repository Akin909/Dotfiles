as.lsp = {}
-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//
local function setup_autocommands(client, _)
  -- FIXME this opens even when there is no content
  -- as.augroup(
  --   "LspLocationList",
  --   {
  --     {
  --       events = {"User LspDiagnosticsChanged"},
  --       command = function()
  --         vim.lsp.diagnostic.set_loclist({workspace = true, severity_limit = "Warning"})
  --       end
  --     }
  --   }
  -- )
  if client and client.resolved_capabilities.code_lens then
    as.augroup("LspCodeLens", {
      {
        events = { "BufEnter", "CursorHold", "InsertLeave" },
        targets = { "<buffer>" },
        command = vim.lsp.codelens.refresh,
      },
    })
  end
  if client and client.resolved_capabilities.document_highlight then
    as.augroup("LspCursorCommands", {
      {
        events = { "CursorHold" },
        targets = { "<buffer>" },
        command = vim.lsp.buf.document_highlight,
      },
      {
        events = { "CursorHoldI" },
        targets = { "<buffer>" },
        command = vim.lsp.buf.document_highlight,
      },
      {
        events = { "CursorMoved" },
        targets = { "<buffer>" },
        command = vim.lsp.buf.clear_references,
      },
    })
  end
  if client and client.resolved_capabilities.document_formatting then
    -- format on save
    as.augroup("LspFormat", {
      {
        events = { "BufWritePre" },
        targets = { "<buffer>" },
        command = "lua vim.lsp.buf.formatting_sync(nil, 5000)",
      },
    })
  end
end
-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//

---Setup mapping when an lsp attaches to a buffer
---@param client table lsp client
---@param bufnr integer?
local function setup_mappings(client, bufnr)
  -- check that there are no existing mappings before assigning these
  local nnoremap, vnoremap, opts =
    as.nnoremap, as.vnoremap, { buffer = bufnr, check_existing = true }

  nnoremap("gd", vim.lsp.buf.definition, opts)
  if client.resolved_capabilities.implementation then
    nnoremap("gi", vim.lsp.buf.implementation, opts)
  end

  if client.resolved_capabilities.type_definition then
    nnoremap("<leader>gd", vim.lsp.buf.type_definition, opts)
  end

  nnoremap("<leader>ca", vim.lsp.buf.code_action, opts)
  vnoremap("<leader>ca", vim.lsp.buf.range_code_action, opts)

  nnoremap("]c", function()
    vim.lsp.diagnostic.goto_prev {
      popup_opts = { border = "rounded", focusable = false },
    }
  end, opts)

  nnoremap("[c", function()
    vim.lsp.diagnostic.goto_next {
      popup_opts = { border = "rounded", focusable = false },
    }
  end, opts)

  nnoremap("K", vim.lsp.buf.hover, opts)
  nnoremap("gI", vim.lsp.buf.incoming_calls, opts)
  nnoremap("gr", vim.lsp.buf.references, opts)

  if client.supports_method "textDocument/rename" then
    nnoremap("<leader>rn", vim.lsp.buf.rename, opts)
  end

  nnoremap("<leader>cs", vim.lsp.buf.document_symbol, opts)
  nnoremap("<leader>cw", vim.lsp.buf.workspace_symbol, opts)
  nnoremap("<leader>rf", vim.lsp.buf.formatting, opts)
  require("which-key").register {
    ["<leader>rf"] = "lsp: format buffer",
    ["<leader>ca"] = "lsp: code action",
    ["<leader>gd"] = "lsp: go to type definition",
    ["gr"] = "lsp: references",
    ["gi"] = "lsp: implementation",
    ["gI"] = "lsp: incoming calls",
  }
end

function as.lsp.tagfunc(pattern, flags)
  if flags ~= "c" then
    return vim.NIL
  end
  local params = vim.lsp.util.make_position_params()
  local client_id_to_results, err = vim.lsp.buf_request_sync(
    0,
    "textDocument/definition",
    params,
    500
  )
  assert(not err, vim.inspect(err))

  local results = {}
  for _, lsp_results in ipairs(client_id_to_results) do
    for _, location in ipairs(lsp_results.result or {}) do
      local start = location.range.start
      table.insert(results, {
        name = pattern,
        filename = vim.uri_to_fname(location.uri),
        cmd = string.format("call cursor(%d, %d)", start.line + 1, start.character + 1),
      })
    end
  end
  return results
end

require("vim.lsp.protocol").CompletionItemKind = {
  " Text", -- Text
  " Method", -- Method
  "ƒ Function", -- Function
  " Constructor", -- Constructor
  "識 Field", -- Field
  " Variable", -- Variable
  " Class", -- Class
  "ﰮ Interface", -- Interface
  " Module", -- Module
  " Property", -- Property
  " Unit", -- Unit
  " Value", -- Value
  "了 Enum", -- Enum
  " Keyword", -- Keyword
  " Snippet", -- Snippet
  " Color", -- Color
  " File", -- File
  "渚 Reference", -- Reference
  " Folder", -- Folder
  " Enum", -- Enum
  " Constant", -- Constant
  " Struct", -- Struct
  "鬒 Event", -- Event
  "\u{03a8} Operator", -- Operator
  " Type Parameter", -- TypeParameter
}

function as.lsp.on_attach(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_mappings(client, bufnr)

  if client.resolved_capabilities.goto_definition then
    vim.bo[bufnr].tagfunc = "v:lua.as.lsp.tagfunc"
  end

  require("lsp_signature").on_attach {
    bind = true,
    hint_enable = false,
    handler_opts = {
      border = "rounded",
    },
  }
  require("lsp-status").on_attach(client)
end

-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//
--- LSP server configs are setup dynamically as they need to be generated during
--- startup so things like runtimepath for lua is correctly populated
as.lsp.servers = {
  lua = function()
    --- NOTE: This is the secret sauce that allows reading requires and variables
    --- between different modules in the nvim lua context
    --- @see https://gist.github.com/folke/fe5d28423ea5380929c3f7ce674c41d8
    --- if I ever decide to move away from lua dev then use the above
    return require("lua-dev").setup {
      lspconfig = {
        settings = {
          Lua = {
            diagnostics = {
              globals = {
                "vim",
                "describe",
                "it",
                "before_each",
                "after_each",
                "pending",
                "teardown",
              },
            },
            completion = { keywordSnippet = "Replace", callSnippet = "Replace" },
          },
        },
      },
    }
  end,
  diagnosticls = function()
    return {
      rootMarkers = { ".git/" },
      filetypes = { "yaml", "json", "html", "css", "markdown", "lua", "graphql" },
      init_options = {
        formatters = {
          prettier = {
            rootPatterns = { ".git" },
            command = "prettier",
            args = { "--stdin-filepath", "%filename" },
          },
          luaformatter = {
            -- 'lua-format -i -c {config_dir}'
            -- add ".lua-format" to root if using lua-format
            rootPatterns = { ".git" },
            command = "lua-format",
            args = { "-i", "-c", "./.lua-format" },
          },
          stylua = {
            rootPatterns = { ".git" },
            command = "stylua",
            args = { "-" },
          },
        },
        formatFiletypes = {
          json = "prettier",
          html = "prettier",
          css = "prettier",
          yaml = "prettier",
          markdown = "prettier",
          graphql = "prettier",
          lua = "stylua",
        },
      },
    }
  end,
}

function as.lsp.setup_servers()
  local lspinstall = require "lspinstall"
  local lspconfig = require "lspconfig"

  lspinstall.setup()
  local installed = lspinstall.installed_servers()
  local status_capabilities = require("lsp-status").capabilities
  for _, server in pairs(installed) do
    local mk_config = as.lsp.servers[server]
    local config = mk_config and mk_config() or {}
    config.flags = config.flags or {}
    config.flags.debounce_text_changes = 150
    config.on_attach = as.lsp.on_attach
    if not config.capabilities then
      config.capabilities = vim.lsp.protocol.make_client_capabilities()
    end
    config.capabilities.textDocument.completion.completionItem.snippetSupport = true
    config.capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    }
    config.capabilities = as.deep_merge(status_capabilities, config.capabilities)
    lspconfig[server].setup(config)
  end
end

-----------------------------------------------------------------------------//
-- Commands
-----------------------------------------------------------------------------//
local command = as.command

command {
  "LspLog",
  function()
    local path = vim.lsp.get_log_path()
    vim.cmd("edit " .. path)
  end,
}

command {
  "Format",
  function()
    vim.lsp.buf.formatting_sync(nil, 1000)
  end,
}

return function()
  if vim.g.lspconfig_has_setup then
    return
  end
  vim.g.lspconfig_has_setup = true

  if vim.env.DEVELOPING then
    vim.lsp.set_log_level(vim.lsp.log_levels.DEBUG)
  end

  -----------------------------------------------------------------------------//
  -- Signs
  -----------------------------------------------------------------------------//
  local icons = as.style.icons
  vim.fn.sign_define {
    { name = "LspDiagnosticsSignError", text = icons.error, texthl = "LspDiagnosticsSignError" },
    { name = "LspDiagnosticsSignHint", text = icons.hint, texthl = "LspDiagnosticsSignHint" },
    {
      name = "LspDiagnosticsSignWarning",
      text = icons.warning,
      texthl = "LspDiagnosticsSignWarning",
    },
    {
      name = "LspDiagnosticsSignInformation",
      text = icons.info,
      texthl = "LspDiagnosticsSignInformation",
    },
  }

  -----------------------------------------------------------------------------//
  -- Handler overrides
  -----------------------------------------------------------------------------//
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      underline = true,
      virtual_text = false,
      signs = true,
      update_in_insert = false,
    }
  )

  local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
  local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

  -- NOTE: the hover handler returns the bufnr,winnr so can be used for mappings
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "rounded", max_width = max_width, max_height = max_height }
  )

  as.lsp.setup_servers()
end

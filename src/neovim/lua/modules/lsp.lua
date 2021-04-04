local lspconfig = require('lspconfig')
local lspsaga   = require('lspsaga')

lspsaga.init_lsp_saga()

local on_attach = function(client, bufnr)
    print('LSP started.') -- announce LSP start

    --require('completion').on_attach() -- moved to main config
    --require('diagnostic').on_attach() -- deprecated

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- mappings
    local opts = {noremap = true, silent = true}
    buf_set_keymap('n', '<leader>cF',        '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>',                                opts)
    buf_set_keymap('n', '<leader>cD',        '<cmd>lua vim.lsp.buf.declaration()<CR>',                                opts)
    --buf_set_keymap('n', 'gd',        '<cmd>lua vim.lsp.buf.definition()<CR>',                                 opts)
    buf_set_keymap('n', '<leader>cd',        '<cmd>lua require("lspsaga.provider").preview_definition()<CR>',                                 opts)
    buf_set_keymap('n', '<leader>ci',        '<cmd>lua vim.lsp.buf.implementation()<CR>',                             opts)
    buf_set_keymap('n', 'K',         '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>',                                      opts)
    buf_set_keymap('n', '<leader>cs',     '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>',                             opts)
    buf_set_keymap('n', '<leader>cwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',                       opts)
    buf_set_keymap('n', '<leader>cwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',                    opts)
    buf_set_keymap('n', '<leader>cwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<leader>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>',                            opts)
    --buf_set_keymap('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>',                                     opts)
    --buf_set_keymap('n', 'gr',        '<cmd>lua vim.lsp.buf.references()<CR>',                                 opts)
    buf_set_keymap('n', '<leader>cr',        '<cmd>lua require("lspsaga.rename").rename()<CR>',                                 opts)
    --buf_set_keymap('n', '<space>e',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',               opts)
    buf_set_keymap('n', '<leader>cl',  '<cmd>Lspsaga show_line_diagnostics<CR>',               opts)
    --buf_set_keymap('n', '[d',        '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',                           opts)
    buf_set_keymap('n', '[d',  '<cmd>lua require("lspsaga.diagnostic").lsp_jump_diagnostic_prev()<CR>',               opts)
    --buf_set_keymap('n', ']d',        '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',                           opts)
    buf_set_keymap('n', ']d',  '<cmd>lua require("lspsaga.diagnostic").lsp_jump_diagnostic_next()<CR>',               opts)
    buf_set_keymap('n', '<leader>q',  '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',                         opts)
    buf_set_keymap('n', '<leader>ca',  '<cmd>Lspsaga code_action<CR>',               opts)
    buf_set_keymap('x', '<leader>ca',  '<cmd>Lspsaga range_code_action<CR>',               opts)

   buf_set_keymap('n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

    -- set keybindings depending on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    end

    -- set autocommands depending on server capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
           :hi LspReferenceRead  cterm=bold ctermbg=red guibg=LightYellow
            :hi LspReferenceText  cterm=bold ctermbg=red guibg=LightYellow
            :hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
            augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup End
        ]], false)
    end
end

local servers = {
--    'pyright',
--    'gopls',
--    'rust_analyzer',
--    'tsserver',
--    'vimls',
}

for _, server in ipairs(servers) do
    lspconfig[server].setup {
        on_attach = on_attach,
    }
end

-- sumenko_lua specific configuration

local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = vim.fn.stdpath('data')..'/lspinstall/lua-language-server'
local sumneko_binary    = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

lspconfig['sumneko_lua'].setup {
    on_attach = on_attach,
    cmd       = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    settings  = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path    = vim.split(package.path, ';'),
            },
            diagnostics = {
                enable = true,
                -- Get the language server to recognize the `vim` global
                globals = {
                    'vim',
                    --'describe',
                    --'it',
                    --'before_each',
                    --'after_each',
                },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')]         = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                },
            },
        },
    },
}

lspconfig['intelephense'].setup {
    on_attach = on_attach,
    cmd = {'/home/alice/.yarn/bin/intelephense', '--stdio' },
}

--lspconfig['tsserver'].setup {
--    on_attach = on_attach,
--    cmd = {'/home/alice/.yarn/bin/typescript-language-server', '--stdio' },
--    filetypes = {'javascript', 'javascriptreact', 'javascript.jsx', 'typescript',
--        'typescriptreact', 'typescript.tsx',},
--        root_dir = lspconfig.util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git')
--}

lspconfig['denols'].setup {
   cmd = {'/home/alice/.deno/bin/deno', 'lsp', '--import-map=import_map.json',},
   filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
   },
   init_options = {
      enable = true,
      lint = true,
      unstable = false,
   },
   root_dir = lspconfig.util.root_pattern('package.json', 'tsconfig.json', '.git')
}
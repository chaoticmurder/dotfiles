--- localise vim globals

local api = vim.api

--- required and optional plugins

local has_config,    config    = pcall(require, 'lspconfig')
local has_kind,      kind      = pcall(require, 'lspkind')
local has_saga,      _         = pcall(require, 'lspsaga')
local has_signature, signature = pcall(require, 'lsp_signature')
local has_whichkey,  whichkey  = pcall(require, 'which-key')

--- internal utilities

local apply_buffer_keymaps = require('sol.vim').apply_buffer_keymaps


local on_attach_default = function (client, bufnr)

   --- LSP startup announcement

   print(' Starting LSP server ...')

   --- omnifunc setup

   vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

   -- INFO(scheatkode): old configuration, no longer needed.
   --
   -- local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
   -- local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
   -- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

   --- signature help

   if has_signature then
      signature.on_attach({

         bind = true, -- this is=j mandatory, otherwise  border config won't get
                      -- registered.  if you  want  to hook  lspsaga or  other
                      -- signature handler, set to false

         doc_lines = 2, -- will  show two  lines of  comment/doc(if there  are
                        -- more than two lines in doc, will be truncated); set
                        -- to 0  if you  DO NOT  want any  API comments  to be
                        -- shown.  this setting  only takes  effect in  insert
                        -- mode, it  does not affect signature  help in normal
                        -- mode, 10 by default

         floating_window = true, -- show  hint in  a floating  window, set  to
                                 -- false for virtual text only mode

         hint_enable = true, -- virtual hint enable
         hint_prefix = "ⓘ ", -- icon
         hint_scheme = "String",

         use_lspsaga = true, -- set to true if you want to use lspsaga popup

         hi_parameter = "Search", -- how your parameter will be highlighted

         max_height = 12, -- max  height  of   signature  floating_window,  if
                          -- content is  more than max_height, you  can scroll
                          -- down to view the hiding contents

         max_width = 120, -- max_width of signature floating_window, line will
                          -- be wrapped if exceed max_width

         handler_opts = {
            border = "single"   -- double, single, shadow, none
         },

      })
   end

   --- mappings

   -- default keymaps

   apply_buffer_keymaps(bufnr, {
      {'n', '<leader>clD',  '<cmd>lua vim.lsp.buf.declaration()<CR>'},
      {'n', '<leader>clR',  '<cmd>lua vim.lsp.buf.rename()<CR>'},
      {'n', '<leader>clI',  '<cmd>lua vim.lsp.buf.incoming_calls()<CR>'},
      {'n', '<leader>clO',  '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>'},
      {'n', '<leader>cla',  '<cmd>lua vim.lsp.buf.code_action()<CR>'},
      {'x', '<leader>cla',  '<cmd>lua vim.lsp.buf.code_action()<CR>'},
      {'n', '<leader>cld',  '<cmd>lua vim.lsp.buf.definition()<CR>'},
      {'n', '<leader>clh',  '<cmd>lua vim.lsp.buf.hover()<CR>'},
      {'n', '<leader>cli',  '<cmd>lua vim.lsp.buf.implementation()<CR>'},
      {'n', '<leader>cll',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>'},
      {'n', '<leader>clq',  '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>'},
      {'n', '<leader>clr',  '<cmd>lua vim.lsp.buf.references()<CR>'},
      {'n', '<leader>cls',  '<cmd>lua vim.lsp.buf.signature_help()<CR>'},
      {'n', '<leader>clt',  '<cmd>lua vim.lsp.buf.type_definition()<CR>'},
      {'n', '<leader>clwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>'},
      {'n', '<leader>clwd', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>'},
      {'n', '<leader>clwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>'},
      {'n', 'K',            '<cmd>lua vim.lsp.buf.hover()<CR>'},
      {'n', '[d',           '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>'},
      {'n', ']d',           '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>'},
   })

   -- conditional mappings

   if client.resolved_capabilities.document_formatting then
      apply_buffer_keymaps(bufnr, {
         {'n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>'},
         {'n', '<leader>=',  '<cmd>lua vim.lsp.buf.formatting()<CR>'},
         {'x', '<leader>cf', '<cmd>lua vim.lsp.buf.range_formatting()<CR>'},
         {'x', '<leader>=',  '<cmd>lua vim.lsp.buf.range_formatting()<CR>'},
      })
   elseif client.resolved_capabilities.document_range_formatting then
      apply_buffer_keymaps(bufnr, {
         {'n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>'},
         {'n', '<leader>=',  '<cmd>lua vim.lsp.buf.formatting()<CR>'},
         {'x', '<leader>cf', '<cmd>lua vim.lsp.buf.range_formatting()<CR>'},
         {'x', '<leader>=',  '<cmd>lua vim.lsp.buf.range_formatting()<CR>'},
      })
   end

   --- mapping overrides

   if has_saga then
      apply_buffer_keymaps(bufnr, {
         {'n', '<leader>clF',  '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>'},
         {'n', '<leader>clR',  '<cmd>lua require("lspsaga.rename").rename()<CR>'},
         {'n', '<leader>cla',  '<cmd>lua require("lspsaga.codeaction").code_action()<CR>'},
         {'x', '<leader>cla',  '<cmd><c-u>lua require("lspsaga.codeaction").range_code_action()<CR>'},
         {'n', '<leader>clc',  '<cmd>lua require("lspsaga.diagnostic").show_cursor_diagnostics()<CR>'},
         {'n', '<leader>cld',  '<cmd>lua require("lspsaga.provider").preview_definition()<CR>'},
         {'n', '<leader>clh',  '<cmd>lua require("lspsaga.provider").render_hover_doc()<CR>'},
         {'n', '<leader>cll',  '<cmd>lua require("lspsaga.diagnostic").show_line_diagnostics()<CR>'},
         {'n', '<leader>cls',  '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>'},
         {'n', 'K',            '<cmd>lua require("lspsaga.provider").render_hover_doc()<CR>'},
         {'n', ']d',           '<cmd>lua require("lspsaga.diagnostic").lsp_jump_diagnostic_next()<CR>'},
         {'n', ']d',           '<cmd>lua require("lspsaga.diagnostic").lsp_jump_diagnostic_prev()<CR>'},
      })
   end

   --- autocommands

   if client.resolved_capabilities.document_highlight then
      api.nvim_exec([[
         :hi LspReferenceRead  cterm=bold ctermbg=red guibg=LightYellow
         :hi LspReferenceText  cterm=bold ctermbg=red guibg=LightYellow
         :hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow

         augroup lsp_document_highlight
         autocmd! *           <buffer>
         autocmd  CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
         autocmd  CursorMoved <buffer> lua vim.lsp.buf.clear_references()
         augroup End
      ]], false)
   end

   --- pictograms

   if has_kind then
      kind.init({
         Function = 'ƒ',
         Method   = 'ƒ',
      })
   end

   --- announce LSP startup

   print(' LSP started.')
end

local servers = {
   -- 'pyright',
   -- 'gopls',
   -- 'rust_analyzer',
   -- 'tsserver',
   -- 'vimls',
   'bashls',
   'ccls',
   'denols',
   'intelephense',
   'jsonls',
   'sumneko_lua',
   'phpactor',
   'yamlls',
}

if not has_config then
   print('‼ lspconfig not found.')
   return has_config
end

for _, server in ipairs(servers) do
   local has_settings, settings = pcall(require, 'lsp.' .. server)

   if not has_settings then
      print('! Missing configuration for language server ' .. server)
      goto continue
   end

   settings.on_attach = on_attach_default

   if settings.before_attach ~= nil then
      settings.before_attach()
   end

   config[server].setup(settings)

   ::continue::
end

if has_whichkey then
   whichkey.register({
      ['<leader>cl'] = {
         name = '+lsp',

         D = {'Show declaration'},
         F = {'Find symbol'},
         I = {'Show incoming calls'},
         O = {'Show outgoing calls'},
         R = {'Rename symbol'},
         d = {'Show definition'},
         a = {'Code action'},
         h = {'Show hover documentation'},
         i = {'Show implementation'},
         l = {'Show line diagnostics'},
         c = {'Show diagnostics under cursor'},
         q = {'Send diagnostics to quicklist'},
         r = {'Show references'},
         s = {'Show signature help'},
         t = {'Show type definition'},

         w = {
            name = '+workspace',

            a = {'Add folder to workspace'},
            d = {'Remove folder from workspace'},
            l = {'List folders in workspace'},
         },
      },

      ['<leader>cf'] = {'Format code'},
      ['<leader>=']  = {'Format code'},

      ['K'] = {'Show hover documentation'},

      ['[d'] = {'Go to previous diagnostic'},
      [']d'] = {'Go to next diagnostic'},
   })
end

-- Local Variables:
-- tab-width: 3
-- mode: lua
-- End:
-- vim: set ft=lua sw=3 ts=3 sts=3 et tw=78:
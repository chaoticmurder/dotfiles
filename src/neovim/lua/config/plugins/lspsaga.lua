local ok, lspsaga = pcall(require, 'lspsaga')

if not ok then
   print('‼ Tried loading lspsaga ... unsuccessfully.')
   return ok
end

lspsaga.init_lsp_saga({
   use_saga_diagnostic_sign = true,
   dianostic_header_icon    = '   ',

   error_sign = '⬤',
   warn_sign  = '⬤',
   hint_sign  = '⬤',
   infor_sign = '⬤',

   code_action_icon   = ' ',
   code_action_prompt = {
      enable        = true,
      sign          = true,
      sign_priority = 20,
      virtual_text  = true,
   },
   code_action_keys = {
      quit = {'q', '<Esc>'},
      exec = '<CR>',
   },

   max_preview_lines = 20, -- preview lines of lsp_finder and definition preview

   finder_definition_icon = '  ',
   finder_reference_icon  = '  ',
   finder_action_keys     = {
      open        = 'o',
      vsplit      = 's',
      split       = 'i',
      quit        = {'q', '<Esc>'}, -- quit can be a table
      scroll_down = '<C-u>',
      scroll_up   = '<C-d>',
   },

   rename_prompt_prefix = '❯ ',
   rename_action_keys   = {
      quit = {'<C-c>', '<Esc>'},  -- quit can be a table
      exec = '<CR>',
   },

   definition_preview_icon = '丨  ',

   border_style = 'round', -- "single" | "double" | "round" | "plus"

   -- if you don't use nvim-lspconfig you must pass your server name and
   -- the related filetypes into this table
   -- like server_filetype_map = {metals = {'sbt', 'scala'}}

   server_filetype_map = {},
})

-- Local Variables:
-- tab-width: 3
-- mode: lua
-- End:
-- vim: set ft=lua sw=3 ts=3 sts=3 et tw=78:

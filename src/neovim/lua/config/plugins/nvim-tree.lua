require('sol.vim').apply_variables('g', {
   vim_tree_side                  = 'left',
   nvim_tree_width                = 35,
   nvim_tree_auto_open            = 0,
   nvim_tree_auto_close           = 1,
   nvim_tree_quit_on_open         = 1,
   nvim_tree_follow               = 1,
   nvim_tree_indent_markers       = 0,
   nvim_tree_hide_dotfiles        = 1,
   nvim_tree_git_hl               = 1,
   nvim_tree_root_folder_modifier = ':~',
   nvim_tree_tab_open             = 0,
   nvim_tree_width_allow_resize   = 1,

   nvim_tree_auto_ignore_ft = {
      'startify',
      'dashboard'
   },

   nvim_tree_ignore = {
      '.git',
      'node_modules',
      '.cache',
   },

--   nvim_tree_bindings = {
--      edit            = {
--         '<CR>',
--         'o',
--      },
--      edit_vsplit     = '<C-v>',
--      edit_split      = '<C-x>',
--      edit_tab        = '<C-t>',
--      close_node      = {
--         '<S-CR>',
--         '<BS>',
--      },
--      toggle_ignored  = 'I',
--      toggle_dotfiles = 'H',
--      refresh         = 'R',
--      preview         = '<Tab>',
--      cd              = '<C-]>',
--      create          = 'a',
--      remove          = 'd',
--      rename          = 'r',
--      cut             = 'x',
--      copy            = 'c',
--      paste           = 'p',
--      prev_git_item   = '[c',
--      next_git_item   = ']c',
--      dir_up          = '-',
--      close           = 'q',
--   },
})

require('sol.vim').apply_keymaps({
   {'n', '<leader>ft', ':NvimTreeToggle<CR>', {silent = true, noremap = true}},
})

-- Local Variables:
-- tab-width: 3
-- mode: lua
-- End:
-- vim: set ft=lua sw=3 ts=3 sts=3 et tw=78:

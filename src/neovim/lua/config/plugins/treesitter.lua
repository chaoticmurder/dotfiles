--- configure treesitter

local ok, treesitter = pcall(require, 'nvim-treesitter.configs')

if not ok then
   print('‼ Tried loading treesitter ... unsuccessfully.')
   return ok
end

treesitter.setup {
   ensure_installed = 'maintained',

   autotag               = { enable = true },
   context_commentstring = { enable = true },
   highlight             = { enable = true },
   indent                = { enable = true },
   lsp_interop           = { enable = true },

   textobjects = {
      lsp_interop = {
         enable = true,
      },

      select = {
         enable  = true,
         keymaps = {
            ['ab'] = '@block.outer',
            ['ib'] = '@block.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
         },
      },

      swap = {
         enable    = true,
         swap_next = {
            ['<leader>cps'] = '@parameter.inner',
         },

         swap_previous = {
            ['<leader>cpS'] = '@parameter.inner',
         },
      },
   },

   -- playground specific
   -- playground = {
   --    enable          = true,
   --    updatetime      = 25,    -- debounced time for highlighting nodes
   --    persist_queries = false, -- persistence across vim sessions
   -- },

}

--- whichkey setup

local has_whichkey, whichkey = pcall(require, 'whichkey_setup')

if not has_whichkey then
   return has_whichkey
end

whichkey.register_keymap('leader', {
   c = {
      name = '+code',

      p = {
         name = '+parameter',

         s = 'Swap next parameter',
         S = 'Swap previous parameter',
      }
   }
})

-- Local Variables:
-- tab-width: 3
-- mode: lua
-- End:
-- vim: set sw=3 ts=3 sts=3 et tw=80 fmr={{{,}}} fdl=0 fdm=marker:
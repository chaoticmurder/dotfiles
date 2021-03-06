if vim.o.background == 'dark' then
   return {
          bg = '#1d2021',
         bg0 = '#1d2021',
         bg1 = '#282828',
         bg2 = '#282828',
         bg3 = '#3c3836',
         bg4 = '#3c3836',
         bg5 = '#504945',
          fg = '#d4be98',
         fg0 = '#d4be98',
         fg1 = '#ddc7a1',
         red = '#ea6962',
      orange = '#e78a4e',
      yellow = '#d8a657',
       green = '#a9b665',
        aqua = '#89b482',
        blue = '#7daea3',
      purple = '#d3869b',
       grey0 = '#7c6f64',
       grey1 = '#928374',
       grey2 = '#a89984',
        none = 'NONE',
   }
else
   return {
               bg = '#f9f5d7',
              bg0 = '#f9f5d7',
              bg1 = '#f5edca',
              bg2 = '#f3eac7',
              bg3 = '#f2e5bc',
              bg4 = '#eee0b7',
              bg5 = '#ebdbb2',
               fg = '#654735',
              fg0 = '#654735',
              fg1 = '#4f3829',
              red = '#ae5858',
         lightred = '#c14a4a',
           orange = '#c35e0a',
           yellow = '#a96b2c',
      lightyellow = '#b47109',
            green = '#6f8352',
       lightgreen = '#6c782e',
             aqua = '#4c7a5d',
             blue = '#45707a',
           purple = '#945e80',
            grey0 = '#a89984',
            grey1 = '#928374',
            grey2 = '#7c6f64',
             none = 'NONE',
   }
end

-- Local Variables:
-- tab-width: 3
-- mode: lua
-- End:
-- vim: set sw=3 ts=3 sts=3 et tw=80

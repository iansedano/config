-- return {
--   'navarasu/onedark.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require('onedark').setup({
--       style = "deep",
--     })
--     vim.cmd('colorscheme onedark')
--   end
-- }

-- return {
--   'tanvirtin/monokai.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd('colorscheme monokai')
--   end
-- }

-- https://neovimcraft.com/plugin/polirritmico/monokai-nightasty.nvim/
return {
  "polirritmico/monokai-nightasty.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local monokai = require("monokai-nightasty")
    monokai.setup({
      on_highlights = function(highlights, colors)
        highlights["DiagnosticUnnecessary"] = {
          fg = colors.grey,
          bg = colors.bg,
          italic = true,
          undercurl = false
        }
      end
    })
    monokai.load()

    vim.cmd("colorscheme monokai-nightasty")
  end,
}

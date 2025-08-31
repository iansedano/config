-- Custom filetype detection for various file patterns

-- Detect Python files with uv shebang patterns
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*",
  callback = function()
    local first_line = vim.fn.getline(1)
    
    -- Match uv run --script shebang pattern
    if first_line:match("^#!/usr/bin/env %-S uv run %-%-script") then
      vim.bo.filetype = "python"
      return
    end

  end,
  desc = "Detect Python files with uv shebang patterns"
})

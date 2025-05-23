-- ~/.config/nvim/lua/keymaps/markdown.lua
local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      vim.keymap.set("n", "<leader>*", function()
        local line = vim.api.nvim_get_current_line()
        if line:find("%[ %]") then
          line = line:gsub("%[ %]", "[X]", 1)
        elseif line:find("%[X%]") then
          line = line:gsub("%[X%]", "[ ]", 1)
        end
        vim.api.nvim_set_current_line(line)
      end, { buffer = true })
    end,
  })
end

return M

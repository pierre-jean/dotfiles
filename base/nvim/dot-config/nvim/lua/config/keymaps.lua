-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local wk = require("which-key")

local toggleCheckbox = function()
  local line = vim.api.nvim_get_current_line()
  if line:find("%[%s*%]") then
    line = line:gsub("%[%s*%]", "[X]", 1)
  elseif line:find("%[X%]") then
    line = line:gsub("%[X%]", "[ ]", 1)
  end
  vim.api.nvim_set_current_line(line)
end

local toggleCheckboxPrefix = function()
  local line = vim.api.nvim_get_current_line()

  if line:find("^%s*%-%s*%[%s*%]%s*") then
    -- If line starts with " - [ ] ", remove it
    line = line:gsub("^%s*%-%s*%[%s*%]%s*", "", 1)
  else
    -- Otherwise, add " - [ ] " at the beginning
    line = " - [ ] " .. line
  end

  vim.api.nvim_set_current_line(line)
end

local addCheckboxToSelection = function()
  -- Get the start and end lines of the visual selection
  local start_line = vim.fn.getpos("'<")[2]
  local end_line = vim.fn.getpos("'>")[2]

  -- Loop over the lines in the selection
  for lnum = start_line, end_line do
    local line = vim.fn.getline(lnum)
    -- Only add prefix if it doesn't already start with a checkbox
    if not line:match("^%s*%-%s*%[[ xX]?%]%s*") then
      vim.fn.setline(lnum, " - [ ] " .. line)
    end
  end
end

local toggleCheckboxInSelection = function()
  -- Get the start and end lines of the visual selection
  local start_line = vim.fn.getpos("'<")[2]
  local end_line = vim.fn.getpos("'>")[2]

  -- Loop over the lines in the selection
  for lnum = start_line, end_line do
    local line = vim.fn.getline(lnum)
    if line:find("%[%s*%]") then
      line = line:gsub("%[%s*%]", "[X]", 1)
    elseif line:find("%[X%]") then
      line = line:gsub("%[X%]", "[ ]", 1)
    end
    vim.fn.setline(lnum, line)
  end
end

wk.add({
  { "<leader>m", group = "Markdown actions" },
  { "<leader>ma", "ggVG:s/\\[ \\]/[X]/g<CR>", desc = "Check all" },
  { "<leader>mx", toggleCheckbox, desc = "Toggle checkbox" },
  { "<leader>mc", toggleCheckboxPrefix, desc = "Add/Remove checkbox", mode = { "n" } },
  { "<leader>mc", addCheckboxToSelection, desc = "Add/Remove checkbox", mode = { "v" } },
  { "<leader>mx", toggleCheckboxInSelection, desc = "Toogle checkbox", mode = { "v" } },
})

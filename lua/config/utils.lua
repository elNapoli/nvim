-- ============================================================================
-- UTILITY FUNCTIONS - SHARED HELPERS AND TOOLS
-- ============================================================================

local M = {}

-- ============================================================================
-- PLUGIN MANAGEMENT UTILITIES
-- ============================================================================

---Check if a plugin is loaded
---@param plugin_name string
---@return boolean
function M.is_loaded(plugin_name)
  return package.loaded[plugin_name] ~= nil
end

---Safely require a module
---@param module string
---@return any|nil
function M.safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify("Failed to load module: " .. module, vim.log.levels.ERROR)
    return nil
  end
  return result
end

---Load plugin configuration safely
---@param plugin_name string
---@param config_fn function
function M.safe_setup(plugin_name, config_fn)
  local plugin = M.safe_require(plugin_name)
  if plugin and config_fn then
    local ok, err = pcall(config_fn, plugin)
    if not ok then
      vim.notify("Failed to setup " .. plugin_name .. ": " .. err, vim.log.levels.ERROR)
    end
  end
end

-- ============================================================================
-- FILE AND DIRECTORY UTILITIES
-- ============================================================================

---Check if file exists
---@param path string
---@return boolean
function M.file_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "file"
end

---Check if directory exists
---@param path string
---@return boolean
function M.dir_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory"
end

---Get project root directory
---@return string|nil
function M.get_project_root()
  local root_patterns = { ".git", "package.json", "Cargo.toml", "pyproject.toml", "go.mod" }
  local current_dir = vim.fn.expand("%:p:h")
  
  for _, pattern in ipairs(root_patterns) do
    local root = vim.fn.finddir(".git/..", current_dir .. ";")
    if root ~= "" then
      return vim.fn.fnamemodify(root, ":p:h")
    end
    
    local file_root = vim.fn.findfile(pattern, current_dir .. ";")
    if file_root ~= "" then
      return vim.fn.fnamemodify(file_root, ":p:h")
    end
  end
  
  return nil
end

---Create directory if it doesn't exist
---@param path string
function M.ensure_dir(path)
  if not M.dir_exists(path) then
    vim.fn.mkdir(path, "p")
  end
end

-- ============================================================================
-- PERFORMANCE UTILITIES
-- ============================================================================

---Simple performance profiler
---@param name string
---@param fn function
---@return any
function M.profile(name, fn)
  local start_time = vim.loop.hrtime()
  local result = fn()
  local end_time = vim.loop.hrtime()
  local duration = (end_time - start_time) / 1e6 -- Convert to milliseconds
  
  print(string.format("[PROFILE] %s took %.2fms", name, duration))
  return result
end

---Setup profiling for startup time
function M.setup_profiling()
  vim.cmd([[
    profile start /tmp/nvim-profile.log
    profile func *
    profile file *
  ]])
  
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      vim.defer_fn(function()
        vim.cmd("profile stop")
        print("Profiling saved to /tmp/nvim-profile.log")
      end, 1000)
    end,
  })
end

-- ============================================================================
-- KEYMAP UTILITIES
-- ============================================================================

---Create keymap with better defaults
---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opts table|nil
function M.keymap(mode, lhs, rhs, opts)
  opts = opts or {}
  local default_opts = {
    noremap = true,
    silent = true,
  }
  opts = vim.tbl_extend("force", default_opts, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

return M

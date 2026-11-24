-- 起動時に走る Mason のインストールを headless で先に済ませる
require("lazy").load({ plugins = { "mason.nvim", "mason-lspconfig.nvim", "nvim-lspconfig" } })
local registry = require("mason-registry")
local want = { "lua-language-server", "shellcheck" }
local refreshed = false
registry.refresh(function() refreshed = true end)
vim.wait(60000, function() return refreshed end, 100)
for _, n in ipairs(want) do
  local ok, pkg = pcall(registry.get_package, n)
  if ok and not pkg:is_installed() and not pkg:is_installing() then pkg:install() end
end
local function busy()
  for _, pkg in ipairs(registry.get_all_packages()) do
    if pkg:is_installing() then return true end
  end
  return false
end
vim.wait(3000) -- 設定側が遅延して開始するインストールを待つ
vim.wait(600000, function() return not busy() end, 500)
local bad = {}
for _, n in ipairs(want) do
  local ok, pkg = pcall(registry.get_package, n)
  if not (ok and pkg:is_installed()) then table.insert(bad, n) end
end
print("mason: " .. (#bad == 0 and "ok" or ("failed: " .. table.concat(bad, ","))))

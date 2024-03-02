local ls = require'luasnip'

vim.keymap.set({ "i", "s" }, "<c-k>", function ()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function ()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- Reload this file to update snippets
vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<cr>")

local s = ls.s
local fmt = require"luasnip.extras.fmt".fmt
local rep = require"luasnip.extras".rep
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node

ls.snippets = {
  rust = {
    s("test", fmt("#[test]\nfn {}() {{\n    {}\n}}", { i(1), i(0) })),
    s("tests", fmt("#[cfg(test)]\nmod tests {{\n    {}\n}}", { i(0) })),
  },
  lua = {
    s("req", fmt("local {} = require('{}')", { i(1, "default"), rep(1) })),
    s("ff", {
      i(1),
      f(function (args, snip, user_arg_1) return args[1][1] .. user_arg_1 end,
          {1},
          "will be appended to test from i(0)"),
      i(0)
    })
  }
}

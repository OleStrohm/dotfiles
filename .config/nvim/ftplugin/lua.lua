local LuaGoto = function()
    linenr = vim.fn.getcurpos()[2]
    line = vim.fn.getline(linenr)
    if vim.startswith(line, "require('") and vim.endswith(line, "')") then
        module = string.sub(line, 10, string.len(line) - 2)
        dir = vim.fn.expand('%:p:h')
        file = dir .. "/lua/" .. module .. ".lua"
        vim.cmd("silent edit " .. file)
    else
        vim.cmd([[
            try
                norm! gf
            catch
                echo "File not found"
            endtry
        ]])
    end
end

vim.keymap.set("n", "gf", LuaGoto, { silent = true, noremap = true, buffer = 0, desc = "Go to file (and `require('file')`)" })
vim.keymap.set("n", "<leader>rl", "<cmd>w<cr><cmd>luafile %<cr>", { silent = true, noremap = true, buffer = 0, desc = "Save and reload current lua file" })

vim.opt_local.shiftwidth=2
vim.opt_local.foldmethod="marker"
vim.cmd[[
  highlight link TSVariable TSText
]]

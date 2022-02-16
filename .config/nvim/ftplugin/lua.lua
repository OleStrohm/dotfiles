vim.api.nvim_buf_set_keymap(vim.fn.bufnr(), "n", "gf", ":lua LuaGoto()<cr>", { silent = true, noremap = true })

vim.opt_local.shiftwidth=2
vim.opt_local.foldmethod="marker"
vim.cmd[[
  highlight link TSVariable TSText
]]

function LuaGoto()
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

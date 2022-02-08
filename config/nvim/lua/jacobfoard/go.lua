function lsp_organize_imports()
    local context = { source = { organizeImports = true } }
    vim.validate({ context = { context, "table", true } })

    local params = vim.lsp.util.make_range_params()
    params.context = context

    local method = "textDocument/codeAction"
    local timeout = 1000 -- ms

    local resp = vim.lsp.buf_request_sync(0, method, params, timeout)
    if not resp then
        return
    end

    for _, client in ipairs(vim.lsp.get_active_clients()) do
        if resp[client.id] then
            local result = resp[client.id].result
            if not result or not result[1] then
                return
            end

            local edit = result[1].edit
            vim.lsp.util.apply_workspace_edit(edit, "utf-8")
        end
    end
end

vim.cmd([[autocmd BufWritePre *.go lua lsp_organize_imports()]])

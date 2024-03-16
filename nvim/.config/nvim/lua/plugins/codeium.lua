return {
    "Exafunction/codeium.vim",
    build = function()
        local bin_path = os.getenv("HOME") .. "/.codeium/bin"
        local oldBinaries = vim.fs.find(
            "language_server_macos_arm",
            { limit = math.huge, path = bin_path }
        )
        table.remove(oldBinaries) -- remove last item (= most up to date binary) from list
        for _, binaryPath in pairs(oldBinaries) do
            os.remove(binaryPath)
            os.remove(vim.fs.dirname(binaryPath))
        end
    end,
}

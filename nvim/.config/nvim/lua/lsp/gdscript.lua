-- GDScript LSP. Superseded at runtime by the `gdev.nvim` plugin (see
-- `lua/gdev.lua`), which registers a richer config under this same `gdscript`
-- name; this file is the fallback for machines without that checkout.
--
-- Unlike every other server here, there is no binary to
-- spawn: the Godot *editor* is the language server, listening on TCP
-- 127.0.0.1:6005 (Editor Settings > Network > Language Server) whenever
-- it is open. `cmd` is therefore a connect function instead of an argv
-- table. If the editor isn't running, attach just fails quietly --
-- reopen the .gd file (or :e) after launching Godot to retry.
return {
	cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
	filetypes = { "gd", "gdscript", "gdscript3" },
	root_markers = { "project.godot", ".git" },
}

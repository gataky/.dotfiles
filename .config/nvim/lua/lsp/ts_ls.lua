return {
  init_options = {
    plugins = { -- I think this was my breakthrough that made it work
      {
        name = "@vue/typescript-plugin",
        location = "",
        languages = { "vue" },
      },
    },
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
}

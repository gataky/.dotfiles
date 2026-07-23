-- HTTP/GraphQL/gRPC client for .http/.rest files
add({ source = 'gataky/tachydromos.nvim'})
later(function()
    require('tachydromos').setup({})
end)

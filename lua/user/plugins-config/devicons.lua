
local default = "#6d8086"

local shell = {
    icon = "",
    color = default,
    name = "customShell"
}

local markdown = {
    icon = '',
    color = "#519aba",
    name = "customMd"
}


require 'nvim-web-devicons'.setup {
    override = {
        bash = shell,
        zsh = shell,
        sh = shell,

        md = markdown,
        mdx = markdown,
        markdown = markdown,

        txt = {
            color = default,
            icon = "",
            name = "customTxt"
        },
        Dockerfile = {
            icon = "",
            color = "#0073ec",
            name = "customDocker"
        },
        go = {
            icon = "",
            color = "#519aba",
            name = "customGo"
        },
    },
    default = true,
}

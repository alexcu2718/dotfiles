return {

{
    "barklan/capslock.nvim",
    lazy = true,
    keys = {
        { "<C-l>", "<Plug>CapsLockToggle", mode = { "i", "c" } },
        { "<leader>c", "<Plug>CapsLockToggle", mode = { "n" } },
    },
    config = true,
},
}


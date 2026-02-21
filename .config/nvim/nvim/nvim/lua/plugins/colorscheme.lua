return {

  {
    name = "monokai-vibrant-rust",
    dir = vim.fn.stdpath("config") .. "/colors",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('monokai-vibrant-rust')
    end
  }
}

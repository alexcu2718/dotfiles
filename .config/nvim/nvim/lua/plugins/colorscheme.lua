return {
  -- Original edge colorscheme (commented out)
  -- {
  --   'sainnhe/edge',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.g.edge_enable_italic = true
  --     vim.cmd.colorscheme('edge')
  --   end
  -- },

  -- Monokai Vibrant Rust colorscheme
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

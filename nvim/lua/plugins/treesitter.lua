-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "rust",
      "go",
      "nix",
      "python",
      "json",
      "yaml",
      "toml",
      "bash",
      "markdown",
    },
  },
}

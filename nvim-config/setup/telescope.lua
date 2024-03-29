require('telescope').setup{
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    },
    project = {
      base_dirs = {
        {'~/repos', max_depth = 2},
        {'~/cf-repos', max_depth = 3},
      },
    }
  }
}

require('telescope').load_extension('fzf')

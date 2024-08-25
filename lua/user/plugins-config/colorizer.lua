require 'colorizer'.setup({
  '*', -- Highlight all files, but customize some others.
  css  = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
}, {
  names = false,
})


-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
  general = {
    -- No gaps between windows.
    gaps_in = 2,
    gaps_out = 0,

    col = {
      active_border = { colors = { "rgba(4a6ab7ff)", "rgba(7b5ab7ff)" }, angle = 45 },
      inactive_border = "rgba(414868ff)",
    },
  },

  -- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
  decoration = {
    -- Use round window corners.
    rounding = 2,
  },
})

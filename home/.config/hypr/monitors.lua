-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

hl.env("HYPRCURSOR_SIZE", "20")
hl.env("XCURSOR_SIZE", "20")

hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x1152", scale = 1.25 })
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0", scale = 1.25 })


## Resurrect

Example config for restoring specific apps and paths on specific workspaces. The one below will start VSCode and Ghostty with the provided paths on workspace 2. Run with `i3-resurrect restore -w 1`

```json
// $HOME/.i3/i3-resurrect/workspace-1_programs.json
[
  {
    "command": ["zed", "$HOME/dotfiles"],
    "working_directory": "$HOME"
  },
  {
    "command": ["ghostty", "--working-directory=$HOME/dotfiles"],
    "working_directory": "$HOME"
  }
]
```

You will also need a `$HOME/.i3/i3-resurrect/workspace-1_layout.json` file, if you don't need anything fancy and the layout can be random it can just be `{}`. With the above config, if you want to make sure Zed is always opened on the left side you need something like:

```json
// $HOME/.i3/i3-resurrect/workspace-1_layout.json
{
  "border": "none",
  "current_border_width": -1,
  "floating": "auto_off",
  "fullscreen_mode": 1,
  "geometry": {
    "x": 0,
    "y": 0,
    "width": 0,
    "height": 0
  },
  "layout": "splith",
  "marks": [],
  "name": "1",
  "orientation": "horizontal",
  "percent": null,
  "scratchpad_state": "none",
  "sticky": false,
  "type": "workspace",
  "workspace_layout": "default",
  "nodes": [
    {
      "border": "none",
      "current_border_width": 0,
      "floating": "auto_off",
      "fullscreen_mode": 0,
      "geometry": {
        "x": 1284,
        "y": 31,
        "width": 1274,
        "height": 1405
      },
      "layout": "splith",
      "marks": [],
      "name": "dotfiles \u2014 README.md",
      "orientation": "none",
      "percent": 0.5,
      "scratchpad_state": "none",
      "sticky": false,
      "type": "con",
      "workspace_layout": "default",
      "swallows": [
        {
          "class": "^dev\\.zed\\.Zed$",
          "instance": "^dev\\.zed\\.Zed$"
        }
      ]
    },
    {
      "border": "none",
      "current_border_width": 0,
      "floating": "auto_off",
      "fullscreen_mode": 0,
      "geometry": {
        "x": 0,
        "y": 0,
        "width": 1000,
        "height": 600
      },
      "layout": "splith",
      "marks": [],
      "name": "dotfiles",
      "orientation": "none",
      "percent": 0.5,
      "scratchpad_state": "none",
      "sticky": false,
      "type": "con",
      "workspace_layout": "default",
      "swallows": [
        {
          "class": "^com\\.mitchellh\\.ghostty$",
          "instance": "^ghostty$"
        }
      ]
    }
  ]
}
```

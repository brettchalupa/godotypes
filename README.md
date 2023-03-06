# Godotypes

Godot prototypes & experiments

Made with Godot 4.0.

## Developing

0. Install Godot 4.0
1. Clone the repository
2. Open up `project.gdot`

## Build Exports

The `export` script uses Ruby for now (sorry). Run it with:

``` console
./export
```

`godot` must be present in your environment as an executable for the script to work.

If you configure `[itch]` in `export.cfg` with `user` (your handle) and `game` (your game slug) and have [butler](https://itch.io/docs/butler/) installed, your builds will automatically get pushed to itch.io.

# PROJECT GARUDA - Starter Bundle

This bundle contains two parallel workstreams:

## A. Stitch UI preview
- Open `index.html` in a browser to see a launcher for all 23 original Stitch HTML screens.
- The original exported HTML files are preserved under `stitch_core_design_system/`.
- The exported screens load Tailwind CSS and Google Fonts from the internet, so this is a preview bundle, not an offline-ready native Android app.
- The launcher does not rewrite the designs or claim that navigation between all screens is already implemented inside the original pages.

## B. Godot 3D prototype
- Open Godot 4 Android Editor.
- Choose Import and select the `godot_ironboy_prototype/project.godot` file after extracting this ZIP.
- Use the Compatibility renderer (configured in `project.godot`).
- Open `scenes/Main.tscn` and press Play.
- On-screen arrows move the prototype character; JUMP jumps. Keyboard WASD/Space also work where a keyboard is connected.
- This is a basic greybox prototype with a glowing golden core, not the finished Ironboy armor model or full game.

## Important
Godot's Android editor is experimental and its phone workflow has limitations. The first milestone is to confirm that the project opens and runs on your device. Do not expect a finished APK or the full open world from this starter bundle.

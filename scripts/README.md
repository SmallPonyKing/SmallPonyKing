# Profile artwork

All artwork is original and stored in this repository. The profile uses a soccer ball as the moving point through a simplified view of software evolution, ending at the current AI and agent focus. The stages are expanding capabilities, not dated career milestones or claims that earlier approaches have been replaced.

Regenerate the static SVG artwork with Python 3:

```sh
python3 scripts/generate_assets.py
```

Regenerate the desktop and phone animations on macOS with Swift and the system CoreGraphics, CoreText, and ImageIO frameworks:

```sh
swift scripts/render_evolution.swift assets
swift scripts/render_evolution.swift assets --mobile
```

Each animation contains 96 frames and loops in roughly nine seconds, including a pause at the final position. The generator also exports a PNG of the final frame. The README selects those still images for reduced-motion preferences and uses a vertical timeline on phone screens.

Buttons and focus cards are ordinary links. No JavaScript or external image services are required.

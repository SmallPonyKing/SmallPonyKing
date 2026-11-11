# Profile artwork

Original soccer artwork and a simplified software-evolution timeline, with separate light and dark palettes and desktop and phone layouts. The timeline describes expanding capabilities rather than a dated career history.

Regenerate SVG artwork:

```sh
python3 scripts/generate_assets.py
```

Regenerate the animated timelines and still images on macOS using Swift and system graphics frameworks:

```sh
swift scripts/render_evolution.swift assets
swift scripts/render_evolution.swift assets --mobile
swift scripts/render_evolution.swift assets --light
swift scripts/render_evolution.swift assets --mobile --light
```

Each GIF contains 96 frames with a pause at the final focus. PNG exports of the final frames serve reduced-motion preferences. README picture sources select the appropriate palette, screen size, and motion setting.

The README contains no authored links or buttons. Its native details/summary disclosure reveals the animation when opened and hides it when closed. The image animation loops independently; opening the section does not guarantee playback restarts at frame zero. No custom click handlers or scripts run in GitHub's renderer.

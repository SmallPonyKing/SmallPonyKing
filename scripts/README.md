# Profile motion artwork

The opening soccer hero, six individually animated brand cards, and software-evolution timeline are all visible and animated by default. Every section has desktop/phone and light/dark variants. Native picture sources select static PNG posters for reduced-motion preferences.

The README has no collapsed sections, navigation links, buttons, or custom scripts.

## Rebuild

Python regenerates the static vector artwork:

```sh
python3 scripts/generate_assets.py
```

On macOS, render the original logo paths into transparent PNG layers with WebKit:

```sh
swift scripts/rasterize_logos.swift assets/logos
```

For each flag combination (none, `--light`, `--mobile`, and `--mobile --light`), run:

```sh
swift scripts/render_profile_motion.swift assets
swift scripts/render_profile_motion.swift assets --hero
swift scripts/render_evolution.swift assets
```

Append the selected flags to each command. The hero and brand panels contain 72 frames per six-second loop. The timeline contains 120 frames and pauses at the current focus. Each renderer also exports a still PNG poster.

Per-brand conceptual motifs and their first-party research sources are in assets/logos/MOTION_RESEARCH.md. All third-party logo paths and the upstream source license remain included locally.

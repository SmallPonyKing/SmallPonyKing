# Profile artwork

All artwork is original and stored in this repository. No external image widget or stats service is required.

Regenerate the static assets with Python 3:

```sh
python3 scripts/generate_assets.py
```

Regenerate the animated workflow on macOS with Swift and the system CoreGraphics, CoreText, and ImageIO frameworks:

```sh
swift scripts/render_motion.swift assets/workflow.gif
```

The GIF contains 64 frames and loops in roughly six seconds. The README uses a static SVG alternative for browsers honoring the reduced-motion media preference. Its buttons and project cards are ordinary links; no JavaScript runs in the README.

"""Build compact AI-logo panels from the vendored Lobe Icons SVG files."""
from pathlib import Path
from html import escape
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / 'assets'
ET.register_namespace('', 'http://www.w3.org/2000/svg')
BRANDS = [
    ('openai', 'OpenAI', 'Reasoning & tool use.'),
    ('claude', 'Claude', 'Reasoning & coding.'),
    ('gemini', 'Gemini', 'Multimodal AI.'),
    ('deepseek', 'DeepSeek', 'Open-weight models.'),
    ('huggingface', 'Hugging Face', 'Models & datasets.'),
    ('ollama', 'Ollama', 'Local model runtime.'),
]

def logo(slug, x, y, size, foreground):
    root = ET.parse(ASSETS / 'logos' / (slug + '.svg')).getroot()
    ids = {node.attrib['id']: slug + '-' + node.attrib['id'] for node in root.iter() if 'id' in node.attrib}
    for node in root.iter():
        for key, value in list(node.attrib.items()):
            if key == 'id':
                node.set(key, ids[value])
            else:
                for old, new in ids.items():
                    value = value.replace('url(#' + old + ')', 'url(#' + new + ')')
                    if value == '#' + old:
                        value = '#' + new
                node.set(key, value)
    root.set('x', str(x)); root.set('y', str(y))
    root.set('width', str(size)); root.set('height', str(size))
    root.set('color', foreground); root.set('style', 'color:' + foreground)
    return ET.tostring(root, encoding='unicode')

def generate():
    for light in (False, True):
        foreground = '#15252c' if light else '#f5f0e8'
        muted = '#4d6168' if light else '#a5b2bf'
        panel = '#f7f9f8' if light else '#111a23'
        border = '#d3dfda' if light else '#2b3742'
        gold = '#836027' if light else '#dbc29a'
        for mobile in (False, True):
            width, height = (600, 738) if mobile else (1200, 420)
            content = []
            for i, (slug, name, caption) in enumerate(BRANDS):
                if mobile:
                    x, y, w, h = 12 + (i % 2)*294, 12 + (i//2)*242, 282, 222
                else:
                    x, y, w, h = 12 + (i % 3)*396, 12 + (i//3)*204, 384, 192
                content.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="18" fill="{panel}" stroke="{border}"/>')
                if mobile:
                    content.append(logo(slug, x + w/2 - 32, y + 24, 64, foreground))
                    content.append(f'<text x="{x+w/2}" y="{y+132}" text-anchor="middle" font-size="28" font-weight="600" fill="{foreground}">{escape(name)}</text>')
                    content.append(f'<text x="{x+w/2}" y="{y+178}" text-anchor="middle" font-size="19" fill="{muted}">{escape(caption)}</text>')
                else:
                    content.append(logo(slug, x + 28, y + 28, 58, foreground))
                    content.append(f'<text x="{x+110}" y="{y+67}" font-size="27" font-weight="600" fill="{foreground}">{escape(name)}</text>')
                    content.append(f'<path d="M{x+30} {y+115}h28" stroke="{gold}" stroke-width="2"/>')
                    content.append(f'<text x="{x+30}" y="{y+155}" font-size="20" fill="{muted}">{escape(caption)}</text>')
            suffix = ('-mobile' if mobile else '') + ('-light' if light else '')
            title = 'AI landscape: ' + '; '.join(name + ' — ' + caption for _, name, caption in BRANDS)
            (ASSETS / ('ai-landscape' + suffix + '.svg')).write_text(
                f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}" role="img" aria-labelledby="landscape-title" font-family="Arial,Helvetica,sans-serif"><title id="landscape-title">{escape(title)}</title>' + ''.join(content) + '</svg>'
            )

if __name__ == '__main__':
    generate()

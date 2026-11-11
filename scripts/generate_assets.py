"""Generate original profile SVG artwork without external image services."""
from pathlib import Path
from html import escape
from math import sin, cos, pi
import re

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / 'assets'
OUT.mkdir(exist_ok=True)
INK, PANEL, GOLD, WHITE, MUTED = '#0c1017', '#121923', '#dbc29a', '#f5f0e8', '#9ba7b6'

def svg(name, width, height, content, title):
    markup = f'''<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}" role="img" aria-labelledby="title"><title id="title">{escape(title)}</title><defs><linearGradient id="bg" x2="1" y2="1"><stop stop-color="#151e2b"/><stop offset="1" stop-color="{INK}"/></linearGradient><linearGradient id="gold"><stop stop-color="#b49565"/><stop offset=".5" stop-color="#f1dfbe"/><stop offset="1" stop-color="#b49565"/></linearGradient><radialGradient id="glow"><stop stop-color="#dbc29a" stop-opacity=".12"/><stop offset="1" stop-color="#dbc29a" stop-opacity="0"/></radialGradient></defs><rect width="{width}" height="{height}" rx="20" fill="{INK}"/>{content}</svg>'''
    (OUT / name).write_text(markup)
    palette = {INK: '#f7f9f8', PANEL: '#ffffff', GOLD: '#836027', WHITE: '#15252c', MUTED: '#4d6168', '#151e2b': '#ffffff', '#2b3442': '#d3dfda', '#344050': '#bdcec5', '#fff': '#557264', '#b49565': '#b99a63', '#f1dfbe': '#ead4ae'}
    light = re.sub(r'#[0-9a-fA-F]{6}(?![0-9a-fA-F])|#[0-9a-fA-F]{3}(?![0-9a-fA-F])', lambda match: palette.get(match.group(0), match.group(0)), markup)
    (OUT / (Path(name).stem + '-light.svg')).write_text(light)

def text(x, y, value, size=16, fill=MUTED, weight=400, extra=''):
    return f'<text x="{x}" y="{y}" font-family="Arial,Helvetica,sans-serif" font-size="{size}" fill="{fill}" font-weight="{weight}" {extra}>{escape(value)}</text>'

def soccer_ball(cx, cy, radius):
    def point(r, a):
        return f'{r*cos(a):.3f},{r*sin(a):.3f}'
    angles = [-pi/2+i*2*pi/5 for i in range(5)]
    content = f'<defs><clipPath id="ball-clip"><circle r="{radius}"/></clipPath></defs><circle r="{radius}" fill="#fffaf0"/>'
    content += '<g clip-path="url(#ball-clip)">'
    center = ' '.join(point(radius*.38,a) for a in angles)
    content += f'<polygon points="{center}" fill="#0b141b"/>'
    for a in angles:
        inner, outer = point(radius*.38,a), point(radius*.68,a)
        content += f'<path d="M{inner}L{outer}" stroke="#0b141b" stroke-width="{radius*.045}"/>'
        vertices = [(radius*.68,a),(radius*.82,a-.28),(radius*1.1,a-.4),(radius*1.1,a+.4),(radius*.82,a+.28)]
        points = ' '.join(point(r,theta) for r,theta in vertices)
        content += f'<polygon points="{points}" fill="#0b141b"/>'
    content += f'</g><circle r="{radius}" fill="none" stroke="{GOLD}" stroke-width="1.5"/>'
    return f'<g transform="translate({cx} {cy})">{content}</g>'

lines = ''.join(f'<path d="M{x} 0V460" stroke="#fff" stroke-opacity=".022"/>' for x in range(0,1201,60))
lines += ''.join(f'<path d="M0 {y}H1200" stroke="#fff" stroke-opacity=".022"/>' for y in range(0,461,60))
rings = ''.join(f'<circle cx="970" cy="236" r="{r}" fill="none" stroke="{GOLD}" stroke-opacity="{o}"/>' for r,o in ((84,.6),(126,.3),(168,.15)))
svg('hero.svg',1200,460,
    '<rect x="1" y="1" width="1198" height="458" rx="20" fill="url(#bg)" stroke="#2b3442"/>'+lines+
    '<circle cx="970" cy="236" r="230" fill="url(#glow)"/>'+rings+
    '<path d="M970 50V422M784 236H1156" stroke="#dbc29a" stroke-opacity=".12"/>'+
    soccer_ball(970,236,97)+
    '<circle cx="970" cy="68" r="5" fill="#dbc29a"/><circle cx="844" cy="236" r="4" fill="#dbc29a"/><circle cx="1058" cy="326" r="4" fill="#dbc29a"/>'+
    '<path d="M54 54H84" stroke="#dbc29a" stroke-width="2"/>'+
    text(96,60,'SMALLPONYKING',14,GOLD,600,'letter-spacing="3"')+
    text(54,154,'Read the field.',66,WHITE,600,'letter-spacing="-2"')+
    text(54,231,'Build the play.',66,WHITE,600,'letter-spacing="-2"')+
    text(57,282,'AI  /  AGENTS  /  SOFTWARE ENGINEERING',14,GOLD,400,'letter-spacing="2"')+
    text(57,329,'Code. Systems. Intelligence. Always moving forward.',19,MUTED)+
    '<path d="M56 383H708" stroke="#2b3442"/>'+
    text(57,416,'ALWAYS LEARNING. ALWAYS MOVING FORWARD.',11,MUTED,400,'letter-spacing="2"')+
    text(908,416,'BUILD / ITERATE',10,GOLD,400,'letter-spacing="2"'),
    'SmallPonyKing — Read the field. Build the play. AI, agents, and software engineering.')

# Compact artwork keeps headings readable when the README is viewed on a phone.
svg('hero-mobile.svg',600,510,
    '<rect x="1" y="1" width="598" height="508" rx="20" fill="url(#bg)" stroke="#2b3442"/>'+
    '<circle cx="507" cy="91" r="46" fill="none" stroke="#dbc29a" stroke-opacity=".3"/>'+
    soccer_ball(507,91,35)+
    text(34,57,'SMALLPONYKING',15,GOLD,600,'letter-spacing="3"')+
    text(34,183,'Read the field.',64,WHITE,600,'letter-spacing="-2"')+
    text(34,259,'Build the play.',64,WHITE,600,'letter-spacing="-2"')+
    text(36,310,'AI / AGENTS / SOFTWARE ENGINEERING',17,GOLD)+
    text(36,369,'Code. Systems. Intelligence.',22,MUTED)+text(36,400,'Always moving forward.',22,MUTED)+
    '<path d="M36 443H564" stroke="#2b3442"/>'+text(36,478,'ALWAYS LEARNING. ALWAYS MOVING FORWARD.',12,MUTED),
    'SmallPonyKing — Read the field. Build the play. AI, agents, and software engineering.')
from generate_landscape import generate
generate()

print('Generated', len(list(OUT.glob('*.svg'))), 'SVG assets.')

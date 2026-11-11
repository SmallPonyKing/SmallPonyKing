"""Generate original profile SVG artwork without external image services."""
from pathlib import Path
from html import escape

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / 'assets'
OUT.mkdir(exist_ok=True)
INK, PANEL, GOLD, WHITE, MUTED = '#0c1017', '#121923', '#dbc29a', '#f5f0e8', '#9ba7b6'

def svg(name, width, height, content, title):
    (OUT / name).write_text(f'''<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}" role="img" aria-labelledby="title"><title id="title">{escape(title)}</title><defs><linearGradient id="bg" x2="1" y2="1"><stop stop-color="#151e2b"/><stop offset="1" stop-color="{INK}"/></linearGradient><linearGradient id="gold"><stop stop-color="#b49565"/><stop offset=".5" stop-color="#f1dfbe"/><stop offset="1" stop-color="#b49565"/></linearGradient><radialGradient id="glow"><stop stop-color="#dbc29a" stop-opacity=".12"/><stop offset="1" stop-color="#dbc29a" stop-opacity="0"/></radialGradient></defs><rect width="{width}" height="{height}" rx="20" fill="{INK}"/>{content}</svg>''')

def text(x, y, value, size=16, fill=MUTED, weight=400, extra=''):
    return f'<text x="{x}" y="{y}" font-family="Arial,Helvetica,sans-serif" font-size="{size}" fill="{fill}" font-weight="{weight}" {extra}>{escape(value)}</text>'

lines = ''.join(f'<path d="M{x} 0V460" stroke="#fff" stroke-opacity=".022"/>' for x in range(0,1201,60))
lines += ''.join(f'<path d="M0 {y}H1200" stroke="#fff" stroke-opacity=".022"/>' for y in range(0,461,60))
rings = ''.join(f'<circle cx="970" cy="236" r="{r}" fill="none" stroke="{GOLD}" stroke-opacity="{o}"/>' for r,o in ((84,.6),(126,.3),(168,.15)))
svg('hero.svg',1200,460,
    '<rect x="1" y="1" width="1198" height="458" rx="20" fill="url(#bg)" stroke="#2b3442"/>'+lines+
    '<circle cx="970" cy="236" r="230" fill="url(#glow)"/>'+rings+
    '<path d="M970 50V422M784 236H1156" stroke="#dbc29a" stroke-opacity=".12"/>'+
    '<path d="M970 151L1044 194V279L970 322L896 279V194Z M970 151V236L1044 279 M970 236L896 279 M970 236L1044 194 M970 236L896 194 M970 236V322" fill="none" stroke="url(#gold)" stroke-width="1.5"/>'+
    '<circle cx="970" cy="68" r="5" fill="#dbc29a"/><circle cx="844" cy="236" r="4" fill="#dbc29a"/><circle cx="1058" cy="326" r="4" fill="#dbc29a"/>'+
    '<path d="M54 54H84" stroke="#dbc29a" stroke-width="2"/>'+
    text(96,60,'SMALLPONYKING',14,GOLD,600,'letter-spacing="3"')+
    text(54,154,'Intelligence,',66,WHITE,600,'letter-spacing="-2"')+
    text(54,231,'engineered.',66,WHITE,600,'letter-spacing="-2"')+
    text(57,282,'AI  /  AGENTS  /  SOFTWARE ENGINEERING',14,GOLD,400,'letter-spacing="2"')+
    text(57,329,'Turning complex workflows into useful software.',19,MUTED)+
    '<path d="M56 383H708" stroke="#2b3442"/>'+
    text(57,416,'THOUGHTFUL SYSTEMS. PRACTICAL OUTCOMES.',11,MUTED,400,'letter-spacing="2"')+
    text(908,416,'BUILD / ITERATE',10,GOLD,400,'letter-spacing="2"'),
    'SmallPonyKing — Intelligence, engineered. AI, agents, and software engineering.')

def button(name,label,width,primary=False):
    svg(name,width,54,f'<rect x="1" y="1" width="{width-2}" height="52" rx="10" fill="{GOLD if primary else PANEL}" stroke="{GOLD if primary else "#344050"}"/>'+text(21,33,label,14,INK if primary else WHITE,600)+f'<path d="M{width-36} 21l6 6-6 6m-8-6h14" stroke="{INK if primary else GOLD}" stroke-width="1.5" fill="none"/>',label)

button('explore.svg','Explore projects',206,True)
button('discuss.svg','Start a conversation',244)
button('approach.svg','Engineering approach',258)

def card(name,number,title,subtitle,description,stack,diagram):
    svg(name,580,334,
        '<rect x="1" y="1" width="578" height="332" rx="20" fill="url(#bg)" stroke="#2b3442"/>'+
        text(30,39,'SELECTED WORK  /  '+number,11,GOLD,400,'letter-spacing="2"')+diagram+
        text(30,112,title,30,WHITE,600,'letter-spacing="-.5"')+
        text(30,146,subtitle,15,GOLD)+text(30,191,description[0],15,MUTED)+text(30,216,description[1],15,MUTED)+
        '<path d="M30 249H550" stroke="#2b3442"/>'+text(30,279,stack,12,MUTED)+text(30,309,'EXPLORE REPOSITORY',11,GOLD,600,'letter-spacing="1.4"')+
        '<path d="M526 295l9 8-9 8m-12-8h21" fill="none" stroke="#dbc29a" stroke-width="1.5"/>',
        f'{title}. {subtitle}. {" ".join(description)} {stack}. Explore repository.')

card('job-scraper.svg','01','Job Scraper Agent','Discovery → enrichment → matching',
     ('Public job discovery with model-assisted enrichment.', 'Durable queues. Resumable scans. Reviewable results.'),
     'PYTHON   /   SQLITE   /   OLLAMA   /   JAVASCRIPT',
     '<path d="M468 39h55m-55 13h55m-55 13h33" stroke="#dbc29a" stroke-opacity=".65"/><circle cx="548" cy="58" r="5" fill="#dbc29a"/>')
card('mail-check.svg','02','Mail Check Agent','Evidence → validation → review',
     ('Compare reported applications with confirmation evidence.', 'Mailbox integrations. Audit history. Exportable reports.'),
     'PYTHON   /   IMAP   /   OAUTH   /   SQLITE',
     '<rect x="494" y="34" width="48" height="32" rx="4" fill="none" stroke="#dbc29a" stroke-opacity=".65"/><path d="M495 36l23 17 23-17" fill="none" stroke="#dbc29a"/>')

svg('workflow.svg',1200,144,
    '<rect x="1" y="1" width="1198" height="142" rx="20" fill="#0c1017" stroke="#2b3442"/>'+text(30,33,'THE WORKFLOW',10,GOLD,400,'letter-spacing="2"')+
    '<path d="M80 76H1120" stroke="#344050"/>'+
    ''.join(f'<circle cx="{x}" cy="76" r="6" fill="#dbc29a"/>'+text(x,115,label,13,WHITE,400,'text-anchor="middle"') for x,label in [(80,'OBSERVE'),(340,'REASON'),(600,'BUILD'),(860,'VALIDATE'),(1120,'ITERATE')]),
    'Workflow: observe, reason, build, validate, iterate.')

# Compact artwork keeps headings readable when the README is viewed on a phone.
svg('hero-mobile.svg',600,510,
    '<rect x="1" y="1" width="598" height="508" rx="20" fill="url(#bg)" stroke="#2b3442"/>'+
    '<circle cx="507" cy="91" r="46" fill="none" stroke="#dbc29a" stroke-opacity=".3"/>'+
    '<path d="M507 62l25 15v29l-25 14-25-14V77Z" fill="none" stroke="#dbc29a"/>'+
    text(34,57,'SMALLPONYKING',15,GOLD,600,'letter-spacing="3"')+
    text(34,183,'Intelligence,',64,WHITE,600,'letter-spacing="-2"')+
    text(34,259,'engineered.',64,WHITE,600,'letter-spacing="-2"')+
    text(36,310,'AI / AGENTS / SOFTWARE ENGINEERING',17,GOLD)+
    text(36,369,'Turning complex workflows',22,MUTED)+text(36,400,'into useful software.',22,MUTED)+
    '<path d="M36 443H564" stroke="#2b3442"/>'+text(36,478,'THOUGHTFUL SYSTEMS. PRACTICAL OUTCOMES.',12,MUTED),
    'SmallPonyKing — Intelligence, engineered. AI, agents, and software engineering.')
for name,num,title,description in (
    ('job-scraper-mobile.svg','01',('Job Scraper','Agent'),('Discover. Enrich.','Match opportunities.')),
    ('mail-check-mobile.svg','02',('Mail Check','Agent'),('Evidence. Validation.','Reviewable results.')),
):
    svg(name,300,280,
        '<rect x="1" y="1" width="298" height="278" rx="20" fill="url(#bg)" stroke="#2b3442"/>'+
        text(22,34,'SELECTED WORK / '+num,11,GOLD)+text(22,91,title[0],32,WHITE,600)+text(22,129,title[1],32,WHITE,600)+
        text(22,174,description[0],17,MUTED)+text(22,201,description[1],17,MUTED)+
        '<path d="M22 225H278" stroke="#2b3442"/>'+text(22,256,'EXPLORE REPOSITORY →',13,GOLD,600),
        ' '.join(title)+'. '+' '.join(description))

print('Generated', len(list(OUT.glob('*.svg'))), 'SVG assets.')

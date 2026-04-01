#!/usr/bin/env python3
"""
Generate simple app icons for the calculator app (light/dark/tinted variants).
Requires: Pillow
"""
from PIL import Image, ImageDraw, ImageFont
import os

OUT_DIR = os.path.join(os.path.dirname(__file__), '..', 'MyCalculator', 'Assets.xcassets', 'AppIcon.appiconset')
OUT_DIR = os.path.abspath(OUT_DIR)

os.makedirs(OUT_DIR, exist_ok=True)

SIZE = 1024
CORNER_RADIUS = 180

# Colors
LIGHT_BG = (250, 250, 250, 255)
DARK_BG = (10, 10, 10, 255)
TINT_BG = (28, 28, 30, 255)  # slightly different for tinted

BUTTON_COLOR = (60, 60, 60, 255)
OP_COLOR = (255, 149, 0, 255)
DISPLAY_COLOR = (200, 200, 200, 255)

ICON_LIGHT = 'AppIcon-1024.png'
ICON_DARK = 'AppIcon-1024-dark.png'
ICON_TINTED = 'AppIcon-1024-tinted.png'

FONT_PATHS = [
    '/Library/Fonts/Arial.ttf',
    '/System/Library/Fonts/SFNSText.ttf',
]

def load_font(size):
    for p in FONT_PATHS:
        try:
            return ImageFont.truetype(p, size)
        except Exception:
            continue
    return ImageFont.load_default()


def rounded_rect(draw, xy, radius, fill):
    x0, y0, x1, y1 = xy
    draw.rounded_rectangle(xy, radius=radius, fill=fill)


def draw_calculator(img, bg_color):
    draw = ImageDraw.Draw(img)
    w, h = img.size

    # Background rounded square
    pad = 64
    rounded_rect(draw, (pad, pad, w - pad, h - pad), CORNER_RADIUS, bg_color)

    # Calculator body inside
    body_pad = 160
    body_rect = (body_pad, body_pad, w - body_pad, h - body_pad)
    draw.rounded_rectangle(body_rect, radius=50, fill=(28,28,30,255))

    # Display area
    dw = w - body_pad*2
    dh = int(dw * 0.2)
    display_rect = (body_pad + 40, body_pad + 40, body_pad + 40 + dw - 80, body_pad + 40 + dh)
    draw.rectangle(display_rect, fill=DISPLAY_COLOR)

    # Buttons (4 columns x 4 rows) inside body
    cols = 4
    rows = 4
    spacing = 28
    btn_w = (dw - (cols + 1) * spacing) / cols
    btn_h = btn_w
    start_x = body_pad + spacing
    start_y = body_pad + dh + 80

    op_col = [3]  # last column operators

    for r in range(rows):
        for c in range(cols):
            x = start_x + c * (btn_w + spacing)
            y = start_y + r * (btn_h + spacing)
            rect = (x, y, x + btn_w, y + btn_h)
            color = OP_COLOR if c in op_col else BUTTON_COLOR
            draw.rounded_rectangle(rect, radius=btn_w*0.15, fill=color)

    # Add small text or glyph for calculator
    font = load_font(int(btn_w * 0.4))
    # Draw a plus symbol in the center
    cx, cy = w/2, h/2 + 50
    # horizontal
    draw.rectangle((cx - 10 - 80, cy - 10, cx + 10 + 80, cy + 10), fill=DISPLAY_COLOR)
    # vertical
    draw.rectangle((cx - 10, cy - 10 - 80, cx + 10, cy + 10 + 80), fill=DISPLAY_COLOR)

    return img


def make_icon(filename, bg_color):
    img = Image.new('RGBA', (SIZE, SIZE), (0,0,0,0))
    img = draw_calculator(img, bg_color)
    out_path = os.path.join(OUT_DIR, filename)
    img.save(out_path, format='PNG')
    print('Wrote', out_path)


if __name__ == '__main__':
    make_icon(ICON_LIGHT, LIGHT_BG)
    make_icon(ICON_DARK, DARK_BG)
    make_icon(ICON_TINTED, TINT_BG)
    print('Done')

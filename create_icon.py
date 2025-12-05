#!/usr/bin/env python3
from PIL import Image, ImageDraw
import os

# Create iconset directory
iconset_dir = "AppIcon.iconset"
os.makedirs(iconset_dir, exist_ok=True)

# Icon sizes needed for macOS
sizes = [
    (16, "icon_16x16.png"),
    (32, "icon_16x16@2x.png"),
    (32, "icon_32x32.png"),
    (64, "icon_32x32@2x.png"),
    (128, "icon_128x128.png"),
    (256, "icon_128x128@2x.png"),
    (256, "icon_256x256.png"),
    (512, "icon_256x256@2x.png"),
    (512, "icon_512x512.png"),
    (1024, "icon_512x512@2x.png"),
]

def create_icon(size):
    # Create image with transparent background
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Draw gradient circle background
    for i in range(size):
        for j in range(size):
            # Calculate distance from center
            dx = i - size/2
            dy = j - size/2
            distance = (dx*dx + dy*dy) ** 0.5
            
            if distance <= size/2 - 2:
                # Create gradient from blue to purple
                ratio = distance / (size/2)
                r = int(88 + (175 - 88) * ratio)
                g = int(86 + (82 - 86) * ratio)
                b = int(214 + (222 - 214) * ratio)
                img.putpixel((i, j), (r, g, b, 255))
    
    # Draw power symbol
    center_x, center_y = size // 2, size // 2
    symbol_size = size // 3
    line_width = max(2, size // 20)
    
    # Draw the circle part of power symbol
    arc_radius = symbol_size // 2
    draw.arc(
        [center_x - arc_radius, center_y - arc_radius + symbol_size//6,
         center_x + arc_radius, center_y + arc_radius + symbol_size//6],
        start=220, end=320, fill='white', width=line_width
    )
    
    # Draw the vertical line
    draw.line(
        [center_x, center_y - symbol_size//2,
         center_x, center_y + symbol_size//6],
        fill='white', width=line_width
    )
    
    return img

# Generate all icon sizes
for size, filename in sizes:
    icon = create_icon(size)
    icon.save(os.path.join(iconset_dir, filename))
    print(f"Created {filename}")

print(f"\nIconset created in {iconset_dir}/")
print("Run: iconutil -c icns AppIcon.iconset")

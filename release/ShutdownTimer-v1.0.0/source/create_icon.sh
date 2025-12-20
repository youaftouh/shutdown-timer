#!/bin/bash

# Create iconset directory
mkdir -p AppIcon.iconset

# Create a simple SVG icon
cat > icon.svg << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="1024" height="1024" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#5856D6;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#AF52DE;stop-opacity:1" />
    </linearGradient>
  </defs>
  
  <!-- Background circle -->
  <circle cx="512" cy="512" r="480" fill="url(#grad)"/>
  
  <!-- Power symbol -->
  <g stroke="white" stroke-width="60" fill="none" stroke-linecap="round">
    <!-- Vertical line -->
    <line x1="512" y1="280" x2="512" y2="512"/>
    <!-- Arc -->
    <path d="M 340 420 A 200 200 0 1 1 684 420" />
  </g>
</svg>
EOF

# Convert SVG to PNG at different sizes using sips (built-in macOS tool)
sizes=(16 32 64 128 256 512 1024)

for size in "${sizes[@]}"; do
    # For retina displays
    if [ $size -le 512 ]; then
        double=$((size * 2))
        qlmanage -t -s $size -o . icon.svg 2>/dev/null
        if [ -f "icon.svg.png" ]; then
            mv icon.svg.png "AppIcon.iconset/icon_${size}x${size}.png"
        fi
        
        qlmanage -t -s $double -o . icon.svg 2>/dev/null
        if [ -f "icon.svg.png" ]; then
            mv icon.svg.png "AppIcon.iconset/icon_${size}x${size}@2x.png"
        fi
    else
        qlmanage -t -s $size -o . icon.svg 2>/dev/null
        if [ -f "icon.svg.png" ]; then
            mv icon.svg.png "AppIcon.iconset/icon_${size}x${size}.png"
        fi
    fi
done

echo "Icon files created in AppIcon.iconset/"
echo "Converting to .icns format..."

# Convert iconset to icns
iconutil -c icns AppIcon.iconset -o AppIcon.icns

if [ -f "AppIcon.icns" ]; then
    echo "✓ AppIcon.icns created successfully!"
    # Copy to app bundle
    cp AppIcon.icns ShutdownTimer.app/Contents/Resources/
    echo "✓ Icon installed to app bundle"
else
    echo "✗ Failed to create icns file"
fi

# Cleanup
rm -f icon.svg

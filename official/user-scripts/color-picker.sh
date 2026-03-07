#!/bin/bash
# ============================================================
# Script Name:  color-picker.sh
# Description:  Opens the macOS color picker, then outputs
#               the selected color as HEX, RGB, and HSL,
#               and copies the HEX value to clipboard.
#               Replaces: Sip, ColorSnapper, Pastel
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/color-picker.sh
# ============================================================

RESULT=$(osascript <<'EOF'
set c to choose color
set r to (item 1 of c) / 65535 * 255
set g to (item 2 of c) / 65535 * 255
set b to (item 3 of c) / 65535 * 255
return (round r) & "," & (round g) & "," & (round b)
EOF
)

if [ -z "$RESULT" ]; then
  echo "No color selected."
  exit 0
fi

R=$(echo "$RESULT" | cut -d',' -f1)
G=$(echo "$RESULT" | cut -d',' -f2)
B=$(echo "$RESULT" | cut -d',' -f3)

HEX=$(printf '#%02X%02X%02X' "$R" "$G" "$B")

# Calculate HSL
python3 - "$R" "$G" "$B" <<'PYEOF'
import sys
r, g, b = int(sys.argv[1])/255, int(sys.argv[2])/255, int(sys.argv[3])/255
cmax, cmin = max(r,g,b), min(r,g,b)
delta = cmax - cmin
l = (cmax + cmin) / 2
s = 0 if delta == 0 else delta / (1 - abs(2*l - 1))
if delta == 0: h = 0
elif cmax == r: h = 60 * (((g-b)/delta) % 6)
elif cmax == g: h = 60 * ((b-r)/delta + 2)
else: h = 60 * ((r-g)/delta + 4)
print(f"HSL: hsl({h:.0f}, {s*100:.0f}%, {l*100:.0f}%)")
PYEOF

echo "HEX: $HEX"
echo "RGB: rgb($R, $G, $B)"
echo -n "$HEX" | pbcopy
echo ""
echo "✅ HEX copied to clipboard: $HEX"

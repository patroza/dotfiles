#!/usr/bin/awk -f

# shade.awk -v m=(darker|lighter) -v r=0xFF -v g=0xFF -v b=0xFF


##################################################
# Absolute value

function abs(x) { return x < 0 ? -x : x; }


##################################################
# Convert RGB to HSB

function rgb2hsb(red, green, blue) {
    red /= 255; green /= 255; blue /= 255;

    max = (red > green ? (red > blue ? red : blue) : (green > blue ? green : blue));
    min = (red < green ? (red < blue ? red : blue) : (green < blue ? green : blue));
    delta = max - min;

    # Hue calculation
    if (delta == 0) {
        hue = 0;
    } else if (max == red) {
        hue = 60 * (((green - blue) / delta) % 6);
    } else if (max == green) {
        hue = 60 * (((blue - red) / delta) + 2);
    } else {
        hue = 60 * (((red - green) / delta) + 4);
    }

    if (hue < 0) hue += 360;

    # Saturation
    sat = (max == 0) ? 0 : delta / max;
    sat = sat * 100;

    # Brightness
    br = max * 100;
}



##################################################
# Convert HSB to RGB

function hsb2rgb(h, s, v) {
    s /= 100;
    v /= 100;

    c = v * s;
    x = c * (1 - abs((h / 60) % 2 - 1));
    m = v - c;

    if (h < 60)      { r = c; g = x; b = 0; }
    else if (h < 120){ r = x; g = c; b = 0; }
    else if (h < 180){ r = 0; g = c; b = x; }
    else if (h < 240){ r = 0; g = x; b = c; }
    else if (h < 300){ r = x; g = 0; b = c; }
    else             { r = c; g = 0; b = x; }

    red = int((r + m) * 255 + 0.5);
    green = int((g + m) * 255 + 0.5);
    blue = int((b + m) * 255 + 0.5);
}


##################################################
# Make it darker

function darker(h, s, v) {
    if (s < mins) { sat = mins } else { sat = s };
    if (v > maxv) { br = maxv } else { br = v };
}


##################################################
# Make it lighter

function lighter(h, s, v) {
    if (s > mins) { sat = mins } else { sat = s };
    if (v < maxv) { br = maxv } else { br = v };
}


##################################################
# Main

BEGIN {
    # Convert to HSB
    rgb2hsb(r, g, b);

    # Adjust
    if (m == "darker") {
	mins = 70
	maxv = 40

	darker(hue, sat, br);
    } else {
	mins = 15
	maxv = 100

	lighter(hue, sat, br);
    }

    # Convert to RGB
    hsb2rgb(hue, sat, br);

    # Print in a format for sketchybar with 100% opacity
    printf("0xff%.2x%.2x%.2x\n", red, green, blue);
}
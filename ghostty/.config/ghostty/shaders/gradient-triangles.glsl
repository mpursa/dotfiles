
const float TRIANGLE_SIZE = 250.0;
// 0 = regular grid, keep below 1.0
const float IRREGULARITY = 0.75;
// theme palette: 0 black, 1 red, 2 green, 3 yellow, 4 blue, 5 magenta, 6 cyan, 7 white
const int COLOR_1 = 0;
const int COLOR_2 = 4;
// 0 = plain background, 1 = full colors
const float STRENGTH = 0.15;

vec2 hash2(vec2 p)
{
    return fract(sin(vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)))) * 43758.5453);
}

vec2 corner(vec2 p)
{
    return p + (hash2(p) - 0.5) * IRREGULARITY;
}

bool inTriangle(vec2 p, vec2 a, vec2 b, vec2 c)
{
    return determinant(mat2(b - a, p - a)) >= 0.0
        && determinant(mat2(c - b, p - b)) >= 0.0
        && determinant(mat2(a - c, p - c)) >= 0.0;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec2 p = fragCoord.xy / TRIANGLE_SIZE;
    float shade = 0.5;
    for (int y = 0; y <= 1; y++)
    for (int x = 0; x <= 1; x++)
    {
        vec2 cell = floor(p - 0.5) + vec2(x, y);
        vec2 a = corner(cell), b = corner(cell + vec2(1, 0)), c = corner(cell + vec2(1, 1)), d = corner(cell + vec2(0, 1));
        if (distance(a, c) > distance(b, d)) { vec2 t = a; a = b; b = c; c = d; d = t; }
        vec2 s = hash2(cell + 0.5);
        if (inTriangle(p, a, b, c)) shade = s.x;
        if (inTriangle(p, a, c, d)) shade = s.y;
    }

    vec3 triangleColor = mix(iPalette[COLOR_1], iPalette[COLOR_2], shade);
    triangleColor = mix(iBackgroundColor, triangleColor, STRENGTH);

    vec4 terminalColor = texture(iChannel0, uv);

    float mask = 1.0 - min(distance(terminalColor.rgb, iBackgroundColor) / distance(iForegroundColor, iBackgroundColor), 1.0);
    vec3 blendedColor = terminalColor.rgb + (triangleColor - iBackgroundColor) * mask;

    fragColor = vec4(blendedColor, terminalColor.a);
}

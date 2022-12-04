#define PI 3.141592653

vec2 FixUV(in vec2 uv){
    return 3. * (2. * uv - iResolution.xy) / min(iResolution.x,iResolution.y);
}

vec3 DrawGrid(in vec2 uv){
    vec3 col = vec3(0);

    vec2 cell = fract(uv);

    if(cell.x < fwidth(uv.x)) col = vec3(1);

    if(cell.y < fwidth(uv.y)) col = vec3(1);
    
    if(abs(uv.x) < fwidth(uv.x)) col = vec3(1,0,0);
    
    if(abs(uv.y) < fwidth(uv.y)) col = vec3(1,0,0);

    return col;
}

float DrawSegment(in vec2 p, in vec2 a, in vec2 b, in float width){
    float f = 0.;
    vec2 ba = b - a;
    vec2 pa = p - a;
    float proj = clamp(dot(pa, ba)/dot(ba, ba),0.,1.);
    float d = length(ba * proj - pa);
    if(d <= width) f = 1.;
    return f;
}

float func(in float x){
    float t = 2. + cos(iTime);
    return cos(PI / t * x);
}

float DrawFunc(in vec2 uv){
    float val = 0.;

    for(float i=0.; i<=iResolution.x; i+=1.){
        float fx = FixUV(vec2(i,0.)).x;
        float nfx = FixUV(vec2(i + 1.,0.)).x;
        val += DrawSegment(uv, vec2(fx, func(fx)), vec2(nfx, func(nfx)), fwidth(uv.x));
    }

    val = clamp(val, 0., 1.);

    return val;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = FixUV(fragCoord);

    vec3 col = mix(DrawGrid(uv), vec3(0.,1.,0.), DrawFunc(uv));

    fragColor = vec4(col, 1.0);
}
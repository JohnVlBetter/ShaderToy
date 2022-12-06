#define PI 3.141592653

vec2 FixUV(in vec2 uv){
    return 3. * (2. * uv - iResolution.xy) / min(iResolution.x,iResolution.y);
}

vec3 DrawGrid(in vec2 uv){
    vec3 col = vec3(0.4);
    vec2 grid = floor(mod(uv,2.));
    if(grid.x == grid.y) col = vec3(.6);

    col = mix(col, vec3(0.), 
        smoothstep(1.1*fwidth(uv.x),fwidth(uv.x),abs(uv.x)));
    col = mix(col, vec3(0.), 
        smoothstep(1.1*fwidth(uv.y),fwidth(uv.y),abs(uv.y)));

    return col;
}

float DrawSphere(in vec2 uv,in vec2 center, in float radius){
    float val = sign(length(uv - center) - radius*0.99);
    float val2 = -sign(length(uv - center) - radius);
    val = val2 + val - 1.;
    return clamp(val,0.,1.);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = FixUV(fragCoord);

    vec2 mpos = FixUV(iMouse.xy);

    vec3 col = mix(DrawGrid(uv), vec3(0.78,0.21,0.63), 
        DrawSphere(uv,mpos,1.));

    fragColor = vec4(col, 1.0);
}
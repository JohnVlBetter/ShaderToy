void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord - 0.5 * iResolution.xy)/min(iResolution.xx,iResolution.yy);

    vec3 col = vec3(0);
    if(length(uv)<0.3) col = vec3(1);

    fragColor = vec4(col,1.0);
}
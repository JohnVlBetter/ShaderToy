#iChannel0 "file://earthmap.jpg"
#iChannel0::WrapMode "Repeat"

#define TMIN 0.1
#define TMAX 20.
#define RAYMARCH_TIME 128
#define PRECISION .001
#define AA 3

vec2 fixUV(in vec2 c) {
    return (2. * c - iResolution.xy) / min(iResolution.x, iResolution.y);
}

float sdfSphere(in vec3 p) {
    return length(p - vec3(0., 0., 2.)) - 1.5;
}

float rayMarch(in vec3 ro, in vec3 rd) {
    float t = TMIN;
    for(int i=0;i<RAYMARCH_TIME && t<=TMAX;++i){
        vec3 p = ro + rd * t;
        float d = sdfSphere(p);
        if(d < PRECISION) break;
        t += d;
    }
    return t;
}

vec3 calcNormal(in vec3 p) {
    const float h = 0.0001;
    const vec2 k = vec2(1, -1);
    return normalize(k.xyy * sdfSphere(p + k.xyy * h) +
        k.yyx * sdfSphere(p + k.yyx * h) +
        k.yxy * sdfSphere(p + k.yxy * h) +
        k.xxx * sdfSphere(p + k.xxx * h));
}

vec3 render(vec2 uv) {
    vec3 color = vec3(0.);
    vec3 ro = vec3(0., 0., -1.5);
    vec3 rd = normalize(vec3(uv, 0.) - ro);
    float t = rayMarch(ro, rd);
    if(t < TMAX) {
        vec3 p = ro + t * rd;
        vec3 n = calcNormal(p);
        vec3 light = vec3(2. * cos(iTime - 2.0), 1., 2. * sin(iTime - 2.0) + 2.);
        float dif = max(dot(normalize(light - p), n),0.) * 0.8 + 0.2;
        color = dif * vec3(1.);
    }
    return color;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    /*vec3 color = vec3(0.);
    for(int m = 0; m < AA; m++) {
        for(int n = 0; n < AA; n++) {
            vec2 offset = 2. * (vec2(float(m), float(n)) / float(AA) - .5);
            vec2 uv = fixUV(fragCoord + offset);
            color += render(uv);
        }
    }
    fragColor = vec4(color / float(AA * AA), 1.);*/
    vec2 uv = fragCoord / iResolution.y;
    //uv *= 3.;
    vec3 col = texture(iChannel0, uv).rgb;
    fragColor = vec4(col,1.);
}

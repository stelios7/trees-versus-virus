SHADERS = {}
SHADERS.infection = [[
    #define u_resolution vec2(1280, 720) 
    extern float u_time;
    
    float random2d(vec2 coords){
        return fract(sin(dot(coords.xy, vec2(12.9898, 78.233))) * 43758.5453);
    }
    
    vec4 effect(vec4 color, Image tex, vec2 coords, vec2 screen_coords){
        vec4 pixel = Texel(tex, coords);
        // coords = coords * u_resolution * .03;
        coords *= u_resolution * 0.05;
        coords -= u_time + vec2(sin(coords.y), cos(coords.x + u_time));

        float rand01 = fract(random2d(floor(coords)) + u_time / 60.0);
        float rand02 = fract(random2d(floor(coords)) + u_time / 40.0);

        //rand01 *= 0.4 - length(fract(coords));
        
        return pixel * vec4(rand01 * rand02 + .15, rand02 * rand01 * 1.78, rand01 * 2.0, 1.0) * pixel[3];
    }
]]



SHADERS.rainbow_pixel = [[
    uniform float u_time;

    float rand(vec2 v){
        return fract(sin(dot(v.xy, vec2(12.8989, 78.233))) * 43758.5453);
    }

    float getCellBright(vec2 id){
        return sin((u_time * 5. + 2.) * rand(id) * 2.) * .1 + .1;
    }

    vec4 effect(vec4 color, Image tex, vec2 coords, vec2 screen_coords){
        vec4 pixel = Texel(tex, coords);
        vec3 col = vec3(1.0);
        float time = u_time * 1.5;

        coords *= 20.;

        vec2 id = floor(coords);
        vec2 gv = fract(coords) - .5;

        float randBright = getCellBright(id);
        vec3 colorShift = vec3(rand(id) * .1);

        col = .6 + .5 * cos(time + (id.xyx * .1) + vec3(1,3,5) + colorShift);

        float shadow = 0.;
        shadow += smoothstep(.2,.85, gv.x*min(0.,(getCellBright(vec2(id.x-1.,id.y))-getCellBright(id))));
        shadow += smoothstep(.2,.85,-gv.y*min(0.,(getCellBright(vec2(id.x,id.y+1.))-getCellBright(id))));

        col -= shadow * 25;
        col *= 2. - (randBright * .3);

        return pixel * vec4(col, 1.0);
    }
]]
#version 310 es

precision highp float;
precision highp int;

struct Globals {
    uvec4 num_lights;
};
struct Light {
    mat4x4 proj;
    vec4 pos;
    vec4 color;
};
uniform Globals_block_0Fragment { Globals _group_0_binding_0_fs; };

layout(std430) readonly buffer Lights_block_1Fragment {
    Light data[];
} _group_0_binding_1_fs;

uniform highp sampler2DArrayShadow _group_0_binding_2_fs;

layout(location = 0) smooth in vec3 _vs2fs_location0;
layout(location = 1) smooth in vec4 _vs2fs_location1;
layout(location = 0) out vec4 _fs2p_location0;

float fetch_shadow(uint light_id, vec4 homogeneous_coords) {
    if ((homogeneous_coords.w <= 0.0)) {
        return 1.0;
    }
    vec2 flip_correction = vec2(0.5, -0.5);
    vec2 light_local = (((homogeneous_coords.xy * flip_correction) / vec2(homogeneous_coords.w)) + vec2(0.5, 0.5));
    float _e26 = textureGrad(_group_0_binding_2_fs, vec4(light_local, int(light_id), (homogeneous_coords.z / homogeneous_coords.w)), vec2(0.0), vec2(0.0));
    return _e26;
}

void main() {
    vec3 raw_normal = _vs2fs_location0;
    vec4 position = _vs2fs_location1;
    vec3 color = vec3(0.05000000074505806, 0.05000000074505806, 0.05000000074505806);
    uint i = 0u;
    vec3 normal = normalize(raw_normal);
    bool loop_init = true;
    while(true) {
        if (!loop_init) {
        uint _e40 = i;
        i = (_e40 + 1u);
        }
        loop_init = false;
        uint _e12 = i;
        uint _e15 = _group_0_binding_0_fs.num_lights.x;
        if ((_e12 >= min(_e15, 10u))) {
            break;
        }
        uint _e19 = i;
        Light light = _group_0_binding_1_fs.data[_e19];
        uint _e22 = i;
        float _e25 = fetch_shadow(_e22, (light.proj * position));
        vec3 light_dir = normalize((light.pos.xyz - position.xyz));
        float diffuse = max(0.0, dot(normal, light_dir));
        vec3 _e34 = color;
        color = (_e34 + ((_e25 * diffuse) * light.color.xyz));
    }
    vec3 _e43 = color;
    _fs2p_location0 = vec4(_e43, 1.0);
    return;
}


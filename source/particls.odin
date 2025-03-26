package game

import rl "vendor:raylib"
import "core:fmt"
// import "core:math"
// import "core:fmt"

img_ani_name::union{
    Texture_Name,
    Animation_Name,
}

particle :: struct{
    pos:[3]f32,
    velocity:[3]f32,
    force:[3]f32,
    w_h:[2]f32,
    w_h_shift:[2]f32,
    rot:f32,
    rot_shift:f32,
    life:f32,
    max_life:f32,
    img:img_ani_name,
    tint:[4]f32,
    tint_shift:[4]f32,
    callback:proc(particle:^particle),
}
max_particles:int:10000
all_particle_data::struct{
    data:[max_particles]particle,
    p_count:int,
}

add_particle::proc(particle:particle){
    if g_mem.state.particle.p_count < max_particles-1{
        g_mem.state.particle.data[g_mem.state.particle.p_count] = particle
        g_mem.state.particle.p_count += 1
    }
}
remove_particle::proc(p_index:int){
    g_mem.state.particle.data[p_index] = g_mem.state.particle.data[g_mem.state.particle.p_count-1]
    if g_mem.state.particle.p_count>0{
        g_mem.state.particle.p_count -=1
    }
}
calc_particles::proc(){
    // fmt.print(g_mem.state.particle.p_count,"\n")
    if g_mem.time.is_60h_this_frame {
        if g_mem.state.particle.p_count > 0{
            for i in 0..<g_mem.state.particle.p_count {
                g_mem.state.particle.data[i].life -= g_mem.time.dt_60h
                if g_mem.state.particle.data[i].callback != nil{
                    g_mem.state.particle.data[i].callback(&g_mem.state.particle.data[i])
                }else{
                    bace_calc_particle(&g_mem.state.particle.data[i])
                }
                if g_mem.state.particle.data[i].life<0{
                    remove_particle(i)
                }
            }
        }
    }
}
bace_calc_particle::proc(particle:^particle){
    particle.velocity += (particle.force * g_mem.time.dt_60h)
    particle.pos += (particle.velocity * g_mem.time.dt_60h)
    particle.rot += (particle.rot_shift * g_mem.time.dt_60h)
    particle.w_h += (particle.w_h_shift * g_mem.time.dt_60h)
}
draw_particles::proc(){
    if g_mem.state.particle.p_count > 0{
        for i in 0..<g_mem.state.particle.p_count {
            part := &g_mem.state.particle.data[i]
            draw_image(
                name = part.img,
                dest = {part.pos.x,part.pos.y,part.w_h.x,part.w_h.y},
                z = part.pos.z,
                origin ={part.w_h.x/2,part.w_h.y/2},
                rot = part.rot,
                tint = rl.ColorFromNormalized(part.tint),
            )
        }
    }
}

particles_stuff::proc(particle:^particle){
    bace_calc_particle(particle)

    particle.tint = lerp_colors({1,1,1,1},{0,0,0,0},particle.life/particle.max_life)
    
}
part_gen_info::struct{
    doo:bool,
    part_c:i32,

    particle:particle,
}

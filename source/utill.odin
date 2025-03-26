package game

import rl "vendor:raylib"
import "core:math"
import "core:math/rand"
import "core:fmt"
time_stuff::struct{
    dt:f32,
    dt_60h:f32,
    is_60h_this_frame:bool,
    frame_count_60h:i32,
    frame_count:uint,

}

mantine_timers::proc(){
    
    g_mem.time.dt = rl.GetFrameTime()
    g_mem.time.dt_60h += rl.GetFrameTime()
    g_mem.time.frame_count+=1
    if g_mem.time.is_60h_this_frame == true{
        g_mem.time.is_60h_this_frame = false
        g_mem.time.dt_60h = -0.016666
    }
    if g_mem.time.dt_60h >0.016666{
        g_mem.time.is_60h_this_frame = true
        g_mem.time.frame_count_60h+=1
    }
    if g_mem.placing.sound_cd>=0{
        g_mem.placing.sound_cd -= g_mem.time.dt
    }
    if g_mem.placing.sound_cd <0{
        g_mem.placing.sound_cd = 0
    }
}
lerp_colors::proc(c1:[4]f32,c2:[4]f32,m:f32)->(f_color:[4]f32){
    f_color ={ math.lerp(c1.r,c2.r,m),math.lerp(c1.g,c2.g,m),math.lerp(c1.b,c2.b,m),math.lerp(c1.a,c2.a,m)}
    return
}
init_defalt_settings::proc(){
    g_mem.settings.render_distance = 3
}
init_seeds::proc(){
    g_mem.state.seeds.bace = rand.int63()
    g_mem.state.seeds.height = rand.int63()
    g_mem.state.seeds.ore = rand.int63()
}


do_inputs::proc(){
    check_rotate_building()
    check_cam_movements()
    if !g_mem.placing.in_ui{
        check_pace_buildings()
        check_destroy_buildings()
        check_fov()
        check_paning()
    }
}
min_zoom::64
max_zoom::2048
check_fov::proc(){
    g_mem.cam.fovy +=rl.GetMouseWheelMove()*tile_size*-2
    if g_mem.cam.fovy < min_zoom {g_mem.cam.fovy = min_zoom}
    if g_mem.cam.fovy > max_zoom {g_mem.cam.fovy = max_zoom}
}

check_rotate_building::proc(){
    if !g_mem.placing.in_ui{
        check_rot_buildings()
	}
}

cam_speed::0.5
check_cam_movements::proc(){
	if rl.IsKeyDown(.UP) || rl.IsKeyDown(.W) {
		g_mem.cam.position.y -= cam_speed *g_mem.cam.fovy *g_mem.time.dt
	}
	if rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S) {
        g_mem.cam.position.y += cam_speed *g_mem.cam.fovy *g_mem.time.dt
	}
	if rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A) {
        g_mem.cam.position.x -= cam_speed *g_mem.cam.fovy *g_mem.time.dt
	}
	if rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D) {
        g_mem.cam.position.x += cam_speed *g_mem.cam.fovy *g_mem.time.dt
	}
    g_mem.cam.target.xy = g_mem.cam.position.xy
}
check_rot_buildings::proc(){
    if rl.IsKeyPressed(.R) {
        g_mem.placing.rot +=90
        if g_mem.placing.rot>=360{
            g_mem.placing.rot = 0
        }
        play_sound(.penswipe,1,1-(g_mem.placing.rot/270)/5)
        play_sound(.penswipe,.8,.8-(g_mem.placing.rot/270)/5)
    }
}
check_destroy_buildings::proc(){
    if rl.IsMouseButtonDown(.MIDDLE){
        delete_building_on_mouse()
    }
}
check_paning::proc(){
    
	if rl.IsMouseButtonDown(.RIGHT) {
        
		delta:rl.Vector2 = rl.GetMouseDelta()
		delta = (delta *(g_mem.cam.fovy/cast(f32)rl.GetScreenHeight())*-1 )
		g_mem.cam.position += {delta.x,delta.y,0}
		g_mem.cam.target.x = g_mem.cam.position.x
		g_mem.cam.target.y = g_mem.cam.position.y

	}
}

check_pace_buildings::proc(){
    if rl.IsMouseButtonDown(.LEFT) {
        if !rl.IsKeyDown(.LEFT_SHIFT){
        ray:=rl.GetScreenToWorldRay(rl.GetMousePosition(),g_mem.cam)
        t_pos:=world_pos_t_pos({ray.position.x,ray.position.y})
        switch building_ in g_mem.defalt.entities[g_mem.placing.id].type {
            case building :
            can_build:bool=true
            for x := cast(i32)t_pos.x; x <cast(i32)t_pos.x+cast(i32)building_.w_h.x; x += 1 {
                for y := cast(i32)t_pos.y; y <cast(i32)t_pos.y+cast(i32)building_.w_h.x; y += 1 {
                    t_l1:=get_tile_l1({cast(int)x,cast(int)y})
                    t_l2:=get_tile_l2({cast(int)x,cast(int)y})
                    if .can_not_build_on in defalt_tile_sets[t_l1].flags{
                        can_build=false
                    }
                    if .can_not_build_on in defalt_tile_sets[t_l2].flags{
                        can_build=false
                    }
                }
            }
            if can_build {
                rec_are_avl:bool=true
                e_info:= get_entity_info[g_mem.placing.id]
                for cost in e_info.cost{
                    if cost.count != 0{
                        if !check_if_item_exists_resources(cost.item,cost.count) {
                            rec_are_avl = false
                        }
                    }
                }
                if rec_are_avl{
                    ent,ok :=place_building_on_grid(g_mem.placing.id,{ray.position.x,ray.position.y},g_mem.placing.rot)
                    if ok{
                        for cost in e_info.cost{
                            remove_item_from_resources(cost.item,cost.count)
                        }
                    }
                    // else if g_mem.placing.sound_cd == 0{
                        // play_sound(.eat)
                        // g_mem.placing.sound_cd=.2
                    // }
                }else if g_mem.placing.sound_cd == 0{
                    play_sound(.no_2)
                    g_mem.placing.sound_cd=.2
                }
            }else if g_mem.placing.sound_cd == 0{
                play_sound(.no_1)
                g_mem.placing.sound_cd=.4
            }
        }
            // fmt.print(ray.position,"w_pos \n")
            // fmt.print(t_pos,"t_pos \n")
            // fmt.print(t_pos_l_pos(t_pos),"l_pos \n")
            // fmt.print(t_pos_g_pos(t_pos),"g_pos \n")
        }else{
            delete_building_on_mouse()
        }
    }
}
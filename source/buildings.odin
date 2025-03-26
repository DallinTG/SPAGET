package game

import "core:fmt"
import rl "vendor:raylib"

belt_slot_count::8
building_name::enum{
    belt_t1,
    belt_over_t1,
    grabber_t1,
    splitter_t1,
    foundry_t1,
    miner_t1,
    belt_t2,
    belt_over_t2,
    grabber_t2,
    splitter_t2,
    blast_furnace,
    industrial_drill,
    core,
}
building_types::union{
    belt,
    miner,
    foundry,
    basic_log,
    core,
}
miner::struct{
    speed:i32,
    range:i32,
    t:i32,
}
core::struct{

}
belt::struct{
    is_over_belt:bool,
    slots:[belt_slot_count]item_slot,
    speed:i32,
}
basic_log::struct{
    speed:i32,
    bool_:bool,
}
foundry::struct{
    slots:[3]item_slot,
    full:i32,
    // slot_foundry:item_slot,
    // slot_cat:item_slot,
    // output:item_slot,
    t:i32,
    speed:i32,
}
building::struct{
    id:building_name,
    pos:[2]i32,
    type:building_types,
    w_h:[2]int,
    sprite:img_ani_name,
    input_slot:[]item_slot,
    output_slot:[]item_slot,
    bace_slot:[1]item_slot,
    bace_out_slot:[1]item_slot,
    place_sound:sound_names,
    sound_v_m:f32,


}

init_defalt_buildings::proc(){
    g_mem.defalt.buildings[.belt_t1] = {
        id=.belt_t1,
        w_h={1,1},
        sprite=.Belt_T1_Animation,
        type = belt{
            slots={
                {max_count=8},
                {max_count=8},
                {max_count=8},
                {max_count=8},
                {max_count=8},
                {max_count=8},
                {max_count=8},
                {max_count=8},
            },
            speed = 3,
            is_over_belt=false,
        },
        place_sound = .small_thud,
        sound_v_m = .8,
    }
    g_mem.defalt.buildings[.belt_over_t1] = {
        id=.belt_over_t1,
        w_h={1,1},
        sprite=.Belt_Over_T1_Animation,
        type = belt{
            slots={
                {max_count=8},
                {max_count=8},
                {max_count=8},
                {max_count=8},
                {max_count=8},
                {max_count=8},
                {max_count=8},
                {max_count=8},
            },
            speed = 2,
            is_over_belt=true,
        },
        place_sound = .small_thud,
        sound_v_m = .8,
    }
    g_mem.defalt.buildings[.grabber_t1] = {
        id=.grabber_t1,
        w_h={1,1},
        sprite=.Grabber,
        type = basic_log{
            speed = 8,
        },
        place_sound = .small_thud,
        sound_v_m = .8,
    }
    g_mem.defalt.buildings[.splitter_t1] = {
        id=.splitter_t1,
        w_h={1,1},
        sprite=.Splitter_T1,
        type = basic_log{
            speed = 3,
        },
        place_sound = .small_thud,
        sound_v_m = .8,
    }
    g_mem.defalt.buildings[.miner_t1] = {
        id=.miner_t1,
        sprite=.Miner_T1,
        w_h={2,2},
        bace_slot={{max_count = 4,}},
        type = miner{
            speed = 60,
            range = 0,
            t = 1,
        },
        place_sound = .s_thud,
        sound_v_m = .15,

    }
    g_mem.defalt.buildings[.foundry_t1] = {
        id=.foundry_t1,
        sprite=.Foundry_T1,
        w_h={2,2},
        bace_slot={{max_count = 4,}},
        type = foundry{
            slots={{max_count=8,required_tag={.r_in_foundry,}},{max_count=8,required_tag={.fuel,}},{max_count=8,}},
            speed = 30,
            t = 1,
        },
        place_sound = .s_thud,
        sound_v_m = .15,
    }
    g_mem.defalt.buildings[.belt_t2] = {
        id=.belt_t2,
        w_h={1,1},
        sprite=.Belt_T2_Animation,
        type = belt{
            slots={
                {max_count=16},
                {max_count=16},
                {max_count=16},
                {max_count=16},
                {max_count=16},
                {max_count=16},
                {max_count=16},
                {max_count=16},
            },
            speed = 1,
            is_over_belt=false,
        },
        place_sound = .small_thud,
        sound_v_m = .8,
    }
    g_mem.defalt.buildings[.belt_over_t2] = {
        id=.belt_over_t2,
        w_h={1,1},
        sprite=.Belt_Over_T2_Animation,
        type = belt{
            slots={
                {max_count=16},
                {max_count=16},
                {max_count=16},
                {max_count=16},
                {max_count=16},
                {max_count=16},
                {max_count=16},
                {max_count=16},
            },
            speed = 1,
            is_over_belt=true,
        },
        place_sound = .small_thud,
        sound_v_m = .8,
    }
    g_mem.defalt.buildings[.grabber_t2] = {
        id=.grabber_t2,
        w_h={1,1},
        sprite=.Grabber_2,
        type = basic_log{
            speed = 2,
        },
        place_sound = .small_thud,
        sound_v_m = .8,
    }
    g_mem.defalt.buildings[.splitter_t2] = {
        id=.splitter_t2,
        w_h={1,1},
        sprite=.Splitter_T2,
        type = basic_log{
            speed = 1,
        },
        place_sound = .small_thud,
        sound_v_m = .8,
    }
    g_mem.defalt.buildings[.blast_furnace] = {
        id=.blast_furnace,
        sprite=.Blast_Furnace,
        w_h={3,3},
        bace_slot={{max_count = 4,}},
        type = foundry{
            slots={{max_count=8,required_tag={.r_in_foundry,}},{max_count=8,required_tag={.fuel,}},{max_count=8,}},
            speed = 20,
            t = 2,
        },
        place_sound = .s_thud,
        sound_v_m = .15,
    }
    g_mem.defalt.buildings[.industrial_drill] = {
        id=.industrial_drill,
        sprite=.Industreal_Drill_Loop,
        w_h={4,4},
        bace_slot={{max_count = 64,}},
        type = miner{
            speed = 100,
            range = 1,
            t = 2,
        },
        place_sound = .s_thud,
        sound_v_m = .15,

    }
    g_mem.defalt.buildings[.core] = {
        id=.core,
        sprite=.Core,
        w_h={12,12},
        bace_slot={{max_count = 4000,required_tag={.is_resource},}},
        place_sound = .s_thud,
        type= core {},
        sound_v_m = .3,
    }
}

place_building_on_grid::proc(id:entity_names ,pos:[2]f32 ,rot:f32)->(entity_index:entity_index,placed:bool){
    entity:entity=g_mem.defalt.entities[id]
    entity.pos = pos
    entity.rot = rot
    t_pos:=world_pos_t_pos({pos.x,pos.y})
    
    invalid_pos:bool
    for x := 0; x <entity.type.(building).w_h.x ; x += 1 {
        for y := 0; y <entity.type.(building).w_h.y ; y += 1 {
            if get_entity_by_index(get_tile_building(t_pos+{x,y})^)!=nil {invalid_pos = true}
        }
    }
    if !invalid_pos{
        entity_index = create_entity(entity)
        placed=true
        for x := 0; x <entity.type.(building).w_h.x ; x += 1 {
            for y := 0; y <entity.type.(building).w_h.y ; y += 1 {
                get_tile_building(t_pos+{x,y})^ = entity_index
            }
        }
        play_sound(entity.type.(building).place_sound,.8*entity.type.(building).sound_v_m,1.3)
        play_sound(entity.type.(building).place_sound,.8*entity.type.(building).sound_v_m,.7)
        // play_sound(entity.type.(building).place_sound,.7,.2)
        return
    }
    placed=false
    return
}
can_place_building_on_grid::proc(id:entity_names ,pos:[2]f32 ,rot:f32)->(can_placed:bool){
    entity:entity=g_mem.defalt.entities[id]
    entity.pos = pos
    entity.rot = rot
    t_pos:=world_pos_t_pos({pos.x,pos.y})
    invalid_pos:bool
    for x := 0; x <entity.type.(building).w_h.x ; x += 1 {
        for y := 0; y <entity.type.(building).w_h.y ; y += 1 {
            if get_entity_by_index(get_tile_building(t_pos+{x,y})^)!=nil {
                invalid_pos = true
            }
        }
    }
    return !invalid_pos
}
draw_bilding::proc(entity:^entity){
    bild:=&entity.type.(building)
    t_pos :=world_pos_t_pos({entity.pos.x,entity.pos.y})
    draw_image(
        bild.sprite,
        {
            cast(f32)(cast(int)(t_pos.x)*tile_size+(tile_size/2*bild.w_h.x)),
            cast(f32)(cast(int)(t_pos.y)*tile_size+(tile_size/2*bild.w_h.y)),
            tile_size * cast(f32)bild.w_h.x,
            tile_size * cast(f32)bild.w_h.y,
        },
        0,
        {tile_size/2*cast(f32)bild.w_h.x,tile_size/2*cast(f32)bild.w_h.y},
        entity.rot,
    )
}
draw_belt::proc(entity:^entity){
    draw_bilding(entity)
    t_pos :=world_pos_t_pos({entity.pos.x,entity.pos.y})
    slot_c:=len(entity.type.(building).type.(belt).slots)
    for slot,i in entity.type.(building).type.(belt).slots{
        if slot.count != 0{
            draw_image(
                defalt_items[slot.item].icon,
                {
                    cast(f32)(cast(int)(t_pos.x)*tile_size+(tile_size/2)),
                    cast(f32)(cast(int)(t_pos.y)*tile_size+(tile_size/2)),
                    tile_size/4,
                    tile_size/4,
                },
                -1,
                {tile_size/8,tile_size/8+(tile_size/cast(f32)slot_c*cast(f32)i)-(tile_size/4)-(tile_size/8)},
                entity.rot,
                tint=defalt_items[slot.item].tint
            )
        }
    }
}
draw_building_outline::proc(pos:[2]f32,rot:f32,building_:entity_names,color:rl.Color){
    if !g_mem.placing.in_ui{
        switch bild in g_mem.defalt.entities[g_mem.placing.id].type {
            case building :
            t_pos :=world_pos_t_pos({pos.x,pos.y})
            draw_image(
                bild.sprite,
                {
                    cast(f32)(cast(int)(t_pos.x)*tile_size+(tile_size/2*bild.w_h.x)),
                    cast(f32)(cast(int)(t_pos.y)*tile_size+(tile_size/2*bild.w_h.y)),
                    tile_size * cast(f32)bild.w_h.x,
                    tile_size * cast(f32)bild.w_h.y,
                },
                0,
                {tile_size/2*cast(f32)bild.w_h.x,tile_size/2*cast(f32)bild.w_h.y},
                rot,
                tint = color,
            )
        }
    }
}
draw_building_preview::proc(){
    if !g_mem.placing.in_ui{

        ray:=rl.GetScreenToWorldRay(rl.GetMousePosition(),g_mem.cam)

        draw_building_outline({ray.position.x,ray.position.y},g_mem.placing.rot,g_mem.placing.id,{255,255,255,150})

        t_pos:=world_pos_t_pos({ray.position.x,ray.position.y})
        // building:=&g_mem.defalt.entities[g_mem.placing.id].type.(building)
        switch building_ in g_mem.defalt.entities[g_mem.placing.id].type {
            case building :
            can_build:bool=true
            for x := cast(i32)t_pos.x; x <cast(i32)t_pos.x+cast(i32)building_.w_h.x; x += 1 {
                for y := cast(i32)t_pos.y; y <cast(i32)t_pos.y+cast(i32)building_.w_h.x; y += 1 {
                    t_l1:=get_tile_l1({cast(int)x,cast(int)y})
                    t_l2:=get_tile_l2({cast(int)x,cast(int)y})
                    t_color:rl.Color={0,255,0,25}
                    if .can_not_build_on in defalt_tile_sets[t_l1].flags {
                        can_build=false
                        t_color={255,0,0,25}
                    }
                    if .can_not_build_on in defalt_tile_sets[t_l2].flags{
                        can_build=false
                        t_color={255,0,0,25}
                    }
                    draw_image(
                        .Tile,
                        {
                            cast(f32)(cast(int)(x)*tile_size+(tile_size/2*building_.w_h.x)),
                            cast(f32)(cast(int)(y)*tile_size+(tile_size/2*building_.w_h.y)),
                            tile_size ,
                            tile_size ,
                        },
                        0,
                        {tile_size/2*cast(f32)building_.w_h.x,tile_size/2*cast(f32)building_.w_h.y},
                        0,
                        tint = t_color,
                    )
                }
            }
        }
    }
}
init_belts::proc(entity:^entity){
    building:=&entity.type.(building)
    belt:=&building.type.(belt)
    building.input_slot = belt.slots[0:1]
    building.output_slot = belt.slots[len(belt.slots)-1:len(belt.slots)]
}
init_miner::proc(entity:^entity){
    building:=&entity.type.(building)
    // building.input_slot = &building.bace_slot
    building.output_slot = building.bace_slot[:]
}
init_core::proc(entity:^entity){
    building:=&entity.type.(building)
    building.input_slot = building.bace_slot[:]
    building.output_slot = building.bace_slot[:]
}
inti_foundry::proc(entity:^entity){
    building:=&entity.type.(building)
    foundry:=&building.type.(foundry)
    building.input_slot = foundry.slots[0:2]
    building.output_slot = foundry.slots[2:3]
}
init_bace::proc(entity:^entity){
    building:=&entity.type.(building)
    building.input_slot = building.bace_slot[:]
    building.output_slot = building.bace_slot[:]
}
splitter_logic::proc(entity:^entity){
    if entity.last_frame_updated_on != g_mem.time.frame_count_60h{
        if g_mem.time.is_60h_this_frame == true{
            build := &entity.type.(building)
            log:=&build.type.(basic_log)
            n_entity:^entity_index
            log.bool_ = !log.bool_
            if log.bool_{
                n_entity=get_building_in_front(entity,-90)
            }else{
                n_entity=get_building_in_front(entity,90)
            }
            new_entity:=get_entity_by_index(n_entity^)

            if  new_entity!= nil{
                push_item_no_stacking(entity,new_entity)
            }
        }
    }
}
grabber_logic::proc(entity:^entity){
    if entity.last_frame_updated_on != g_mem.time.frame_count_60h{
        if g_mem.time.is_60h_this_frame == true{
            building:=&entity.type.(building)
            grabber:=&building.type.(basic_log)
            if g_mem.time.frame_count_60h%grabber.speed == 0{
                building_2:=get_building_in_front(entity)
                front_entity:=get_entity_by_index(building_2^)

                building_3:=get_building_in_front(entity,180)
                back_entity:=get_entity_by_index(building_3^)
                if back_entity!= nil{
                    push_item_no_stacking(back_entity,entity)
                }
                if front_entity!= nil{
                    push_item_no_stacking(entity,front_entity)
                }
            }
        }
    }
}
core_logic::proc(entity:^entity){
    building:=&entity.type.(building)
    slot:=&building.bace_slot
    sus:=add_item_to_resources(slot[0].item,slot[0].count)
    
    slot[0].count=0
    slot[0].item=.None
    
    
}
belt_logic::proc(entity:^entity){
    if entity.last_frame_updated_on != g_mem.time.frame_count_60h{
        if g_mem.time.is_60h_this_frame == true{
            building_1:=&entity.type.(building)
            #partial switch &belt_1 in &building_1.type{
                case belt:
                    slot_c:=len(belt_1.slots)
                    slot:=&belt_1.slots
                    if g_mem.time.frame_count_60h%belt_1.speed == 0{
                        entity.last_frame_updated_on = g_mem.time.frame_count_60h
                        building_2:=get_building_in_front(entity)
                        end_entity:=get_entity_by_index(building_2^)
                        if end_entity!= nil{
                            if slot[slot_c-1].count != 0{
                                switch type_b in end_entity.type {
                                    case building:
                                        #partial switch type_t in type_b.type{
                                            case belt: 
                                            if type_t.is_over_belt{
                                                if entity.rot !=end_entity.rot{
                                                    building_2=get_building_in_front(entity,0,2)
                                                    end_entity=get_entity_by_index(building_2^)
                                                }
                                            }
                                        }
                                }
                                if end_entity!= nil{
                                    
                                    belt_logic(end_entity)
                                    push_item_no_stacking(entity,end_entity)
                                }
                            }
                        }
                        move_item_within_belt(slot)
                    }
            }
        }
    }
}
foundry_logic::proc(entity:^entity){
    
    if entity.last_frame_updated_on != g_mem.time.frame_count_60h{
        if g_mem.time.is_60h_this_frame == true{
            building:=&entity.type.(building)
            foundry:=&building.type.(foundry)
            // if building.input_slot.item == .ore_coal{
            //     push_item_slots(building.input_slot,&foundry.slot_cat)
            // }
            // push_item_slots(building.input_slot,&foundry.slot_foundry)
            if g_mem.time.frame_count_60h%foundry.speed == 0{
                for res in get_recipe{
                    if res.r_tag <= defalt_items[foundry.slots[0].item].tags{
                        if res.t <= foundry.t{
                            if building.output_slot[0].count<=0{
                                if foundry.full>0{
                                    foundry.full -=1
                                }else if foundry.slots[1].count>0{
                                    foundry.slots[1].count -=1
                                    foundry.full = 3
                                }
                                if foundry.full>0{
                                    foundry.slots[0].count -=1
                                    if foundry.slots[0].count <= 0 {foundry.slots[0].item=.None}
                                    add_item_stack_output_slot(entity,res.output,1)
                                }
                            }
                        }
                    }
                }
            }
            building_2:=get_building_in_front(entity)
            end_entity:=get_entity_by_index(building_2^)
            if end_entity!= nil{
                push_item_no_stacking(entity,end_entity)
            }
        }
    }
}

miner_logic::proc(entity:^entity){

    if entity.last_frame_updated_on != g_mem.time.frame_count_60h{
        if g_mem.time.is_60h_this_frame == true{
            t_pos:=world_pos_t_pos(entity.pos)
            building:=&entity.type.(building)
            miner:=&building.type.(miner)
            if g_mem.time.frame_count_60h%miner.speed == 0{
                for x := cast(i32)t_pos.x-miner.range; x <cast(i32)t_pos.x+cast(i32)building.w_h.x+miner.range; x += 1 {
                    for y := cast(i32)t_pos.y-miner.range; y <cast(i32)t_pos.y+cast(i32)building.w_h.x+miner.range; y += 1 {
                        t_l1:=get_tile_l1({cast(int)x,cast(int)y})
                        t_l2:=get_tile_l2({cast(int)x,cast(int)y})
                        if defalt_tile_sets[t_l1].mineable_item != .None && defalt_tile_sets[t_l1].t_required_to_mine <= miner.t{
                            add_item_stack_output_slot(entity,defalt_tile_sets[t_l1].mineable_item,1)
                        }
                        if defalt_tile_sets[t_l2].mineable_item != .None && defalt_tile_sets[t_l2].t_required_to_mine <= miner.t{
                            add_item_stack_output_slot(entity,defalt_tile_sets[t_l2].mineable_item,1)
                        }
                    }
                }
            }
            building_2:=get_building_in_front(entity)
            end_entity:=get_entity_by_index(building_2^)
            if end_entity!= nil{
                push_item_no_stacking(entity,end_entity)
            }
        }
    }
}


move_item_within_belt::proc(slots:^[belt_slot_count]item_slot){
    slot_c:=len(slots)
    for i := slot_c-1; i >-1 ; i -= 1 {
        if slots[i].count == 0{
            for i2 := i; i2 >0 ; i2 -= 1 {
                slots[i2]=slots[i2-1]
            }
            slots[0].count=0
            break
        }
    }
}

delete_building_at_t_pos::proc(t_pos:[2]int){
    ent:=get_entity_by_index(get_tile_building(t_pos)^)
    if ent!=nil{
        for res in get_entity_info[ent.name].cost {
            add_item_to_resources(res.item,res.count)
        }
        delete_entity(ent.entity_index)
        play_sound(.s_pop,.3,.8)
        play_sound(.s_pop,.2,.7)
        play_sound(.s_pop,.1,1.2)
    }
}
delete_building_on_mouse::proc(){
    ray:=rl.GetScreenToWorldRay(rl.GetMousePosition(),g_mem.cam)
    t_pos:=world_pos_t_pos({ray.position.x,ray.position.y})
    delete_building_at_t_pos(t_pos)

}


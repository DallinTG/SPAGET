#+feature dynamic-literals
package game
// import ecs "odin-ecs-main"
import "core:fmt"
max_entities::8000
defalt::struct{
    items:[item_names]item,
    entities:[entity_names]entity,
    buildings:[building_name]building,
}
placing::struct{
    rot:f32,
    id:entity_names,
    in_ui:bool,
    sound_cd:f32,
}

pos::struct{
    pos:[3]f32,
}
sprite::struct{
    image_id:img_ani_name,
    offset:[3]f32,
    origin:[2]f32,
    w_h:[2]f32,
}
entity_flags::enum{

}
entity_index::struct{
    id:u32,
    gen:u32,
}
entity_bucket::struct{
    entities:[max_entities]entity,
    next_open_slot:u32,
    last_entity:u32,
    count:u32,
}
entity_names::enum{
    bace,
    belt_t1,
    belt_over_t1,
    splitter_t1,
    grabber_t1,
    miner_t1,
    foundry_t1,
    belt_t2,
    belt_over_t2,
    splitter_t2,
    grabber_t2,
    industrial_drill,
    blast_furnace,
    core,
}
entity::struct{
    last_frame_updated_on:i32,
    entity_index:entity_index,
    is_occupied:bool,
    name:entity_names,
    pos:[2]f32,
    rot:f32,
    callback_insert:proc(^entity),
    callback_replace:proc(^entity),
    callback_render:proc(^entity),
    logic:proc(^entity),
    init:proc(^entity),
    flags:bit_set[entity_flags],
    type:entity_types,
}
entity_types::union{
    building,
}
entity_info::struct{
    id:entity_names,
    icon:img_ani_name,
    cost:[3]item_slot,
    name:string,
    description:string,
    cant_place:bool,
}
get_entity_info:[entity_names]entity_info={
    .bace={id = .bace,cant_place=true,},

    .belt_t1={
        id = .belt_t1,
        icon=.Belt_T1_Animation,
        name = "Belt T1",
        description="Gets stuff from \nplace to place",
        cost={{item=.copper_ingot,count=10},{},{}},
    },
    .belt_over_t1={
        id = .belt_t1,
        icon=.Belt_Over_T1_Animation,
        name = "Belt Over T1",
        description="Gets stuff over stuff ",
        cost={{item=.copper_ingot,count=10},{item=.iron_ingot,count=10},{}},
    },
    .grabber_t1={
        id = .grabber_t1,
        icon=.Grabber,
        name = "Grabber T1",
        description="Gets stuff from place to place \nby grabbing",
        cost={{item=.copper_ingot,count=10},{item=.iron_ingot,count=10},{}},
    },
    .splitter_t1={
        id = .splitter_t1,
        icon=.Splitter_T1,
        name = "Splitter T1",
        description="splits a belt",
        cost={{item=.copper_ingot,count=20},{item=.iron_ingot,count=20},{}},
    },
    .miner_t1={
        id = .miner_t1,
        icon=.Miner_T1,
        name = "Miner T1",
        description="DIG DIG DIG",
        cost={{item=.copper_ingot,count=50},{item=.iron_ingot,count=50},{}},
    },
    .foundry_t1={
        id = .foundry_t1,
        icon=.Foundry_T1,
        name = "Foundry T1",
        description="smelt ore to ingots \nRequires Fuel",
        cost={{item=.copper_ingot,count=25},{item=.iron_ingot,count=50},{}},
    },
    .belt_t2={
        id = .belt_t2,
        icon=.Belt_T2_Animation,
        name = "Belt T2",
        description="Gets stuff from \nplace to place",
        cost={{item=.steel_ingot,count=20},{item=.glass,count=20},{item=.copper_ingot,count=10}},
    },
    .belt_over_t2={
        id = .belt_over_t2,
        icon=.Belt_Over_T2_Animation,
        name = "Belt Over T2",
        description="Gets stuff over stuff ",
        cost={{item=.steel_ingot,count=30},{item=.glass,count=30},{item=.copper_ingot,count=10}},
    },
    .grabber_t2={
        id = .grabber_t2,
        icon=.Grabber_2,
        name = "Grabber T2",
        description="Gets stuff from place to place \nby grabbing",
        cost={{item=.steel_ingot,count=30},{item=.glass,count=30},{item=.copper_ingot,count=10}},
    },
    .splitter_t2={
        id = .splitter_t2,
        icon=.Splitter_T2,
        name = "Splitter T2",
        description="splits a belt",
        cost={{item=.steel_ingot,count=30},{item=.glass,count=30},{item=.copper_ingot,count=10}},
    },
    .blast_furnace={
        id = .blast_furnace,
        icon=.Blast_Furnace,
        name = "Blast Furnace",
        description="smelt ore to ingots\nand Iron To Steel Requires Fuel",
        cost={{item=.copper_ingot,count=100},{item=.iron_ingot,count=200},{item=.stone_ingot,count=500}},
    },
    .industrial_drill={
        id = .industrial_drill,
        icon=.Industreal_Drill_Loop,
        name = "Industrial \nDrill",
        description="DIG DIG DIG But 4X4 and 1 extra range",
        cost={{item=.steel_ingot,count=1000},{item=.glass,count=500},{item=.copper_ingot,count=200}},
    },
    .core={
        id = .core,
        icon=.Core,
        name = "Core",
        description="The Center Of Your Base \nAll Input Resources Are Accessiblel For Building",
        cost={{item=.core_frag,count=100},{},{}}
    },
}


init_defalt_items::proc(){
    g_mem.defalt.items[.ore_copper] = {
        id = .ore_copper,
        icon = .Round_Cat,
    }
}


init_defalt_entities::proc(){
    g_mem.defalt.entities[.bace] = {

    }
    g_mem.defalt.entities[.belt_t1] = {
        name=.belt_t1,
        callback_insert = {},
        callback_replace = {},
        callback_render = draw_belt,
        flags = {},
        type = g_mem.defalt.buildings[.belt_t1],
        logic = belt_logic,
        init = init_belts,
    }
    g_mem.defalt.entities[.belt_over_t1] = {
        name=.belt_t1,
        callback_insert = {},
        callback_replace = {},
        callback_render = draw_belt,
        flags = {},
        type = g_mem.defalt.buildings[.belt_over_t1],
        logic = belt_logic,
        init = init_belts,
    }
    g_mem.defalt.entities[.grabber_t1] = {
        name=.grabber_t1,
        callback_insert = {},
        callback_replace = {},
        callback_render = draw_bilding,
        flags = {},
        type = g_mem.defalt.buildings[.grabber_t1],
        logic = grabber_logic,
        init = init_bace,
    }
    g_mem.defalt.entities[.splitter_t1] = {
        name=.splitter_t1,
        callback_insert = {},
        callback_replace = {},
        callback_render = draw_bilding,
        flags = {},
        type = g_mem.defalt.buildings[.splitter_t1],
        logic = splitter_logic,
        init = init_bace,
    }
    g_mem.defalt.entities[.miner_t1] = {
        name=.miner_t1,
        callback_insert = {},
        callback_replace = {},
        callback_render = draw_bilding,
        flags = {},
        type = g_mem.defalt.buildings[.miner_t1],
        logic = miner_logic,
        init = init_miner,
    }
    g_mem.defalt.entities[.foundry_t1] = {
        name=.foundry_t1,
        callback_insert = {},
        callback_replace = {},
        callback_render = draw_bilding,
        flags = {},
        type = g_mem.defalt.buildings[.foundry_t1],
        logic = foundry_logic,
        init = inti_foundry,
    }
    g_mem.defalt.entities[.belt_t2] = {
        name=.belt_t2,
        callback_insert = {},
        callback_replace = {},
        callback_render = draw_belt,
        flags = {},
        type = g_mem.defalt.buildings[.belt_t2],
        logic = belt_logic,
        init = init_belts,
    }
    g_mem.defalt.entities[.belt_over_t2] = {
        name=.belt_t2,
        callback_insert = {},
        callback_replace = {},
        callback_render = draw_belt,
        flags = {},
        type = g_mem.defalt.buildings[.belt_over_t2],
        logic = belt_logic,
        init = init_belts,
    }
    g_mem.defalt.entities[.grabber_t2] = {
        name=.grabber_t2,
        callback_insert = {},
        callback_replace = {},
        callback_render = draw_bilding,
        flags = {},
        type = g_mem.defalt.buildings[.grabber_t2],
        logic = grabber_logic,
        init = init_bace,
    }
    g_mem.defalt.entities[.splitter_t2] = {
        name=.splitter_t2,
        callback_insert = {},
        callback_replace = {},
        callback_render = draw_bilding,
        flags = {},
        type = g_mem.defalt.buildings[.splitter_t2],
        logic = splitter_logic,
        init = init_bace,
    }
    g_mem.defalt.entities[.industrial_drill] = {
        name=.industrial_drill,
        callback_insert = {},
        callback_replace = {},
        callback_render = draw_bilding,
        flags = {},
        type = g_mem.defalt.buildings[.industrial_drill],
        logic = miner_logic,
        init = init_miner,
    }
    g_mem.defalt.entities[.blast_furnace] = {
        name=.blast_furnace,
        callback_insert = {},
        callback_replace = {},
        callback_render = draw_bilding,
        flags = {},
        type = g_mem.defalt.buildings[.blast_furnace],
        logic = foundry_logic,
        init = inti_foundry,
    }
    g_mem.defalt.entities[.core] = {
        name=.core,
        callback_insert = {},
        callback_replace = {},
        callback_render = draw_bilding,
        flags = {},
        type = g_mem.defalt.buildings[.core],
        logic = core_logic,
        init = init_core,
        
    }

}


create_entity_by_id::proc(id:entity_names)->(entity_index:entity_index){
    return create_entity(g_mem.defalt.entities[id])
}
create_entity::proc(entity:entity)->(entity_id:entity_index){
    bucket :=&g_mem.state.entity_bucket
    next_slot:=&bucket.entities[bucket.next_open_slot]
    ent:=&bucket.entities
    if !next_slot.is_occupied{

        bucket.count +=1
        temp_gen:=next_slot.entity_index.gen
        next_slot^ = entity
        next_slot.is_occupied = true
        next_slot.entity_index.gen = temp_gen+1
        entity_id = {id = bucket.next_open_slot,gen = next_slot.entity_index.gen}
        next_slot.entity_index = entity_id
        if entity.init !=nil {
            entity.init(next_slot)
        }

        if bucket.next_open_slot != max_entities-1{
            bucket.next_open_slot += 1
            for bucket.entities[bucket.next_open_slot].is_occupied{
                if bucket.next_open_slot != max_entities-1{
                    bucket.next_open_slot += 1
                }else { break }
            }
        }

        if bucket.last_entity != max_entities-1 {
            for bucket.entities[bucket.last_entity].is_occupied{
                if bucket.last_entity != max_entities-1{
                    bucket.last_entity += 1
                }else{break}
            }
        }

        return entity_id
    }
    entity_id = {0,0}
    return entity_id
}

delete_entity::proc(entity_id:entity_index){
    bucket :=&g_mem.state.entity_bucket
    if bucket.entities[entity_id.id].entity_index.gen == entity_id.gen && bucket.entities[entity_id.id].is_occupied{

        bucket.count -=1
        bucket.entities[entity_id.id].is_occupied=false
        bucket.entities[bucket.next_open_slot].entity_index.gen += 1
        // if b2.Body_IsValid(bucket.entities[entity_id.id].entity.body_id){
        //     b2.DestroyBody(bucket.entities[entity_id.id].entity.body_id)
        // }
        
        if entity_id.id < bucket.next_open_slot{
            bucket.next_open_slot = entity_id.id 
        }
        if entity_id.id == bucket.last_entity {
            if bucket.last_entity != 0 {
                bucket.last_entity -= 1
                for !bucket.entities[bucket.last_entity].is_occupied{
                    bucket.last_entity -= 1
                }
            }
        }
    }
}

dos_entity_exist::proc(entity_id:entity_index)->bool{
    
    bucket :=&g_mem.state.entity_bucket
    if bucket.entities[entity_id.id].entity_index.gen == entity_id.gen&& bucket.entities[entity_id.id].is_occupied{
        return true
    }
    return false
}

get_entity_by_index::proc(entity_id:entity_index) -> (entity:^entity){
    bucket :=&g_mem.state.entity_bucket
    if dos_entity_exist(entity_id) {
        entity = &bucket.entities[entity_id.id]
        return
    }
    entity = nil
    return
}

do_entities::proc(){
    entities :=&g_mem.state.entity_bucket.entities
    if g_mem.state.entity_bucket.count > 0 {
        for &entity,i in entities[:g_mem.state.entity_bucket.last_entity+1]{
            if entity.is_occupied {
                if entity.callback_replace!=nil{
                    entity.callback_replace(&entity)
                }else {
                    if entity.callback_insert!=nil{
                        entity.callback_insert(&entity)
                    }
                    if entity.logic!=nil{
                        entity.logic(&entity)
                    }
                }
            }
        }
    }
}
draw_entities::proc(){
    entities :=&g_mem.state.entity_bucket.entities
    if g_mem.state.entity_bucket.count > 0 {
        for &entity,i in entities[:g_mem.state.entity_bucket.last_entity+1]{
            if entity.is_occupied {
                if entity.callback_render!=nil{
                    entity.callback_render(&entity)
                }
            }
        }
    }
}

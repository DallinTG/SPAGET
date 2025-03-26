package game

import rl"vendor:raylib"
import "core:fmt"

item_names::enum{
    None,
    sand,
    ore_copper,
    ore_iron,
    ore_stone,
    ore_coal,
    copper_ingot,
    iron_ingot,
    stone_ingot,
    steel_ingot,
    glass,
    core_frag,
}
item_tags::enum{
    is_resource,
    ore,
    ingot,
    copper,
    iron,
    stone,
    steel,
    sand,
    coal,
    fuel,
    r_in_foundry,
    glass,
}

item::struct{
    id:item_names,
    icon:img_ani_name,
    tint:rl.Color,
    tags:bit_set[item_tags],
}
item_slot::struct{
    item:item_names,
    count:i32,
    max_count:i32,
    required_tag:bit_set[item_tags],
}
defalt_items:[item_names]item={
    .None = {
        id=.None,
        icon=Texture_Name.None,
        tint={0,0,0,0},
    },
    .sand={
        id=.sand,
        icon=.Gray_Sand_Ball,
        tint={255, 255, 255,255},
        tags={.sand,.r_in_foundry},
    },
    .ore_copper = {
        id=.ore_copper,
        icon=.Ore_Chunk_Bace,
        tint={232, 130, 14,255},
        tags={.ore,.copper,.r_in_foundry},
    },
    .ore_iron = {
        id=.ore_iron,
        icon=.Ore_Chunk_Bace,
        tint={255, 255, 255,255},
        tags={.ore,.iron,.r_in_foundry},
    },
    .ore_stone = {
        id=.ore_stone,
        icon=.Ore_Chunk_Bace,
        tint={161, 136, 96,255},
        tags={.ore,.stone,.r_in_foundry},
    },
    .ore_coal = {
        id=.ore_coal,
        icon=.Ore_Chunk_Bace,
        tint={20, 4, 0,255},
        tags={.ore,.coal,.fuel},
    },
    .copper_ingot = {
        id=.iron_ingot,
        icon=.Bace_Ingot,
        tint={232, 130, 14,255},
        tags={.is_resource,.ingot,.copper,}
    },
    .iron_ingot = {
        id=.iron_ingot,
        icon=.Bace_Ingot,
        tint={255, 255, 255,255},
        tags={.is_resource,.ingot,.iron,.r_in_foundry}
    },
    .stone_ingot = {
        id=.stone_ingot,
        icon=.Bace_Ingot,
        tint={161, 136, 96,255},
        tags={.is_resource,.ingot,.stone,}
    },
    .steel_ingot = {
        id=.steel_ingot,
        icon=.Bace_Ingot,
        tint={136, 136, 136,255},
        tags={.is_resource,.ingot,.steel}
    },
    .glass = {
        id=.glass,
        icon=.Glass,
        tint={255, 255, 255,255},
        tags={.is_resource,}
    },
    .core_frag={
        id=.core_frag,
        icon=.Core_Frag,
        tint={255, 255, 255,255},
        tags={.is_resource,}
    }
}
recipe_ids::enum{
    copper_ore_to_ingot,
    iron_ore_to_ingot,
    stone_ore_to_ingot,
    iron_ingot_to_steel_ingot,
    sand_to_glass,
}
recipe_type::enum{
    foundry,
}
recipe::struct{
    t:i32,
    type:recipe_type,
    r_tag:bit_set[item_tags],
    output:item_names,
}
get_recipe:[recipe_ids]recipe={
    .copper_ore_to_ingot = {
        t=1,
        type=.foundry,
        r_tag={.copper,.ore,},
        output=.copper_ingot,
    },
    .iron_ore_to_ingot = {
        t=1,
        type=.foundry,
        r_tag={.iron,.ore,},
        output=.iron_ingot,
    },
    .iron_ingot_to_steel_ingot = {
        t=2,
        type=.foundry,
        r_tag={.iron,.ingot,},
        output=.steel_ingot,
    },
    .stone_ore_to_ingot = {
        t=1,
        type=.foundry,
        r_tag={.stone,.ore,},
        output=.stone_ingot,
    },
    .sand_to_glass = {
        t=2,
        type=.foundry,
        r_tag={.sand,},
        output=.glass,
    },
}

push_item_no_stacking::proc(start_entity:^entity,end_entity:^entity){
    output_slots:=start_entity.type.(building).output_slot
    input_slots:=end_entity.type.(building).input_slot
    if output_slots != nil{
        if input_slots != nil{
            for &output_slot in &output_slots{
                for &input_slot in &input_slots{
                    if input_slot.count == 0{
                        if output_slot.count !=0{
                            if input_slot.required_tag <= defalt_items[output_slot.item].tags{
                                input_slot.item = output_slot.item
                                input_slot.count = 1
                                output_slot.count -= 1
                                #partial switch type in end_entity.type.(building).type {
                                    case core:
                                        end_entity.logic(end_entity)
                                }
                            }
                        }
                    }
                }   
            }
        }
    }
}

push_item_stacking::proc(start_entity:^entity,end_entity:^entity){
    output_slots:=start_entity.type.(building).output_slot
    input_slots:=end_entity.type.(building).input_slot
    if output_slots != nil{
        if input_slots != nil{
            for &output_slot in &output_slots{
                for &input_slot in &input_slots{
                    if input_slot.count == 0{
                        if output_slot.item == input_slot.item{
                            if input_slot.required_tag <= defalt_items[output_slot.item].tags{
                                input_slot.count += 1
                                output_slot.count -= 1
                                #partial switch type in end_entity.type.(building).type {
                                    case core:
                                        end_entity.logic(end_entity)
                                }
                            }
                        }else if output_slot.count !=0{
                            if input_slot.required_tag <= defalt_items[output_slot.item].tags{
                                input_slot.item = output_slot.item
                                input_slot.count = 1
                                output_slot.count -= 1
                                #partial switch type in end_entity.type.(building).type {
                                    case core:
                                        end_entity.logic(end_entity)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
push_item_slots::proc(output_slot:^item_slot,input_slot:^item_slot){
    if output_slot != nil{
        if input_slot != nil{
            if input_slot.count == 0{
                if output_slot.item == input_slot.item&& output_slot.item!=.None{
                    if input_slot.required_tag <= defalt_items[output_slot.item].tags{
                        input_slot.count += 1
                        output_slot.count -= 1
                    }
                }else if output_slot.count !=0{
                    if input_slot.required_tag <= defalt_items[output_slot.item].tags{
                        input_slot.item = output_slot.item
                        input_slot.count = 1
                        output_slot.count -= 1
                    }
                }
            }
        }
    }
}
add_item_no_stack::proc(entity:^entity,item:item_names){

}
add_item_stack_input_slot::proc(entity:^entity,item:item_names,count:i32){
    input_slots:=entity.type.(building).input_slot
    if input_slots != nil{
        for &input_slot in &input_slots{    
            if item == input_slot.item{
                input_slot.count += count
            }else if input_slot.count == 0{
                input_slot.item = item
                input_slot.count = count
            }
            if input_slot.count > input_slot.max_count{
                input_slot.count = input_slot.max_count
            }
        }
    }
}
add_item_stack_output_slot::proc(entity:^entity,item:item_names,count:i32){
    output_slots:=entity.type.(building).output_slot
    if output_slots != nil{
        for &output_slot in &output_slots{
            if item == output_slot.item{
                output_slot.count += count
                // fmt.print("1")
            }else if output_slot.count == 0{
                output_slot.item = item
                output_slot.count = count
                // fmt.print("2")
            }
            // if output_slot.count > output_slot.max_count{
            //     output_slot.count = output_slot.max_count
            //     // fmt.print("3")
            // }
            // fmt.print("4")
        }
    }
}
init_resources::proc(){
    res:=&g_mem.state.resources
    for item_name in item_names{
        item:=defalt_items[item_name]
        item_slot:item_slot
        item_slot.item = item_name
        if  .is_resource in item.tags{
            append(res, item_slot)
        }
    }
}
update_resources::proc(){
    resources:=&g_mem.state.resources
    for res in resources{
        ui_e_icon:=&g_mem.ui_context.ui_elements[fmt.tprint(res.item)]
        ui_e_text:=&g_mem.ui_context.ui_elements[fmt.tprint("text",res.item)]
        ui_e_text.style.text_box_data.raw_text = fmt.tprint(res.count)
        ui_e_text.hover_style.text_box_data.raw_text = fmt.tprint(res.count)
        if res.count <1{
            ui_e_icon.is_disabled = true
            // fmt.print(res.item,"\n")
        }else{
            ui_e_icon.is_disabled = false
            // calc_text_box_data(&ui_e_text.style.text_box_data)
            // calc_text_box_data(&ui_e_text.hover_style.text_box_data)
        }
    }
}
add_item_to_resources::proc(item:item_names,count:i32)->(sus:bool){
    resources:=&g_mem.state.resources
    for &res in resources{
        if res.item == item{
            res.count += count
            return true
        }
    }
    return false
}
remove_item_from_resources::proc(item:item_names,count:i32)->(sus:bool){
    resources:=&g_mem.state.resources
    for &res in resources{
        if res.item == item{
            if res.count>=count{
                res.count-=count
                return true
            }
        }
    }
    return false
}
check_if_item_exists_resources::proc(item:item_names,count:i32)->(sus:bool){
    resources:=&g_mem.state.resources
    for &res in resources{
        if res.item == item{
            if res.count>=count{
                return true
            }
        }
    }
    return false
}
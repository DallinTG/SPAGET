package game
import "core:fmt"
// import "core:strings"
// import stc"core:strconv"
import rl "vendor:raylib"
init_ui_elements::proc(){
    
    c_context := get_current_context()
    c_context.base_container.type = .l_r
    c_context.base_container.max_e_in_column_row = 4
    // c_context.base_container.width = cast(f32)rl.GetScreenWidth()
    // c_context.base_container.hight = cast(f32)rl.GetScreenHeight()
    c_context.base_container.padding = 60
    defalt_e: ui_element

    defalt_e.img = Texture_Name.None
    defalt_e.style.border_thickness = 5
    defalt_e.style.border_color = {39, 42, 46,255}
    defalt_e.style.background_color = {127, 141, 163,200}
    defalt_e.hover_style.border_thickness = 5
    defalt_e.hover_style.border_color = {39, 42, 46,255}
    defalt_e.hover_style.background_color = {147, 160, 181,225}
    defalt_e.pos_flag = .flex
    defalt_e.is_disabled = true

    el_inventory : ui_element
    el_inventory.container={
        max_e_in_column_row = 6,
        padding = 15,
        type = .l_r,
    }
	el_inventory.img = Texture_Name.None
    el_inventory.style.border_thickness = 5
    el_inventory.style.border_color = {39, 42, 46,255}
    el_inventory.style.background_color = {127, 141, 163,200}
    el_inventory.hover_style.border_thickness = 5
    el_inventory.hover_style.border_color = {39, 42, 46,255}
    el_inventory.hover_style.background_color = {147, 160, 181,225}
    el_inventory.pos_flag = .flex
    el_inventory.callbacks.tick = cb_togl_inventory
    el_inventory.is_disabled = true
    append_ui_e_to_parent("inventory",&el_inventory)
    el_inventory.pos_flag = .top_right
    el_inventory.callbacks.tick = cb_togl_inventory_resources
    append_ui_e_to_parent("inventory_resources",&el_inventory)
    el_i_slot : ui_element = defalt_e
    el_i_slot.is_disabled = false
    el_i_slot.container={
        max_e_in_column_row = 4,
        // padding = 30,
        type = .l_r,
    }
    el_i_slot.img = Texture_Name.None
    el_i_slot.style.border_thickness = 0
    el_i_slot.style.border_color = {39, 42, 46,255}
    el_i_slot.style.background_color = {127, 141, 163,0}
    el_i_slot.hover_style.border_thickness = 0
    el_i_slot.hover_style.border_color = {39, 42, 46,255}
    el_i_slot.hover_style.background_color = {39, 42, 46,225}
    el_i_slot.is_disabled = false
    el_i_slot.callbacks.tick = nil
    el_i_slot.style.hight = .1666666666
    el_i_slot.style.width = .1666666666
    el_i_slot.style.padding = 0
    el_i_slot.hover_style.padding = 0
    el_i_slot.pos_flag=.flex_fill
    el_i_slot.size_w_flag =.container_multiplier_w
    el_i_slot.size_h_flag =.container_multiplier_w
    

    el_i_img_slot : ui_element = el_i_slot
    el_i_img_slot.callbacks.start_hovering=huv_slot
    el_i_img_slot.pos_flag=.center
    el_i_img_slot.size_w_flag=.container_multiplier_w
    el_i_img_slot.size_h_flag=.container_multiplier_h
    el_i_img_slot.hover_style.width=1
    el_i_img_slot.hover_style.hight=1
    el_i_img_slot.hover_style.padding = 0
    el_i_img_slot.hover_style.background_color = {255,255,255,255}
    el_i_img_slot.style.width=1
    el_i_img_slot.style.hight=1
    el_i_img_slot.style.padding = 4
    el_i_img_slot.style.background_color = {255,255,255,255}
    el_i_img_slot.callbacks.hovering=cb_button_change_building
    slot_count:int
    for ent in entity_names{
        if !get_entity_info[ent].cant_place{
            el_i_img_slot.img = get_entity_info[ent].icon
            el_i_img_slot.ent=ent
            slot_count+=1
            info:="i_slot_"
            info_2:="i_slot_img_"
            str:=fmt.tprint(slot_count)
            // arr:[2]string={info,str}
            // arr_2:[2]string={info_2,str}
            // i_slot_:=strings.concatenate(arr[:])
            // i_slot_img_:=strings.concatenate(arr_2[:])
            // append_ui_e_to_parent(i_slot_,&el_i_slot,"inventory")
            // append_ui_e_to_parent(i_slot_img_,&el_i_img_slot,i_slot_)
            append_ui_e_to_parent(fmt.aprint(info,str),&el_i_slot,"inventory")
            append_ui_e_to_parent(fmt.aprint(info_2,str),&el_i_img_slot,fmt.aprint(info,str))
        }
    } 
    el_i_slot.style.border_color = {39, 42, 46,255}
    el_i_slot.style.background_color = {255, 255, 255,255}
    el_i_slot.hover_style.border_thickness = 5
    el_i_slot.hover_style.border_color = {39, 42, 46,255}
    el_i_slot.hover_style.background_color = {147, 160, 181,255}

    el_i_slot.style.border_thickness = 5
    el_i_slot.style.background_color = {255, 255, 255,255}
    el_i_slot.hover_style.border_thickness = 5
    el_i_slot.hover_style.background_color = {39, 42, 46,225}

    el_i_info_box : ui_element = el_i_slot
    el_i_info_box.container.padding = 20
    el_i_info_box.container.max_e_in_column_row=3
    el_i_info_box.pos_flag=.top_right
    el_i_info_box.offset={0,0}
    el_i_info_box.size_w_flag=.pixel
    el_i_info_box.size_h_flag=.pixel
    el_i_info_box.hover_style.width=1
    el_i_info_box.hover_style.hight=1
    el_i_info_box.hover_style.padding = 9
    el_i_info_box.hover_style.background_color = {147, 160, 181,255}
    el_i_info_box.style.width=300
    el_i_info_box.style.hight=300
    el_i_info_box.style.padding = 15
    el_i_info_box.style.background_color = {147, 160, 181,255}
    el_i_info_name : ui_element = el_i_slot
    el_i_info_text : ui_element = el_i_slot
    el_i_info_icon : ui_element = el_i_slot
    el_i_info_cost : ui_element = el_i_slot

    // el_i_info_icon.style.padding = 4
    el_i_info_icon.pos_flag =.top_left
    el_i_info_name.pos_flag = .top_center
    el_i_info_name.style.text_box_data.text_color={55,55,55,255}
    el_i_info_name.style.text_box_data.size = 25
    el_i_info_name.style.background_color={0,0,0,0}
    el_i_info_name.style.border_color={0,0,0,0}
    el_i_info_name.hover_style.text_box_data.text_color={55,55,55,255}
    el_i_info_name.hover_style.text_box_data.size = 25
    el_i_info_name.hover_style.background_color={0,0,0,0}
    el_i_info_name.hover_style.border_color={0,0,0,0}
    el_i_info_name.offset={-20,0}

    el_i_info_text.pos_flag = .center_left
    el_i_info_text.style.text_box_data.text_color={55,55,55,255}
    el_i_info_text.style.text_box_data.size = 12
    el_i_info_text.style.background_color={0,0,0,0}
    el_i_info_text.style.border_color={0,0,0,0}
    el_i_info_text.offset={0,-20}

    el_i_info_text.hover_style.text_box_data.text_color={55,55,55,255}
    el_i_info_text.hover_style.text_box_data.size = 12
    el_i_info_text.hover_style.background_color={0,0,0,0}
    el_i_info_text.hover_style.border_color={0,0,0,0}
    

    el_i_info_icon.style.width = .25
    el_i_info_icon.style.hight = .25
  

    el_i_info_cost.pos_flag=.bot_left
    el_i_info_cost.style.background_color ={0,0,0,0}
    el_i_info_cost.style.border_color = {0,0,0,0}
    el_i_info_cost.hover_style.background_color ={0,0,0,0}
    el_i_info_cost.hover_style.border_color = {0,0,0,0}
    el_i_info_cost.style.text_box_data.text_color={55,55,55,255}
    el_i_info_cost.style.text_box_data.size = 30
    el_i_info_cost.size_h_flag = .container_multiplier_h
    el_i_info_cost.style.hight = .5
    el_i_info_cost.style.width = 1
    el_i_info_cost.style.text_box_data.raw_text = "COST:"
    el_i_info_cost.container.padding = 20
    // el_i_info_name.style.text_box_data.
    append_ui_e_to_parent("info_box",&el_i_info_box,"inventory")
    append_ui_e_to_parent("info_icon",&el_i_info_icon,"info_box")
    append_ui_e_to_parent("info_name",&el_i_info_name,"info_box")
    append_ui_e_to_parent("info_text",&el_i_info_text,"info_box")
    append_ui_e_to_parent("info_cost",&el_i_info_cost,"info_box")
    el_i_info_cost.size_h_flag = .container_multiplier_h
    el_i_info_cost.style.hight = .666666
    el_i_info_cost.style.width = .333333
    el_i_info_cost.style.padding = 5
    el_i_info_cost.style.background_color={255,255,255,255}
    el_i_info_cost.pos_flag=.bot_left
    el_i_info_cost.style.text_box_data.padding =- 18
    el_i_info_cost.style.text_box_data.size = 15
    append_ui_e_to_parent("info_cost_0",&el_i_info_cost,"info_cost")
    el_i_info_cost.pos_flag=.bot_center
    append_ui_e_to_parent("info_cost_1",&el_i_info_cost,"info_cost")
    el_i_info_cost.pos_flag=.bot_right
    append_ui_e_to_parent("info_cost_2",&el_i_info_cost,"info_cost")

    el_r_slot :=el_i_slot
    el_r_slot.callbacks.tick = nil
    el_r_slot.callbacks.hovering = nil
    el_r_slot.container.padding = 2
    el_r_slot.style.padding = 0
    el_r_slot.hover_style.padding = 0
    el_r_slot.hover_style.text_box_data.font.baseSize = 100
    el_r_slot.hover_style.text_box_data.size = 16
    el_r_slot.hover_style.text_box_data.padding = 0
    el_r_slot.hover_style.text_box_data.text_color={0,0,0,255}



    el_r_info_text:=el_i_img_slot
    el_r_info_text.pos_flag=.bot_left
    el_r_info_text.callbacks.tick = nil
    el_r_info_text.callbacks.hovering = nil
    el_r_info_text.img = Texture_Name.None
    el_r_info_text.style.text_box_data.raw_text="4700"
    el_r_info_text.style.text_box_data.size = 16
    el_r_info_text.style.text_box_data.padding = 0
    el_r_info_text.style.text_box_data.text_color={0,0,0,255}
    el_r_info_text.style.hight =.5
    el_r_info_text.style.width =1
    el_r_info_text.style.background_color={255,255,255,0}
    el_r_info_text.style.border_color={0,0,0,0}

    el_r_info_text.hover_style.text_box_data.raw_text="4700"
    el_r_info_text.hover_style.text_box_data.font.baseSize = 100
    el_r_info_text.hover_style.text_box_data.size = 16
    el_r_info_text.hover_style.text_box_data.padding = 0
    el_r_info_text.hover_style.text_box_data.text_color={0,0,0,255}
    el_r_info_text.hover_style.hight =.5
    el_r_info_text.hover_style.width =.5
    el_r_info_text.hover_style.background_color={255,255,255,255}
    el_r_info_text.hover_style.border_color={0,0,0,0}

    for item_n in item_names{
        item:=defalt_items[item_n]
        if  .is_resource in item.tags{
            el_r_slot.img = item.icon
            el_r_slot.hover_style.text_box_data.raw_text = fmt.aprint(item_n)
            el_r_slot.style.background_color = cast([4]u8)item.tint
            el_r_slot.hover_style.background_color = cast([4]u8)item.tint
            // fmt.print(fmt.tprint("text",item_n))

            
            append_ui_e_to_parent(fmt.aprint(item_n),&el_r_slot,"inventory_resources")
            append_ui_e_to_parent(fmt.aprint("text",item_n),&el_r_info_text,fmt.aprint(item_n))
            
            
        }
    }

}

cb_togl_inventory::proc(ui_element:^ui_element){
    if rl.IsKeyPressed(.E)||rl.IsKeyPressed(.TAB){
        ui_element.is_disabled = !ui_element.is_disabled
        // play_sound(.s_woo,.2,1.2)
        play_sound(.penswipe,1,1.6)
        play_sound(.s_click,1,1.)
        play_sound(.s_click,1,.7)
    }
    if ui_element.interact.is_huv&&!ui_element.is_disabled{
        g_mem.placing.in_ui = true
        move_info_box(ui_element)
        
    }else{
        // g_mem.placing.in_ui = false
        hide_info_box(ui_element)
    }
}
cb_togl_inventory_resources::proc(ui_element:^ui_element){
    if rl.IsKeyPressed(.E)||rl.IsKeyPressed(.TAB){
        ui_element.is_disabled = !ui_element.is_disabled
    }
    if ui_element.interact.is_huv&&!ui_element.is_disabled{
        g_mem.placing.in_ui = true
        // move_info_box(ui_element)
        
    }else{
        // g_mem.placing.in_ui = false
        // hide_info_box(ui_element)
    }
}
cb_button_change_building::proc(ui_element:^ui_element){
    if rl.IsMouseButtonPressed(.LEFT){
        g_mem.placing.id = ui_element.ent
    }
    move_calc_info_box(ui_element)
}
move_calc_info_box::proc(ui_element:^ui_element){
    ok := "info_box" in g_mem.ui_context.ui_elements
    if ok{
        box : = &g_mem.ui_context.ui_elements["info_box"]
        icon : = &g_mem.ui_context.ui_elements["info_icon"]
        name : = &g_mem.ui_context.ui_elements["info_name"]
        text : = &g_mem.ui_context.ui_elements["info_text"]
        cost : = &g_mem.ui_context.ui_elements["info_cost"]
        cost_0 : = &g_mem.ui_context.ui_elements["info_cost_0"]
        cost_1 : = &g_mem.ui_context.ui_elements["info_cost_1"]
        cost_2 : = &g_mem.ui_context.ui_elements["info_cost_2"]
        box.offset = g_mem.ui_context.cursor_pos/2
        box.is_disabled = false
        icon.img = ui_element.img
        name.style.text_box_data.raw_text = get_entity_info[ui_element.ent].name
        // calc_text_box_data(&name.style.text_box_data)
        text.style.text_box_data.raw_text = get_entity_info[ui_element.ent].description
        // calc_text_box_data(&text.style.text_box_data)
        cost_0.img = defalt_items[get_entity_info[ui_element.ent].cost[0].item].icon
        cost_1.img = defalt_items[get_entity_info[ui_element.ent].cost[1].item].icon
        cost_2.img = defalt_items[get_entity_info[ui_element.ent].cost[2].item].icon
        cost_0.style.background_color = cast([4]u8)defalt_items[get_entity_info[ui_element.ent].cost[0].item].tint
        cost_1.style.background_color = cast([4]u8)defalt_items[get_entity_info[ui_element.ent].cost[1].item].tint
        cost_2.style.background_color = cast([4]u8)defalt_items[get_entity_info[ui_element.ent].cost[2].item].tint
        if get_entity_info[ui_element.ent].cost[0].count > 0{
            cost_0.is_disabled = false
        }else{cost_0.is_disabled = true}
        if get_entity_info[ui_element.ent].cost[1].count > 0{
            cost_1.is_disabled = false
        }else{cost_1.is_disabled = true}
        if get_entity_info[ui_element.ent].cost[2].count > 0{
            cost_2.is_disabled = false
        }else{cost_2.is_disabled = true}
        cost_0.style.text_box_data.raw_text = fmt.tprint(get_entity_info[ui_element.ent].cost[0].count)
        cost_1.style.text_box_data.raw_text = fmt.tprint(get_entity_info[ui_element.ent].cost[1].count)
        cost_2.style.text_box_data.raw_text = fmt.tprint(get_entity_info[ui_element.ent].cost[2].count)
        // calc_text_box_data(&cost_0.style.text_box_data)
        // calc_text_box_data(&cost_1.style.text_box_data)
        // calc_text_box_data(&cost_2.style.text_box_data)
        // fmt.tprint(get_entity_info[ui_element.ent].cost[0].item)
        // calc_text_box_data(&cost.style.text_box_data)
    }
}
move_info_box::proc(ui_element:^ui_element){
    ok := "info_box" in g_mem.ui_context.ui_elements
    if ok{
        box : = &g_mem.ui_context.ui_elements["info_box"]
        box.offset = g_mem.ui_context.cursor_pos/2
    }
}
hide_info_box::proc(ui_element:^ui_element){
    ok := "info_box" in g_mem.ui_context.ui_elements
    if ok{
        box : = &g_mem.ui_context.ui_elements["info_box"]
        box.is_disabled = true

    }
}
huv_slot::proc(ui_element:^ui_element){
    play_sound(.s_click,.5,.6)
    play_sound(.s_click,.3,.3)
}
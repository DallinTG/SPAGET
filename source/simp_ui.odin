package game

import "core:fmt"
import rl "vendor:raylib"
// import "core:os"
import "core:slice"
// import "core:encoding/cbor"
import "core:math"
// import te "core:text/edit"
import "core:strings"


rec::struct{
    x:f32,
    y:f32,
    w:f32,
    h:f32,
}


container_type::enum{
    l_r,
    up_down
}
element_pos_flags::enum{
    flex,
    flex_fill,
    top_left,
    top_center,
    top_right,
    center_left,
    center,
    center_right,
    bot_left,
    bot_center,
    bot_right,
}
element_size_flags::enum{
    flex,
    pixel,
    multiplier,
    screen_multiplier_w,
    container_multiplier_w,
    screen_multiplier_h,
    container_multiplier_h,
}

ui_context::struct{
    base_container:ui_container,
    ui_elements:map[string]ui_element,
    element_keys:[dynamic]string,
    cursor_pos:[2]f32,
    inpute_this_frame:bool,

}
ui_container::struct{
    offset:[2]f32,
    width:f32,
    hight:f32,
    padding:f32,
    background_color:[4]u8,
    type:container_type,
    max_e_in_column_row:int,
    // ui_elements:[dynamic]ui_element,
    ui_e_keys:[dynamic]string,
    current_z_index:f32,

}
ui_element::struct{
    ent:entity_names,
    img:img_ani_name,
    interact:ui_interact,
    parent_key:string,
    pos_flag:element_pos_flags,
    size_w_flag:element_size_flags,
    size_h_flag:element_size_flags,
    offset:[2]f32,
    is_hidden:bool,
    is_disabled:bool,
    current_style:^element_style,
    style:element_style,
    hover_style:element_style,
    container:ui_container,
    callbacks:ui_callbacks,
    last_frame_updated_on:uint,
}
ui_interact::struct{
    is_huv:bool,
    start_huv:bool,
    end_huv:bool,
}
ui_callbacks::struct{
    start_hovering:proc(ui_element:^ui_element),
    hovering:proc(ui_element:^ui_element),
    end_hovering:proc(ui_element:^ui_element),
    button_clicked:proc(ui_element:^ui_element),
    button_held:proc(ui_element:^ui_element),
    button_releced:proc(ui_element:^ui_element),
    tick:proc(ui_element:^ui_element),
}
current_context:^ui_context
// defalt_context:ui_context
// test:ui_callbacks
init_ui_context::proc(){
    // set_current_context(&defalt_context)
}
update_current_context::proc(ui_width:f32,ui_hight:f32,cursor_pos:[2]f32){
    current_context.base_container.width = ui_width
    current_context.base_container.hight = ui_hight
    current_context.cursor_pos = cursor_pos
}
set_current_context::proc(ui_context:^ui_context){
    current_context = ui_context
}
get_current_context::proc()->^ui_context{
    return current_context
}
render_current_context::proc(){
    g_mem.placing.in_ui = false
    calc_context(current_context)
}
calc_context::proc(ui_context:^ui_context){
    // rl.DrawRectanglePro({cast(f32)ui_context.base_container.offset.x,cast(f32)ui_context.base_container.offset.y},{0,0},0,cast(rl.Color)ui_context.base_container.background_color)
    calc_container(&ui_context.base_container,1)
    render_context(ui_context)
}
delete_ui_container::proc(container:^ui_container){

    for key in container.ui_e_keys {
        element := &current_context.ui_elements[key]
        delete_ui_container(&element.container)
        // delete(g_mem.ui_context.ui_elements[key].container.ui_e_keys)
    }
    delete(container.ui_e_keys)
}

calc_container::proc(container:^ui_container,z_index:f32){
    
    // rl.DrawRectanglePro({cast(f32)container.offset.x,cast(f32)container.offset.y,container.width,container.hight},{0,0},0,cast(rl.Color)container.background_color)
    base_offset:[2]f32
    max_enabled_e:int
    max_flex_e:int
    e_index:int
    max_col:int
    for key in container.ui_e_keys {
        element := &current_context.ui_elements[key]
        if !element.is_disabled{
            max_enabled_e+=1
            if element.pos_flag == .flex{
                max_flex_e+=1
            }
        }
    }
    if max_flex_e<container.max_e_in_column_row {
        max_col = 1
    } else {
        max_col = cast(int)math.ceil(cast(f32)max_flex_e/cast(f32)container.max_e_in_column_row)
    }
    for key in container.ui_e_keys {
        element := &current_context.ui_elements[key]
        
        element.current_style=&element.style
        style:=element.current_style
        base_offset = current_context.base_container.offset + element.offset +container.offset + (container.padding/2) + (element.style.padding/2)

        pos_w_h:rl.Rectangle = {cast(f32)base_offset.x,base_offset.y, element.style.width, element.style.hight}
        //* call tick
        if element.callbacks.tick != nil{
            // fmt.print("awdads")
            element.callbacks.tick(element)
        }
        if !element.is_disabled{
            element.last_frame_updated_on = g_mem.time.frame_count
            //* set size of the element baced on the flag
            switch element.size_w_flag{
                case .flex:
                    pos_w_h.width = (container.width - container.padding)/cast(f32)container.max_e_in_column_row 
                    // pos_w_h.height = (container.hight - container.padding)/cast(f32)max_col
                case .multiplier:
                    pos_w_h.width = ((container.width - container.padding)/cast(f32)container.max_e_in_column_row)*element.style.width
                    // pos_w_h.height = ((container.hight - container.padding)/cast(f32)max_col)*element.style.hight
                case .screen_multiplier_w:
                    pos_w_h.width = ((current_context.base_container.width - current_context.base_container.padding))*element.style.width
                    // pos_w_h.height = ((current_context.base_container.hight - current_context.base_container.padding))*element.style.hight
                case .container_multiplier_w:
                    pos_w_h.width = ((container.width - container.padding))*element.style.width
                    // pos_w_h.height = ((container.hight - container.padding))*element.style.hight
                case .screen_multiplier_h:
                    // pos_w_h.width = ((current_context.base_container.width - current_context.base_container.padding))*element.style.width
                    pos_w_h.width = ((current_context.base_container.hight - current_context.base_container.padding))*element.style.hight
                case .container_multiplier_h:
                    // pos_w_h.width = ((container.width - container.padding))*element.style.width
                    pos_w_h.width = ((container.hight - container.padding))*element.style.hight
                case .pixel:
                    pos_w_h.width = element.style.width
                    // pos_w_h.height = element.style.hight
            }
            switch element.size_h_flag{
                case .flex:
                    // pos_w_h.width = (container.width - container.padding)/cast(f32)container.max_e_in_column_row 
                    pos_w_h.height = (container.hight - container.padding)/cast(f32)max_col
                case .multiplier:
                    // pos_w_h.width = ((container.width - container.padding)/cast(f32)container.max_e_in_column_row)*element.style.width
                    pos_w_h.height = ((container.hight - container.padding)/cast(f32)max_col)*element.style.hight
                case .screen_multiplier_h:
                    // pos_w_h.width = ((current_context.base_container.width - current_context.base_container.padding))*element.style.width
                    pos_w_h.height = ((current_context.base_container.hight - current_context.base_container.padding))*element.style.hight
                case .container_multiplier_h:
                    // pos_w_h.width = ((container.width - container.padding))*element.style.width
                    pos_w_h.height = ((container.hight - container.padding))*element.style.hight
                case .screen_multiplier_w:
                    pos_w_h.height = ((current_context.base_container.width - current_context.base_container.padding))*element.style.width
                    // pos_w_h.height = ((current_context.base_container.hight - current_context.base_container.padding))*element.style.hight
                case .container_multiplier_w:
                    pos_w_h.height = ((container.width - container.padding))*element.style.width
                    // pos_w_h.height = ((container.hight - container.padding))*element.style.hight
                case .pixel:
                    // pos_w_h.width = element.style.width
                    pos_w_h.height = element.style.hight
            }
            //* set the pos of the element baced on the flag
            switch element.pos_flag{
                case .flex:
                    pos_w_h.x += cast(f32)(e_index%container.max_e_in_column_row)*((container.width - container.padding)/cast(f32)container.max_e_in_column_row)
                    pos_w_h.y += cast(f32)(e_index/container.max_e_in_column_row)/cast(f32)max_col*(container.hight - container.padding)
                    e_index +=1
                case .flex_fill:
                    pos_w_h.x += cast(f32)(e_index%container.max_e_in_column_row)*((container.width - container.padding)/cast(f32)container.max_e_in_column_row)
                    pos_w_h.y += cast(f32)(e_index/container.max_e_in_column_row) *pos_w_h.height//+(container.hight - container.padding)
                    e_index +=1
                case .top_left:
                    pos_w_h.x = element.offset.x + base_offset.x
                    pos_w_h.y = element.offset.y + base_offset.y
                case .top_center:
                    // pos_w_h.width = (container.width - container.padding)/cast(f32)container.max_e_in_column_row 
                    // pos_w_h.height = (container.hight - container.padding)/cast(f32)max_col
                    pos_w_h.x = element.offset.x + (base_offset.x-(container.padding/2)) +(container.width/2) - (pos_w_h.width/2)
                    pos_w_h.y = element.offset.y + base_offset.y
                case .top_right:
                    pos_w_h.x = element.offset.x + (base_offset.x-(container.padding)) +(container.width) - (pos_w_h.width)
                    pos_w_h.y = element.offset.y + base_offset.y
                case .center_left:
                    pos_w_h.x = element.offset.x + base_offset.x
                    pos_w_h.y = element.offset.y + (base_offset.y-(container.padding/2)) +(container.hight/2) - (pos_w_h.height/2)
                  case .center:
                    pos_w_h.x = element.offset.x + (base_offset.x-(container.padding/2)) +(container.width/2) - (pos_w_h.width/2)
                    pos_w_h.y = element.offset.y + (base_offset.y-(container.padding/2)) +(container.hight/2) - (pos_w_h.height/2)
                case .center_right:
                    pos_w_h.x = element.offset.x + (base_offset.x-(container.padding)) +(container.width) - (pos_w_h.width)
                    pos_w_h.y = element.offset.y + (base_offset.y-(container.padding/2)) +(container.hight/2) - (pos_w_h.height/2)                        
                case .bot_left:
                    pos_w_h.x = element.offset.x + base_offset.x
                    pos_w_h.y = element.offset.y + (base_offset.y-(container.padding)) +(container.hight) - (pos_w_h.height)
                case .bot_center:
                    pos_w_h.x = element.offset.x + (base_offset.x-(container.padding/2)) +(container.width/2) - (pos_w_h.width/2)
                    pos_w_h.y = element.offset.y + (base_offset.y-(container.padding)) +(container.hight) - (pos_w_h.height)
                case .bot_right:
                    pos_w_h.x = element.offset.x + (base_offset.x-(container.padding)) +(container.width) - (pos_w_h.width)
                    pos_w_h.y = element.offset.y + (base_offset.y-(container.padding)) +(container.hight) - (pos_w_h.height)

                }
            //* callback for start huvering
            if element.interact.is_huv == false && is_e_huv(pos_w_h,current_context.cursor_pos)==true{
                if element.callbacks.start_hovering != nil{
                    element.callbacks.start_hovering(element)
                }
            }
            //* callback for end huvering
            if element.interact.is_huv == true && is_e_huv(pos_w_h,current_context.cursor_pos)==false{
                if element.callbacks.end_hovering != nil{
                    element.callbacks.end_hovering(element)
                }
            }
            //* call back for huvering
            element.interact.is_huv = is_e_huv(pos_w_h,current_context.cursor_pos)
            if element.interact.is_huv{
                style=&element.hover_style
                element.current_style = &element.hover_style
                if element.callbacks.hovering != nil{
                    element.callbacks.hovering(element)
                }
            }

            pos_w_h.width -= (style.padding)
            pos_w_h.height -= (style.padding)
            element.container.width = pos_w_h.width
            element.container.hight = pos_w_h.height
            element.container.offset = {pos_w_h.x,pos_w_h.y}
            if pos_w_h.width-style.text_box_data.padding != style.text_box_data.w_h.x||pos_w_h.height-style.text_box_data.padding != style.text_box_data.w_h.y{
                style.text_box_data.w_h = {pos_w_h.width-style.text_box_data.padding,pos_w_h.height-style.text_box_data.padding}
                // calc_text_box_data(&style.text_box_data)
            }
            element.container.current_z_index = z_index + 1 + style.z_index
            calc_container(&element.container,element.container.current_z_index)
        }
    }
}
render_context::proc(ui_context:^ui_context){
    clear(&ui_context.element_keys)
    for key in ui_context.ui_elements {
        append(&ui_context.element_keys,key)
    }
    slice.sort_by(ui_context.element_keys[:],sort_z_index)
    container:=ui_context.base_container
    rl.DrawRectanglePro({cast(f32)container.offset.x,cast(f32)container.offset.y,container.width,container.hight},{0,0},0,cast(rl.Color)container.background_color)
    for key in ui_context.element_keys{
        element:=&current_context.ui_elements[key]
        if element.last_frame_updated_on == g_mem.time.frame_count{
            if element.img != Texture_Name.None &&element.img !=Animation_Name.None{
                draw_image(
                    name = element.img,
                    dest = {
                        element.container.offset.x,
                        element.container.offset.y,
                        element.container.width,
                        element.container.hight
                    },
                    tint = cast(rl.Color)element.current_style.background_color
                )
                draw_text_box(element.container.offset,&element.current_style.text_box_data)
            }else if !element.is_hidden&&!element.is_disabled{
                rl.DrawRectangleRounded(
                    rec = {
                        element.container.offset.x,
                        element.container.offset.y,
                        element.container.width,
                        element.container.hight
                    },
                    roundness = element.current_style.roundness,
                    segments = 0,
                    color = cast(rl.Color)element.current_style.background_color
                )
                if element.current_style.border_thickness > 0 {
                    rl.DrawRectangleRoundedLinesEx(
                        {
                            element.container.offset.x+element.current_style.border_thickness,
                            element.container.offset.y+element.current_style.border_thickness,
                            element.container.width-element.current_style.border_thickness*2,
                            element.container.hight-element.current_style.border_thickness*2,
                        },
                        element.current_style.border_roundness,
                        10,
                        element.current_style.border_thickness,
                        cast(rl.Color)element.current_style.border_color
                    )
                }
                draw_text_box(element.container.offset,&element.current_style.text_box_data)
            }
        }
    }

}
sort_z_index::proc(key_1:string,key_2:string)->bool{
    if current_context.ui_elements[key_1].container.current_z_index<current_context.ui_elements[key_2].container.current_z_index{
        return true
    }
    return false
}
is_e_huv::proc(rec:rl.Rectangle,pos:[2]f32)->(bool){
// if pos.x > rec.x && pos.y > rec.x{
//     if pos.x< rec.x+rec.width&&pos.y< rec.y+rec.height{
//         return true
//     }
// }
// return false
return rl.CheckCollisionPointRec(pos,rec)
}
append_ui_e_to_parent::proc(new_element_key:string, ui_element:^ui_element,parent_key:string = ""){
    current_context.ui_elements[new_element_key] = ui_element^
    if parent_key == "" {
        append(&current_context.base_container.ui_e_keys,new_element_key)
    }else{
        parent:=&current_context.ui_elements[parent_key]
        append(&parent.container.ui_e_keys,new_element_key)
    }
}



test_temp_print::proc(){
    fmt.print("\nhi \n this \n is \n a\n test\n")
}
print_ui_element::proc(element:^ui_element){
 fmt.print("\nThis is a log of a ui element \n",element,"\n")
}


//__--------------------------styles-------------------------




element_style::struct{
    text_box_data:text_box_data,
    background_color:[4]u8,
    foreground_color:[4]u8,
    border_color:[4]u8,
    padding:f32,
    border_thickness:f32,
    border_padding:f32,
    border_roundness:f32,
    roundness:f32,
    z_index:f32,
    width:f32,
    hight:f32,
    //0-1
}
style_ids::enum{
    base,
    test,
    button,
    red,
    blue,
    green,

}
all_styles:[style_ids]element_style
default_style:element_style = {
    background_color = {255,255,255,255},
    foreground_color = {255,255,255,255},
    padding = 0,
}

init_styles::proc(){
    for &style in all_styles{
        style = default_style
    }
    all_styles[.base] = {
        background_color = {255,255,255,255},
        foreground_color = {255,255,255,255},
        padding = 10,
        border_thickness = 0,
        border_padding = 0,
        z_index = 0,
    }
    all_styles[.red] = {
        background_color = {255,55,55,255},
        foreground_color = {255,55,55,255},
        padding = 10,
        border_thickness = 0,
        border_padding = 0,
        z_index = 0,
    }
    all_styles[.blue] = {
        background_color = {55,55,255,255},
        foreground_color = {55,55,255,255},
        padding = 10,
        border_thickness = 0,
        border_padding = 10,
        z_index = 0,
    }
    all_styles[.green] = {
        background_color = {55,255,55,255},
        foreground_color = {55,255,55,255},
        padding = 10,
        border_thickness = 0,
        border_padding = 0,
        z_index = 0,
    }
}

//-------------------text------------------------------



text_box_data::struct{
    raw_text:string,
    text:string,
    w_h:[2]f32,
    padding:f32,
    size:f32,
    font:rl.Font,
    text_color:rl.Color
}

calc_text_box_data::proc(t_box:^text_box_data){
    w_h_p := t_box.w_h
    cur_w_h:[2]f32
    cur_w_h.x = (-t_box.size/2)
    cur_w_h.y = t_box.size
    line_it:int
    // fmt.print(strings.split_after(text," "))
    index:int
    // delete(t_box.text)
    // delete(words)
    // if &t_box.text !=nil{
    //     delete(t_box.text)
    // }
    words:=strings.split_after(t_box.raw_text," ",context.temp_allocator)
    
    for &word in &words {
        // fmt.print(rl.MeasureTextEx(font, strings.clone_to_cstring(word),size,size/2))
        string_:=strings.clone_to_cstring(word,context.temp_allocator)
        word_w_h := rl.MeasureTextEx(t_box.font, string_,t_box.size,t_box.size/2)
        if cur_w_h.x + word_w_h.x+(t_box.size/2) <= w_h_p.x {
            cur_w_h.x += word_w_h.x +(t_box.size/2)
            line_it += 1
        } else if line_it == 0 {
            word = ""
        } else if cur_w_h.y + word_w_h.y <= w_h_p.y{
            cur_w_h.x = word_w_h.x
            cur_w_h.y += word_w_h.y 
            line_it = 0
            
            word = strings.concatenate({"\n",word},context.temp_allocator)
            // delete(T)
        }else{
            word = ""
        }
        index+=1
        // delete_cstring(string_)
        
    }
    
    t_box.text = strings.concatenate(words,context.temp_allocator)
    // delete(t_box.text)
    // delete(T)
    // delete(words)
    // fmt.print("sadas")
    return
}

draw_text_box::proc(pos:[2]f32,t_box:^text_box_data){
    calc_text_box_data(t_box)
    // rl.SetTextLineSpacing(10)
    // temp:=rl.MeasureTextEx(rl.GetFontDefault(),st.clone_to_cstring(strings),100,100/2)
    rl.SetTextLineSpacing(cast(i32)t_box.size)
    // rl.DrawRectangleLines(cast(i32)(pos.x + t_box.padding/2),cast(i32)(pos.y+ t_box.padding/2),cast(i32)t_box.w_h.x,cast(i32)t_box.w_h.y,{255,255,255,255})
    string_:=strings.clone_to_cstring(t_box.text,context.temp_allocator)
    rl.DrawTextPro(t_box.font, string_,pos+ t_box.padding/2,{0,0},0,t_box.size,t_box.size/4,t_box.text_color)
    // delete_cstring(string_)
    // delete(t_box.text)
}



//---------------------------call backs--------------
cb_hide::proc(ui_element:^ui_element){
    ui_element.is_hidden = true
}
cb_show::proc(ui_element:^ui_element){
    ui_element.is_hidden = false
}
cb_swop_vis::proc(ui_element:^ui_element){
    ui_element.is_hidden = !ui_element.is_hidden
}
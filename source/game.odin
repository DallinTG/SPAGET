package game

import "core:fmt"
import "core:math/linalg"
import "core:math"
import rl "vendor:raylib"
import noise"core:math/noise"



init::proc(){
	rl.InitAudioDevice()
	init_seeds()
	init_sounds()
	init_shaders()
	init_atlases()
	init_box_2d()
	init_global_animations()
	init_defalts()
	init_defalt_settings()
	set_current_context(&g_mem.ui_context)
	init_ui_elements()
	init_resources()
	add_item_to_resources(.copper_ingot,2000)
	add_item_to_resources(.iron_ingot,2000)
	// add_item_to_resources(.stone_ingot,40000)
	// add_item_to_resources(.glass,40000)
	// add_item_to_resources(.steel_ingot,40000)
	g_mem.cam.position = {0,2,-100}
	g_mem.cam.target = {0,2,0}
	g_mem.cam.fovy = 512
	g_mem.cam.projection=.ORTHOGRAPHIC
	g_mem.cam.up = {0,-1,0}

	fill_tile_map_by_x_y(0,0,.Bace_Rock)
	fill_tile_map_by_x_y(0,1,.Bace_Rock)
	fill_tile_map_by_x_y(1,0,.Bace_Rock)
	fill_tile_map_by_x_y(1,1,.Bace_Rock)

	place_building_on_grid(.core,{0,0},0)
	// g_mem.placing.id = .core
	rl.SetMusicVolume(g_mem.assets.music , .10)   
	rl.PlayMusicStream(g_mem.assets.music) 
}

update :: proc() {
	mantine_timers()
	update_current_context(cast(f32)rl.GetScreenWidth(),cast(f32)rl.GetScreenHeight(),rl.GetMousePosition())
	update_global_animations()
	calc_particles()
	sim_box_2d()
	do_entities()
	update_resources()
	do_inputs()
	manage_sound_bytes()
	update_song()
	
}

draw :: proc() {
	

	rl.BeginDrawing()
	rl.ClearBackground(rl.GREEN)
	rl.BeginMode3D(g_mem.cam)
	rl.BeginShaderMode(g_mem.assets.shaders.bace)
	// rl.BeginBlendMode(.ALPHA_PREMULTIPLY)

	draw_game_map()
	draw_entities()
	draw_building_preview()
	// rl.DrawRectangle(0,0,1000,1000,{255,255,255,55})
	// draw_image(.Round_Cat,{0,0,100,100},-10)
	
	draw_particles()
	// rl.EndBlendMode()
	rl.EndShaderMode()
	rl.EndMode3D()

	rl.BeginMode2D(ui_camera())

	rl.EndMode2D()
	render_current_context()
	// rl.DrawFPS(10,10)
	rl.EndDrawing()
}

game_camera :: proc() -> rl.Camera2D {
	w := f32(rl.GetScreenWidth())
	h := f32(rl.GetScreenHeight())

	return {
		zoom = h/PIXEL_WINDOW_HEIGHT,
		// target = g_mem.player_pos,
		offset = { w/2, h/2 },
	}
}

ui_camera :: proc() -> rl.Camera2D {
	return {
		zoom = f32(rl.GetScreenHeight())/PIXEL_WINDOW_HEIGHT,
	}
}
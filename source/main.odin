/*
This file is the starting point of your game.

Some important procedures are:
- game_init_window: Opens the window
- game_init: Sets up the game state
- game_update: Run once per frame
- game_should_close: For stopping your game when close button is pressed
- game_shutdown: Shuts down game and frees memory
- game_shutdown_window: Closes window

The procs above are used regardless if you compile using the `build_release`
script or the `build_hot_reload` script. However, in the hot reload case, the
contents of this file is compiled as part of `build/hot_reload/game.dll` (or
.dylib/.so on mac/linux). In the hot reload cases some other procedures are
also used in order to facilitate the hot reload functionality:

- game_memory: Run just before a hot reload. That way game_hot_reload.exe has a
      pointer to the game's memory that it can hand to the new game DLL.
- game_hot_reloaded: Run after a hot reload so that the `g_mem` global
      variable can be set to whatever pointer it was in the old DLL.

NOTE: When compiled as part of `build_release`, `build_debug` or `build_web`
then this whole package is just treated as a normal Odin package. No DLL is
created.
*/

package game

// import "core:fmt"
// import "core:math/linalg"
import rl "vendor:raylib"

// import ecs "odin-ecs-main"

PIXEL_WINDOW_HEIGHT :: 180

Game_Memory :: struct {
	player_pos: rl.Vector2,
	player_texture: rl.Texture,
	some_number: int,
	cam:rl.Camera,
	run: bool,
	assets:assets,
	platforme:platforme,
	state:state,
	placing:placing,
	time:time_stuff,
	defalt:defalt,
	settings:settings,
	ui_context:ui_context,
}
state::struct{
	particle:all_particle_data,
	lights:[max_lights]light,
	entity_bucket:entity_bucket, //contains all entities
	game_map:game_map,
	seeds:seeds,
	resources:[dynamic]item_slot,
	// ecs:ecs.Context,
}
seeds::struct{
	bace:i64,
	ore:i64,
	height:i64
}
settings::struct{
	render_distance:i32,
}
platforme::enum{
	desktop,
	web,
}

g_mem: ^Game_Memory

@(export)
game_update :: proc() {
	update()
	draw()
}

@(export)
game_init_window :: proc() {
	rl.SetConfigFlags({.WINDOW_RESIZABLE,})
	rl.InitWindow(1080, 720, "Odin + Raylib + Hot Reload template!")
	rl.SetWindowPosition(200, 200)
	// rl.SetTargetFPS(5)
	rl.SetExitKey(nil)
}

@(export)
game_init :: proc() {
	g_mem = new(Game_Memory)

	g_mem^ = Game_Memory {
		run = true,
		some_number = 100,

		// You can put textures, sounds and music in the `assets` folder. Those
		// files will be part any release or web build.
		// player_texture = rl.LoadTexture("assets/textures/round_cat.png"),
	}
	// t_maps := make(map[[2]int]tile_map,)
	// g_mem.state.game_map.tile_maps =&t_maps
	when ODIN_ARCH == .wasm32{
		g_mem.platforme = .web
	}
	game_hot_reloaded(g_mem)
	init()
}

@(export)
game_should_run :: proc() -> bool {
	when ODIN_OS != .JS {
		// Never run this proc in browser. It contains a 16 ms sleep on web!
		if rl.WindowShouldClose() {
			return false
		}
	}

	return g_mem.run
}

@(export)
game_shutdown :: proc() {
	delete_ui_container(&current_context.base_container)
	delete(g_mem.ui_context.element_keys)
	delete(g_mem.ui_context.ui_elements)
	delete(g_mem.state.resources)
	delete(g_mem.state.game_map.tile_maps)

	free(g_mem)
}

@(export)
game_shutdown_window :: proc() {
	rl.CloseWindow()
}

@(export)
game_memory :: proc() -> rawptr {
	return g_mem
}

@(export)
game_memory_size :: proc() -> int {
	return size_of(Game_Memory)
}

@(export)
game_hot_reloaded :: proc(mem: rawptr) {
	g_mem = (^Game_Memory)(mem)

	// Here you can also set your own global variables. A good idea is to make
	// your global variables into pointers that point to something inside
	// `g_mem`.
}

@(export)
game_force_reload :: proc() -> bool {
	return rl.IsKeyPressed(.F5)
}

@(export)
game_force_restart :: proc() -> bool {
	return rl.IsKeyPressed(.F6)
}

// In a web build, this is called when browser changes size. Remove the
// `rl.SetWindowSize` call if you don't want a resizable game.
game_parent_window_size_changed :: proc(w, h: int) {
	rl.SetWindowSize(i32(w), i32(h))
}

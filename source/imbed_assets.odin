package game


asset :: struct {
	path: string,
	data: []u8,
	info: cstring,
}

font_names :: enum {
}

shader_names :: enum {
	bace_fs,
	bace_vs,
	bace_web_fs,
	bace_web_vs,
}

sound_names :: enum {
	none,
	eat,
	no_1,
	no_2,
	penswipe,
	place,
	running_1,
	running_2,
	running_3,
	running_4,
	running_5,
	running_6,
	sand_step_1,
	small_thud,
	s_click,
	s_nu,
	s_paper_swipe,
	s_pop,
	s_thud,
	s_ts,
	s_woo,
	woosh,
}

music_names :: enum {
	none,
	fact_music,
}

	all_fonts := [font_names]asset {
	}

	all_shaders := [shader_names]asset {
		.bace_fs = { path = "shaders/bace_fs.fs",  info = #load("../assets/shaders/bace_fs.fs",cstring), },
		.bace_vs = { path = "shaders/bace_vs.vs",  data = #load("../assets/shaders/bace_vs.vs"), },
		.bace_web_fs = { path = "shaders/bace_web_fs.fs",  info = #load("../assets/shaders/bace_web_fs.fs",cstring), },
		.bace_web_vs = { path = "shaders/bace_web_vs.vs",  data = #load("../assets/shaders/bace_web_vs.vs"), },
	}

	all_sounds := [sound_names]asset {
		.none = {},
		.eat = { path = "sounds/eat.wav",  data = #load("../assets/sounds/eat.wav"), },
		.no_1 = { path = "sounds/no_1.wav",  data = #load("../assets/sounds/no_1.wav"), },
		.no_2 = { path = "sounds/no_2.wav",  data = #load("../assets/sounds/no_2.wav"), },
		.penswipe = { path = "sounds/penswipe.wav",  data = #load("../assets/sounds/penswipe.wav"), },
		.place = { path = "sounds/place.wav",  data = #load("../assets/sounds/place.wav"), },
		.running_1 = { path = "sounds/running_1.wav",  data = #load("../assets/sounds/running_1.wav"), },
		.running_2 = { path = "sounds/running_2.wav",  data = #load("../assets/sounds/running_2.wav"), },
		.running_3 = { path = "sounds/running_3.wav",  data = #load("../assets/sounds/running_3.wav"), },
		.running_4 = { path = "sounds/running_4.wav",  data = #load("../assets/sounds/running_4.wav"), },
		.running_5 = { path = "sounds/running_5.wav",  data = #load("../assets/sounds/running_5.wav"), },
		.running_6 = { path = "sounds/running_6.wav",  data = #load("../assets/sounds/running_6.wav"), },
		.sand_step_1 = { path = "sounds/sand_step_1.wav",  data = #load("../assets/sounds/sand_step_1.wav"), },
		.small_thud = { path = "sounds/small_thud.wav",  data = #load("../assets/sounds/small_thud.wav"), },
		.s_click = { path = "sounds/S_Click.wav",  data = #load("../assets/sounds/S_Click.wav"), },
		.s_nu = { path = "sounds/S_NU.wav",  data = #load("../assets/sounds/S_NU.wav"), },
		.s_paper_swipe = { path = "sounds/S_Paper_Swipe.wav",  data = #load("../assets/sounds/S_Paper_Swipe.wav"), },
		.s_pop = { path = "sounds/S_POP.wav",  data = #load("../assets/sounds/S_POP.wav"), },
		.s_thud = { path = "sounds/S_Thud.wav",  data = #load("../assets/sounds/S_Thud.wav"), },
		.s_ts = { path = "sounds/S_TS.wav",  data = #load("../assets/sounds/S_TS.wav"), },
		.s_woo = { path = "sounds/S_woo.wav",  data = #load("../assets/sounds/S_woo.wav"), },
		.woosh = { path = "sounds/woosh.wav",  data = #load("../assets/sounds/woosh.wav"), },
	}

	all_music := [music_names]asset {
		.none = {},
		.fact_music = { path = "music/fact_music.mp3",  data = #load("../assets/music/fact_music.mp3"), },
	}


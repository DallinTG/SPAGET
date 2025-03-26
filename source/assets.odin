package game


// import "core:strings"
// import "core:strconv"
import "core:fmt"
// import "core:sort"
// import "core:slice"
import rl "vendor:raylib"

ATLAS_DATA :: #load("../assets/atlases/atlas.png")

assets::struct{
    sounds:[sound_names]rl.Sound,
    sound_aliases:[dynamic]sound_byte,
    atlas:rl.Texture2D,
    shaders:shaders,
    animations:animations,
    music:rl.Music,

}
shaders::struct{
    bace:rl.Shader,
}



init_sounds::proc(){
    for sound,i in all_sounds{
        if i != sound_names.none{
            // if i != sound_names.factorionvibe{
                g_mem.assets.sounds[i] = rl.LoadSoundFromWave(rl.LoadWaveFromMemory(".wav",&sound.data[0],cast(i32)(len(all_sounds[i].data))))
            // }
        }
    }
    g_mem.assets.music = rl.LoadMusicStreamFromMemory(".mp3",cast(rawptr)&all_music[.fact_music].data[0],cast(i32)(len(all_music[.fact_music].data)))
}

init_shaders::proc(){
    
    g_mem.assets.shaders.bace = rl.LoadShaderFromMemory(all_shaders[.bace_web_vs].info,all_shaders[.bace_web_fs].info)
    if g_mem.platforme ==.desktop {
        g_mem.assets.shaders.bace = rl.LoadShaderFromMemory(all_shaders[.bace_vs].info,all_shaders[.bace_fs].info)
    }


}
init_atlases::proc(){
    atlas_image := rl.LoadImageFromMemory(".png", raw_data(ATLAS_DATA), i32(len(ATLAS_DATA)))
	g_mem.assets.atlas = rl.LoadTextureFromImage(atlas_image)
	rl.UnloadImage(atlas_image)
    // rl.SetTextureFilter(g_mem.assets.atlas,.BILINEAR)
    fmt.print("\n")
}

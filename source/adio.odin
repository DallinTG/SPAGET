package game

import rl "vendor:raylib"
import fmt "core:fmt"
// // import as "../assets"
import "core:math"

sound_aliases:[dynamic]sound_byte

sound_byte::struct{
    pos:[2]f32,
    has_pos:bool,
    name:sound_names,
    sound:rl.Sound,
    intesity:f32,
    v_multiplier:f32,
    // entity_lock:entity_index,
    lock_to_entity:bool,
}
defalt_sound_intesity:f32:800
zoom::1

play_sound_at_pos::proc(s_name:sound_names,pos:[2]f32,v_multiplier:f32=1,lock_to_entity:bool=false){
    cam3 := g_mem.cam.target+{(cast(f32)rl.GetScreenWidth()/zoom)/2,(cast(f32)rl.GetScreenHeight()/zoom)/2,0}
    cam:=cam3.xy
    sound:=rl.LoadSoundAlias(g_mem.assets.sounds[s_name])
    rl.SetSoundPan(sound, math.lerp(cast(f32)1,cast(f32)0,cast(f32)(pos.x-cam.x+(defalt_sound_intesity/2))/defalt_sound_intesity))
    //fmt.print(math.lerp(cast(f32)1,cast(f32)0,cast(f32)(pos.x-cam.x+(defalt_sound_intesity/2))/defalt_sound_intesity),"  ")
    rl.SetSoundVolume(sound,(math.clamp(math.abs(math.lerp(cast(f32)1,cast(f32)0,math.sqrt(math.pow_f32(cam.x-pos.x,2)+math.pow_f32(cam.y-pos.y,2))/defalt_sound_intesity)),0,1)*-1)*v_multiplier)
    //fmt.print(math.clamp(math.abs(math.lerp(cast(f32)0,cast(f32)1,math.sqrt(math.pow_f32(cam.x-pos.x,2)+math.pow_f32(cam.y-pos.y,2))/defalt_sound_intesity)),0,1)*-1,"   \n")


    rl.PlaySound(sound)
    s_bty:sound_byte
    s_bty.lock_to_entity=lock_to_entity
    // s_bty.entity_lock=entity_lock
    s_bty.v_multiplier=v_multiplier
    s_bty.pos = pos
    s_bty.has_pos = true
    s_bty.sound = sound
    s_bty.intesity = defalt_sound_intesity
    append(&g_mem.assets.sound_aliases, s_bty)
    
}
play_sound_byte::proc(sound_:sound_byte){
    cam3 := g_mem.cam.target+{(cast(f32)rl.GetScreenWidth()/zoom)/2,(cast(f32)rl.GetScreenHeight()/zoom)/2,0}
    cam:=cam3.xy
    sound:=rl.LoadSoundAlias(g_mem.assets.sounds[sound_.name])
    rl.SetSoundPan(sound, math.lerp(cast(f32)1,cast(f32)0,cast(f32)(sound_.pos.x-cam.x+(defalt_sound_intesity/2))/defalt_sound_intesity))
    //fmt.print(math.lerp(cast(f32)1,cast(f32)0,cast(f32)(pos.x-cam.x+(defalt_sound_intesity/2))/defalt_sound_intesity),"  ")
    rl.SetSoundVolume(sound,(math.clamp(math.abs(math.lerp(cast(f32)1,cast(f32)0,math.sqrt(math.pow_f32(cam.x-sound_.pos.x,2)+math.pow_f32(cam.y-sound_.pos.y,2))/defalt_sound_intesity)),0,1)*-1)*sound_.v_multiplier)
    //fmt.print(math.clamp(math.abs(math.lerp(cast(f32)0,cast(f32)1,math.sqrt(math.pow_f32(cam.x-pos.x,2)+math.pow_f32(cam.y-pos.y,2))/defalt_sound_intesity)),0,1)*-1,"   \n")


    rl.PlaySound(sound)

    append(&g_mem.assets.sound_aliases, sound_)
    
}

manage_sound_bytes::proc(){
    cam3 := g_mem.cam.target+{(cast(f32)rl.GetScreenWidth()/zoom)/2,(cast(f32)rl.GetScreenHeight()/zoom)/2,0}
    cam:=cam3.xy
    for &sound_byte,i in sound_aliases{
        if rl.IsSoundPlaying(sound_byte.sound){
            if sound_byte.has_pos{
                // if sound_byte.lock_to_entity{
                //     // fmt.print(all_entitys.data[sound_byte.entity_lock.id].gen ,"     ", sound_byte.entity_lock.gen,"\n")
                //     if all_entitys.data[sound_byte.entity_lock.id].gen == sound_byte.entity_lock.gen{
                //         sound_byte.pos=all_entitys.data[sound_byte.entity_lock.id].entity.pos
                        
                //     // }else{
                //         rl.StopSound(sound_byte.sound)
                //     // }
                //     // if !dos_entity_exist(sound_byte.entity_lock){
                //         // rl.StopSound(sound_byte.sound)
                //     // }
                // }
                rl.SetSoundPan(sound_byte.sound, math.lerp(cast(f32)1,cast(f32)0,cast(f32)(sound_byte.pos.x-cam.x+(defalt_sound_intesity/2))/defalt_sound_intesity))
                //fmt.print(math.lerp(cast(f32)1,cast(f32)0,cast(f32)(pos.x-cam.x+(defalt_sound_intesity/2))/defalt_sound_intesity),"  ")
                rl.SetSoundVolume(sound_byte.sound,(math.clamp(math.abs(math.lerp(cast(f32)0,cast(f32)1,math.sqrt(math.pow_f32(cam.x-sound_byte.pos.x,2)+math.pow_f32(cam.y-sound_byte.pos.y,2))/defalt_sound_intesity)),0,1)*-1+1)*sound_byte.v_multiplier)
                //fmt.print(math.clamp(math.abs(math.lerp(cast(f32)0,cast(f32)1,math.sqrt(math.pow_f32(cam.x-pos.x,2)+math.pow_f32(cam.y-pos.y,2))/defalt_sound_intesity)),0,1)*-1+1,"   \n")
                
            }
        }else{
            rl.UnloadSoundAlias(sound_byte.sound)
            unordered_remove(&sound_aliases, i) 
        }
    }
}

play_sound::proc(s_name:sound_names,v_multiplier:f32=1,pitch:f32 = 1){
    cam3 := g_mem.cam.target+{(cast(f32)rl.GetScreenWidth()/zoom)/2,(cast(f32)rl.GetScreenHeight()/zoom)/2,0}
    cam:=cam3.xy
    sound:=rl.LoadSoundAlias(g_mem.assets.sounds[s_name])
    // rl.SetSoundPan(sound, math.lerp(cast(f32)1,cast(f32)0,cast(f32)(pos.x-cam.x+(defalt_sound_intesity/2))/defalt_sound_intesity))
    //fmt.print(math.lerp(cast(f32)1,cast(f32)0,cast(f32)(pos.x-cam.x+(defalt_sound_intesity/2))/defalt_sound_intesity),"  ")
    rl.SetSoundVolume(sound,v_multiplier)
    //fmt.print(math.clamp(math.abs(math.lerp(cast(f32)0,cast(f32)1,math.sqrt(math.pow_f32(cam.x-pos.x,2)+math.pow_f32(cam.y-pos.y,2))/defalt_sound_intesity)),0,1)*-1,"   \n")

    
    rl.SetSoundPitch(sound,pitch)
    rl.PlaySound(sound)
    s_bty:sound_byte
    s_bty.lock_to_entity=false
    // s_bty.entity_lock=entity_lock
    s_bty.v_multiplier=v_multiplier
    // s_bty.pos = pos
    s_bty.has_pos = false
    s_bty.sound = sound
    s_bty.intesity = defalt_sound_intesity
    append(&g_mem.assets.sound_aliases, s_bty)
    
}

update_song::proc(){
    // if !rl.IsMusicStreamPlaying(g_mem.assets.music){
    //     fmt.print("sdasdasdasdasdkjhakdjsfhaskjdhflkajsdfhkljsdhkjsldfhalkjsdhfkjasdhf")
    //     rl.PlayMusicStream(g_mem.assets.music)      
    //     rl.SetMusicVolume(g_mem.assets.music , .25)                      // Start music playing
    // }
    rl.UpdateMusicStream(g_mem.assets.music)
}
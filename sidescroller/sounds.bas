	#include "SDL2/SDL_mixer.bi"
	
	function load_sound(fname as string) as Mix_Chunk ptr
	    dim as Mix_Chunk ptr snd
	    snd = Mix_LoadWAV(fname)
	    if snd = 0 then
		print #1, "Failed to load " + fname + " : "; Mix_GetError()
	    end if
	    return snd
	end function

	sub init_sound()
	    Mix_OpenAudio( 48000 , AUDIO_S16SYS , 2 , 2048 )
	end sub

	sub load_and_play(byref snd as Mix_Chunk ptr, fname as string)
	    if snd = 0 then
		snd = load_sound(fname)
	    end if
	    if snd <> 0 then
		Mix_PlayChannel( -1 , snd, 0 )
	    end if	    
	end sub

	sub aliens_fire_sound
	    static as Mix_Chunk ptr aliens_fire_chunk
	    load_and_play(aliens_fire_chunk, "sounds/321102__nsstudios__laser1.wav")
	end sub
	
	sub missile_fire_sound
	    static as Mix_Chunk ptr missile_fire_chunk
	    load_and_play(missile_fire_chunk, "sounds/414888__matrixxx__retro_laser_shot_04.wav")
	end sub

	sub alien_launch_sound
	    static as Mix_Chunk ptr aliens_launch_chunk
	    load_and_play(aliens_launch_chunk, "sounds/34557__timkahn__reverse-bass-blip.wav")
	end sub

	sub alien_explode_sound
	    static as Mix_Chunk ptr aliens_explode_chunk
	    load_and_play(aliens_explode_chunk, "sounds/170144__timgormly__8-bit-explosion2.wav")
	end sub

	sub missile_base_explode_sound
	    static as Mix_Chunk ptr missile_base_chunk
	    load_and_play(missile_base_chunk, "sounds/587190__derplayer__explosion_04.wav")
	end sub

	sub fuel_depot_explode_sound
	    static as Mix_Chunk ptr fuel_depot_chunk
	    load_and_play(fuel_depot_chunk, "sounds/435416__v-ktor__explosion13.wav")
	end sub

	sub missile_explode_sound
	    missile_base_explode_sound()
	end sub

	sub extra_life_sound
	    static as Mix_Chunk ptr extra_life_chunk
	    load_and_play(extra_life_chunk, "sounds/614973__strangehorizon__bronze_bell_b_1.wav")
	end sub	

	sub player_explode_sound
	    static as Mix_Chunk ptr player_explode_chunk
	    load_and_play(player_explode_chunk, _
			  "sounds/110115__ryansnook__small-explosion.wav")
	end sub

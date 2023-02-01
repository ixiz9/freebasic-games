    'All sounds are from freesound.org and licensed under CC
    'Sources:
    'https://freesound.org/people/andersmmg/sounds/523423/
    'https://freesound.org/people/jeremysykes/sounds/341242/
    'https://freesound.org/people/Kodack/sounds/258020/
    'https://freesound.org/people/Aesterial-Arts/sounds/633248/
    

    
    #ifdef SOUND
	#include "SDL2/SDL_mixer.bi"
	
	dim shared as Mix_Chunk ptr eat_dot_sound, eat_powerup_sound
	dim shared as Mix_Chunk ptr eat_ghost_sound, eat_pman_sound
	
    #endif

    #ifdef SOUND
	sub load_sound(byref snd as Mix_Chunk ptr, fname as string)
	    snd = Mix_LoadWAV(fname)
	    if snd = 0 then
		print #1, "Failed to load " + fname + " : "; Mix_GetError()
	    end if
	end sub
    #else
	sub load_sound(snd as any ptr, fname as string)
	end sub
    #endif

    sub init_sound()
	#ifdef SOUND
	    Mix_OpenAudio( 48000 , AUDIO_S16SYS , 2 , 2048 )
	    load_sound(eat_dot_sound, _
		       "sounds/523423__andersmmg__bloop.wav" )
	    load_sound(eat_powerup_sound, _
		       "sounds/341242__jeremysykes__powerup01.wav" )
	    load_sound(eat_ghost_sound, _
		       "sounds/258020__kodack__arcade-bleep-sound.wav" )
	    load_sound(eat_pman_sound, _
		       "sounds/633248__aesterial-arts__arcade-die.wav" )
	#endif
    end sub

    sub play_eat_dot()
	#ifdef SOUND
	    if eat_dot_sound <> 0 then
		Mix_PlayChannel( -1 , eat_dot_sound, 0 )
	    end if
	#endif
    end sub

    sub play_eat_powerup()
	#ifdef SOUND
	    if eat_powerup_sound <> 0 then 
		Mix_PlayChannel( -1 , eat_powerup_sound, 0 )
	    end if
	#endif
    end sub
    
    sub play_eat_ghost()
	#ifdef SOUND
	    if eat_ghost_sound <> 0 then 
		Mix_PlayChannel( -1 , eat_ghost_sound, 0 )
	    end if
	#endif
    end sub

    sub play_eat_pman()
	#ifdef SOUND
	    if eat_pman_sound <> 0 then
		Mix_PlayChannel( -1 , eat_pman_sound, 0 )
	    end if
	#endif
    end sub

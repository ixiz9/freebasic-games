    'Define for the maze in the shape of the word "2023"
    'Remove this define for a more traditional maze
    '#define V2023

    'avoid conflict with windows 
    #define MMIN(a,b)  (iif((a) < (b), (a), (b)))
    #define MMAX(a,b)  (iif((a) > (b), (a), (b)))
    'These includes have nothing specific to pman
    #include "gaming.bas"
    #include "alphatext.bas"

    'maze related globals and defines
    dim shared as integer maze_w, maze_h
    #define EMPTY 0
    #define FOOD 1
    #define POWERUP 2
    #define GHOST_HOME 3
    #define WALL 4
    #define HOME_WALL 5
    dim shared as my_coord ghost_door
    dim shared as integer total_food
    dim shared as my_coord pman_start
    dim shared as integer maze(any, any), saved_maze(any,any)

    'graphics objects
    dim shared as integer screen_w = 1920, screen_h = 1080
    dim shared as fb.image ptr maze_walls_image
    dim shared as integer maze_xfactor 
    dim shared as integer maze_yfactor    
    dim shared as integer sprite_xfactor
    dim shared as integer sprite_yfactor
    dim shared as integer wall_thickness
    dim shared as integer winfont_factor
    dim shared as integer scorefont_factor
    dim shared as integer bonusfont_factor

    dim shared as sprite pman
    #define BLINKY 1
    #define INKY 2
    #define PINKY 3
    #define CLYDE 4
    #define MAX_GHOSTS 4
    type ghost
	as my_coord corner
	as my_coord home
	as sprite gsprite
	as double start_time
	as integer algorithm
    end type
    dim shared as integer num_ghosts
    dim shared as ghost ghosts(MAX_GHOSTS)
    dim shared as blockfont win_font
    dim shared as blockfont score_font
    dim shared as blockfont bonus_font
    dim shared as integer food_factor
    dim shared as sprite food_sprite

    #include "sounds.bas"
    #ifndef VLAYOFFS
    #include "assets.bas"
    #endif

    'general gameplay variables
    #define MAX_BONUSES 10
    type display_bonus
	as my_coord mz
	as double expiration
	as integer bonus_val
    end type
    dim shared as display_bonus bonuses(MAX_BONUSES)
    dim shared as integer bonusc = 0
    dim shared as integer bonus_amount
    
    dim shared as double frames_per_sec
    dim shared as double time_now
    dim shared as double powerup_end
    #define POWERUP_DURATION 10
    dim shared as integer Score, HiScore
    dim shared as integer lives
    dim shared as integer food_left
    dim shared as DirVect Directions(4)
    #define DIR_NONE 0
    #define DIR_UP 1
    #define DIR_RIGHT 2
    #define DIR_DOWN 3
    #define DIR_LEFT 4
    #define PMAN_EATEN 1
    #define GHOST_EATEN 2

    
    #define DISTANCE(c1, c2) (sqr(((c1).x-(c2).x)^2 + ((c1).y-(c2).y)^2))
    #define MAZE_AT(c) (maze((c).x , (c).y))

    sub update_sprite_xy_from_mz(sp as sprite ptr)
	sp->x = (sp->mz.x - 1) * maze_xfactor + maze_xfactor/2 - sp->w/2
	sp->y = (sp->mz.y - 1) * maze_yfactor + maze_yfactor/2 - sp->h/2
    end sub

    #ifdef VLAYOFFS
    #include "assets_lo.bas"
    #endif

    sub reset_pman
	with pman
	    .mz = pman_start
	    .vx = 0
	    .vy = 0
	    .targ = .mz
	    .cycle_count = 1
	    .time_to_cross(ALIVE) = 0.15
	    .frame_count = 0
	    .state = ALIVE
	    .pref_dir = Directions(DIR_NONE)
	    .cur_dir = Directions(DIR_NONE)
	end with
	update_sprite_xy_from_mz(@pman)
    end sub	

    sub reset_ghosts
	for i as integer = 1 to num_ghosts
	    with ghosts(i).gsprite
		.mz = ghosts(i).home
		.vx = 0
		.vy = 0
		.targ = .mz
		.cycle_count = 1
		.time_to_cross(ALIVE) = 0.2  'a little slower than pman
		.time_to_cross(FLEEING) = 0.4 'a lot slower than pman
		.time_to_cross(DYING) = 0.05 'very fast
		.frame_count = 0
		.state = ALIVE
		.pref_dir = Directions(DIR_NONE)
		.cur_dir = Directions(DIR_NONE)
	    end with
	    'a new ghost exits the ghost house every 5 seconds
	    ghosts(i).start_time = time_now + i * 5	    
	    update_sprite_xy_from_mz(@ghosts(i).gsprite)
	next
	
    end sub

    sub reset_maze
	for i as integer = 0 to maze_w + 1
	    for j as integer = 0 to maze_h + 1
		maze(i,j) = saved_maze(i,j)
	    next
	next
    end sub
    
    sub reset_bonuses
	bonusc = 0
    end sub

    sub reset_globals
	frames_per_sec = 0
	time_now = 0
	powerup_end = 0
	Score = 0
	lives = 3
	food_left = total_food
    end sub	

    'pressing a direction key (WASD) sets that to be pman's preferred direction.
    'He will go in that direction (if he can) as soon as he finishes his current
    'move between board tiles. 
    function pman_keys(pm as sprite ptr) as integer
	dim as string pressed = KeysPressed("wasd/")
	if pressed <> "" then
	    if instr(pressed,"/") > 0 then return 1
	    if instr(pressed,"a") > 0 then
		pm->pref_dir = Directions(DIR_LEFT)
	    elseif instr(pressed,"d") > 0 then
		pm->pref_dir = Directions(DIR_RIGHT)
	    elseif instr(pressed,"w") > 0 then
		pm->pref_dir = Directions(DIR_UP)
	    elseif instr(pressed,"s") > 0 then
		pm->pref_dir = Directions(DIR_DOWN)
	    end if
	end if
	return 0
    end function

    sub pman_new_target(pm as sprite ptr)
	dim as DirVect dv(2)
	dv(1) = pm->pref_dir
	dv(2) = pm->cur_dir
	for i as integer = 1 to 2
	    if MAZE_AT(coord_add(pm->mz, dv(i))) < WALL then
		pm->targ = coord_add(pm->mz, dv(i))
		pm->cur_dir = dv(i)
		exit for
	    end if
	next
    end sub

    'Moves a sprite 1 frame between tiles.
    'returns true if this move completes the transition between tiles and
    'a new target tile should be selected
    function move_sprite(sp as sprite ptr) as boolean
	dim as boolean retval
	sp->cycle_count -= 1
	if sp->cycle_count > 0 then
	    'interim frame, sprite is between tiles
	    sp->x += sp->vx
	    sp->y += sp->vy
	    retval = false
	else
	    'final frame of a tile move
	    sp->mz = sp->targ
	    'implement wraparound tunnel
	    if sp->mz.x > maze_w then sp->mz.x = 1
	    if sp->mz.x < 1 then sp->mz.x = maze_w
	    'realign on the current tile to avoid numerical drift
	    update_sprite_xy_from_mz(sp)
	    sp->vx = 0
	    sp->vy = 0
	    retval = true
	end if
	return retval
    end function

    sub calculate_sprite_velocity(sp as sprite ptr)
	'translate move selection from tiles to screen coordinates
	dim as double dx,dy,frames
	dx = (sp->targ.x - sp->mz.x) * maze_xfactor
	dy = (sp->targ.y - sp->mz.y) * maze_yfactor
	'How many frames should the move across the tile take?
	frames = sp->time_to_cross(sp->state) * frames_per_sec
	sp->vx = dx / frames
	sp->vy = dy / frames
	if dx <> 0 or dy <> 0 then
	    sp->cycle_count = frames
	else
	    'if for some reason we could not move, try again next frame
	    sp->cycle_count = 1
	end if
    end sub

    function move_pman() as integer
	if pman_keys(@pman) then return 1
	if move_sprite(@pman) then 
	    if MAZE_AT(pman.mz) = FOOD then
		MAZE_AT(pman.mz) = 0
		food_left -= 1
		Score += 10
		play_eat_dot()
	    end if
	    if MAZE_AT(pman.mz) = POWERUP then
		MAZE_AT(pman.mz) = 0
		for i as integer = 1 to num_ghosts
		    ghosts(i).gsprite.state = FLEEING
		    ghosts(i).gsprite.state_change = 1
		next 
		powerup_end = time_now + POWERUP_DURATION
		bonus_amount = 0
		play_eat_powerup()
	    end if

	    pman_new_target(@pman)
	    calculate_sprite_velocity(@pman)
	end if
	return 0
    end function

    function ghost_can_go_there(sp as sprite ptr, c as my_coord) as integer
	if MAZE_AT(c) = WALL then return 0
	if MAZE_AT(c) < WALL then return 1
	'Get here if the ghost is trying to go through the door of the ghost
	'house. OK to go out through the door
	if MAZE_AT(sp->mz) = GHOST_HOME then return 1
	'But can only go in if it's in DYING (eyes) state
	if sp->state = DYING then return 1
	return 0
    end function

    'These ghost target selections are pretty close to what is
    'described here https://www.gamedeveloper.com/design/the-pac-man-dossier
    function blinky_goal(g as ghost ptr) as my_coord
	return pman.mz
    end function
	
    function clyde_goal(g as ghost ptr) as my_coord
	dim as double d = DISTANCE(pman.mz, g->gsprite.mz)
	'8?? Apparently that's the clyde algorithm
	if d > 8 then
	    return pman.mz
	else
	    return g->corner
	end if
    end function

    function pinky_goal(g as ghost ptr) as my_coord
	dim as my_coord c
	dim as DirVect v
	for i as integer = 5 to 0 step -1
	    v.dx = i * pman.cur_dir.dx
	    v.dy = i * pman.cur_dir.dy
	    c = coord_add(pman.mz, v)
	    if c.x >= 0 andalso c.x <= maze_w andalso _
	       c.y >= 0 andalso c.y <= maze_h andalso _
	       MAZE_AT(c) < WALL then
		return c
	    end if
	next
	return g->corner
    end function

    'in the original game inky's target is calculated based on both pman's
    'location and blinky, but I want to support an arbitrary selection of ghosts
    'which may not have a blinky, so I prefer each ghost be independent 
    function inky_goal(g as ghost ptr) as my_coord
	dim as my_coord c
	dim as DirVect v
	'find a random location somewhere near pman that is not a wall
	for i as integer = 1 to 4
	    v.dx = int(rnd() * 7) - 3
	    v.dx = int(rnd() * 7) - 3
	    c = coord_add(pman.mz, v)
	    if c.x >= 0 andalso c.x <= maze_w andalso _
	       c.y >= 0 andalso c.y <= maze_h andalso _
	       MAZE_AT(c) < WALL then
		return c
	    end if
	next
	return g->corner
    end function
	    

    'Select one of the 4 adjacent tiless for the ghost to move to. Most of the
    'process is the same for all ghosts with just the hunting behavior different
    sub ghost_new_target(g as ghost ptr)
	dim as my_coord goal
	if time_now < g->start_time then
	    'Either the ghost has been eaten and should return to the ghost
	    'house and be there for a while, or it has not started yet and 
	    'should remain in the ghost house
	    goal = g->home
	    'Ghosts in their home are allowed not to move, all others must move
	    if g->gsprite.mz.x = goal.x and g->gsprite.mz.y = goal.y then
		g->gsprite.cur_dir = Directions(DIR_NONE)
		return
	    end if
	elseif g->gsprite.state = DYING then
	    'Ghost was in the "eyes" state long enough
	    g->gsprite.state = ALIVE
	    g->gsprite.state_change = 1
	end if
	    
	if g->gsprite.state = FLEEING then
	    goal = g->corner
	elseif g->gsprite.state = ALIVE then
	    if MAZE_AT(g->gsprite.mz) = GHOST_HOME then
		goal = ghost_door
	    else
		select case g->algorithm
		case BLINKY
		    goal = blinky_goal(g)
		case INKY
		    goal = inky_goal(g)
		case PINKY
		    goal = pinky_goal(g)
		case CLYDE
		    goal = clyde_goal(g)
		end select		    
	    end if
	end if
	    
	dim as DirVect best_dir = Directions(DIR_NONE)
	if g->gsprite.state_change = 1 then
	    'A state change forces a direction flip, as in the original game
	    best_dir.dx = - g->gsprite.cur_dir.dx
	    best_dir.dy = - g->gsprite.cur_dir.dy
	    g->gsprite.state_change = 0
	else 
	    dim as double shortest = maze_w + maze_h
	    'Search for the move that will bring us closest to our
	    'goal, disallowing a return to the tile we just left
	    for i as integer = 1 to 4
		if Directions(i).dx + g->gsprite.cur_dir.dx = 0 and _
		   Directions(i).dy + g->gsprite.cur_dir.dy = 0 then
		    continue for
		end if
		
		dim as my_coord td = coord_add(g->gsprite.mz, Directions(i))
		if  ghost_can_go_there(@(g->gsprite), td) then
		    dim as double dist = DISTANCE(td, goal)
		    if dist < shortest then
			best_dir = Directions(i)
			shortest = dist
		    end if
		end if
		
	    next
	end if
	g->gsprite.targ = coord_add(g->gsprite.mz, best_dir)
	g->gsprite.cur_dir = best_dir
    end sub    

    
    function move_ghost(g as ghost ptr) as integer
	dim as integer pmx,pmy,gmx,gmy
	dim as integer retval = 0 

	'pman and the ghosts are always moving between tiles
	'determine which tile they are currently on by seeing
	'where the center of sprite falls
	pmx = int((pman.x + pman.w/2.0) / maze_xfactor) + 1
	pmy = int((pman.y + pman.h/2.0) / maze_yfactor) + 1
	gmx = int((g->gsprite.x + g->gsprite.w/2.0) / maze_xfactor) + 1
	gmy = int((g->gsprite.y + g->gsprite.h/2.0) / maze_yfactor) + 1

	if pmx = gmx and pmy = gmy then
	    if g->gsprite.state = ALIVE then return PMAN_EATEN
	    if g->gsprite.state = FLEEING then
		g->gsprite.state = DYING
		g->gsprite.state_change = 1
		g->gsprite.frame_count = 0
		'Eaten ghost remain in "eyes" state for 5 seconds
		g->start_time = time_now + 5
		retval = GHOST_EATEN
	    end if
	end if
	
	if g->gsprite.state = FLEEING and time_now > powerup_end then
	    g->gsprite.state = ALIVE
	    g->gsprite.state_change = 1
	end if

	if move_sprite(@(g->gsprite))  then
	    ghost_new_target(g)
	    calculate_sprite_velocity(@(g->gsprite))
	end if
	return retval
    end function
    
    sub draw_ghost(g as ghost ptr, maze_x as integer, maze_y as integer)
	g->gsprite.frame_count += 1
	dim as integer imgn = 1
	'swap between animation frame every 1/4 of a second
	dim as integer frames_per_image = (frames_per_sec / 4) + 1
	dim as integer c = (g->gsprite.frame_count \ frames_per_image) mod 2

	if g->gsprite.state = FLEEING then
	    imgn = 1 + c
	    'in the last 3 seconds of ghosts fleeing from pman we toggle
	    'their color
	    if powerup_end - time_now < 3 then
		dim as integer k
		k = int(abs(powerup_end - time_now)*3 + 0.5) mod 2
		imgn += k * 2
	    end if
	elseif g->gsprite.state = ALIVE or g->gsprite.state = DYING then
	    dim as integer dirn = DIR_DOWN
	    'Pick the image that corresponds to the movement direction
	    'Ghosts eyes point to where they are going
	    for i as integer = 1 to 4
		if DirVectSame(g->gsprite.cur_dir, Directions(i)) then
		    dirn = i
		    exit for
		end if
	    next   
	    if g->gsprite.state = ALIVE then
		'Ghosts that are alive have 2 animation frames per direction
		imgn = dirn*2 + c - 1
	    else
		'Ghosts in "eyes" state (= DYING) have one frame per direction
		imgn = dirn
	    end if
	end if
	put (g->gsprite.x + maze_x,g->gsprite.y + maze_y), _
	    g->gsprite.images(g->gsprite.state).img(imgn), trans
    end sub

    'Draw pman with mouth in the right direction and flip between open and
    'closed images. Also draws the animation when pman has been eaten.
    sub draw_pman(maze_x as integer, maze_y as integer)
	dim as integer frames_per_image = (frames_per_sec / 4) + 1
	pman.frame_count += 1
	if pman.state = ALIVE then
	    dim as integer c = (pman.frame_count \ frames_per_image) mod 2
	    dim as integer imgn
	    imgn = 5
	    #ifdef VLAYOFFS
	    c = 1
	    #endif
	    if c = 1 then
		for i as integer = 1 to 4
		    if DirVectSame(pman.cur_dir, Directions(i)) then
			imgn = i
			exit for
		    end if
		next 
	    end if
	    put (pman.x + maze_x,pman.y + maze_y), _
		pman.images(ALIVE).img(imgn), trans
	else
	    dim as integer death_anim_frames = ubound(pman.images(DYING).img)
	    dim as integer imgn = ((pman.frame_count - 1) \ frames_per_image) + 1
	    if imgn <= death_anim_frames then
		put (pman.x + maze_x,pman.y + maze_y), _
		    pman.images(DYING).img(imgn), trans
	    else 
		pman.state = DEAD
	    end if	    
	end if
    end sub
   

    'Draw on the screen bonuses that pman recently got
    sub draw_bonuses(maze_x as integer, maze_y as integer)
	for i as integer = 1 to bonusc
	    dim as integer x,y
	    dim as string s = str(bonuses(i).bonus_val)
	    dim as integer w = draw_text(0,0,s,@bonus_font, 0)
	    dim as integer h = bonus_font.max_height
	    x = (bonuses(i).mz.x - 1) * maze_xfactor + maze_xfactor/2 - w/2
	    y = (bonuses(i).mz.y - 1) * maze_yfactor + maze_yfactor/2 - h/2
	    draw_text(maze_x + x, maze_y + y,s,@bonus_font,1)
	next
    end sub

    'When pman eats a ghost we draw on the screen the bonus amount.
    sub add_bonus(mz as my_coord, amount as integer, expiration as double)
	bonusc += 1
	assert(bonusc < MAX_BONUSES)
	with bonuses(bonusc)
	    .mz = mz
	    .expiration = expiration
	    .bonus_val = amount
	end with
    end sub

    'Remove bonuses that should no longer be displayed on the screen
    sub expire_bonuses
	dim as integer i = 1
	do while i <= bonusc
	    if time_now > bonuses(i).expiration then
		bonuses(i) = bonuses(bonusc)
		bonusc -= 1
		i -= 1
	    end if
	    i += 1
	loop
    end sub

    'Write the score and hi score at the top of the screen
    sub draw_score()
	draw_text(2*maze_xfactor, maze_yfactor, _
		  "S:" & Score, @score_font, 1)
	if score > hiscore then hiscore = score
	dim as integer w = draw_text(0,0, _
	    "HI:" & HiScore, @score_font, 0)
	draw_text(screen_w - w - 2*maze_xfactor, maze_yfactor, _
		  "HI:" & HiScore, @score_font, 1)

	w = 2*maze_xfactor
	for i as integer = 1 to lives - 1
	    put (w, screen_h - pman.images(ALIVE).img(2)->height - maze_yfactor), _
		pman.images(ALIVE).img(2), trans
	    w += pman.images(ALIVE).img(2)->width + maze_xfactor
	next
    end sub

    'Let's the user pick a resolution and sets graphics constants accordingly
    'These could have been computed automatically but often sometimes need a
    'little manual tweaking
    sub pick_resolution
	dim as integer res
	do
	    print "Pick you game resolution:"
	    print "1) 800x600"
	    print "2) 1024x768"
	    print "3) 1280x720"
	    print "4) 1280x800"
	    print "5) 1366x768"
	    print "6) 1440x900"
	    print "7) 1920x1080"
	    print "q) quit"
	    res = getkey()
	    if res = ASC("q") then end
	    res -= ASC("0")
	loop while res < 1 or res > 7
	select case res
	case 1
	    screen_w = 800
	    screen_h = 600
	    #ifdef V2023
	    maze_xfactor = 20
	    maze_yfactor = 16
	    sprite_xfactor = 1
	    sprite_yfactor = 1
	    food_factor = 1
	    #else
	    maze_xfactor = 26
	    maze_yfactor = 20
	    sprite_xfactor = 2
	    sprite_yfactor = 2
	    food_factor = 1
	    #endif
	    wall_thickness = 3
	    winfont_factor = 10
	    scorefont_factor = 3
	    bonusfont_factor = 2
	case 2
	    screen_w = 1024
	    screen_h = 768
	    #ifdef V2023
	    maze_xfactor = 24
	    maze_yfactor = 20
	    #else
	    maze_xfactor = 28
	    maze_yfactor = 26
	    #endif
	    wall_thickness = 3
	    sprite_xfactor = 2
	    sprite_yfactor = 2
	    food_factor = 1
	    winfont_factor = 15
	    scorefont_factor = 4
	    bonusfont_factor = 2
	case 3
	    screen_w = 1280
	    screen_h = 720
	    #ifdef V2023
	    maze_xfactor = 30
	    maze_yfactor = 20
	    #else
	    maze_xfactor = 33
	    maze_yfactor = 24
	    #endif
	    wall_thickness = 3
	    sprite_xfactor = 2
	    sprite_yfactor = 2
	    food_factor = 2
	    winfont_factor = 16
	    scorefont_factor = 5
	    bonusfont_factor = 2
	case 4
	    screen_w = 1280
	    screen_h = 800
	    #ifdef V2023
	    maze_xfactor = 30
	    maze_yfactor = 22
	    #else
	    maze_xfactor = 33
	    maze_yfactor = 27
	    #endif
	    wall_thickness = 3
	    sprite_xfactor = 2
	    sprite_yfactor = 2
	    food_factor = 2
	    winfont_factor = 18
	    scorefont_factor = 5
	    bonusfont_factor = 2
	case 5
	    screen_w = 1366
	    screen_h = 768
	    #ifdef V2023
	    maze_xfactor = 32
	    maze_yfactor = 22
	    #else
	    maze_xfactor = 34
	    maze_yfactor = 28
	    #endif
	    wall_thickness = 3
	    sprite_xfactor = 2
	    sprite_yfactor = 2
	    food_factor = 2
	    winfont_factor = 20
	    scorefont_factor = 5
	    bonusfont_factor = 2
	case 6
	    screen_w = 1440
	    screen_h = 900
	    maze_xfactor = 36
	    #ifdef V2023
	    maze_yfactor = 26
	    #else
	    maze_yfactor = 32
	    #endif
	    wall_thickness = 3
	    sprite_xfactor = 2
	    sprite_yfactor = 2
	    food_factor = 2
	    winfont_factor = 24
	    scorefont_factor = 6
	    bonusfont_factor = 2
 	case 7
	    screen_w = 1920
	    screen_h = 1080
	    #ifdef V2023
	    maze_xfactor = 48
	    maze_yfactor = 30
	    #else
	    maze_xfactor = 50
	    maze_yfactor = 36
	    #endif
	    wall_thickness = 3
	    sprite_xfactor = 3
	    sprite_yfactor = 3
	    food_factor = 2
	    winfont_factor = 30
	    scorefont_factor = 8
	    bonusfont_factor = 3
	end select
    end sub


    Directions(DIR_NONE).dx = 0 : Directions(DIR_NONE).dy = 0
    Directions(DIR_UP).dx = 0 : Directions(DIR_UP).dy = -1
    Directions(DIR_RIGHT).dx = 1 : Directions(DIR_RIGHT).dy = 0
    Directions(DIR_DOWN).dx = 0 : Directions(DIR_DOWN).dy = 1
    Directions(DIR_LEFT).dx = -1 : Directions(DIR_LEFT).dy = 0
    
    open cons for output as #1 ' open console to file numer 1
    pick_resolution()
    
    screenres screen_w, screen_h, 32
    dim as double start_t, end_t

    def_maze
    def_letters
    def_pman
    def_ghosts
    #ifdef VLAYOFFS
    def_food
    #endif

    bonus_font = make_font(bonusfont_factor, bonusfont_factor, "W")
    win_font = make_font(winfont_factor, winfont_factor, "W")
    score_font = make_font(scorefont_factor, scorefont_factor, "W")

    cls
    #ifdef V2023
    #define V2023NAME "2023" NL
    #else
    #define V2023NAME ""
    #endif
    #ifdef VLAYOFFS
	#define GNAME "TECHMAN"
	#define SUCCESSM "RETIRE" NL "RICH!"
	#define TAGLINE "AVOID LAYOFFS "
	#define FAILM "LAYED" NL "OFF!"
    #else
    #define GNAME "PMAN"
    #define SUCCESSM "WINNER"
    #define TAGLINE ""
    #define FAILM "SORRY!"
    #endif
    draw_centered(screen_w, screen_h, _
		  "WELCOME TO " GNAME NL _
		  TAGLINE V2023NAME NL  _
		  "KEYS:           " NL _
		  " W,A,S,D TO MOVE" NL _
		  "       / TO QUIT" NL NL _
		  "PRESS ANY KEY TO START", _
		  @score_font)
    dim as integer k = getkey()
    if k = ASC("/") then end

    init_sound()
    maze_walls_image = ImageCreate(maze_w*maze_xfactor, maze_h*maze_yfactor, _
		       RGB(0,0,0), 32)
    draw_wall_outlines(maze_walls_image)
    draw_maze(maze_walls_image)


    dim as integer maze_x = (screen_w - maze_w * maze_xfactor) / 2
    dim as integer maze_y = (screen_h - maze_h * maze_yfactor) / 2

    start_t = timer()
    draw_maze(maze_walls_image)
    end_t = timer()
    frames_per_sec = 1. / (end_t - start_t)

    
    dim as integer quit, frame_counter, last_frame_counter
    dim as double last_sec, start_fps_agg
    #define FPSAGG 40
    do
	reset_globals
	reset_pman
	reset_ghosts
	reset_maze
	reset_bonuses
	frame_counter = 0
	start_t = timer()
	start_fps_agg = start_t
	do
	    time_now = timer() - start_t
	    dim as integer eaten
	    expire_bonuses
	    if pman.state = ALIVE then
		quit = move_pman()
		if quit > 0 then exit do
		for i as integer = 1 to num_ghosts
		    eaten = move_ghost(@ghosts(i))
		    if eaten = PMAN_EATEN then			
			pman.state = DYING
			pman.frame_count = 0
			play_eat_pman()
		    end if
		    if eaten = GHOST_EATEN then
			bonus_amount += 200
			score += bonus_amount
			play_eat_ghost()
			add_bonus(ghosts(i).gsprite.mz, bonus_amount, _
				  time_now + 3)
		    end if
		next
	    end if

	    screenlock
	    cls

	    draw_maze(maze_walls_image)
	    draw_bonuses(maze_x, maze_y)
	    draw_score()
	    for i as integer = 1 to num_ghosts
		draw_ghost(@ghosts(i), maze_x, maze_y)
	    next
	    draw_pman(maze_x, maze_y)
	    screenunlock
	    frame_counter += 1
	    dim as double elapsed = timer() - start_t
	    if elapsed < 1 then
		frames_per_sec = frame_counter / elapsed
	    elseif elapsed > last_sec + 1 then
		'recalculate FPS once a second using only the count over frames
		'over the previous second
		frames_per_sec = (frame_counter - last_frame_counter) / (elapsed - last_sec)
		last_frame_counter = frame_counter
		last_sec = elapsed		
	    end if
		
	    sleep 1, 1
	    if pman.state = DEAD then
		reset_pman
		reset_ghosts
		reset_bonuses
		lives -= 1
	    end if
	loop while (food_left > 0) and (lives > 0)

	if food_left = 0 then
	    flash_maze(maze_walls_image, SUCCESSM, @win_font)
	elseif lives = 0 then
	    flash_maze(maze_walls_image, FAILM, @win_font)	
	    cls
	    draw_centered(screen_w, screen_h, _
			  "YOUR SCORE:" NL _
			  & Score &  NL NL _
			  "HI SCORE:" NL _
			  & HiScore & NL NL _
			  "PLAY AGAIN (Y/N)", _
			  @score_font)
	    dim as integer k
	    do 
		k = getkey()
	    loop while k <> asc("y") and k <> asc("n")
	    if k = asc("n") then quit = 1
	end if
	
    loop while quit = 0



    

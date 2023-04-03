    #include "string.bi"
    #define minimum(a,b) (iif((a) < (b), (a), (b)))
    #define maximum(a,b) (iif((a) > (b), (a), (b)))

    #include "gaming.bas"
    #include "alphatext.bas"

    #ifndef NL
	#define NL !"\n"
    #endif

    type vport
	'viewportrt in map coordinates - moves to follow player
	as dbl_coord mp
	'viewport in screen coordinates - constant throughout the game
	as dbl_coord s
	'velocity of movement in map coordinates to follow player, should be
	'faster than max player speed or the player can outrun the viewport
	as dbl_dirvect v
	as integer w,h
	as double diagonal
    end type

    type minfo
	as int_coord min_bounds
	as int_coord max_bounds
	as integer w,h
    end type
    
    type int_box
	as integer x,y,w,h
    end type

    type int_box_list
	as int_box bb(any)
    end type

    'things that we could change to make the level harder
    'we don't really change all of these each level, but we could
    type level_info
	'how long it takes aliens to cross the screen, essentially alien speed
	as double aliens_time_to_cross
	'time for the alien to spin their gun to face the player
	as double aliens_time_to_spin
	'how fast alien bullets move
	as double bullet_time_to_cross
	'how fast bombs take to drop
	as double bomb_time_to_cross
	'Player speed expressed as time to cross the screen
	as double player_time_to_cross
	'Missle speed
	as double missile_time_to_cross
	'Speed of player's shots
	as double shot_time_to_cross
	'total number of alien bullets that can be alive at a time
	as integer max_bullets
	'total number of alien missiles that can be alive at a time
	as integer max_missiles
	'How often we get alien missile bases
	as double percent_missile_bases
	'How often we get fuel depot
	as double percent_fuel
	'How likely an alien is to launch when they see the player
	as double alien_launch_likelihood
	'How likely an alien is to fire at the user
	as double missile_fire_likelihood
	'How likely a killed alien is to turn into an extra life bonus
	as double extra_life_likelihood
	as integer pixels_per_fuel_tank
	'How long a bonus stays on the screem
	as double bonus_duration
	'Miminum delay between alien shots
	as double alien_shot_delay
    end type
    
    dim shared as level_info linfo(10)
    #define LVLI linfo(iif((level) <= 10, (level), 10))
    
    dim shared as fb.image ptr bb_image, grass_image
    dim shared as fb.image ptr player_ship_image
    dim shared as sprite player_sprite
    dim shared as sprite alien_sprites(500)
    dim shared as sprite fuel_sprites(500)
    dim shared as sprite shot_sprites(10)
    dim shared as sprite bullet_sprites(50)
    dim shared as sprite bomb_sprites(2)
    dim shared as sprite missile_sprites(5)
    dim shared as sprite missile_base_sprites(500)
    dim shared as sprite dot_sprites(500)
    dim shared as sprite extra_life_sprites(10)
    dim shared as sprite portal_sprite(1)
    dim shared as dbl_coord stars(500)
    dim shared as integer bblock_xfactor = 5 , bblock_yfactor = 3
    dim shared as integer player_xfactor = 3 , player_yfactor = 3
    dim shared as integer screen_h = 720, screen_w = 1280
    dim shared as boolean auto_shoot, auto_bombs

    dim shared as integer display_vp_left 
    dim shared as integer display_vp_top
    dim shared as integer display_vp_height
    dim shared as integer display_map_height
    dim shared as integer display_radar_left
    dim shared as integer display_radar_top
    dim shared as integer display_radar_height
    dim shared as integer display_fuel_left
    dim shared as integer display_fuel_width
    dim shared as integer display_fuel_top
    dim shared as integer display_fuel_height
    
    #define STAR_FACTOR 10
    dim shared as integer displayed_blocks_x
    dim shared as integer player_start_x, player_start_y
    dim shared as vport viewport, radar_vp
    dim shared as integer background_map_block_x
    dim shared as minfo mapinfo
    dim shared as double frames_per_second
    dim shared as double time_to_reverse = 2
    dim shared as double time_now, time_base
    dim shared as double global_g
    dim shared as double player_fuel
    dim shared as integer score, hi_score
    dim shared as integer level
    dim shared as integer lives
    
    #define MAP_WIDTH_BLOCKS 1000
    'windows doesn't like #define PI
    #define PI_VAL 3.1415
    #define MAXTOWER 8
    dim shared as integer map(MAP_WIDTH_BLOCKS)
    dim shared as int_box_list terrain_box(MAP_WIDTH_BLOCKS)

    dim shared as fb.image ptr background(1)
    dim shared as fb.image ptr collision_map

    dim shared as integer small_text_xscale = 3
    dim shared as integer small_text_yscale = 3    
    dim shared as integer score_text_xscale = 6
    dim shared as integer score_text_yscale = 6    
    dim shared as integer level_text_xscale = 10
    dim shared as integer level_text_yscale = 10
    dim shared as blockfont small_text, score_text
    dim shared as blockfont level_text

    #define PLAYER_SP 1
    #define ALIEN_SP 2
    #define FUEL_SP 3
    #define MISSILE_BASE_SP 4
    #define SHOT_SP 5
    #define BULLET_SP 6
    #define BOMB_SP 7
    #define MISSILE_SP 8
    #define GROUND_SP 9
    #define EXTRA_LIFE_SP 10
    #define PORTAL_SP 11
    #define QUIT_BUTTON 100
    #define OPTIONS_BUTTON 101
    
    #define DISTANCE(c1, c2) (sqr(((c1).x-(c2).x)^2 + ((c1).y-(c2).y)^2))

    #include "assets.bas"
    #include "sounds.bas"
    
    function overlap overload(x1 as double, y1 as double, w1 as integer, h1 as integer, _	
		     x2 as double, y2 as double, w2 as integer, h2 as integer) as boolean
	if x1 >= x2 + w2 then return false
	if x1 + w1 < x2 then return false
	if y1 >= y2 + h2 then return false
	if y1 + h1 < y2 then return false
	return true
    end function

    function overlap overload(b as int_box, _
	     x2 as double, y2 as double, w2 as integer, h2 as integer) as boolean
	return overlap(b.x, b.y, b.w, b.h, x2, y2, w2, h2)
    end function
    
    function overlap overload(b as int_box, _
	     c as dbl_coord, w2 as integer, h2 as integer) as boolean
	return overlap(b.x, b.y, b.w, b.h, c.x, c.y, w2, h2)
    end function

    function overlap overload(b as int_box, _
	     c as int_coord, w2 as integer, h2 as integer) as boolean
	return overlap(b.x, b.y, b.w, b.h, c.x, c.y, w2, h2)
    end function

    sub def_levels
	dim as integer world_pixels = MAP_WIDTH_BLOCKS * bb_image->width
	with linfo(1)
	    .aliens_time_to_cross = 3.5
	    .aliens_time_to_spin = 0.5
	    .bullet_time_to_cross = 8
	    .bomb_time_to_cross = 2
	    .player_time_to_cross = 5
	    .missile_time_to_cross = 4
	    .shot_time_to_cross = 0.5
	    .max_bullets = Minimum(3, ubound(bullet_sprites))
	    .max_missiles = Minimum(2, ubound(missile_sprites))
	    .percent_fuel = .3
	    .percent_missile_bases = 0
	    .alien_launch_likelihood = 0.3
	    .missile_fire_likelihood = 0.3
	    .extra_life_likelihood = 0.8
	    .pixels_per_fuel_tank = world_pixels / 2
	    .bonus_duration = 5
	    .alien_shot_delay = 1
	end with
	linfo(2) = linfo(1)
	with linfo(2)
	    .bullet_time_to_cross = 4.5
	    .max_bullets = Minimum(12, ubound(bullet_sprites))
	    .alien_launch_likelihood = 0.45
	end with	
	linfo(3) = linfo(2)
	with linfo(3)
	    .max_bullets = Minimum(14, ubound(bullet_sprites))
	    .percent_missile_bases = 0.1
	    .alien_shot_delay = 0.75
	end with	
	linfo(4) = linfo(3)
	with linfo(4)
	    .max_bullets = Minimum(16, ubound(bullet_sprites))
	    .missile_fire_likelihood = 0.6
	    .missile_time_to_cross = 1.5
	    .max_missiles = Minimum(3, ubound(missile_sprites))
	    .aliens_time_to_cross = 1.5	    
	end with	
	linfo(5) = linfo(4)
	with linfo(5)
	    .percent_fuel = 0.2
	    .max_bullets = Minimum(18, ubound(bullet_sprites))
	    .alien_launch_likelihood = 0.6
	    .bullet_time_to_cross = 4	    
	    .alien_shot_delay = 0.5
	end with	
	linfo(6) = linfo(5)
	with linfo(6)
	    .missile_fire_likelihood = 0.8
	    .missile_time_to_cross = 1.25
	    .max_missiles = Minimum(4, ubound(missile_sprites))
	    .percent_missile_bases = 0.2
	end with	
	linfo(7) = linfo(6)
	with linfo(7)
	    .max_bullets = Minimum(20, ubound(bullet_sprites))
	    .alien_launch_likelihood = 0.8
	end with	
	linfo(8) = linfo(7)
	with linfo(8)
	    .percent_fuel = 0.1
	    .max_bullets = Minimum(22, ubound(bullet_sprites))
	    .bullet_time_to_cross = 3.5	    
	    .alien_shot_delay = 0.25
	end with	
	linfo(9) = linfo(8)
	with linfo(9)
	    .percent_missile_bases = 0.3
	    .missile_fire_likelihood = 1
	    .missile_time_to_cross = 1
	    .max_missiles = Minimum(6, ubound(missile_sprites))
	end with	
	linfo(10) = linfo(9)
	with linfo(10)
	    .max_bullets = Minimum(25, ubound(bullet_sprites))
	    .bullet_time_to_cross = 3	    
	end with
    end sub


    'called at the start of each level to determine where things (aliens, bases, etc) go on the map
    sub def_terrain
	dim as integer mx = 2
	dim as integer alienc, fuelc, missilebc
	for i as integer = 1 to ubound(fuel_sprites)
	    fuel_sprites(i).state = DEAD
	next
	for i as integer = 1 to ubound(missile_base_sprites)
	    missile_base_sprites(i).state = DEAD
	next
	for i as integer = 1 to ubound(alien_sprites)
	    alien_sprites(i).state = DEAD
	next
	while mx < MAP_WIDTH_BLOCKS - 8
	    mx += int(rnd(1) * 5) + 1
	    dim as integer x = mx * bb_image->width + bb_image->width/2
	    dim as integer y = mapinfo.h - map(mx) * bb_image->height
	    dim as double r = rnd(1)
	    dim as boolean done = false
	    if r < LVLI.percent_fuel and fuelc < ubound(fuel_sprites) then
		fuelc += 1
		def_fuel_depot(fuelc, x, y)
		done = true
	    end if
	    r -= LVLI.percent_fuel
	    if not done and r > 0 and r < LVLI.percent_missile_bases and _
	       missilebc < ubound(missile_base_sprites) then
		missilebc += 1
		def_missile_base(missilebc, x, y)
		done = true
	    end if
	    if not done and alienc < ubound(alien_sprites) then
		alienc += 1
		def_alien(alienc, x, y)
	    end if
	wend
    end sub
	

    sub reset_ammunition
	for i as integer = 1 to ubound(shot_sprites)
	    with shot_sprites(i)
		.who = SHOT_SP
		.mp.x = 0
		.mp.y = 0
		.v.dx = 0
		.v.dy = 0
		.time_to_cross(ALIVE) = LVLI.shot_time_to_cross
		.frame_count = 0
		.state = DEAD
		.cur_dir = DIR_RIGHT
	    end with
	next
	for i as integer = 1 to ubound(bomb_sprites)
	    with bomb_sprites(i)
		.who = BOMB_SP
		.mp.x = 0
		.mp.y = 0
		.v.dx = 0
		.v.dy = 0
		.time_to_cross(ALIVE) = LVLI.bomb_time_to_cross
		.frame_count = 0
		.state = DEAD
		.cur_dir = DIR_NONE
	    end with
	next
	for i as integer = 1 to ubound(missile_sprites)
	    with missile_sprites(i)
		.who = MISSILE_SP
		.mp.x = 0
		.mp.y = 0
		.v.dx = 0
		.v.dy = 0
		.time_to_cross(ALIVE) = LVLI.missile_time_to_cross
		.frame_count = 0
		.state = DEAD
		.cur_dir = DIR_UP
	    end with
	next
	for i as integer = 1 to ubound(bullet_sprites)
	    with bullet_sprites(i)
		.who = BULLET_SP
		.mp.x = 0
		.mp.y = 0
		.v.dx = 0
		.v.dy = 0
		.time_to_cross(ALIVE) = LVLI.bullet_time_to_cross
		.frame_count = 0
		.state = DEAD
		.cur_dir = DIR_NONE
	    end with
	next
	for i as integer = 1 to ubound(alien_sprites)
	    alien_sprites(i).last_shot_time = 0
	next
	for i as integer = 1 to ubound(missile_base_sprites)
	    missile_base_sprites(i).last_shot_time = 0
	next
	for i as integer = 1 to ubound(extra_life_sprites)
	    extra_life_sprites(i).state = DEAD
	next
    end sub


    sub reset_player
	with player_sprite
	    .who = PLAYER_SP
	    .mp.x = player_start_x
	    .mp.y = player_start_y
	    .v.dx = 0
	    .v.dy = 0
	    .time_to_cross(ALIVE) = LVLI.player_time_to_cross
	    .frame_count = 0
	    .state = ALIVE
	    .cur_dir = DIR_RIGHT
	    .last_shot_time = 0
	    .last_bomb_time = 0
	end with
	viewport.mp.x = maximum(mapinfo.min_bounds.x, player_start_x - viewport.w * 0.2)
	viewport.mp.y = 0
	player_fuel = 100
    end sub

   sub make_map
	mapinfo.w = (MAP_WIDTH_BLOCKS+1) *  bb_image->width
	mapinfo.h = display_map_height
	mapinfo.min_bounds.x = bb_image->width
	mapinfo.min_bounds.y = 0
	mapinfo.max_bounds.x = (MAP_WIDTH_BLOCKS - 1) * bb_image->width - 1
	mapinfo.max_bounds.y = mapinfo.h
	for i as integer = 0 to MAP_WIDTH_BLOCKS
	    dim as double x,y
	    'go over 2*pi 10 times
	    x = (2 * PI_VAL * 10) * (i / MAP_WIDTH_BLOCKS)
	    'no special significance to this formula, it just looked good
	    y = abs(sin(x) + cos(x) - sin(x/2) + cos(x/2) - sin(x/3)^2 + cos(x/3)^2) / 4 * MAXTOWER
	    map(i) = int(y + 0.5) + 1
	next
	for i as integer = 0 to MAP_WIDTH_BLOCKS
	    dim as integer c = 1
	    for j as integer = 1 to map(i) - 1
		if (i > 0 andalso map(i-1) < j) or _
		   (i < MAP_WIDTH_BLOCKS andalso map(i+1) < j) then c += 1
	    next
	    redim (terrain_box(i).bb)(c)
	    c = 1
	    for j as integer = 1 to map(i)
		if (j = map(i)) or _
		   (i > 0 andalso map(i-1) < j) or _
		   (i < MAP_WIDTH_BLOCKS andalso map(i+1) < j) then
		    terrain_box(i).bb(c).x = i * bb_image->width
		    terrain_box(i).bb(c).y = mapinfo.h - bb_image->height*j + 1
		    terrain_box(i).bb(c).w = bb_image->width
		    terrain_box(i).bb(c).h = bb_image->height
		    c += 1
		end if
	    next	    
	next
	
	for i as integer = 1 to ubound(stars)
	    dim as integer x,y
	    x = int(rnd(1) * ((MAP_WIDTH_BLOCKS-2) * bb_image->width)) + bb_image->width
	    y = int(rnd(1) * mapinfo.h * 0.8)  + (mapinfo.h * 0.1)
	    stars(i).x = x / STAR_FACTOR
	    stars(i).y = y
	next
    
	viewport.mp.x = mapinfo.min_bounds.x
	viewport.mp.y = 0
	viewport.s.x = display_vp_left
	viewport.s.y = display_vp_top
	viewport.w = screen_w
	viewport.h = display_vp_height
	viewport.diagonal = sqr(viewport.w^2 +  viewport.h^2)

	radar_vp.mp.x = mapinfo.min_bounds.x
	radar_vp.mp.y = 0
	radar_vp.w = screen_w * 0.8
	radar_vp.h = display_radar_height
	radar_vp.s.x = display_radar_left
	radar_vp.s.y = display_radar_top
    end sub

    sub init_background
	displayed_blocks_x = int(viewport.w / bb_image->width + 0.999)
	for i as integer = 0 to 1
	    background(i) = ImageCreate(viewport.w + 2 * bb_image->width, viewport.h, _
					RGB(0,0,0), 32)
	    if background(i) = 0 then
		print #1, "Can't create background image of size " _
		      & (viewport.w + 2 * bb_image->width) _
		      & " x " & viewport.h
		end
	    end if
	next
	collision_map = ImageCreate(viewport.w, viewport.h, RGB(0,0,0), 32)
	if collision_map = 0 then
	    print #1, "Can't create collisionmap image of size " _
		  & viewport.w & " x " & viewport.h
	    end
	end if
    end sub

    'startx is in map block coordinates, not screen pixels
    sub sync_background(startx as integer)
	assert(startx > 0)
	if startx = background_map_block_x then return
	put background(0), (0,0), background(1), pset
	for i as integer = -1 to displayed_blocks_x
	    dim as integer mi = (i + startx + MAP_WIDTH_BLOCKS) mod MAP_WIDTH_BLOCKS
	    dim as integer h = map(mi)
	    dim as integer x = (i + 1) * bb_image->width
	    for j as integer = 1 to h
		dim as integer y = viewport.h - bb_image->height*j + 1
		if j = h then
		    put background(0), (x,y), grass_image, trans
		else
		    put background(0), (x,y), bb_image, trans
		end if
	    next
	next
	background_map_block_x = startx
    end sub


    sub add_sprites_to_radar(sprites(any) as sprite, rgb_color as uinteger)
	for i as integer = 1 to ubound(sprites)
	    if (sprites(i).state = ALIVE) then
		dim as integer j,x,y
		j = (sprites(i).mp.x + sprites(i).w/2) \ bb_image->width
		if j >= 0 and j <= MAP_WIDTH_BLOCKS then
		    y = int((sprites(i).mp.y + sprites(i).h/2) / viewport.h * radar_vp.h)
		    x = int((j-1) / MAP_WIDTH_BLOCKS * radar_vp.w)
		    line (x + radar_vp.s.x,y + radar_vp.s.y - 1) - step (1,1), rgb_color, bf
		end if
	    end if
	next
    end sub

    sub draw_score
	dim as blockfont ptr bf = @score_text
	dim as integer y = (display_radar_top - bf->max_height) / 2
	dim as integer wid, x = 10	
	dim as string s = "L:" & format(level, "00") & "  S:" & format(score, "0000000")
	draw_text(x,y,s,bf,true)
	if score > hi_score then hi_score = score
	s = "H:" & format(hi_score, "0000000")
	wid = draw_text(0,0,s,bf,false)
	x = screen_w - 10 - wid
	draw_text(x,y,s,bf,true)	
    end sub
    
    sub draw_fuel
	line (display_fuel_left-2, display_fuel_top-2) - _
	     step (display_fuel_width+4, display_fuel_height+4), Text2Color("x"), bf
	dim as integer w = int(player_fuel / 100 * display_fuel_width + 0.49)
	line (display_fuel_left, display_fuel_top) - _
	     step (w, display_fuel_height), Text2Color("G"), bf
    end sub

    sub draw_lives
	dim as integer y = display_fuel_top + display_fuel_height/2 - player_sprite.h / 2
	dim as integer l = player_sprite.w / 2
	dim as integer w = display_fuel_left - 2*l
	dim as integer n = w / (player_sprite.w * 1.2)
	dim as integer x = l
	dim as integer extra_lives = lives - 1
	if extra_lives <= n then
	    for i as integer = 1 to extra_lives
		put (x,y), player_ship_image, trans
		x += player_sprite.w * 1.2
	    next
	else
	    dim as integer tw = draw_text(0,0,"+11", @small_text, false)
	    w -= tw
	    n = w / (player_sprite.w * 1.2)
	    for i as integer = 1 to n
		put (x,y), player_ship_image, trans
		x += player_sprite.w * 1.2
	    next
	    dim as string s = "+" & (extra_lives - n)
	    draw_text(x,y,s,@small_text, true)
	end if
    end sub
    
    
    sub draw_radar
	with radar_vp
	    dim as integer x1,y1,x2,y2
	    y1 = .s.y
	    y2 = .s.y + .h
	    x1 = viewport.mp.x / mapinfo.max_bounds.x * .w + .s.x
	    x2 = (viewport.mp.x + viewport.w) / mapinfo.max_bounds.x * .w + .s.x
	    line (x1,y1) - (x2,y2), RGBA(49, 162, 242, 40), bf
	    line (.s.x - 1, .s.y - 1) - (.s.x + .w, .s.y +.h), RGB(255,255,255), b
	    dim as integer b1 = maximum(2, int(bb_image->height / viewport.h *.h))
	    for i as integer = 1 to MAP_WIDTH_BLOCKS
		dim as double x, h
		for x as integer = int((i-1) / MAP_WIDTH_BLOCKS * .w) to _
		                   int(i / MAP_WIDTH_BLOCKS * .w) - 1
		    h = int(map(i) * bb_image->height / viewport.h * .h) - b1
		    if h > 0 then
			line (.s.x + x, .s.y + .h - 1) - STEP (0, - h), Text2Color("B")
		    else
			h = 0
		    end if
		    line (.s.x + x, .s.y + .h - 1 - h) - STEP (0, - b1), Text2Color("G")
		next
	    next
	    add_sprites_to_radar(alien_sprites(), Text2Color("Y"))
	    add_sprites_to_radar(fuel_sprites(), Text2Color("x"))	
	    add_sprites_to_radar(missile_base_sprites(), Text2Color("R"))	
	end with
    end sub

    function ground_top(x as integer) as integer
	x = int(x / bb_image->width)
	return (viewport.h - map(x) * bb_image->height)
    end function
    
    
    sub draw_background
	dim as integer map_x = int(viewport.mp.x + 0.5)
	dim as integer xblock = map_x \ bb_image->width
	dim as integer offset = map_x mod bb_image->width
	sync_background(xblock)
	put collision_map, (0,0), background(1), pset
	with viewport
	    put (.s.x,.s.y), background(0), (bb_image->width + offset,0) - _
		STEP (.w-1, .h-1), trans
	    line (.s.x ,maximum(.s.y - 2,0)) - _
		 (.s.x + .w, maximum(.s.y - 1,0)), RGB(38, 136, 235), bf
	    line (.s.x,minimum(.s.y + .h + 2, screen_h)) - _
		 (.s.x + .w, minimum(.s.y + .h + 1, screen_h)), RGB(38, 136, 235), bf
	    for i as integer = 1 to ubound(stars)
		dim as integer x = stars(i).x - .mp.x / STAR_FACTOR
		if x >= 0 and x <= .mp.x + .w and stars(i).y < ground_top(x + .mp.x) then
		    pset (x + .s.x ,stars(i).y + .s.y), RGB(255,255,255)
		end if
	    next
	end with
	draw_radar
    end sub

    function detect_collision(s as sprite ptr, state as integer, imgn as integer, _
	     byref p as sprite ptr) as integer
	dim as integer x,y
	for i as integer = 1 to ubound(s->images(state).col_img(imgn).colp)
	    x = s->s.x + s->images(state).col_img(imgn).colp(i).x
	    y = s->s.y + s->images(state).col_img(imgn).colp(i).y
	    if x < 0 or x >= viewport.w or y < 0 or y >= viewport.h then continue for
	    dim as ulong res = point(x, y, collision_map) and &HFFFFFF
	    if res > 0 then
		assert(res <= spritecount)
		p = spritemap(res)		
		'print #1 , "collision at i = " & i & " ( " & x & " , " & y & " ) = " & res & _
		'      " who = " & p->who & " state = " & p->state
		if p->state = ALIVE then
		    return p->who
		end if
	    end if	    	    
	next
	dim as integer maps = s->mp.x \ bb_image->width
	if maps > 0 then maps -= 1
	dim as integer mape = (s->mp.x + s->w + bb_image->width - 1) \ bb_image->width
	if mape < MAP_WIDTH_BLOCKS then mape += 1
	for i as integer = maps to mape
	    for j as integer = 1 to ubound(terrain_box(i).bb)
		if overlap(terrain_box(i).bb(j), s->mp, s->w, s->h) then return GROUND_SP
	    next
	next	
	return 0
    end function

    
    function detect_hit_bottom(s as sprite ptr, byref maxy as double) as boolean
	dim as integer y_left, y_right
	y_left = ground_top(s->mp.x)
	y_right = ground_top(s->mp.x + s->w - 1)
	maxy = minimum(y_left, y_right)  - s->h + 1
	return s->mp.y > maxy 
    end function

    sub update_player_fuel
	dim as double v = sqr(player_sprite.v.dx^2 + player_sprite.v.dy^2)
	player_fuel -= (v / LVLI.pixels_per_fuel_tank) * 100
	if player_fuel < 0 then player_fuel = 0
    end sub   
    
    sub handle_shoot_button
	if time_now < player_sprite.last_shot_time + 0.2 then return
	for s as integer = 1 to ubound(shot_sprites)
	    if shot_sprites(s).state = DEAD then
		with shot_sprites(s)
		    .mp.y = player_sprite.mp.y + 3 * player_yfactor 
		    .mp.x = player_sprite.mp.x + player_sprite.w + 1
		    .v.dy = 0
		    .v.dx = viewport.w / (frames_per_second  * .time_to_cross(ALIVE))
		    if .v.dx > .w then .v.dx = .w
		    .cur_dir = player_sprite.cur_dir
		    .state = ALIVE
		    if .cur_dir = DIR_LEFT then
			.v.dx = - .v.dx
			.mp.x = player_sprite.mp.x - .w + player_sprite.v.dx
		    else
			.mp.x = player_sprite.mp.x  + player_sprite.w + player_sprite.v.dx
		    end if
		    .mp.x -= .v.dx
		end with
		player_sprite.last_shot_time = time_now
		exit for
	    end if
	next
    end sub
    
    sub handle_bomb_button
	if time_now < player_sprite.last_bomb_time + 0.2 then return
	for s as integer = 1 to ubound(bomb_sprites)
	    if bomb_sprites(s).state = DEAD then
		with bomb_sprites(s)
		    .mp.y = player_sprite.mp.y + player_sprite.h + 1
		    .mp.x = player_sprite.mp.x + player_sprite.w / 2
		    '.v.dy = 0
		    '.v.dx = viewport.w / (frames_per_second  * .time_to_cross(ALIVE))
		    .v.dx = player_sprite.v.dx
		    .v.dy = player_sprite.v.dy
		    'if .v.dx > .w then .v.dx = .w
		    .cur_dir = player_sprite.cur_dir
		    .state = ALIVE
		    if .cur_dir = DIR_LEFT then
			'.v.dx = - .v.dx
			.mp.x -= .w
		    end if
		    .mp.x -= .v.dx
		end with
		player_sprite.last_bomb_time = time_now
		exit for
	    end if
	next
    end sub

    sub move_player(pressed as string)
	dim as double v, vx, vy
	dim as integer new_dir = DIR_NONE
	v = maximum(viewport.w , viewport.h) / _
	    (frames_per_second  * player_sprite.time_to_cross(ALIVE))
	if instr(pressed," ") > 0 or auto_shoot then handle_shoot_button
	if instr(pressed,"b") > 0 or auto_bombs then handle_bomb_button
	if player_fuel > 0 then 
	    if instr(pressed,"a") then
		new_dir = DIR_LEFT
	    elseif instr(pressed,"d") then
		new_dir = DIR_RIGHT
	    end if
	    if new_dir = DIR_NONE then
		vx = v
	    else
		player_sprite.cur_dir = new_dir
		vx = 2 * v
	    end if
	    if instr(pressed,"w") then
		vy = - v
	    elseif instr(pressed,"s") then
		vy = v
	    end if
	else
	    vx = v
	    vy = player_sprite.v.dy + global_g
	end if
	if player_sprite.cur_dir = DIR_LEFT then vx = -vx
	    
	player_sprite.v.dx = vx
	player_sprite.v.dy = vy
	assert( vx < 100 )
	assert( vy < 100 )
	
	player_sprite.mp = coord_add(player_sprite.mp, player_sprite.v)
	if player_sprite.mp.x < mapinfo.min_bounds.x then player_sprite.mp.x = mapinfo.min_bounds.x
	if player_sprite.mp.x + player_sprite.w >= mapinfo.max_bounds.x then
	    player_sprite.mp.x = mapinfo.max_bounds.x - player_sprite.w - 1
	end if
	if player_sprite.mp.y < mapinfo.min_bounds.y then player_sprite.mp.y = mapinfo.min_bounds.y
	if player_sprite.mp.y + player_sprite.h >= mapinfo.max_bounds.y then
	    player_sprite.mp.y = mapinfo.max_bounds.y - player_sprite.h - 1
	end if
	dim as double maxy
    end sub
	
    sub determine_viewport
	dim as dbl_coord ideal_viewport
	if player_sprite.cur_dir = DIR_LEFT then
	    ideal_viewport.x = player_sprite.mp.x - 0.8 * screen_w
	else
	    ideal_viewport.x = player_sprite.mp.x - 0.2 * screen_w
	end if
	if ideal_viewport.x < mapinfo.min_bounds.x then ideal_viewport.x = mapinfo.min_bounds.x
	if ideal_viewport.x + viewport.w >= mapinfo.max_bounds.x then
	    ideal_viewport.x = mapinfo.max_bounds.x - viewport.w
	end if
	viewport.v.dx = abs(2 * player_sprite.v.dx)
	if abs(ideal_viewport.x - viewport.mp.x) < viewport.v.dx then
	    viewport.mp.x = ideal_viewport.x
	else
	    viewport.mp.x += sgn(ideal_viewport.x - viewport.mp.x) * viewport.v.dx
	end if

    end sub

    sub aliens_fire(alien as integer)
	dim as integer b, direc = DIR_NONE, tipx
	with alien_sprites(alien)
	    dim as double pcenterx, pcentery
	    if time_now < .last_shot_time + LVLI.alien_shot_delay then return
	    pcenterx = player_sprite.mp.x + player_sprite.w / 2
	    pcentery = player_sprite.mp.y + player_sprite.h / 2
	    'aliens can fire at the player if their gun is facing in the direction of the
	    'player and the angle is not too steep
	    if .mp.x + .w < player_sprite.mp.x and _
		.angle > 180 - 36 then
		direc = DIR_RIGHT
		tipx = .mp.x + .w + 1
	    elseif .mp.x > player_sprite.mp.x + player_sprite.w and _
		    .angle  < 36 then
		direc = DIR_LEFT
		tipx = .mp.x - bullet_sprites(1).w - 1
	    end if
	    if direc = DIR_NONE then return
	    if abs(pcenterx - .mp.x) < 2 * abs(pcentery - .mp.y) then return
	    for b = 1 to LVLI.max_bullets
		if bullet_sprites(b).state = DEAD then exit for
	    next
	    if b > LVLI.max_bullets then return
	    bullet_sprites(b).mp.x = tipx
	    bullet_sprites(b).mp.y = .mp.y + 2
	    bullet_sprites(b).state = ALIVE
	    dim as double d = DISTANCE(player_sprite.mp, bullet_sprites(b).mp)
	    dim as double ratio = d / viewport.diagonal
	    bullet_sprites(b).v.dx = (pcenterx - bullet_sprites(b).mp.x) / _
			  (LVLI.bullet_time_to_cross * frames_per_second * ratio)
	    bullet_sprites(b).v.dy = (pcentery - bullet_sprites(b).mp.y) / _
			  (LVLI.bullet_time_to_cross * frames_per_second * ratio)
	    .last_shot_time = time_now
	    aliens_fire_sound()
	end with
    end sub
	
    sub missile_base_fire(mbase as integer)
	dim as integer b, direc = DIR_NONE, tipx
	with missile_base_sprites(mbase)
	    dim as double pcenterx, pcentery
	    if time_now < .last_shot_time + 1 then return
	    for b = 1 to LVLI.max_missiles
		if missile_sprites(b).state = DEAD then exit for
	    next
	    if b > LVLI.max_missiles then
		return
	    end if
	    missile_sprites(b).mp.x = .mp.x + (.w - missile_sprites(b).w) / 2
	    missile_sprites(b).mp.y = .mp.y - missile_sprites(b).h
	    missile_sprites(b).state = ALIVE
	    missile_sprites(b).v.dx = 0
	    missile_sprites(b).v.dy = - viewport.h / _
			   (LVLI.missile_time_to_cross * frames_per_second)
	    missile_sprites(b).cur_dir = DIR_UP
	    missile_sprites(b).frame_count = 0
	    .last_shot_time = time_now
	    missile_fire_sound()
	end with
    end sub

    sub move_missle_bases
	for i as integer = 1 to ubound(missile_base_sprites)
	    with missile_base_sprites(i)
		if .state = DEAD then continue for
		dim as boolean onscreen = false
		if (.mp.x >= viewport.mp.x and .mp.x < viewport.mp.x + viewport.w) or _
		   (.mp.x + .w >= viewport.mp.x and .mp.x + .w < viewport.mp.x + viewport.w) then _
		   onscreen = true
		if onscreen and _
		   rnd(1) < LVLI.missile_fire_likelihood / frames_per_second then
		    missile_base_fire(i)
		end if
	    end with
	next
    end sub
    
    sub move_aliens
	for i as integer = 1 to ubound(alien_sprites)
	    with alien_sprites(i)
		if .state = DEAD then continue for
		dim as boolean dormant = false, onscreen = false
		if .v.dx = 0 and .v.dy = 0 then dormant = true
		if (.mp.x >= viewport.mp.x and .mp.x < viewport.mp.x + viewport.w) or _
		   (.mp.x + .w >= viewport.mp.x and .mp.x + .w < viewport.mp.x + viewport.w) then _
		   onscreen = true
		if dormant then
		    if onscreen then
			'alien is on the ground, see if it should jump
			if rnd(1) < LVLI.alien_launch_likelihood / frames_per_second then
			    'Randomly determine how high and how far the alien will hop
			    'Aliens hops follow standard physics rules where they have initial
			    'velocity upwards (v.dy) and are then affected by gravity. 
			    dim as double t, h
			    h = .mp.y - viewport.mp.y - int(rnd(1) * 20 + 1)
			    .v.dy = - sqr(2 * h * global_g)
			    t = - .v.dy / global_g
			    'a,b are used to randomly pick a block either to the left or right
			    'of the alien for them to jump to
			    dim as integer a,b
			    if .mp.x - viewport.mp.x < 4 * bb_image->width then
				a = 0
				b = 3
			    elseif viewport.mp.x + viewport.w - .mp.x  < 4 * bb_image->width then
				a = -3
				b = 0
			    else
				a = -3
				b = 3
			    end if
			    .v.dx = ((int(rnd(1) * (b-a+1)) + a) * bb_image->width) / (2 * t)
			    alien_launch_sound()
			end if
		    end if
		else
		    'alien is jumping, update coords and decide if it can fire at the player
		    .mp = coord_add(.mp, .v)
		    .mp.y += global_g / 2
		    .v.dy += global_g
		    dim as double maxy
		    if detect_hit_bottom(@alien_sprites(i), maxy) then 
			.mp.y = maxy
			.v.dy = 0
			.v.dx = 0
		    end if
		    dim as double angle_delta = 180 / _
			(frames_per_second * LVLI.aliens_time_to_spin)
		    if .mp.x < player_sprite.mp.x then
			.angle += angle_delta
			if .angle >= 179.9 then .angle = 179.9
		    elseif .mp.x > player_sprite.mp.x then
			.angle -= angle_delta
			if .angle < 0 then .angle = 0
		    end if
		    aliens_fire(i)
		end if
	    end with
	next
    end sub

    sub update_score(who as integer)
	select case who
	case ALIEN_SP
	    score += 10
	    alien_explode_sound()
	case MISSILE_BASE_SP
	    score += 20
	    missile_base_explode_sound()
	case FUEL_SP
	    score += 20
	    player_fuel += 33
	    if player_fuel > 100 then player_fuel = 100
	    fuel_depot_explode_sound()
	case MISSILE_SP
	    score += 100
	    missile_explode_sound()
	end select
    end sub
    
    sub add_bonus(s as sprite ptr, what as integer)
	if what = EXTRA_LIFE_SP then
	    for i as integer = 1 to ubound(extra_life_sprites)
		if extra_life_sprites(i).state = DEAD then
		    with extra_life_sprites(i)
			.state = ALIVE
			.last_shot_time = time_now
			.mp.x = s->mp.x + s->w/2 - .w/2
			.mp.y = s->mp.y + s->h/2 - .h/2			
		    end with
		    exit for
		end if
	    next
	end if
    end sub
    
    sub	draw_sprites(sprites(any) as sprite)
	for i as integer = 1 to ubound(sprites)
	    with sprites(i)
		if .state = DEAD then continue for
		if (.mp.x >= viewport.mp.x + viewport.w) or _
		   (.mp.x + .w < viewport.mp.x) or _
		   (.mp.y >= viewport.h) or _
		   (.mp.y + .w < 0) then
		    continue for
		end if
		dim as double x,y,leftx, rightx, topy, bottomy
		x = maximum(0, .mp.x - viewport.mp.x)
		leftx = maximum(0, viewport.mp.x - .mp.x + 1)
		rightx = minimum(viewport.mp.x + viewport.w - .mp.x, .w - 1)
		y = maximum(0, .mp.y - viewport.mp.y)
		topy = maximum(0, viewport.mp.y - .mp.y + 1)
		bottomy = minimum(viewport.mp.y + viewport.h - .mp.y, .h - 1)
		.s.x = x
		.s.y = y
		.frame_count += 1
		dim as integer j = 1
		if .state = ALIVE then
		    if .who = ALIEN_SP then j = int(.angle / 36) + 1
		    if .who = PORTAL_SP then
			j = int(.frame_count / (frames_per_second * .1)) + 1
			if j > ubound(.images(.state).col_img) then
			    .frame_count = 0
			    j = 1
			end if
		    end if
		else
		    j = int(.frame_count / (frames_per_second * .1)) + 1
		    if j > ubound(.images(.state).col_img) then
			.state = DEAD
			if .who = ALIEN_SP and rnd(1) < LVLI.extra_life_likelihood then
			    add_bonus(@sprites(i), EXTRA_LIFE_SP)
			end if
		    end if
		end if
		if .state = ALIVE or .state = DYING then
		    put (x + viewport.s.x, y + viewport.s.y), _
			.images(.state).col_img(j).img, _
			(leftx,topy) - (rightx,bottomy), trans
		    put collision_map, (x, y), _
			.images(.state).col_img(j).id_img, _
			(leftx,topy) - (rightx,bottomy), trans
		end if
	    end with
	next
    end sub

    function draw_player as integer
	dim as integer who
	with player_sprite
	    .s.x = .mp.x - viewport.mp.x
	    assert(.s.x >= 0)
	    assert(.s.x < viewport.w - .w)
	    .s.y = .mp.y - viewport.mp.y
	    assert(.s.y >= 0)
	    assert(.s.y < viewport.h - .h)
	    dim as sprite ptr hit
	    who = detect_collision(@player_sprite, ALIVE, .cur_dir, hit)
	    if who = ALIEN_SP or who = GROUND_SP or who = FUEL_SP or who = MISSILE_BASE_SP then
		player_sprite.state = DYING
		player_sprite.frame_count = 0
	    end if
	    if who = EXTRA_LIFE_SP then
		hit->state = DEAD
		if lives < 99 then lives += 1
		extra_life_sound()
	    end if
	    put (.s.x + viewport.s.x, .s.y + viewport.s.y), _
		.images(ALIVE).col_img(.cur_dir).img, trans
	    put collision_map, (.s.x, .s.y), _
		player_sprite.images(ALIVE).col_img(.cur_dir).id_img, trans
	end with
	return who
    end function
	    
    sub init_explode_animation
	dim as double mxvx = -1000 ,mxvy = -1000, mnvx = 1000, mnvy = 1000
	for i as integer = 1 to ubound(dot_sprites)
	    with dot_sprites(i)
		.mp.x = player_sprite.mp.x + int(rnd(1) * player_sprite.w)
		.mp.y = player_sprite.mp.y + int(rnd(1) * player_sprite.h)
		.v.dx = (viewport.w / frames_per_second) * (int(rnd(1) * 20) / 10 + 0.1)
		.v.dy = (viewport.h / frames_per_second) * (int(rnd(1) * 20) / 10 + 0.1)
		if rnd(1) < 0.5 then .v.dx = - .v.dx
		if rnd(1) < 0.5 then .v.dy = - .v.dy
		if .v.dx < mnvx then mnvx = .v.dx
		if .v.dy < mnvy then mnvy = .v.dy
		if .v.dx > mxvx then mxvx = .v.dx
		if .v.dy > mxvy then mxvy = .v.dy
		.w = 1
		.h = 1
		.state = ALIVE
	    end with
	next
	player_explode_sound()
    end sub

    function advance_explode_animation() as boolean
	dim as integer alive_count
	player_sprite.frame_count += 1
	for i as integer = 1 to ubound(dot_sprites)
	    with dot_sprites(i)
		if .state = DEAD then continue for
		.mp = coord_add(.mp, .v)
		if .mp.x < viewport.mp.x or .mp.x + .w >= viewport.mp.x + viewport.w or _
		    .mp.y < viewport.mp.y or .mp.y + .h >= viewport.mp.y + viewport.h then
		    .state = DEAD		    
		end if
		if .state = ALIVE then
		    alive_count += 1
		    .s.x = .mp.x - viewport.mp.x
		    .s.y = .mp.y - viewport.mp.y
		    pset (.s.x + viewport.s.x, .s.y + viewport.s.y), RGB(255,255,255)
		end if		
	    end with
	next
	return alive_count < ubound(dot_sprites) / 5
    end function

    function player_hittable(hit as sprite ptr) as boolean
	if hit = 0 then return false
	if hit->state <> ALIVE then return false
	return hit->who = ALIEN_SP or hit->who = FUEL_SP or hit->who = MISSILE_BASE_SP _
	       or hit->who = MISSILE_SP
    end function

    function advance_projectile(s as sprite ptr) as boolean
	if s->state = ALIVE then
	    with *s
		.mp = coord_add(.mp, .v)
		if .mp.x < viewport.mp.x or .mp.x + .w >= viewport.mp.x + viewport.w or _
		    .mp.y + .h  >= viewport.h or .mp.y < 0 then
		    .state = DEAD
		else
		    .s.x = .mp.x - viewport.mp.x
		    .s.y = .mp.y - viewport.mp.y
		end if
	    end with
	end if
	return s->state <> DEAD
    end function

    
    sub advance_and_draw_player_projectile(sprites(any) as sprite, kind as integer)
	dim as sprite ptr hit
	for s as integer = 1 to ubound(sprites)
	    if advance_projectile(@sprites(s)) then
		with sprites(s)
		    if kind = BOMB_SP then .v.dy += global_g * 10
		    dim as integer imgn
		    if kind = BOMB_SP then
			dim as double vratio = abs(.v.dy) / abs(.v.dx)
			if vratio > 1.5 then
			    imgn = 5
			elseif vratio > 0.75 then
			    imgn = iif(.cur_dir = DIR_RIGHT, 2, 4)
			else
			    imgn = iif(.cur_dir = DIR_RIGHT, 1, 3)
			end if
		    else
			imgn = .cur_dir
		    end if
		    dim as integer who = detect_collision(@sprites(s), ALIVE, imgn, hit)
		    if who > 0 and who <> PLAYER_SP and who <> BOMB_SP and who <> SHOT_SP then
			.state = DEAD
			if player_hittable(hit) then
			    hit->frame_count = 0
			    hit->state = DYING
			    update_score(hit->who)
			end if
		    else
			put (.s.x + viewport.s.x, .s.y + viewport.s.y), _
			    .images(ALIVE).col_img(imgn).img, trans
		    end if
		end with
	    end if
	next
    end sub



    sub advance_and_draw_missiles
	dim as sprite ptr hit
	for s as integer = 1 to ubound(missile_sprites)
	    if missile_sprites(s).state = ALIVE then
		with missile_sprites(s)
		    if .cur_dir = DIR_UP and _
			.mp.y < player_sprite.mp.y + player_sprite.h - 1 and _
			.mp.y + .h >= player_sprite.mp.y then
			if .mp.x < player_sprite.mp.x then
			    .cur_dir = DIR_RIGHT
			    .v.dx = abs(.v.dy)
			else
			    .cur_dir = DIR_LEFT
			    .v.dx = - abs(.v.dy)
			end if
			.v.dy = 0
		    end if
		    if not advance_projectile(@missile_sprites(s)) then continue for
		    dim as integer who = detect_collision(@missile_sprites(s), ALIVE,_
							  .cur_dir, hit)
		    if who > 0 then
			.state = DYING
			.frame_count = 0
			if who = ALIEN_SP or who = FUEL_SP or who = MISSILE_BASE_SP _
			   or who = PLAYER_SP or who = MISSILE_SP then
			    if hit->state = ALIVE then
				hit->state = DYING
				hit->frame_count = 0
			    end if
			else 
			    if hit <> 0 then hit->state = DEAD
			end if			
		    end if
		    dim as integer j
		    if .state = ALIVE then
			j = .cur_dir
		    else
			j = int(.frame_count / (frames_per_second * .1)) + 1
			if j > ubound(.images(.state).col_img) then .state = DEAD
		    end if
		    if .state <> DEAD then
			put (.s.x + viewport.s.x, .s.y + viewport.s.y), _
			    .images(.state).col_img(j).img, trans
		    end if
		    .frame_count += 1
		end with
	    end if
	next
    end sub

    sub advance_and_draw_bullets
	dim as sprite ptr hit
	for s as integer = 1 to ubound(bullet_sprites)
	    if advance_projectile(@bullet_sprites(s)) then 
		with bullet_sprites(s)
		    dim as integer who = detect_collision(@bullet_sprites(s), ALIVE, 1, hit)
		    if who > 0 then
			.state = DEAD
			if who = PLAYER_SP andalso hit->state = ALIVE then 
			    hit->state = DYING
			    hit->frame_count = 0
			end if
		    else
			put (.s.x + viewport.s.x, .s.y + viewport.s.y), _
			    .images(ALIVE).col_img(1).img, trans
		    end if
		end with
	    end if
	next
    end sub

    sub update_bonuses
	for i as integer = 1 to ubound(extra_life_sprites)
	    if extra_life_sprites(i).state = ALIVE and _
	       extra_life_sprites(i).last_shot_time + LVLI.bonus_duration < time_now then
		extra_life_sprites(i).state = DEAD
	    end if
	next
    end sub
    
    function play_game_till_something_happens() as integer
	dim as double start_t = timer()
	dim as integer frame_count = 0
	dim as integer player_hit
	do
	    global_g = (2 * screen_h) / ((frames_per_second * LVLI.aliens_time_to_cross)^2)
	    dim as string pressed = KeysPressed("wasd b/o")
	    if instr(pressed, "/") then
		player_hit = QUIT_BUTTON
		exit do
	    end if
	    if instr(pressed, "o") then
		player_hit = OPTIONS_BUTTON
		exit do
	    end if	    
	    time_now = time_base + (timer() - start_t)
	    if player_sprite.state = ALIVE then		
		move_player(pressed)
		update_player_fuel
	    end if
	    update_bonuses
	    determine_viewport
	    move_aliens
	    move_missle_bases
	    screenlock
	    cls
	    draw_background
	    draw_sprites(fuel_sprites())
	    draw_sprites(missile_base_sprites())
	    draw_sprites(alien_sprites())
	    draw_sprites(extra_life_sprites())
	    draw_sprites(portal_sprite())
	    draw_fuel
	    draw_lives
	    draw_score
	    if player_sprite.state = ALIVE then
		player_hit = draw_player
		advance_and_draw_bullets
		advance_and_draw_missiles
		advance_and_draw_player_projectile(shot_sprites(), SHOT_SP)
		advance_and_draw_player_projectile(bomb_sprites(), BOMB_SP)
	    elseif player_sprite.state = DYING then
		if player_sprite.frame_count = 0 then init_explode_animation
		if advance_explode_animation() = true then player_sprite.state = DEAD
	    end if
	    screenunlock
	    sleep(1)
	    dim as double now = timer()
	    frame_count += 1
	    frames_per_second = frame_count / (now - start_t)
	loop while player_sprite.state <> DEAD and player_hit <> PORTAL_SP _
		   and player_hit <> QUIT_BUTTON and player_hit <> OPTIONS_BUTTON 
	if player_sprite.state = DEAD and lives > 0 then lives -= 1
	return player_hit
    end function

    function start_of_game_animation() as integer
	dim as integer hit = 0
	screenlock
	cls
	draw_centered(screen_w, screen_h, _
		      "WELCOME TO ALIEN DESTROYER" NL NL _
		      "KEYS:                     " NL _
		      "W,A,S,D ............. MOVE" NL _
		      "SPACE ............... FIRE" NL _
		      "B ............. DROP BOMBS" NL _
		      "O ................ OPTIONS" NL _
		      "/ ................... QUIT" NL NL _
		      "PRESS ANY KEY", _
	@score_text)
	screenunlock
	dim as string k
	do
	    k = inkey
	    if k = "" then sleep(100)
	loop while k = ""
	if k = "/" then hit = QUIT_BUTTON
	if ucase(k) = "O" then hit = OPTIONS_BUTTON
	return hit
    end function
    
    function handle_options() as integer
	dim as string pressed
	do
	    screenlock
	    cls
	    draw_centered(screen_w, screen_h, _
			  "Choose Options   " NL NL _
			  "S: AUTO SHOOT (" & iif(auto_shoot, "X", " ") & ")" NL _
			  "B: AUTO BOMBS (" & iif(auto_bombs, "X", " ") & ")" NL _
			  "R: RETURN        " NL _
			  "/: QUIT          ", @score_text)
	    screenunlock
	    pressed = ucase(inkey())
	    if pressed = "B" then auto_bombs = not auto_bombs
	    if pressed = "S" then auto_shoot = not auto_shoot
	    sleep(100)
	loop while pressed <> "R" and pressed <> "/"
	return iif(pressed = "/", QUIT_BUTTON, OPTIONS_BUTTON)
    end function
    
    function start_level_animation(level as integer) as integer
	dim as integer quit = 0
	dim as double start_t
	dim as double delta
	dim as integer seconds
	start_t = timer()
	do 
	    delta = 3.9 - (timer() - start_t)
	    seconds = int(delta)
	    if seconds > 0 then
		screenlock
		cls
		draw_centered(screen_w, screen_h, _
			      "GET READY FOR" NL _
			      "LEVEL " & level & NL _
			      "In" NL _
			      & seconds, @level_text)
		screenunlock
		sleep(100)
	    end if
	    dim as string k = ucase(inkey())
	    if k = "/" then
		quit = QUIT_BUTTON
	    end if
	    if k = "O" then
		quit = handle_options
		start_t = timer()
	    end if
	loop while seconds > 0 and quit <> QUIT_BUTTON
	return quit
    end function

    function play_one_level() as integer
	dim as integer player_hit
	reset_player
	reset_ammunition
	if start_level_animation(level) = QUIT_BUTTON then return QUIT_BUTTON
	time_base = 0
	do
	    player_hit = play_game_till_something_happens()
	    time_base = time_now
	    if player_hit = OPTIONS_BUTTON then
		player_hit = handle_options
	    end if
	    if player_hit = QUIT_BUTTON or player_hit = PORTAL_SP then
		exit do
	    end if
	    if player_sprite.state = DEAD then
		if lives <= 0 then exit do
		'every time the player dies we send them a back a little
		player_start_x = maximum(viewport.w * 0.2, _
					 player_sprite.mp.x - 20 * bb_image->width)
		player_start_y = mapinfo.h / 2
		reset_player
		reset_ammunition
	    end if
	loop
	return player_hit
    end function
	
    function play_one_game() as integer
	level = 1
	lives = 5
	score = 0
	dim as integer player_hit
	do
	    def_terrain
	    player_start_x = viewport.w * 0.2
	    player_start_y = viewport.h / 2
	    reset_player
	    draw_background
	    dim as integer player_hit = play_one_level()
	    if player_hit = QUIT_BUTTON then exit do
	    if player_hit = PORTAL_SP then level += 1
	loop while lives > 0
	return player_hit
    end function

    function game_over_screen() as integer
	dim as integer hit
	do
	    screenlock
	    cls
	    draw_centered(screen_w, screen_h, _
			  "GAME OVER" NL NL _
			  "YOUR SCORE: " & score & NL _
			  "HIGH SCORE: " & hi_score & NL _
			  & iif(score > 0 and score >= hi_score, _
			  "YOU BEAT THE HIGH SCORE!!", "") & NL NL _
			  "PLAY AGAIN (Y/N)", @score_text)
	    screenunlock
	    dim as string pressed = ucase(inkey())
	    if pressed = "Y" then return 0
	    if pressed = "N" then return QUIT_BUTTON
	    sleep(100)
	loop 
    end function
    
    sub pick_resolution
	dim as integer res
	do
	    print "Pick you game resolution:"
	    print "1) 1280x720"
	    print "2) 1366x768"
	    print "3) 1920x1080"
	    print "q) quit"
	    res = getkey()
	    if res = ASC("q") then end
	    res -= ASC("0")
	loop while res < 1 or res > 3
	small_text_xscale = 3
	small_text_yscale = 3    
	score_text_xscale = 6
	score_text_yscale = 6    
	level_text_xscale = 10
	level_text_yscale = 10
	bblock_xfactor = 5
	bblock_yfactor = 3
	player_xfactor = 3
	player_yfactor = 3
	display_vp_left = 0
	display_vp_top = 120
	display_vp_height = 550
	display_radar_left = (screen_w \ 10)
	display_radar_top = 80
	display_radar_height = 30
	display_fuel_left = (screen_w \ 2)
	display_fuel_width = (int(screen_w * .45))
	display_fuel_top = (display_vp_top + display_vp_height + 10)
	display_fuel_height = 15
	select case res
	case 1
	    screen_w = 1280
	    screen_h = 720
	case 2
	    screen_w = 1366
	    screen_h = 768
	case 3
	    screen_w = 1920
	    screen_h = 1080
	    small_text_xscale = 5
	    small_text_yscale = 5    
	    score_text_xscale = 8
	    score_text_yscale = 8    
	    level_text_xscale = 18
	    level_text_yscale = 12
	    bblock_xfactor = 7
	    bblock_yfactor = 5
	    player_xfactor = 4
	    player_yfactor = 4
	    display_vp_left = 0
	    display_vp_top = 180
	    display_vp_height = 850
	    display_radar_top = 120
	    display_radar_height = 50
	    display_fuel_height = 20
	end select
	display_map_height = display_vp_height
	display_radar_left = (screen_w \ 10)
	display_fuel_left = (screen_w \ 2)
	display_fuel_width = (int(screen_w * .45))
	display_fuel_top = (display_vp_top + display_vp_height + 10)
    end sub

    sub main
	print #1, "Running!"
	screenres screen_w, screen_h, 32, 1, GFX_FULLSCREEN
	init_sound()
	def_basic_block
	level = 1
	def_letters
	small_text = make_font(small_text_xscale, small_text_yscale, "W")
	score_text = make_font(score_text_xscale, score_text_yscale, "W")
	level_text = make_font(level_text_xscale, level_text_yscale, "Y")
	def_levels
	make_map
	def_player_ship
	def_bullets
	def_missiles
	def_extra_life
	def_level_portal
	frames_per_second = 60
	def_player_shots
	def_player_bombs
	'player_start_x = viewport.w * 0.2
	init_background

	dim as integer hit
	do
	    hit = start_of_game_animation()
	    if hit = QUIT_BUTTON then return
	    if hit = OPTIONS_BUTTON then hit = handle_options
	    if hit = QUIT_BUTTON then return
	    play_one_game()
	    hit = game_over_screen()
	loop while hit <> QUIT_BUTTON	
    end sub

    pick_resolution
    open cons for output as #1 ' open console to file numer 1
    main


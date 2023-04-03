    #include once "fbgfx.bi"
    using fb

    dim shared as integer DBGG

    'Avoid conflict with some windows libraries that also define coord GRRR
    Type int_coord
	as integer x, y
    end type
    
    Type int_dirvect
	as integer dx, dy
    end type

    Type dbl_coord
	as double x, y
    end type
    
    Type dbl_dirvect
	as double dx, dy
    end type
    
    function DirVectSame(a as int_dirvect, b as int_dirvect) as boolean
	return a.dx = b.dx and a.dy = b.dy
    end function
    
    function DirVectDiff(a as int_dirvect, b as int_dirvect) as boolean
	return a.dx <> b.dx or a.dy <> b.dy
    end function

    #macro coord_add_tmpl(type1, type2, typeres)
	function coord_add overload (a as type1, b as type2) as typeres
	    dim as typeres c
	    c.x = a.x + b.x
	    c.y = a.y + b.y
	    return c
	end function
    #endmacro
	
    coord_add_tmpl(int_coord, int_coord, int_coord)
    coord_add_tmpl(int_coord, dbl_coord, dbl_coord)
    coord_add_tmpl(dbl_coord, int_coord, dbl_coord)
    coord_add_tmpl(dbl_coord, dbl_coord, dbl_coord)
    
    #macro coord_dirvect_add_tmpl(type1, type2, typeres)
	function coord_add overload (a as type1, b as type2) as typeres
	    dim as typeres c
	    c.x = a.x + b.dx
	    c.y = a.y + b.dy
	    return c
	end function
    #endmacro

    coord_dirvect_add_tmpl(int_coord, int_dirvect, int_coord)
    coord_dirvect_add_tmpl(int_coord, dbl_dirvect, dbl_coord)
    coord_dirvect_add_tmpl(dbl_coord, int_dirvect, dbl_coord)
    coord_dirvect_add_tmpl(dbl_coord, dbl_dirvect, dbl_coord)

    enum States
	DEAD = 0
	ALIVE = 1
	DYING = 2
	FLEEING = 3
	TOTAL_STATES = 4
    end enum

    enum Directions
	DIR_NONE = 0
	DIR_RIGHT = 1
	DIR_LEFT = 2
	DIR_UP = 3
    end enum

    Type ColImg
	as fb.image ptr img
	as fb.image ptr id_img
	as int_coord colp(any)
    end Type
	
    Type ColImgArr
	as ColImg col_img(any)
    end type
    
    Type sprite
	as integer id
	as integer who
	'location on the screen and velocity
	as dbl_coord s
	as dbl_dirvect v
	'location in the map
	as dbl_coord mp
	as double angle
	as double last_shot_time
	as double last_bomb_time
	'Time to cross the screen. Higher value means slower sprite
	as double time_to_cross(TOTAL_STATES)
	'width and height of image
	as integer w, h
	'Keeps track of how many frames we've drawn this sprite, used for
	'switching between animation frames. We switch images approxmately
	'every 1/4 second
	as integer frame_count
	'Each state can have mutiple images for animation such
	'pman's mouth opening
	as ColImgArr images(TOTAL_STATES)
	as States state
	'The direction the sprite would like to go and the direction it is
	'currently going
	as integer cur_dir
    end type

    dim shared as sprite ptr spritemap(any)
    dim shared as integer spritecount
    
    type blocks2d
	as integer mp(any,any)
    end type

    'color palette from https://androidarts.com/palette/16pal.htm
    function Text2Color(c as string) as uinteger
	select case c
	Case "X" 'Black
	    return RGB(0, 0, 0)
	case "x" 'Gray
	    return RGB(157, 157, 157)
	case "W" ' White
	    return RGB(255, 255, 255)
	case "R" ' Red
	    return RGB(190, 38, 51)
	case "P" ' Pink
	    return RGB(224, 111, 139)
	case "b" ' dark Brown
	    return RGB(73, 60, 43)
	case "B" ' Brown	
	    return RGB(164, 100, 34)
	case "O" ' Orange
	    return RGB(235, 137, 49)
	case "Y" ' Yellow
	    return RGB(247, 226, 107)
	case "g" ' Dark Green
	    return RGB(29, 84, 13)' RGB(47, 72, 78)
	case "G" ' Green
	    return RGB(68, 137, 26)
	case "N" ' Neon Green	
	    return RGB(163, 206, 39)
	case "M" ' Midnight Blue
	    return RGB(27, 38, 50)
	case "s" ' Seablue
	    return RGB(0, 87, 132)
	case "S" ' Skyblue
	    return RGB(49, 162, 242)
	case "L" ' Lightblue
	    return RGB(178, 220, 239)
	case "p" ' Dark Purple
	    return RGB(72, 4, 117)
	end select
	print #1, "ERROR! NO COLOR FOR " & c
    end function
    
    
    function Text2Image(txt as string, xfactor as integer, yfactor as integer, _
			b2d as blocks2d ptr = 0, sid as ulong = 0) as fb.Image ptr
	dim as fb.Image Ptr img
	dim as ulong col
	'traverse the image string twice, the first time is just to determine
	'overall width and height of the image the second time we actually
	'draw the image into the buffer
	for j as integer = 1 to 2
	    dim as integer w, h, maxw
	    for i as integer = 1 to len(txt)
		dim as string c = mid(txt,i,1)
		if c = !"\n" then
		    h += 1
		    w = 0
		else
		    if img <> 0 and c <> " " then
			col = iif(sid = 0, Text2Color(c), sid)
			line img, (w*xfactor,h*yfactor) - _
			     step (xfactor-1, yfactor-1), col ,bf
			if b2d <> 0 then b2d->mp(w,h) = 1
		    end if
		    w += 1
		    if w > maxw then maxw = w
		end if
	    next i
	    if w > 0 then h += 1
	    if img = 0 then
		img = ImageCreate(maxw*xfactor, h*yfactor, _
				  RGB(255,0,255), 32)
		if img = 0 then
		    print #1, "ERROR! Can't create image of size ";maxw*xfactor;" x ";h*yfactor;". Try using a different resolution?"
		    end
		end if
		if b2d <> 0 then redim b2d->mp(maxw,h)
	    end if
	next
	
	return img
    end function

    sub create_collision_points(b2d as blocks2d ptr, _
	xfactor as integer, yfactor as integer, _
	state as States,  byref sp as sprite)
	dim as integer x, y, w, h
	#define MAX_POINTS 1000
	dim as int_coord colp(MAX_POINTS)
	dim as integer colpc
	w = ubound(b2d->mp)
	h = ubound(b2d->mp, 2)
	for y = 0 to h-1
	    for x = 0 to w-1
		if b2d->mp(x,y) = 1 then
		    colpc += 1
		    colp(colpc).x = x * xfactor
		    colp(colpc).y = y * yfactor
		    if b2d->mp(x+1,y) = 0 and (y = 0 orelse b2d->mp(x,y-1) = 0) then
			colpc += 1
			colp(colpc).x = (x + 1) * xfactor - 1
			colp(colpc).y = y * yfactor
		    end if
		    if b2d->mp(x,y+1) = 0 and (x = 0 orelse b2d->mp(x-1,y) = 0) then
			colpc += 1
			colp(colpc).x = x * xfactor
			colp(colpc).y = (y + 1) * yfactor - 1
		    end if
		    if b2d->mp(x+1,y+1) = 0 then
			colpc += 1
			colp(colpc).x = (x + 1) * xfactor - 1
			colp(colpc).y = (y + 1) * yfactor - 1
		    end if
		end if
	    next
	next
	dim as integer c
	c = ubound(sp.images(state).col_img)
	redim (sp.images(state).col_img(c).colp)(colpc)
	for i as integer = 1 to colpc
	    sp.images(state).col_img(c).colp(i).x = colp(i).x 
	    sp.images(state).col_img(c).colp(i).y = colp(i).y
	next
    end sub

   
    sub AddTextImage2Sprite(txt as string, xfactor as integer, yfactor as integer, _
	state as States,  byref sp as sprite)
	dim as integer c
	dim as blocks2d b2d
	static as integer next_id

	if sp.id = 0 then
	    next_id += 1
	    sp.id = next_id
	    c = ubound(spritemap)
	    if c < sp.id then
		redim preserve spritemap(sp.id * 2)
	    end if
	    spritemap(sp.id) = @sp
	    if sp.id > spritecount then spritecount = sp.id
	end if
	c = ubound(sp.images(state).col_img)
	if c < 1 then c = 1 else c += 1
	redim preserve (sp.images(state).col_img)(c)
	dim as fb.image ptr img = Text2Image(txt, xfactor, yfactor, @b2d)
	sp.images(state).col_img(c).img = img
	create_collision_points(@b2d, xfactor, yfactor, state, sp)
	img  = Text2Image(txt, xfactor, yfactor, 0, sp.id)
	sp.images(state).col_img(c).id_img = img
	if img->width > sp.w then sp.w = img->width
	if img->height > sp.h then sp.h = img->height
    end sub    
    
    
    'Simple keyboard drive, keeps track of key and down events so it can know which
    'keys are currently pressed. This version only supports keys with ASCII codes
    'so can't handle e.g. arrow keys.
    function KeysPressed(keys as string) as string
	static as long pressed(100)
	static as integer pressed_count
	static as integer max_events
	dim as event e
	dim as integer got_event
	
	dim as integer delay = 10
	dim as integer count
	Do
	    count += 1
	    got_event = 0
	    If (ScreenEvent(@e)) Then
		got_event = 1
		Select Case e.Type
		Case EVENT_KEY_PRESS
		    If (e.ascii > 0) Then
			dim as integer found
			for i as integer = 1 to pressed_count
			    if pressed(i) = e.ascii then found = 1
			next
			if found = 0 then
			    pressed_count += 1
			    pressed(pressed_count) = e.ascii
			end if
		    end if
		Case EVENT_KEY_RELEASE
		    If (e.ascii > 0) Then
			dim as integer found
			for i as integer = 1 to pressed_count
			    if pressed(i) = e.ascii then found = i
			next
			if found > 0 then
			    pressed(found) = pressed(pressed_count)
			    pressed_count -= 1
			end if
		    end if
		end select
	    end if
	    if got_event = 0 then delay -= 1
	loop while delay > 0
	if count > max_events then max_events = count
	do
	loop while inkey() <> ""
	
	'Only report as pressed the subset of keys the user cares about
	dim as string keys_pressed
	for i as integer = 1 to len(keys)
	    dim as Long c = asc(mid(keys,i,1))
	    for j as integer = 1 to pressed_count
		if pressed(j) = c then keys_pressed += chr(c)
	    next
	next
	return keys_pressed
    end function
    
    function replace_letter(s as string, l as string, r as string) as string
	dim as string tmp
	for j as integer = 1 to len(s)
	    dim as string t = mid(s, j, 1)
	    if t = l then t = r
	    tmp += t
	next j
	return tmp
    end function
    
    

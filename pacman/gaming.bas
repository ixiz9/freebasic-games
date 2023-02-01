    #include once "fbgfx.bi"
    using fb

    dim shared as integer DBGG

    'Odd spelling to avoid conflict with wincon.bi
    Type ccoord
	as integer x, y
    end type
    
    Type DirVect
	as integer dx, dy
    end type
    
    function DirVectSame(a as DirVect, b as DirVect) as boolean
	return a.dx = b.dx and a.dy = b.dy
    end function
    
    function DirVectDiff(a as DirVect, b as DirVect) as boolean
	return a.dx <> b.dx or a.dy <> b.dy
    end function
    
    enum States
	DEAD = 0
	ALIVE = 1
	DYING = 2
	FLEEING = 3
	TOTAL_STATES = 4
    end enum
    
    Type ImgArr
	as fb.image ptr img(any)
    end type
    
    Type sprite
	'location on the screen and velocity
	as double x, y, vx, vy
	'location we are moving FROM in maze coordinates
	as ccoord mz
	'location we are moving TO in maze coordinates. One tile away from mz
	as ccoord targ
	'Time to cross one tile in the maze. Higher value means slower sprite
	'Pman uses only one speed but ghosts' speed changes between states
	as double time_to_cross(TOTAL_STATES)
	'used for keeping track of maze tiles traversal since it can take many
	'frames to move between tiles, depending on the speed of the computer
	as integer cycle_count
	'width and height of image
	as integer w, h
	'Keeps track of how many frames we've drawn this sprite, used for
	'switching between animation frames. We switch images approxmately
	'every 1/4 second
	as integer frame_count
	'Each state can have mutiple images for animation such
	'pman's mouth opening
	as ImgArr images(TOTAL_STATES)
	as States state
	'set to 1 when we change state, to allow us to e.g. flip direction
	as integer state_change
	'The direction the sprite would like to go and the direction it is
	'currently going
	as Dirvect pref_dir, cur_dir
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
	    return RGB(47, 72, 78)
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
	end select
	print #1, "ERROR! NO COLOR FOR " & c
    end function
    
    function coord_add overload (a as ccoord, b as ccoord) as ccoord
	dim as ccoord c
	c.x = a.x + b.x
	c.y = a.y + b.y
	return c
    end function
    
    function coord_add overload (a as ccoord, b as DirVect) as ccoord
	dim as ccoord c
	c.x = a.x + b.dx
	c.y = a.y + b.dy
	return c
    end function
    
    
    function Text2Image(txt as string, xfactor as integer, yfactor as integer) as _
	     fb.Image ptr
	dim as fb.Image Ptr img 
	
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
		    w += 1
		    if w > maxw then maxw = w
		    if img <> 0 and c <> " " then
			line img, (w*xfactor,h*yfactor) - _
			     step (xfactor-1, yfactor-1), Text2Color(c) ,bf
		    end if
		end if
	    next i
	    if w > 0 then h += 1
	    if img = 0 then
		img = ImageCreate((maxw+1)*xfactor, (h+1)*yfactor, _
					 RGB(255,0,255), 32)
		if img = 0 then
		    print #1, "ERROR! Can't create image of size ";maxw*xfactor;" x ";h*yfactor;". Try using a different resolution?"
		    end
		end if
	    end if
	next
	return img
    end function
    
    
    sub AddTextImage2Sprite(txt as string, xfactor as integer, yfactor as integer, _
	state as States,  byref sp as sprite)
	dim as integer c
	c = ubound(sp.images(state).img)
	if c < 1 then c = 1 else c += 1
	redim preserve (sp.images(state).img)(c)
	dim as fb.image ptr img = Text2Image(txt, xfactor, yfactor)
	sp.images(state).img(c) = img
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
    
    

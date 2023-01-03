#include once "fbgfx.bi"
using fb

dim shared as integer DBGG

Type coord
    as integer x, y
end type

Type CollisionImage
    as fb.Image Ptr image
    as coord detectors(any)
end  Type

enum States
    DEAD = 0
    ALIVE = 1
    DYING = 2
end enum

Type sprite
    as double x, y, vx, vy
    as integer w, h
    as integer frame_count
    as integer display_image
    as CollisionImage ci(any)
    as States state
end type

function string_dump(s as sprite ptr) as string
    return " state = " + str(s->state) + " x = " + str(s->x) + " y = " + str(s->y) + _
	   " vx = " + str(s->vx) + " vy = " + str(s->vy) + " w = " + str(s->w) + " h = "+ str(s->h)
end function

function inboundingbox(c as coord, s as sprite ptr) as integer
    if s->state <> DEAD and c.x >= s->x and c.x < s->x + s->w and _
       c.y >= s->y and c.y < s->y + s->h then return 1
    return 0
end function
    
function detectcollision(s as sprite ptr, byref c as coord) as integer
    dim as integer col_x, col_y
    dim as integer found = 0
    for i as integer = 1 to ubound(s->ci(s->display_image).detectors)
	col_x = s->x + s->ci(s->display_image).detectors(i).x
	col_y = s->y + s->ci(s->display_image).detectors(i).y
	dim as ulong res = point(col_x, col_y) and &HFFFFFF
	if res > 0 then
	    found = 1
	    exit for
	end if
    next
    if found > 0 then c.x = col_x : c.y = col_y
    return found
end function


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
end function

sub det_point(x as integer, y as integer,  w as integer, h as integer, map as fb.Image Ptr, detector_list() as coord, byref num_dets as integer)
    if x < w and y < h and (point(x,y,map) and &HFFFFFF) = 0 then
	dim as coord c
	c.x = x
	c.y = y
	num_dets += 1
	detector_list(num_dets) = c
	dim as integer xd = x, yd = y
	if xd > 0 then xd -= 1
	if yd > 0 then yd -= 1
	line map, (xd,yd) - step (3,3), RGB(255,255,255), bf
    end if
end sub

    
sub detection_points(x as integer, y as integer, w as integer, h as integer, map as fb.Image Ptr, _
	 detector_list() as coord, byref num_dets as integer)
    dim as integer wid,hig
    dim as coord c
    wid = map->width
    hig = map->height
    det_point(x,y,wid,hig,map,detector_list(),num_dets)
    det_point(x+w-1,y,wid,hig,map,detector_list(),num_dets)
    det_point(x,y+h-1,wid,hig,map,detector_list(),num_dets)
    det_point(x+w-1,y+h-1,wid,hig,map,detector_list(),num_dets)
    det_point(x + w/2,y,wid,hig,map,detector_list(),num_dets)
    det_point(x,y+h/2,wid,hig,map,detector_list(),num_dets)
    det_point(x+w/2,y+h-1,wid,hig,map,detector_list(),num_dets)
    det_point(x+w-1,y+h/2,wid,hig,map,detector_list(),num_dets)
    det_point(x+w/2,y+h/2,wid,hig,map,detector_list(),num_dets)
end sub

function Text2CollisionImage(txt as string, xfactor as integer, yfactor as integer, ci as CollisionImage Ptr) as fb.Image ptr
    dim as integer w, h, wid, height, num_blocks
    dim as coord dets(any)
    for i as integer = 1 to len(txt)
	dim as string c = mid(txt,i,1)
	if c = !"\n" then
	    height += 1
	    w = 0
	else
	    if c <> " " then num_blocks += 1
	    w += 1
	    if w > wid then wid = w
	end if
    next i
    if w > 0 then height += 1
    dim as fb.Image Ptr img = ImageCreate(wid*xfactor, height*yfactor, RGB(255,0,255), 32)
    dim as fb.Image Ptr detectormap = ImageCreate(wid*xfactor, height*yfactor, RGB(0,0,0), 32)
    if img = 0 or detectormap = 0 then
	print #1, "ERROR! Can't create image of size ";wid*xfactor;" x ";height*yfactor;". Try using a different resolution?"
	end
    end if
    w = 0
    h = 0
    if ci <> 0 then redim as coord dets(num_blocks * 9)
    dim as integer num_dets
    for i as integer = 1 to len(txt)
	dim as string c = mid(txt,i,1)
	if c = !"\n" then
	    h += 1
	    w = 0
	else
	    if c <> " " then
		line img, (w*xfactor,h*yfactor) - step (xfactor-1, yfactor-1), Text2Color(c) ,bf
		if ci <> 0 then detection_points(w*xfactor,h*yfactor,xfactor, yfactor, detectormap, dets(), num_dets)
	    end if
	    w += 1
	end if
    next i
    ImageDestroy(detectormap)
    if ci <> 0 then
	redim as coord ci->detectors(num_dets)
	ci->image = img
	for i as integer = 1 to num_dets
	    ci->detectors(i) = dets(i)
	next i
    end if
    return img
end function


sub Text2Sprite(txt as string, xfactor as integer, yfactor as integer, byref sp as sprite)
    dim as integer w, h, c
    c = ubound(sp.ci)
    if c < 1 then c = 1 else c += 1
    redim preserve sp.ci(c)
    Text2CollisionImage(txt, xfactor, yfactor, @sp.ci(c))
    sp.display_image = 1
    w = sp.ci(c).image->width
    h = sp.ci(c).image->height
    if w > sp.w then sp.w = w
    if h > sp.h then sp.h = h
end sub    
    
    
function KeysPressed(keys as string) as string
    static as long pressed(100)
    static as integer pressed_count
    static as integer max_events
    dim as event e
    dim as integer got_event

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
		    if found = 0 then pressed_count += 1 : pressed(pressed_count) = e.ascii
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
    loop while got_event > 0
    if count > max_events then max_events = count
    do
    loop while inkey() <> ""
    
    dim as string keys_pressed
    for i as integer = 1 to len(keys)
	dim as Long c = asc(mid(keys,i,1))
	for j as integer = 1 to pressed_count
	    if pressed(j) = c then keys_pressed += chr(c)
	next
    next
    return keys_pressed
end function

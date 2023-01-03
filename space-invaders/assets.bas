dim shared as string char_shape(32 to 90)
type blockfont
    as fb.Image ptr char_image(32 to 90)
end type

dim shared as blockfont white4x6, yellow10x10, red10x10

#ifndef NL
#define NL !"\n"
#endif

sub MakeShapes
    char_shape(ASC(" ")) = _
	      "     " NL _
	      "     " NL _
	      "     " NL _
	      "     " NL _
	      "     " NL _
	      "     " NL _
	      "     " NL
    char_shape(ASC("A")) = _
	      "  W  " NL _
	      " W W " NL _
	      "W   W" NL _
	      "WWWWW" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL
    
    char_shape(ASC("B")) = _
	      "WWWW " NL _
	      "W   W" NL _
	      "W   W" NL _
	      "WWWW " NL _
	      "W   W" NL _
	      "W   W" NL _
	      "WWWW " NL
    
    char_shape(ASC("C")) = _
	      " WWW " NL _
	      "W   W" NL _
	      "W    " NL _
	      "W    " NL _
	      "W    " NL _
	      "W   W" NL _
	      " WWW " NL
    
    char_shape(ASC("D")) = _
	      "WWWW " NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "WWWW " NL
    
    char_shape(ASC("E")) = _
	      "WWWWW" NL _
	      "W    " NL _
	      "W    " NL _
	      "WWW  " NL _
	      "W    " NL _
	      "W    " NL _
	      "WWWWW" NL
    
    char_shape(ASC("F")) = _
	      "WWWWW" NL _
	      "W    " NL _
	      "W    " NL _
	      "WWW  " NL _
	      "W    " NL _
	      "W    " NL _
	      "W    " NL
    
    char_shape(ASC("G")) = _
	      " WWW " NL _
	      "W   W" NL _
	      "W    " NL _
	      "W    " NL _
	      "W  WW" NL _
	      "W   W" NL _
	      " WWW " NL
    
    char_shape(ASC("H")) = _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "WWWWW" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL
    
    char_shape(ASC("I")) = _
	      "WWWWW" NL _
	      "  W  " NL _
	      "  W  " NL _
	      "  W  " NL _
	      "  W  " NL _
	      "  W  " NL _
	      "WWWWW" NL
    
    char_shape(ASC("J")) = _
	      "WWWWW" NL _
	      "   W " NL _
	      "   W " NL _
	      "   W " NL _
	      "W  W " NL _
	      "W  W " NL _
	      " WW  " NL
    
    char_shape(ASC("K")) = _
	      "W   W" NL _
	      "W  W " NL _
	      "W W  " NL _
	      "WW   " NL _
	      "W W  " NL _
	      "W  W " NL _
	      "W   W" NL _
	      
    char_shape(ASC("L")) = _
	      "W    " NL _
	      "W    " NL _
	      "W    " NL _
	      "W    " NL _
	      "W    " NL _
	      "W    " NL _
	      "WWWWW" NL
    
    char_shape(ASC("M")) = _
	      "WW WW" NL _
	      "W W W" NL _
	      "W W W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL
    
    char_shape(ASC("N")) = _
	      "WW  W" NL _
	      "WW  W" NL _
	      "W W W" NL _
	      "W W W" NL _
	      "W W W" NL _
	      "W  WW" NL _
	      "W  WW" NL
    
    char_shape(ASC("O")) = _
	      " WWW " NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      " WWW " NL
    
    char_shape(ASC("P")) = _
	      "WWWW " NL _
	      "W   W" NL _
	      "W   W" NL _
	      "WWWW " NL _
	      "W    " NL _
	      "W    " NL _
	      "W    " NL _
	      
    char_shape(ASC("Q")) = _
	      " WWW " NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W W W" NL _
	      "W  W " NL _
	      " WW W" NL
    
    char_shape(ASC("R")) = _
	      "WWWW " NL _
	      "W   W" NL _
	      "W   W" NL _
	      "WWWW " NL _
	      "W W  " NL _
	      "W  W " NL _
	      "W   W" NL
    
    char_shape(ASC("S")) = _
	      " WWW " NL _
	      "W   W" NL _
	      "W    " NL _
	      " WWW " NL _
	      "    W" NL _
	      "W   W" NL _
	      " WWW " NL
    
    char_shape(ASC("T")) = _
	      "WWWWW" NL _
	      "  W  " NL _
	      "  W  " NL _
	      "  W  " NL _
	      "  W  " NL _
	      "  W  " NL _
	      "  W  " NL
    
    char_shape(ASC("U")) = _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      " WWW " NL
    
    char_shape(ASC("V")) = _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      " W W " NL _
	      "  W  " NL
    
    char_shape(ASC("W")) = _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W w W" NL _
	      "W W W" NL _
	      "W W W" NL _
	      " W W " NL
    
    char_shape(ASC("X")) = _
	      "W   W" NL _
	      "W   W" NL _
	      " W W " NL _
	      "  W  " NL _
	      " W W " NL _
	      "W   W" NL _
	      "W   W" NL
    
    char_shape(ASC("Y")) = _
	      "W   W" NL _
	      "W   W" NL _
	      " W W " NL _
	      "  W  " NL _
	      "  W  " NL _
	      "  W  " NL _
	      "  W  " NL
    
    char_shape(ASC("Z")) = _
	      "WWWWW" NL _
	      "    W" NL _
	      "   W " NL _
	      "  W  " NL _
	      " W   " NL _
	      "W    " NL _
	      "WWWWW" NL
    
    
    char_shape(ASC("0")) = _
	      " WWW " NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      "W   W" NL _
	      " WWW"  NL
    
    char_shape(ASC("1")) = _
	      " WW "  NL _
	      "W W  " NL _
	      "  W  " NL _
	      "  W  " NL _
	      "  W  " NL _
	      "  W  " NL _
	      "WWWWW" NL
    
    char_shape(ASC("2")) = _
	      " WWW " NL _
	      "W   W" NL _
	      "    W" NL _
	      "   W " NL _
	      " WW  " NL _
	      "W    " NL _
	      "WWWWW" NL
    
    char_shape(ASC("3")) = _
	      " WWW " NL _
	      "W   W" NL _
	      "    W" NL _
	      "  WW " NL _
	      "    W" NL _
	      "W   W" NL _
	      " WWW " NL
    
    char_shape(ASC("4")) = _
	      "W  W " NL _
	      "W  W " NL _
	      "W  W " NL _
	      "WWWWW" NL _
	      "   W " NL _
	      "   W " NL _
	      "   W " NL
    
    char_shape(ASC("5")) = _
	      "WWWWW" NL _
	      "W    " NL _
	      "W    " NL _
	      "WWWW " NL _
	      "    W" NL _
	      "    W" NL _
	      "WWWW " NL
    
    char_shape(ASC("6")) = _
	      " WWWW" NL _
	      "W    " NL _
	      "W    " NL _
	      "WWWW " NL _
	      "W   W" NL _
	      "W   W" NL _
	      " WWW " NL
    
    char_shape(ASC("7")) = _
	      "WWWWW" NL _
	      "    W" NL _
	      "   W " NL _
	      "  W  " NL _
	      "  W  " NL _
	      "  W  " NL _
	      "  W  " NL
    
    char_shape(ASC("8")) = _
	      " WWW " NL _
	      "W   W" NL _
	      "W   W" NL _
	      " WWW " NL _
	      "W   W" NL _
	      "W   W" NL _
	      " WWW " NL
    
    char_shape(ASC("9")) = _
	      " WWW " NL _
	      "W   W" NL _
	      "W   W" NL _
	      " WWWW" NL _
	      "    W" NL _
	      "W   W" NL _
	      " WWW " NL

    
    char_shape(ASC("(")) = _
	      "  WW " NL _
	      " W   " NL _
	      " W   " NL _
	      " W   " NL _
	      " W   " NL _
	      " W   " NL _
              "  WW " NL

    char_shape(ASC(")")) = _
	      " WW  " NL _
	      "   W " NL _
	      "   W " NL _
	      "   W " NL _
	      "   W " NL _
	      "   W " NL _
	      " WW  " NL
    
    char_shape(ASC("/")) = _
	      "    W" NL _
	      "    W" NL _
	      "   W " NL _
	      "  W  " NL _
	      " W   " NL _
	      "W    " NL _
	      "W    " NL
end sub	

function replace_letter(s as string, l as string, r as string) as string
    dim as string tmp
    for j as integer = 1 to len(s)
	dim as string t = mid(s, j, 1)
	if t = l then t = r
	tmp += t
    next j
    return tmp
end function
    
sub MakeBaseImages
    Text2CollisionImage(_
			"GGG" NL _
			"GGG" NL _
			"GGG" NL _
			,2 * GXScale, 2 * GYScale, @base_image(1))

    Text2CollisionImage(_
			" GG" NL _
			"G G" NL _
			"G  " NL _
			,2 * GXScale, 2 * GYScale, @base_image(2))
    
    Text2CollisionImage(_
			"  G" NL _
			"G  " NL _
			" G " NL _
			,2 * GXScale, 2 * GYScale, @base_image(3))
end sub

sub MakeBases
    MakeBaseImages

    dim as integer w = base_image(1).image->width
    dim as integer h = base_image(1).image->height
    dim as integer bw = w * 7 , bh = h * 5
    dim as integer w1 = (SCREEN_W - 3 * bw) / 3
    dim as integer w2 = w1 / 2

    for b as integer = 1 to 3
	for i as integer = 1 to 22
	    redim preserve (mbase(b,i).ci)(3)
	    mbase(b,i).display_image = 1
	    mbase(b,i).w = base_image(1).image->width
	    mbase(b,i).h = base_image(1).image->height
	    mbase(b,i).state = ALIVE
	    for j as integer = 1 to 3
		mbase(b,i).ci(j) = base_image(j)
	    next
	    if i <= 5 then
		mbase(b,i).y = BASE_Y
		mbase(b,i).x = w2 + w * i
	    elseif i <= 10 then
		mbase(b,i).y = BASE_Y + h
		mbase(b,i).x = w2 + w * (i - 5)
	    end if
	next
	mbase(b,11).y = BASE_Y + h * 2
	mbase(b,11).x = w2
	mbase(b,12).y = BASE_Y + h * 2
	mbase(b,12).x = w2 + w
	mbase(b,13).y = BASE_Y + h * 2
	mbase(b,13).x = w2 + w * 5
	mbase(b,14).y = BASE_Y + h * 2
	mbase(b,14).x = w2 + w * 6

	mbase(b,15).y = BASE_Y + h * 3
	mbase(b,15).x = w2
	mbase(b,16).y = BASE_Y + h * 3
	mbase(b,16).x = w2 + w
	mbase(b,17).y = BASE_Y + h * 3
	mbase(b,17).x = w2 + w * 5
	mbase(b,18).y = BASE_Y + h * 3
	mbase(b,18).x = w2 + w * 6
	
	mbase(b,19).y = BASE_Y + h * 4
	mbase(b,19).x = w2
	mbase(b,20).y = BASE_Y + h * 4
	mbase(b,20).x = w2 + w
	mbase(b,21).y = BASE_Y + h * 4
	mbase(b,21).x = w2 + w * 5
	mbase(b,22).y = BASE_Y + h * 4
	mbase(b,22).x = w2 + w * 6

	w2 += bw + w1
    next
end sub


sub MakeAlienSprites
    for i as integer = 1 to ALIEN_T
	dim as integer r = (i - 1) \ ALIEN_C
	if r = 0 then
	    Text2Sprite(_
			"     WW     " NL _
			"   WW  WW   " NL _
			"  WWWWWWWW  " NL _
			"  WW WW WW  " NL _
			" W    W   W " NL _
			"W    W     W" NL _
			" W    W   W " NL _
			"W    W     W", GXScale, GYScale, aliens(i))
	    
	    Text2Sprite(_
			"     WW     " NL _
			"   WW  WW   " NL _
			"  WWWWWWWW  " NL _
			"  WW WW WW  " NL _
			" W   W    W " NL _
			"  W   W  W  " NL _
			" W   W    W " NL _
			"  W   W  W  ", GXScale, GYScale, aliens(i))
	
	    Text2Sprite(_
			"Y   Y   Y  Y" NL _
			" Y   Y Y  Y " NL _
			"   O  O  O  " NL _
			" O R R R R O" NL _
			" O R R R R O" NL _
			"   O  O  O  " NL _
			" Y   Y Y  Y " NL _
			"Y   Y   Y  Y", GXScale, GYScale, aliens(i))
	elseif r < 3 then 	
	    Text2Sprite(_
			" WWWWWWWWWW " NL _
			"WW  WWWW  WW" NL _
			"WW  WWWW  WW" NL _
			" WWWWWWWWWW " NL _
			" WWWWWWWWWW " NL _
			"   WW  WW   " NL _
			"   WW  WW   " NL _
			"    WWWW    ", GXScale, GYScale, aliens(i))
	    
	    Text2Sprite(_
			" WWWWWWWWWW " NL _
			"WW  WWWW  WW" NL _
			"WW  WWWW  WW" NL _
			" WWWWWWWWWW " NL _
			" WWWWWWWWWW " NL _
			"   WWWWWW   " NL _
			"   WWWWWW   " NL _
			"    WWWW    ", GXScale, GYScale, aliens(i))

	    Text2Sprite(_
			"Y   Y   Y  Y" NL _
			" Y   Y Y  Y " NL _
			"   O  O  O  " NL _
			" O R R R R O" NL _
			" O R R R R O" NL _
			"   O  O  O  " NL _
			" Y   Y Y  Y " NL _
			"Y   Y   Y  Y", GXScale, GYScale, aliens(i))
	else 
	    
	    Text2Sprite(_
			"  W      W  " NL _
			"   W    W   " NL _
			"  WWWWWWWW  " NL _
			" WWW WW WWW " NL _
			"WWWWWWWWWWWW" NL _
			"W WWWWWWWW W" NL _
			"W   WWWW   W" NL _
			"WWW  WW  WWW", GXScale, GYScale, aliens(i))
	    
	    Text2Sprite(_
			"  W      W  " NL _
			"   W    W   " NL _
			"  WWWWWWWW  " NL _
			" WWW WW WWW " NL _
			"WWWWWWWWWWWW" NL _
			" WWWWWWWWWW " NL _
			"  WWWWWWWW  " NL _
			"WWW  WW  WWW", GXScale, GYScale, aliens(i))
	    Text2Sprite(_
			"Y   Y   Y  Y" NL _
			" Y   Y Y  Y " NL _
			"   O  O  O  " NL _
			" O R R R R O" NL _
			" O R R R R O" NL _
			"   O  O  O  " NL _
			" Y   Y Y  Y " NL _
			"Y   Y   Y  Y", GXScale, GYScale, aliens(i))
	end if
    next
end sub

sub MakeMothershipSprite
    Text2Sprite(_
		"      YYYYYYYYYY      " NL _
		"  YYYYYYYYYYYYYYYYYY  " NL _
		"YYxxYYxxYYxxYYxxYYxxYY" NL _
		"YYxxYYxxYYxxYYxxYYxxYY" NL _
		"YYxxYYxxYYxxYYxxYYxxYY" NL _
		    "  YYYYYYYYYYYYYYYYYY  " NL _
		"      YYYYYYYYYY      " NL _
		, GXScale, GYScale, mother_ship)
    
    Text2Sprite(_
		"      YYYYYYYYYY      " NL _
		"  YYYYYYYYYYYYYYYYYY  " NL _
		"YYSSYYSSYYSSYYSSYYSSYY" NL _
		"YYSSYYSSYYSSYYSSYYSSYY" NL _
		"YYSSYYSSYYSSYYSSYYSSYY" NL _
		"  YYYYYYYYYYYYYYYYYY  " NL _
		"      YYYYYYYYYY      " NL _
		, GXScale, GYScale, mother_ship)
    
    Text2Sprite(_
		"      Y  Y   Y  Y     " NL _
		" Y   Y    Y Y    Y   Y " NL _
		"   O    O  O  O    O   " NL _
		"     R R  R R  R R     " NL _
		"   O    O  O  O    O   " NL _
		" Y   Y    Y Y    Y   Y " NL _
		"      Y  Y   Y  Y      " NL _
		, GXScale, GYScale, mother_ship)
end sub

sub MakeProjectileSprites
    Text2Sprite(_
		" L " NL _
		"LLL" NL _
		"LLL" NL _
		"LLL" NL _
		, GXScale, GYScale, missile)
    missile.state = DEAD
    
    for i as integer = 1 to MAX_BOMBS
	Text2Sprite(_
		    "NNNNN" NL _
		    "NNNNN" NL _
		    " NNN " NL _
		    " NNN " NL _
		    " NNN " NL _
		    "  N  " NL _
		    , GXScale, GYScale, bomb(i))
	Text2Sprite(_
		    "Y   Y" NL _
		    " Y Y " NL _
		    "  R O" NL _
		    "O R  " NL _
		    " Y Y " NL _
		    "Y   Y" NL _
		    , GXScale, GYScale, bomb(i))
	bomb(i).state = DEAD
    next
end sub

sub MakeCannonSprite
    Text2Sprite(_
		"      xxx      " NL _
		"      xxx      " NL _
		"      xxx      " NL _
		"      xxx      " NL _
		"     gxxxg     " NL _
		"    ggxxxgg    " NL _	    	    	    
		" ggggYYYYYgggg " NL _
		"ggggggYYYgggggg" NL _
		"ggxxxxxYxxxxxgg" NL _
		" ggxxxxxxxxxgg " NL _
		, GXScale, GYScale, cannon)

    Text2Sprite(_
		"Y             Y" NL _
		" Y   Y   Y   Y " NL _
		"  Y   Y Y   Y  " NL _
		"   Y   Y   Y   " NL _
		"     R R R     " NL _
		" Y YOROROROY Y " NL _	    	    	    
		"     R R R     " NL _
		"   Y   Y   Y   " NL _
		"  Y   Y Y   Y  " NL _
		" Y   Y   Y   Y " NL _
		, GXScale, GYScale, cannon)
end sub

    
sub MakeFonts
    for i as integer = lbound(char_shape) to ubound(char_shape)
	if char_shape(i) <> "" then
	    white4x6.char_image(i) = Text2CollisionImage(char_shape(i), GXScale, GYScale * 1.5, 0)
	    yellow10x10.char_image(i) = Text2CollisionImage(replace_letter(char_shape(i),"W","Y"), GXScale * 2.5, GYScale * 2.5, 0)
	    red10x10.char_image(i) = Text2CollisionImage(replace_letter(char_shape(i),"W","R"), GXScale * 2.5, GYScale * 2.5, 0)
	end if
    next
end sub

function draw_text(x as integer, y as integer, s as string, f as blockfont ptr, do_draw as integer) as integer
    for i as integer = 1 to len(s)
	dim as string l = mid(s, i, 1)
	l = ucase(l)
	dim as integer j = asc(l)
	if j >= lbound(char_shape) and j <= ubound(char_shape) then
	    if do_draw then put (x, y), f->char_image(j), trans
	    x += f->char_image(j)->width * 1.5
	end if
    next
    return x
end function


sub draw_centered(s as string, f as blockfont ptr)
    dim as integer lines = 1, x, y, start

    dim as integer l, nlpos = instr(s, NL)
    do while nlpos > 0
	lines += 1
	nlpos = instr(nlpos + 1, s, !"\n")
    loop
    y = (SCREEN_H - f->char_image(ASC("A"))->height * 1.5* lines) / 2
    nlpos = 1
    do
	l = instr(nlpos, s, NL)
	dim as string ln
	if (l > 0) then
	    ln = mid(s, nlpos, l - nlpos)
	else
	    ln = mid(s, nlpos)
	end if
	dim as integer w = draw_text(0,0,ln,f,0)
	x = (SCREEN_W - w)/2
	draw_text(x,y,ln,f,1)
	y += f->char_image(ASC("A"))->height * 1.5
	nlpos = l + 1
    loop while l > 0
end sub
    
    
    
sub MakeAssets
    MakeShapes
    MakeFonts
    MakeCannonSprite
    MakeBases
    MakeMothershipSprite
    MakeProjectileSprites
    MakeAlienSprites
end sub

    dim shared as string char_shape(32 to 90)
    type blockfont
	as fb.Image ptr char_image(32 to 90)
	as integer max_height
	as integer max_width
    end type

    #ifndef NL
	#define NL !"\n"
    #endif

    sub def_letters
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
		  "W W W" NL _
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

	char_shape(ASC(":")) = _
		  "     " NL _
		  " WW  " NL _
		  " WW  " NL _
		  "     " NL _
		  " WW  " NL _
		  " WW  " NL _
		  "     " NL

	char_shape(ASC(",")) = _
		  "     " NL _
		  "     " NL _
		  "     " NL _
		  "     " NL _
		  " WW  " NL _
		  " WW  " NL _
		  "WW   " NL

	char_shape(ASC("!")) = _
		  " WWW " NL _
		  " WWW " NL _
		  " WWW " NL _
		  "  W  " NL _
		  "     " NL _
		  " WWW " NL _
		  " WWW " NL

	char_shape(ASC("+")) = _
		  "     " NL _
		  "     " NL _
		  "  W  " NL _
		  " WWW " NL _
		  "  W  " NL _
		  "     " NL _
		  "     " NL

	char_shape(ASC(".")) = _
		  "     " NL _
		  "     " NL _
		  "     " NL _
		  "     " NL _
		  " WW  " NL _
		  " WW  " NL _
		  "     " NL

	char_shape(ASC("<")) = _
		  "     " NL _
		  "   WW" NL _
		  " WW  " NL _
		  "W    " NL _
		  " WW  " NL _
		  "   WW" NL _
		  "     " NL
	char_shape(ASC(">")) = _
		  "     " NL _
		  "WW   " NL _
		  "  WW " NL _
		  "    W" NL _
		  "  WW " NL _
		  "WW   " NL _
		  "     " NL

    end sub	
    
    
    function make_font(xscale as integer, yscale as integer, _
		       colorstring as string) as blockfont
	dim as blockfont bf
	for i as integer = lbound(char_shape) to ubound(char_shape)
	    if char_shape(i) <> "" then
		bf.char_image(i) = Text2Image(replace_letter(char_shape(i),"W", _
					      colorstring), xscale, yscale)
		bf.max_height = Maximum(bf.max_height, bf.char_image(i)->height)
		bf.max_width = Maximum(bf.max_width, bf.char_image(i)->width)
	    end if
	next
	return bf
    end function

    'Write on string on the screen in the given font at position x,y
    '(top left corner).
    'returns width of the text in pixels
    function draw_text(x as integer, y as integer, s as string, _
		       f as blockfont ptr, do_draw as boolean) as integer
	for i as integer = 1 to len(s)
	    dim as string l = mid(s, i, 1)
	    l = ucase(l)
	    dim as integer j = asc(l)
	    if j >= lbound(char_shape) and j <= ubound(char_shape) then
		if f->char_image(j) = 0 then
		    print #1, "NO IMAGE FOR " & l & " = " & j
		else
		    if do_draw then put (x, y), f->char_image(j), trans
		    'distance between characters is 1/2 the width of the character
		    x += f->char_image(j)->width * 1.5
		end if
	    end if
	next
	return x
    end function
    
    'Write a string centered on the screen. Text can contain newlines.
    sub draw_centered(screen_w as integer, screen_h as integer, s as string, _
		      f as blockfont ptr)
	dim as integer lines = 1, x, y, start
	
	dim as integer l, nlpos = instr(s, NL)
	do while nlpos > 0
	    lines += 1
	    nlpos = instr(nlpos + 1, s, !"\n")
	loop
	'determine top left corner of text block.
	'Assumes each line is 1.5 times taller than "A" to account for
	'space between lines
	y = (screen_h - f->char_image(ASC("A"))->height * (1.5*lines - 0.5)) / 2
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
	    x = (screen_w - w)/2
	    draw_text(x,y,ln,f,1)
	    y += f->char_image(ASC("A"))->height * 1.5
	    nlpos = l + 1
	loop while l > 0
    end sub
    

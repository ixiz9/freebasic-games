    #ifndef NL
	#define NL !"\n"
    #endif

    sub def_pman
	dim as string pman_closed_s = _
	    "      YYYY      " NL _
	    "    YYYYYYYY    " NL _
	    "   YYYYYYYYYY   " NL _
	    "  YYYYYYYYYYYY  " NL _
	    " YYYYYYYYYYYYYY " NL _
	    " YYYYYYYYYYYYYY " NL _
	    "YYYYYYYYYYYYYYYY" NL _
	    "YYYYYYYYYYYYYYYY" NL _
	    "YYYYYYYYYYYYYYYY" NL _
	    "YYYYYYYYYYYYYYYY" NL _
	    " YYYYYYYYYYYYYY " NL _
	    " YYYYYYYYYYYYYY " NL _
	    "  YYYYYYYYYYYY  " NL _
	    "   YYYYYYYYYY   " NL _
	    "    YYYYYYYY    " NL _
	    "      YYYY      "
	dim as string pman_left_s = _
	    "      YYYY      " NL _
	    "    YYYYYYYY    " NL _
	    "   YYYYYYYYYY   " NL _
	    "  YYYYYYYYYYYY  " NL _
	    " YYYYYYYYYYYYYY " NL _
	    "    YYYYYYYYYYY " NL _
	    "       YYYYYYYYY" NL _
	    "           YYYYY" NL _
	    "           YYYYY" NL _
	    "       YYYYYYYYY" NL _
	    "    YYYYYYYYYYY " NL _
	    " YYYYYYYYYYYYYY " NL _
	    "  YYYYYYYYYYYY  " NL _
	    "   YYYYYYYYYY   " NL _
	    "    YYYYYYYY    " NL _
	    "      YYYY      "

	dim as string pman_up_s = _
	    "                " NL _
            "    Y      Y    " NL _
	    "   YY      YY   " NL _
	    "  YYY      YYY  " NL _
	    " YYYYY    YYYYY " NL _
	    " YYYYY    YYYYY " NL _
	    "YYYYYY    YYYYYY" NL _
	    "YYYYYYY  YYYYYYY" NL _
	    "YYYYYYY  YYYYYYY" NL _
	    "YYYYYYY  YYYYYYY" NL _
	    " YYYYYY  YYYYYY " NL _
	    " YYYYYYYYYYYYYY " NL _
	    "  YYYYYYYYYYYY  " NL _
	    "   YYYYYYYYYY   " NL _
	    "    YYYYYYYY    " NL _
	    "      YYYY      "

	dim as string pman_down_s = _
	    "      YYYY      " NL _
	    "    YYYYYYYY    " NL _
	    "   YYYYYYYYYY   " NL _
	    "  YYYYYYYYYYYY  " NL _
	    " YYYYYYYYYYYYYY " NL _
	    " YYYYYY  YYYYYY " NL _
	    "YYYYYYY  YYYYYYY" NL _
	    "YYYYYYY  YYYYYYY" NL _
	    "YYYYYYY  YYYYYYY" NL _
	    "YYYYYY    YYYYYY" NL _
	    " YYYYY    YYYYY " NL _
	    " YYYYY    YYYYY " NL _
	    "  YYY      YYY  " NL _
	    "   YY      YY   " NL _
	    "    Y      Y    " NL _	
	    "                " 

	dim as string pman_right_s = _
	    "      YYYY      " NL _
	    "    YYYYYYYY    " NL _
	    "   YYYYYYYYYY   " NL _
	    "  YYYYYYYYYYYY  " NL _
	    " YYYYYYYYYYYYYY " NL _
	    " YYYYYYYYYYY    " NL _
	    "YYYYYYYYY       " NL _
	    "YYYYY           " NL _
	    "YYYYY           " NL _
	    "YYYYYYYYY       " NL _
	    " YYYYYYYYYYY    " NL _
	    " YYYYYYYYYYYYYY " NL _
	    "  YYYYYYYYYYYY  " NL _
	    "   YYYYYYYYYY   " NL _
	    "    YYYYYYYY    " NL _
	    "      YYYY      "


	dim as string pman_eaten1 = _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    " Y            Y " NL _
	    "YYY          YYY" NL _
	    "YYYY        YYYY" NL _
	    "YYYYY      YYYYY" NL _
	    "YYYYYY   YYYYYYY" NL _
	    " YYYYYY  YYYYYY " NL _
	    " YYYYYYYYYYYYYY " NL _
	    "  YYYYYYYYYYYY  " NL _
	    "   YYYYYYYYYY   " NL _
	    "    YYYYYYYY    " NL _
	    "      YYYY      "
     
	dim as string pman_eaten2 = _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "YY            YY" NL _
	    " YYYY      YYYY " NL _
	    " YYYYYYYYYYYYYY " NL _
	    "  YYYYYYYYYYYY  " NL _
	    "   YYYYYYYYYY   " NL _
	    "    YYYYYYYY    " NL _
	    "      YYYY      " NL _
     
     
     
                  
	dim as string pman_eaten3 = _	    
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "     YYYYYY     " NL _  
	    "    YYYYYYYY    " NL _
	    "   YYYYYYYYYY   " NL _
	    "    YYYYYYYY    " NL _
	    "      YYYY      " NL _
     
     
	dim as string pman_eaten4 = _	    
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "     YYYYYY     " NL _
	    "     YYYYYY     " NL _
	    "      YYYY      " NL _
	    "       YY       " NL _
			 
     
	dim as string pman_eaten5 = _	    
	    "Y              Y" NL _       	
	    " Y   Y    Y   Y " NL _       	
	    "  Y   Y  Y   Y  " NL _       	
	    "   Y   YY   Y   " NL _       	
	    "    Y      Y    " NL _       	
	    "YY   Y    Y   YY" NL _       	
	    "  YY        YY  " NL _       	
	    "    YY   YY     " NL _       	
	    "    YY   YY     " NL _       	
	    "  YY        YY  " NL _       	
	    "YY   Y    Y   YY" NL _       	
	    "    Y      Y    " NL _       	
	    "   Y   YY   Y   " NL _       	
	    "  Y   Y  Y   Y  " NL _       	
	    " Y   Y    Y   Y " NL _       	
	    "Y              Y" NL _       	

	
	AddTextImage2Sprite(pman_up_s, sprite_xfactor, sprite_yfactor, ALIVE, pman)
	AddTextImage2Sprite(pman_right_s, sprite_xfactor, sprite_yfactor, ALIVE, pman)
	AddTextImage2Sprite(pman_down_s, sprite_xfactor, sprite_yfactor, ALIVE, pman)
	AddTextImage2Sprite(pman_left_s, sprite_xfactor, sprite_yfactor, ALIVE, pman)
	AddTextImage2Sprite(pman_closed_s, sprite_xfactor, sprite_yfactor, ALIVE, pman)
	AddTextImage2Sprite(pman_closed_s, sprite_xfactor, sprite_yfactor, DYING, pman)
	AddTextImage2Sprite(pman_eaten1, sprite_xfactor, sprite_yfactor, DYING, pman)
	AddTextImage2Sprite(pman_eaten2, sprite_xfactor, sprite_yfactor, DYING, pman)
	AddTextImage2Sprite(pman_eaten3, sprite_xfactor, sprite_yfactor, DYING, pman)
	AddTextImage2Sprite(pman_eaten4, sprite_xfactor, sprite_yfactor, DYING, pman)
	AddTextImage2Sprite(pman_eaten5, sprite_xfactor, sprite_yfactor, DYING, pman)

    end sub


    sub def_ghosts
	dim as string ghost_left_1 = _
	    "    ########    " NL _
	    "  ############  " NL _
	    "  ############  " NL _
	    " ############## " NL _
	    "##WWW####WWW####" NL _
	    "#XXWWW##XXWWW###" NL _
 	    "#XXWWW##XXWWW###" NL _
	    "##WWW####WWW####" NL _
	    "################" NL _
	    "################" NL _
	    "################" NL _
 	    "################" NL _
	    "################" NL _
	    "################" NL _
	    "##  ###  ###  ##" NL _
	    "#    #    #    #" 

	dim as string ghost_left_2 = _
	    "    ########    " NL _
	    "  ############  " NL _
	    "  ############  " NL _
	    " ############## " NL _
	    "##WWW####WWW####" NL _
	    "#XXWWW##XXWWW###" NL _
 	    "#XXWWW##XXWWW###" NL _
	    "##WWW####WWW####" NL _
	    "################" NL _
	    "################" NL _
	    "################" NL _
 	    "################" NL _
	    "################" NL _
	    "################" NL _
	    " ###  ###  ### " NL _
	    "  #    #    #  " 

	dim as string ghost_right_1 = _
	    "    ########    " NL _
	    "  ############  " NL _
	    "  ############  " NL _
	    " ############## " NL _
	    "####WWW####WWW##" NL _
	    "###WWWXX##WWWXX#" NL _
 	    "###WWWXX##WWWXX#" NL _
	    "####WWW####WWW##" NL _
	    "################" NL _
	    "################" NL _
	    "################" NL _
 	    "################" NL _
	    "################" NL _
	    "################" NL _
	    "##  ###  ###  ##" NL _
	    "#    #    #    #" 

	dim as string ghost_right_2 = _
	    "    ########    " NL _
	    "  ############  " NL _
	    "  ############  " NL _
	    " ############## " NL _
	    "####WWW####WWW##" NL _
	    "###WWWXX##WWWXX#" NL _
 	    "###WWWXX##WWWXX#" NL _
	    "####WWW####WWW##" NL _
	    "################" NL _
	    "################" NL _
	    "################" NL _
 	    "################" NL _
	    "################" NL _
	    "################" NL _
	    " ###  ###  ### " NL _
	    "  #    #    #  " 
	dim as string ghost_up_1 = _
	    "    ########    " NL _
	    "  ############  " NL _
	    "  ############  " NL _
	    " ############## " NL _
	    "###WXX####XXW###" NL _
	    "##WWXXW##WXXWW##" NL _
 	    "##WWWWW##WWWWW##" NL _
	    "###WWW####WWW###" NL _
	    "################" NL _
	    "################" NL _
	    "################" NL _
 	    "################" NL _
	    "################" NL _
	    "################" NL _
	    "##  ###  ###  ##" NL _
	    "#    #    #    #" 

	dim as string ghost_up_2 = _
	    "    ########    " NL _
	    "  ############  " NL _
	    "  ############  " NL _
	    " ############## " NL _
	    "###WXX####XXW###" NL _
	    "##WWXXW##WXXWW##" NL _
 	    "##WWWWW##WWWWW##" NL _
	    "###WWW####WWW###" NL _
	    "################" NL _
	    "################" NL _
	    "################" NL _
 	    "################" NL _
	    "################" NL _
	    "################" NL _
	    " ###  ###  ### " NL _
	    "  #    #    #  " 
	dim as string ghost_down_1 = _
	    "    ########    " NL _
	    "  ############  " NL _
	    "  ############  " NL _
	    " ############## " NL _
	    "###WWW####WWW###" NL _
	    "##WWWWW##WWWWW##" NL _
 	    "##WWXXW##WXXWW##" NL _
	    "###WXX####XXW###" NL _
	    "################" NL _
	    "################" NL _
	    "################" NL _
 	    "################" NL _
	    "################" NL _
	    "################" NL _
	    "##  ###  ###  ##" NL _
	    "#    #    #    #" 

	dim as string ghost_down_2 = _
	    "    ########    " NL _
	    "  ############  " NL _
	    "  ############  " NL _
	    " ############## " NL _
	    "###WWW####WWW###" NL _
	    "##WWWWW##WWWWW##" NL _
 	    "##WWXXW##WXXWW##" NL _
	    "###WXX####XXW###" NL _
	    "################" NL _
	    "################" NL _
	    "################" NL _
 	    "################" NL _
	    "################" NL _
	    "################" NL _
	    " ###  ###  ### " NL _
	    "  #    #    #  " 

	dim as string ghost_fleeing_1 = _
	    "    ########    " NL _
	    "  ############  " NL _
	    "  ############  " NL _
	    " ############## " NL _
	    "################" NL _
	    "###OOO####OOO###" NL _
 	    "###OOO####OOO###" NL _
	    "################" NL _
	    "################" NL _
	    "###OO##OO##OO###" NL _
	    "#OO##OO##OO##OO#" NL _
 	    "################" NL _
	    "################" NL _
	    "################" NL _
	    "##  ###  ###  ##" NL _
	    "#    #    #    #" 

	dim as string ghost_fleeing_2 = _
	    "    ########    " NL _
	    "  ############  " NL _
	    "  ############  " NL _
	    " ############## " NL _
	    "################" NL _
	    "###OOO####OOO###" NL _
 	    "###OOO####OOO###" NL _
	    "################" NL _
 	    "################" NL _
	    "###OO##OO##OO###" NL _
	    "#OO##OO##OO##OO#" NL _
 	    "################" NL _
	    "################" NL _
	    "################" NL _
	    " ###  ###  ### " NL _
	    "  #    #    #  " 

	dim as string ghost_eyes_left = _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "  WWW    WWW    " NL _
	    " XXWWW  XXWWW   " NL _
 	    " XXWWW  XXWWW   " NL _
	    "  WWW    WWW    " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
 	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " 

	dim as string ghost_eyes_right = _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "    WWW    WWW  " NL _
	    "   WWWXX  WWWXX " NL _
 	    "   WWWXX  WWWXX " NL _
	    "    WWW    WWW  " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
 	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " 

	dim as string ghost_eyes_up = _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "   WXX    XXW   " NL _
	    "  WWXXW  WXXWW  " NL _
 	    "  WWWWW  WWWWW  " NL _
	    "   WWW    WWW   " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
 	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " 

	dim as string ghost_eyes_down = _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "   WWW    WWW   " NL _
	    "  WWWWW  WWWWW  " NL _
 	    "  WWXXW  WXXWW  " NL _
	    "   WXX    XXW   " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
 	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " NL _
	    "                " 


	for i as integer = 1 to num_ghosts
	    dim as string c = mid("RSPO",ghosts(i).algorithm,1)
	    
	    AddTextImage2Sprite(replace_letter(ghost_up_1, "#", c), _
				sprite_xfactor, sprite_yfactor, ALIVE, _
				ghosts(i).gsprite)
	    AddTextImage2Sprite(replace_letter(ghost_up_2, "#", c), _
				sprite_xfactor, sprite_yfactor, ALIVE, _
				ghosts(i).gsprite)
	    AddTextImage2Sprite(replace_letter(ghost_right_1, "#", c), _
				sprite_xfactor, sprite_yfactor, ALIVE, _
				ghosts(i).gsprite)
	    AddTextImage2Sprite(replace_letter(ghost_right_2, "#", c), _
				sprite_xfactor, sprite_yfactor, ALIVE, _
				ghosts(i).gsprite)
	    AddTextImage2Sprite(replace_letter(ghost_down_1, "#", c), _
				sprite_xfactor, sprite_yfactor, ALIVE, _
				ghosts(i).gsprite)
	    AddTextImage2Sprite(replace_letter(ghost_down_2, "#", c), _
				sprite_xfactor, sprite_yfactor, ALIVE, _
				ghosts(i).gsprite)
	    AddTextImage2Sprite(replace_letter(ghost_left_1, "#", c), _
				sprite_xfactor, sprite_yfactor, ALIVE, _
				ghosts(i).gsprite)
	    AddTextImage2Sprite(replace_letter(ghost_left_2, "#", c), _
				sprite_xfactor, sprite_yfactor, ALIVE, _
				ghosts(i).gsprite)
	
	    AddTextImage2Sprite(replace_letter(ghost_fleeing_1, "#", "s"), _
				sprite_xfactor, sprite_yfactor, FLEEING, _
				ghosts(i).gsprite)
	    AddTextImage2Sprite(replace_letter(ghost_fleeing_2, "#", "s"), _
				sprite_xfactor, sprite_yfactor, FLEEING, _
				ghosts(i).gsprite)
	    AddTextImage2Sprite(replace_letter(_
				replace_letter(ghost_fleeing_1,"O", "s"),_
				"#", "O"), _
				sprite_xfactor, sprite_yfactor, FLEEING, _
				ghosts(i).gsprite)
	    AddTextImage2Sprite(replace_letter(_
				replace_letter(ghost_fleeing_2,"O", "s"),_
				"#", "O"), _
				sprite_xfactor, sprite_yfactor, FLEEING, _
				ghosts(i).gsprite)
	    
	    AddTextImage2Sprite(ghost_eyes_up, sprite_xfactor, sprite_yfactor,_
				DYING, ghosts(i).gsprite)
	    AddTextImage2Sprite(ghost_eyes_right, sprite_xfactor, sprite_yfactor,_
				DYING, ghosts(i).gsprite)
	    AddTextImage2Sprite(ghost_eyes_down, sprite_xfactor, sprite_yfactor,_
				DYING, ghosts(i).gsprite)
	    AddTextImage2Sprite(ghost_eyes_left, sprite_xfactor, sprite_yfactor,_
				DYING, ghosts(i).gsprite)
		
	next
    end sub

    sub def_maze
	dim as string maze_string = _
		     "XXXXXXXXXXXXXXXXXXXXXXXXXXXX" NL _
		     "XB...........XX...........IX" NL _
		     "X.XXXX.XXXXX.XX.XXXXX.XXXX.X" NL _
		     "X*X  X.X   X.XX.X   X.X  X*X" NL _
		     "X.XXXX.XXXXX.XX.XXXXX.XXXX.X" NL _
		     "X..........................X" NL _
		     "X.XXXX.XX.XXXXXXXX.XX.XXXX.X" NL _
		     "X.XXXX.XX.XXXXXXXX.XX.XXXX.X" NL _
		     "X......XX....XX....XX......X" NL _
    		     "XXXXXX.XXXXX.XX.XXXXX.XXXXXX" NL _
		     "     X.XX..........XX.X     " NL _
		     "XXXXXX.XX.XXXxxXXX.XX.XXXXXX" NL _
		     "      ....X HHHH X....      " NL _
		     "XXXXXX.XX.XXXXXXXX.XX.XXXXXX" NL _
		     "     X.XX.....M....XX.X     " NL _		     
		     "     X.XX.XXXXXXXX.XX.X     " NL _
		     "XXXXXX.XX..........XX.XXXXXX" NL _
		     "X.........X.XXXX.X.........X" NL _
		     "X.XXXX.XXXX.XXXX.XXXX.XXXX.X" NL _
		     "X*X  X.X............X.X  X*X" NL _
		     "X.XXXX.X.XXXXXXXXXX.X.XXXX.X" NL _
		     "XP........................CX" NL _
		     "XXXXXXXXXXXXXXXXXXXXXXXXXXXX" NL
	dim as string maze_2023string = _
	    "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" NL _
	    "XB...................................IX" NL _	     
	    "X.XXXXXXXX.XXXXXXXX.XXXXXXXX.XXXXXXXX.X" NL _
	    "X*.......X........X........X........X*X" NL _
	    "X.XXXXXX.X.X.XXXX.X.XXXXXX.X.XXXXXX.X.X" NL _
	    "X......X.X.X.X  X.X......X.X......X.X.X" NL _
	    "X.XXXXXX.X.X.X  X.X.XXXXXX.X.XXXXXX.X.X" NL _
	    "X.X......X.X.X  X.X.X......X........X.X" NL _
	    "X.X.XXXXXX.X.X  X.X.X.XXXXXX.XXXXXX.X.X" NL _
	    "X.X.X......X.X  X.X.X.X...........X.X.X" NL _
	    "X.X.XXXXXX.X.XXXX.X.X.XXXXXX.XXXXXX.X.X" NL _
	    "X.X........X........X...............X.X" NL _
	    "X.XXXXXXXX.XXXXXXXX.XXXXXXXX.XXXXXXXX.X" NL _
	    "......................................." NL _
	    "XXXXXX.XXXXXXXX.XXxxxXX.XXXXXXXX.XXXXXX" NL _
	    "X...............X HHHHX...............X" NL _
	    "X.XXXXXXXX.XXXX.XXXXXXX.XXXX.XXXXXXXX.X" NL _
	    "X.....................................X" NL _
	    "X.XXXX.XXXXXXXX.X.XXX.X.XXXXXXX..XXXX.X" NL _
	    "X.X  X........X.X.XXX.X.X........X  X.X" NL _
	    "X.X  XXXX.XXX.X.X..M..X.X.XXX.XXXX  X.X" NL _
	    "X.X  XXXX.XXX.X.XXX.XXX.X.XXX.XXXX  X.X" NL _
	    "X.X  X............X.X............X  X.X" NL _
	    "X.XXXX.XXXXXXXXXX.X.X.XXXXXXXXXX.XXXX.X" NL _
	    "X*.....X........X.X.X.X........X.....*X" NL _
	    "X.XXXXXX.XXXXXX.X.X.X.X.XXXXXX.XXXXXX.X" NL _
	    "XP.......X    X.........X    X.......CX" NL _
	    "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"


	#ifdef V2023
	    maze_string = maze_2023string
	#endif
	dim as integer w, h = 1
	for i as integer = 1 to len(maze_string)
	    dim as string c = mid(maze_string, i, 1)
	    if c = NL then
		if w > 0 then
		    if maze_w = 0 then maze_w = w else assert(maze_w = w)
		end if
		w = 0
		h += 1
	    else
		w += 1
	    end if
	next
	if right(maze_string, 1) = NL then h -= 1
	maze_h = h
	redim as integer maze(0 to maze_w + 1, 0 to maze_h + 1)
	redim as integer saved_maze(0 to maze_w + 1, 0 to maze_h + 1)
	h = 1
	w = 1
	dim as integer walls, dots
	dim as integer gstart_count
	for i as integer = 1 to len(maze_string)
	    dim as string c = mid(maze_string, i, 1)
	    if c = NL then
		w = 0  : h += 1
	    else
		if c = "X" then
		    maze(w,h) = WALL
		    walls += 1
		elseif c = "." then
		    maze(w,h) = FOOD
		    dots += 1
		elseif c = "M" then
		    pman_start.x = w
		    pman_start.y = h
		elseif instr("BIPC",c) > 0 then
		    num_ghosts += 1
		    ghosts(num_ghosts).corner.x = w
		    ghosts(num_ghosts).corner.y = h
		    ghosts(num_ghosts).algorithm = instr("BIPC",c)
		    maze(w,h) = FOOD
		    dots += 1
		elseif c = "*" then
		    maze(w,h) = POWERUP
		elseif c = "x" then
		    MAZE(w,h) = HOME_WALL
		    ghost_door.x = w
		    ghost_door.y = h
		elseif c = "H" then
		    MAZE(w,h) = GHOST_HOME
		    gstart_count += 1
		    ghosts(gstart_count).home.x = w
		    ghosts(gstart_count).home.y = h
		end if
	    end if
	    w += 1
	next
	'print #1, "WALLS = ";walls;" DOTS = ";dots;" MAZE = ";maze_w;" x ";maze_h
	for i as integer = 0 to maze_w + 1
	    for j as integer = 0 to maze_h + 1
		saved_maze(i,j) = maze(i,j)
	    next
	next
	total_food = dots	
    end sub

    sub thickline(x1 as integer, y1 as integer, x2 as integer, y2 as integer, _
		  r as integer, c as ULONG, img as fb.image ptr)
	dim as integer dx = sgn(x2 - x1), dy = sgn(y2 - y1)
	do
	    circle img, (x1, y1), r,c ,,,, f
	    x1 += dx
	    y1 += dy	    
	loop while (x1 <> x2 or y1 <> y2)
    end sub
	
    sub thicklined(x1 as integer, y1 as integer, dx1 as integer, dy1 as integer, _
		  r as integer, c as ULONG, img as fb.image ptr)
	thickline(x1,y1,x1+dx1,y1+dy1,r,c,img)
    end sub
	
    sub draw_wall_outlines(img as fb.Image ptr) 
	dim as integer n = 3
	dim as integer mazei(maze_w * n + 1, maze_h * n + 1)
	for x as integer = 1 to maze_w * n
	    for y as integer = 1 to maze_h * n 
		mazei(x,y) = maze((x - 1)\n + 1 ,(y - 1)\n + 1)
	    next
	next
	for x as integer = 1 to maze_w
	    for y as integer = 1 to maze_h
		if maze(x,y) = WALL then
		    if maze(x-1,y) <> WALL then
			for i as integer = 0 to n+1
			    mazei((x-1)*n + 1, (y-1)*n + i) = EMPTY
			next
		    end if
		    if maze(x+1,y) <> WALL then
			for i as integer = 0 to n+1
			    mazei(x*n, (y-1)*n + i) = EMPTY
			next
		    end if
		    if maze(x,y-1) <> WALL then
			for i as integer = 0 to n + 1
			    mazei((x-1)*n + i, (y-1)*n + 1) = EMPTY
			next
		    end if
		    if maze(x,y+1) <> WALL then
			for i as integer = 0 to n+1
			    mazei((x-1)*n + i, y*n) = EMPTY
			next
		    end if
		end if
	    next
	next
	for x as integer = 1 to maze_w * n
	    for y as integer = 1 to maze_h * n
		if mazei(x,y) = WALL then
		    if mazei(x-1,y) <> WALL then
			thicklined((x-1)*maze_xfactor\n,(y-1)*maze_yfactor\n, _
				       0,maze_yfactor\n-1, wall_thickness, RGB(0,150,255), img)
		    end if
		    if mazei(x+1,y) <> WALL then
			thicklined(x*maze_xfactor\n-1,(y-1)*maze_yfactor\n, _
				   0,maze_yfactor\n-1, wall_thickness, RGB(0,150,255), img)
		    end if
		    if mazei(x,y-1) <> WALL then
			thicklined((x-1)*maze_xfactor\n,(y-1)*maze_yfactor\n, _
				       maze_xfactor\n-1,0, wall_thickness, RGB(0,150,255), img)
		    end if
		    if mazei(x,y+1) <> WALL then
			thicklined((x-1)*maze_xfactor\n,y*maze_yfactor\n-1, _
				       maze_xfactor\n-1,0, wall_thickness, RGB(0,150,255), img)
		    end if
		end if
	    next
	next
	for x as integer = 1 to maze_w
	    for y as integer = 1 to maze_h
		if maze(x,y) = HOME_WALL then
		    if maze(x-1,y) < WALL and maze(x+1,y) < WALL then
			thicklined((x-1)*maze_xfactor + maze_xfactor/2,(y-1)*maze_yfactor, _
				       0, maze_yfactor, wall_thickness, RGB(224, 111, 139), img)
		    elseif maze(x,y-1) < WALL and maze(x,y+1) < WALL then
			thicklined((x-1)*maze_xfactor,(y-1)*maze_yfactor + maze_yfactor/2, _
				       maze_xfactor, 0, wall_thickness, RGB(224, 111, 139), img)
		    else
			print #1, "Something wrong with home wall at: " & x & "," & y
		    end if
		end if
	    next
	next
	
    end sub
			
    sub draw_maze(walls_img as fb.image ptr)
	dim as integer maze_x , maze_y
	maze_x = (screen_w - maze_w * maze_xfactor) / 2
	maze_y = (screen_h - maze_h * maze_yfactor) / 2
	put (maze_x, maze_y), walls_img, pset
	for x as integer = 0 to maze_w-1
	    for y as integer = 0 to maze_h-1
		if maze(x+1,y+1) = FOOD then
		    circle (maze_x + x*maze_xfactor + maze_xfactor\2, maze_y + y*maze_yfactor + maze_yfactor\2), _
			   MIN(maze_xfactor\6, maze_yfactor\6), RGB(200,200,200),,,,F
		end if
		if maze(x+1,y+1) = POWERUP then
		    circle (maze_x + x*maze_xfactor + maze_xfactor\2, maze_y + y*maze_yfactor + maze_yfactor\2), _
			   MIN(maze_xfactor\3, maze_yfactor\3), RGB(163, 206, 39),,,,F
		end if
	    next
	next
    end sub

    

    sub flash_maze(walls_img as fb.image ptr, msg as string, f as blockfont ptr)
	for i as integer = 1 to 3
	    for j as integer = 500 to 0 step -10
		screenlock
		cls
		dim as integer maze_x = (screen_w - maze_w * maze_xfactor) / 2
		dim as integer maze_y = (screen_h - maze_h * maze_yfactor) / 2
		dim as integer a
		a = iif(j >= 250, j - 250, 250 - j) 
		put (maze_x, maze_y), maze_walls_image, alpha, a
		draw_centered(screen_w, screen_h, msg, f)
		screenunlock
		sleep 10
	    next
	next
    end sub

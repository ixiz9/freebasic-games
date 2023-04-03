    sub def_basic_block
	dim as string bblock_s = _
	    "bbbBXbbbbXBbBbbb" NL _
	    "BbXbbbXBbbbbXBBb" NL _
	    "BbbBbbXBbbbbbbBB" NL _
	    "bBbbBbbbBBbbBbBB" NL _
	    "bbBbbbbBbBbBbbbb" NL _
	    "BXbBbbBBbbXbBBBb" NL _
	    "bbBBBBBbBXbbBBBb" NL _
	    "bBBbBbBbbBBbBBbB"
	
	bb_image = Text2Image(bblock_s, bblock_Xfactor, bblock_yfactor)

	dim as string grass_s = _
	    "GgGGGGGGgggGGgGG" NL _
	    "gGGGGgGGRGGgRggG" NL _
	    "GggRggGRGgGGGGgG" NL _
	    "gGGGGgGgGGGGggGg" NL _
	    "GgGGggggGGGggGGg" NL _
	    "gGggggGGGRGGGggG" NL _
	    "ggGGRggGRggRgRgg" NL _
	    "GRGgggGggGGGGgGG"
	grass_image = Text2Image(grass_s, bblock_Xfactor, bblock_yfactor)

    end sub

    sub def_player_ship
	dim as string player_r_s = _
	    " xxxx                   " NL _
	    " xxxxx         xxx      " NL _
	    "xxxxxxxxxxxxxxxYYYxx    " NL _
	    "xxxxxxxLLLLLLLxxxxxxxxxx" NL _
	    "xxxxxLLLLLLLxxxxxxxxx   " NL _
	    "  LLLLLLL               "
	
	dim as string player_l_s = _
	    "                   xxxx " NL _
	    "      xxx         xxxxx " NL _
	    "    xxYYYxxxxxxxxxxxxxxx" NL _
	    "xxxxxxxxxxLLLLLLLxxxxxxx" NL _
	    "   xxxxxxxxxLLLLLLLxxxxx" NL _
	    "              LLLLLLL   "

	AddTextImage2Sprite(player_r_s, player_xfactor, player_yfactor, _
			    ALIVE, player_sprite)
	AddTextImage2Sprite(player_l_s, player_xfactor, player_yfactor, _
			    ALIVE, player_sprite)
	player_ship_image = Text2Image(player_r_s, player_xfactor, player_yfactor)
    end sub


    
    sub def_alien(num as integer, x as integer, y as integer)
	dim as string saucer_r_s = _
	    "       NNNNNNNNN       " NL _
	    "     NNNNNNNNNNNNN     " NL _
	    "WWWNNNNXXXNNNXXXNNNN   " NL _
	    "WWNNNNNXXXNNNXXXNNNNN  " NL _
	    "   NNNNNNNNNNNNNNNNN   " NL _
	    "    xxxxxxxxxxxxxxx    " NL _
	    "     YYYYYYYYYYYY      " 

	dim as string saucer_rh_s = _
	    "       NNNNNNNNN       " NL _
	    "     NNNNNNNNNNNNN     " NL _
	    "   NNWWWxNNXXXNNNXNN   " NL _
	    "  NNNWWWxNNXXXNNNXNNN  " NL _
	    "   NNNNNNNNNNNNNNNNN   " NL _
	    "    xxxxxxxxxxxxxxx    " NL _
	    "     YYYYYYYYYYYY      " 

	dim as string saucer_f_s = _
	    "       NNNNNNNNN       " NL _
	    "     NNNNNNNNNNNNN     " NL _
	    "   NNNNNNNWWWNNNNNNN   " NL _
	    "  NNNNNNNNWWWNNNNNNNN  " NL _
	    "   NNNNNNNNNNNNNNNNN   " NL _
	    "    xxxxxxxxxxxxxxx    " NL _
	    "      YYYYYYYYYYYY     " 
    
	dim as string saucer_lh_s = _
	    "       NNNNNNNNN       " NL _
	    "     NNNNNNNNNNNNN     " NL _
	    "   NNXNNNXXXNNxWWWNN   " NL _
	    "  NNNXNNNXXXNNxWWWNNN  " NL _
	    "   NNNNNNNNNNNNNNNNN   " NL _
	    "    xxxxxxxxxxxxxxx    " NL _
	    "      YYYYYYYYYYYY     " 

	dim as string saucer_l_s = _
	    "       NNNNNNNNN       " NL _
	    "     NNNNNNNNNNNNN     " NL _
	    "   NNNNXXXNNNXXXNNNNWWW" NL _
	    "  NNNNNXXXNNNXXXNNNNNWW" NL _
	    "   NNNNNNNNNNNNNNNNN   " NL _
	    "    xxxxxxxxxxxxxxx    " NL _
	    "      YYYYYYYYYYYY     " 

	dim as string saucer_boom1_s = _
	    "                       " NL _
	    "        Y  Y  Y        " NL _
	    "         Y Y Y         " NL _
	    "          YWY          " NL _
	    "         Y Y Y         " NL _
	    "        Y  Y  Y        " NL _
	    "                       " 

	dim as string saucer_boom2_s = _
	    "    R   Y   R   Y   R  " NL _
	    "      Y  O  Y  O  Y    " NL _
	    "        Y Y O Y Y      " NL _
	    "          YOWOY        " NL _
	    "        Y Y O Y Y      " NL _
	    "      Y  O  Y  O  Y    " NL _
	    "    R   Y   R   Y   R  " 

	dim as string saucer_boom3_s = _
	    "    Y   O   Y   O   Y  " NL _
	    "      Y  Y  Y  Y  Y    " NL _
	    " Y                     " NL _
	    "    Y              Y   " NL _
	    "                      Y" NL _
	    "      Y  Y  Y  Y  Y    " NL _
	    "    O   Y   Y   Y   O  " 


	if ubound(alien_sprites(num).images(ALIVE).col_img) <= 0 then
	    AddTextImage2Sprite(saucer_r_s, player_xfactor, player_yfactor, _
				ALIVE, alien_sprites(num))
	    AddTextImage2Sprite(saucer_rh_s, player_xfactor, player_yfactor, _
				ALIVE, alien_sprites(num))
	    AddTextImage2Sprite(saucer_f_s, player_xfactor, player_yfactor, _
				ALIVE, alien_sprites(num))
	    AddTextImage2Sprite(saucer_lh_s, player_xfactor, player_yfactor, _
				ALIVE, alien_sprites(num))
	    AddTextImage2Sprite(saucer_l_s, player_xfactor, player_yfactor, _
				ALIVE, alien_sprites(num))
	    AddTextImage2Sprite(saucer_boom1_s, player_xfactor, player_yfactor, _
				DYING, alien_sprites(num))
	    AddTextImage2Sprite(saucer_boom2_s, player_xfactor, player_yfactor, _
				DYING, alien_sprites(num))
	    AddTextImage2Sprite(saucer_boom3_s, player_xfactor, player_yfactor, _
				DYING, alien_sprites(num))
	end if
	with alien_sprites(num)
	    .who = ALIEN_SP
	    .mp.y = y - .h + 1
	    .mp.x = x - .w/2
	    .v.dx = 0
	    .v.dy = 0
	    .time_to_cross(ALIVE) = LVLI.aliens_time_to_cross
	    .frame_count = 0
	    .state = ALIVE
	    .cur_dir = DIR_RIGHT
	    .angle = int(rnd(1) + 0.5) * 179.9
	end with
    end sub

    sub def_fuel_depot(num as integer, x as integer, y as integer)
	dim as string fuel_s = _
	    "     WxxxxxM     " NL _
	    "   WxxxxxxxxxM   " NL _
	    " WxxXXXXXXXXxxxM " NL _
	    "WxxxXYYYYYYXxxxxM" NL _
	    "WxxxXYXXXXXXxxxxM" NL _
	    "WxxxXYXxxxxxxxxxM" NL _
	    "WxxxXYXXXXxxxxxxM" NL _
	    "WxxxXYYYYXxxxxxxM" NL _
	    "WxxxXYXXXXxxxxxxM" NL _
	    "WxxxXYXxxxxxxxxxM" NL _
	    "WxxxXYXxxxxxxxxxM" NL _
	    "WxxxXXXxxxxxxxxxM" NL _
	    "WxxxxxxxxxxxxxxxM"

	dim as string fuel_boom1_s = _
	    "     WxxxxxM    " NL _
	    "   WxxxxxxxxxM  " NL _
	    " WxxXXXXXXXXxxxM" NL _
	    "WxY  Y Y  Y  YxM" NL _
	    "Wx Y  Y  Y Y YxM" NL _
	    "Wx O Y Y O Y OxM" NL _
	    "WxY  O Y   O YxM" NL _
	    "Wx O Y  Y O Y xM" NL _
	    "WxY O O Y O YxxM" NL _
	    "Wx  Y O Y O  OxM" NL _
	    "WxY O Y  Y O YxM" NL _
	    "WxxY O Y O O YxM" NL _
	    "WxxxxxxxxxxxxxxM"

	dim as string fuel_boom2_s = _
	    " x Y R Y x O x Y" NL _
	    "  Y O Y O Yx R x" NL _
	    "x Y O Y O Y Y Rx" NL _
	    "Y Y Y YO Y O Y Y" NL _
	    " Y YO Y YO R Y Y" NL _
	    " O Y Y R Y O Y O" NL _
	    "Y R O Y Y O  O Y" NL _
	    " O R Y O YY O Y " NL _
	    "R Y O R Y OY O Y" NL _
	    "  Y O Y RY O R O" NL _
	    "Y O O Y Y YR O Y" NL _
	    "RY O Y O Y O Y Y" NL _
	    "WxxxxxxxxxxxxxxM"

	dim as string fuel_boom3_s = _
	    " Y   Yx  O     Y" NL _
	    "  O     Y    Y  " NL _
	    "Y  O          Y " NL _
	    "       R    Y   " NL _
	    " Y       O      " NL _
	    "    O       Y   " NL _
	    "     Y       R  " NL _
	    " R      Y       " NL _
	    "   O      R    Y" NL _
	    " R    O     Y   " NL _
	    "Y    Y         Y" NL _
	    "Y    Y    O   R " NL _
	    " Y   Y     O   Y"

	if ubound(fuel_sprites(num).images(ALIVE).col_img) <= 0  then
	    AddTextImage2Sprite(fuel_s, player_xfactor, player_yfactor, _
				ALIVE, fuel_sprites(num))
	    AddTextImage2Sprite(fuel_boom1_s, player_xfactor, player_yfactor, _
				DYING, fuel_sprites(num))
	    AddTextImage2Sprite(fuel_boom2_s, player_xfactor, player_yfactor, _
				DYING, fuel_sprites(num))
	    AddTextImage2Sprite(fuel_boom3_s, player_xfactor, player_yfactor, _
				DYING, fuel_sprites(num))
	end if
	with fuel_sprites(num)
	    .who = FUEL_SP
	    .mp.x = x - .w/2
	    .mp.y = y - .h + 1
	    .v.dx = 0
	    .v.dy = 0
	    .frame_count = 0
	    .state = ALIVE
	end with
    end sub

    sub def_missile_base(num as integer, x as integer, y as integer)
	dim as string missile_base_s = _
	    "                 " NL _
	    "                 " NL _
	    "                 " NL _
	    "WxxxxxxxxxxxxxxxM" NL _
	    "WxxxxRxxxxxRxxxxM" NL _
	    "WxxxRRRxxxRRRxxxM" NL _
	    "WxxRRRRRxRRRRRxxM" NL _
	    "WxxxxxxxxxxxxxxxM"

	dim as string missile_base_boom1_s = _
	    "  Y         Y    " NL _
	    "   Y     Y     Y " NL _
	    "  Y    Y      Y  " NL _
	    " Y  O  Y   Y   O " NL _
	    "  Y  Y   Y   OY  " NL _
	    "Wxx Y O  O Y YxxM" NL _
	    "Wxxx Y O  Y  OxxM" NL _
	    "WxxxxxxxxxxxxxxxM"

	dim as string missile_base_boom2_s = _
	    "  Y  Y   Y O  Y  " NL _
	    " Y   O   Y  R   Y" NL _
	    "   O   Y  O  O Y " NL _
	    "     R   R  Y   Y" NL _
	    " Y  Y  Y O  Y  Y " NL _
	    "  Y R O  Y   Y   " NL _
	    "   Y  Y  O Y  Y  " NL _
	    "  Y O YY  OR Y R " 

	dim as string missile_base_boom3_s = _
	    "   Y    Y    Y O " NL _
	    " O              R" NL _
	    "  Y Y      R O   " NL _
	    "     R      Y   Y" NL _
	    "   Y          O  " NL _
	    "  O       Y      " NL _
	    "  O           Y  " NL _
	    " Y     Y  OR Y R " 

	if ubound(missile_base_sprites(num).images(ALIVE).col_img) <= 0 then
	    AddTextImage2Sprite(missile_base_s, player_xfactor, player_yfactor, _
				ALIVE, missile_base_sprites(num))
	    AddTextImage2Sprite(missile_base_boom1_s, player_xfactor, player_yfactor, _
				DYING, missile_base_sprites(num))
	    AddTextImage2Sprite(missile_base_boom2_s, player_xfactor, player_yfactor, _
				DYING, missile_base_sprites(num))
	    AddTextImage2Sprite(missile_base_boom3_s, player_xfactor, player_yfactor, _
				DYING, missile_base_sprites(num))
	end if
	with missile_base_sprites(num)
	    .who = MISSILE_BASE_SP
	    .mp.x = x - .w/2
	    .mp.y = y - .h + 1
	    .v.dx = 0
	    .v.dy = 0
	    .frame_count = 0
	    .state = ALIVE
	    .last_shot_time = 0
	end with
    end sub

        sub def_player_shots
	dim as string shot_r = _
	    "W   W  W WWWWWWWWWWWWWWWWOOORRRY"
	dim as string shot_l = _
	    "YRRROOOWWWWWWWWWWWWWWWW W  W   W"

	for i as integer = 1 to ubound(shot_sprites)
	    AddTextImage2Sprite(shot_r, player_xfactor, player_yfactor, _
				ALIVE, shot_sprites(i))
	    AddTextImage2Sprite(shot_l, player_xfactor, player_yfactor, _
				ALIVE, shot_sprites(i))
	next
    end sub

    sub def_player_bombs
	dim as string bomb_r_s = _
	    "        " NL _
	    "        " NL _
	    "W  WWWW " NL _
	    "WWWWWWWW" NL _
	    "WWWWWWWW" NL _
	    "W  WWWW " NL _
	    "        " NL _
	    "        "

	dim as string bomb_rh_s = _
	    "    W   " NL _
	    "   W    " NL _
	    "  WWW   " NL _
	    " WWWWWW " NL _
	    "W WWWWW " NL _
	    "   WWW  " NL _
	    "        " NL _
	    "        "

	dim as string  bomb_d_s = _
	    "  WWWW  " NL _
	    "   WW   " NL _
	    "  WWWW  " NL _
	    "  WWWW  " NL _
	    "  WWWW  " NL _
	    "  WWWW  " NL _
	    "   WW   " NL _
	    "        " 

	dim as string bomb_l_s = _
	    "        " NL _
	    "        " NL _
	    " WWWW  W" NL _
	    "WWWWWWWW" NL _
	    "WWWWWWWW" NL _
	    " WWWW  W" NL _
	    "        " NL _
	    "        "

	dim as string bomb_lh_s = _
	    "   W    " NL _
	    "    W   " NL _
	    "   WWW  " NL _
	    " WWWWWW " NL _
	    " WWWWW W" NL _
	    "  WWW   " NL _
	    "        " NL _
	    "        "

	for i as integer = 1 to ubound(bomb_sprites)
	    AddTextImage2Sprite(bomb_r_s, player_xfactor, player_yfactor, _
				ALIVE, bomb_sprites(i))
	    AddTextImage2Sprite(bomb_rh_s, player_xfactor, player_yfactor, _
				ALIVE, bomb_sprites(i))
	    AddTextImage2Sprite(bomb_l_s, player_xfactor, player_yfactor, _
				ALIVE, bomb_sprites(i))
	    AddTextImage2Sprite(bomb_lh_s, player_xfactor, player_yfactor, _
				ALIVE, bomb_sprites(i))
	    AddTextImage2Sprite(bomb_d_s, player_xfactor, player_yfactor, _
				ALIVE, bomb_sprites(i))
	next
    end sub
	
    sub def_missiles
	dim as string missile_r_s = _
	    "RR       " NL _
	    "RRRRRR   " NL _
	    "RRRRRRRRR" NL _
	    "RRRRRR   " NL _
	    "RR       "

	dim as string missile_l_s = _
	    "       RR" NL _
	    "   RRRRRR" NL _
	    "RRRRRRRRR" NL _
	    "   RRRRRR" NL _
	    "       RR"

	dim as string  missile_u_s = _
	    "  R  " NL _
	    "  R  " NL _
	    "  R  " NL _
	    " RRR " NL _
	    " RRR " NL _
	    " RRR " NL _
	    " RRR " NL _
	    "RRRRR" NL _
	    "RRRRR" 

	dim as string  missile_boom1_s = _
	    "          "NL _
	    "         " NL _
	    "   Y Y   " NL _
	    "  Y R  Y " NL _
	    " O  Y O  " NL _
	    "  Y  R  Y" NL _
	    "  R Y Y  " NL _
	    "         " NL _
	    "         "

	dim as string  missile_boom2_s = _
	    "R   Y   O" NL _
	    " O  Y  Y " NL _
	    "  Y Y Y  " NL _
	    "Y   R   Y" NL _
	    "  O Y O  " NL _
	    "Y   R   Y" NL _
	    "  Y Y Y  " NL _
	    " Y  Y  O " NL _
	    "O   Y   R"

	dim as string  missile_boom3_s = _
	    "Y   Y   Y" NL _
	    " Y  Y  Y " NL _
	    "         " NL _
	    "R       Y" NL _
	    "         " NL _
	    "Y       R" NL _
	    "         " NL _
	    " Y  Y  Y " NL _
	    "Y   Y   Y"

	for i as integer = 1 to ubound(missile_sprites)
	    AddTextImage2Sprite(missile_r_s, player_xfactor, player_yfactor, _
				ALIVE, missile_sprites(i))
	    AddTextImage2Sprite(missile_l_s, player_xfactor, player_yfactor, _
				ALIVE, missile_sprites(i))
	    AddTextImage2Sprite(missile_u_s, player_xfactor, player_yfactor, _
				ALIVE, missile_sprites(i))
	    AddTextImage2Sprite(missile_boom1_s, player_xfactor, player_yfactor, _
				DYING, missile_sprites(i))
	    AddTextImage2Sprite(missile_boom2_s, player_xfactor, player_yfactor, _
				DYING, missile_sprites(i))
	    AddTextImage2Sprite(missile_boom3_s, player_xfactor, player_yfactor, _
				DYING, missile_sprites(i))
	next
    end sub

    sub def_bullets
	dim as string bullet_s = "WW" NL "WW"
	for i as integer = 1 to ubound(bullet_sprites)
	    AddTextImage2Sprite(bullet_s, player_xfactor, player_yfactor, _
				ALIVE, bullet_sprites(i))
	next
    end sub


    sub def_extra_life
	dim as string extra_life = _
	    "   YYYY   " NL _
	    " YYYYYYYY " NL _
	    "YYRRYYRRYY" NL _
	    "YRRRRRRRRY" NL _
	    "YRRRRRRRRY" NL _
	    "YYRRRRRRYY" NL _
	    " YYYRRYYY " NL _
	    "   YYYY   "
		       
	for i as integer = 1 to ubound(extra_life_sprites)
	    AddTextImage2Sprite(extra_life, player_xfactor, player_yfactor, _
				ALIVE, extra_life_sprites(i))
	    with extra_life_sprites(i)
		.who = EXTRA_LIFE_SP
		.state = DEAD
	    end with
	next
    end sub

    sub def_level_portal
	dim as string portal1 = _
	    "     BOB     " NL _
	    "    BOOOB    " NL _
	    " BOOOOOOOOOB " NL _
	    "BBpppppppppBB" NL _
	    "BpppppppppppB" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "BpppppppppppB" NL _
	    "BBpppppppppBB" NL _
	    " BOOOOOOOOOB " NL _
	    "    BOOOB    " NL _
	    "     BOB     " NL

	dim as string portal2 = _
	    "     BOB     " NL _
	    "    BOOOB    " NL _
	    " BOOOOOOOOOB " NL _
	    "BBLLLLLLLLLBB" NL _
	    "BLpppppppppLB" NL _
	    "LpppppppppppL" NL _
	    "LpppppppppppL" NL _
	    "LpppppppppppL" NL _
	    "LpppppppppppL" NL _
	    "LpppppppppppL" NL _
	    "LpppppppppppL" NL _
	    "LpppppppppppL" NL _
	    "LpppppppppppL" NL _
	    "LpppppppppppL" NL _
	    "LpppppppppppL" NL _
	    "LpppppppppppL" NL _
	    "LpppppppppppL" NL _
	    "LpppppppppppL" NL _
	    "LpppppppppppL" NL _
	    "BLpppppppppLB" NL _
	    "BBLLLLLLLLLBB" NL _
	    " BOOOOOOOOOB " NL _
	    "    BOOOB    " NL _
	    "     BOB     " NL

	dim as string portal3 = _
	    "     BOB     " NL _
	    "    BOOOB    " NL _
	    " BOOOOOOOOOB " NL _
	    "BBpppppppppBB" NL _
	    "BppLLLLLLLppB" NL _
	    "ppLpppppppLpp" NL _
	    "pLpppppppppLp" NL _
	    "pLpppppppppLp" NL _
	    "pLpppppppppLp" NL _
	    "pLpppppppppLp" NL _
	    "pLpppppppppLp" NL _
	    "pLpppppppppLp" NL _
	    "pLpppppppppLp" NL _
	    "pLpppppppppLp" NL _
	    "pLpppppppppLp" NL _
	    "pLpppppppppLp" NL _
	    "pLpppppppppLp" NL _
	    "pLpppppppppLp" NL _
	    "ppLpppppppLpp" NL _
	    "BppLLLLLLLppB" NL _
	    "BBpppppppppBB" NL _
	    " BOOOOOOOOOB " NL _
	    "    BOOOB    " NL _
	    "     BOB     " NL

	dim as string portal4 = _
	    "     BOB     " NL _
	    "    BOOOB    " NL _
	    " BOOOOOOOOOB " NL _
	    "BBpppppppppBB" NL _
	    "BpppppppppppB" NL _
	    "ppppLLLLLpppp" NL _
	    "pppLpppppLppp" NL _
	    "ppLpppppppLpp" NL _
	    "ppLpppppppLpp" NL _
	    "ppLpppppppLpp" NL _
	    "ppLpppppppLpp" NL _
	    "ppLpppppppLpp" NL _
	    "ppLpppppppLpp" NL _
	    "ppLpppppppLpp" NL _
	    "ppLpppppppLpp" NL _
	    "ppLpppppppLpp" NL _
	    "ppLpppppppLpp" NL _
	    "pppLpppppLppp" NL _
	    "ppppLLLLLpppp" NL _
	    "BpppppppppppB" NL _
	    "BBpppppppppBB" NL _
	    " BOOOOOOOOOB " NL _
	    "    BOOOB    " NL _
	    "     BOB     " NL

	dim as string portal5 = _
	    "     BOB     " NL _
	    "    BOOOB    " NL _
	    " BOOOOOOOOOB " NL _
	    "BBpppppppppBB" NL _
	    "BpppppppppppB" NL _
	    "ppppppppppppp" NL _
	    "pppppLLLppppp" NL _
	    "ppppLpppLpppp" NL _
	    "pppLpppppLppp" NL _
	    "pppLpppppLppp" NL _
	    "pppLpppppLppp" NL _
	    "pppLpppppLppp" NL _
	    "pppLpppppLppp" NL _
	    "pppLpppppLppp" NL _
	    "pppLpppppLppp" NL _
	    "pppLpppppLppp" NL _
	    "ppppLpppLpppp" NL _
	    "pppppLLLppppp" NL _
	    "ppppppppppppp" NL _
	    "BpppppppppppB" NL _
	    "BBpppppppppBB" NL _
	    " BOOOOOOOOOB " NL _
	    "    BOOOB    " NL _
	    "     BOB     " NL

	dim as string portal6 = _
	    "     BOB     " NL _
	    "    BOOOB    " NL _
	    " BOOOOOOOOOB " NL _
	    "BBpppppppppBB" NL _
	    "BpppppppppppB" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "pppppLLLppppp" NL _
	    "ppppLpppLpppp" NL _
	    "ppppLpppLpppp" NL _
	    "ppppLpppLpppp" NL _
	    "ppppLpppLpppp" NL _
	    "ppppLpppLpppp" NL _
	    "ppppLpppLpppp" NL _
	    "ppppLpppLpppp" NL _
	    "ppppLpppLpppp" NL _
	    "pppppLLLppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "BpppppppppppB" NL _
	    "BBpppppppppBB" NL _
	    " BOOOOOOOOOB " NL _
	    "    BOOOB    " NL _
	    "     BOB     " NL

	dim as string portal7 = _
	    "     BOB     " NL _
	    "    BOOOB    " NL _
	    " BOOOOOOOOOB " NL _
	    "BBpppppppppBB" NL _
	    "BpppppppppppB" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppLpppppp" NL _
	    "pppppLpLppppp" NL _
	    "pppppLpLppppp" NL _
	    "pppppLpLppppp" NL _
	    "pppppLpLppppp" NL _
	    "pppppLpLppppp" NL _
	    "pppppLpLppppp" NL _
	    "pppppLpLppppp" NL _
	    "ppppppLpppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "BpppppppppppB" NL _
	    "BBpppppppppBB" NL _
	    " BOOOOOOOOOB " NL _
	    "    BOOOB    " NL _
	    "     BOB     " NL

	dim as string portal8 = _
	    "     BOB     " NL _
	    "    BOOOB    " NL _
	    " BOOOOOOOOOB " NL _
	    "BBpppppppppBB" NL _
	    "BpppppppppppB" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppLpppppp" NL _
	    "ppppppLpppppp" NL _
	    "ppppppLpppppp" NL _
	    "ppppppLpppppp" NL _
	    "ppppppLpppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "ppppppppppppp" NL _
	    "BpppppppppppB" NL _
	    "BBpppppppppBB" NL _
	    " BOOOOOOOOOB " NL _
	    "    BOOOB    " NL _
	    "     BOB     " NL

	if ubound(portal_sprite(1).images(ALIVE).col_img) <= 0 then
	    AddTextImage2Sprite(portal1, player_xfactor * 2, player_yfactor * 3, _
				ALIVE, portal_sprite(1))
	    AddTextImage2Sprite(portal2, player_xfactor * 2, player_yfactor * 3, _
				ALIVE, portal_sprite(1))
	    AddTextImage2Sprite(portal3, player_xfactor * 2, player_yfactor * 3, _
				ALIVE, portal_sprite(1))
	    AddTextImage2Sprite(portal4, player_xfactor * 2, player_yfactor * 3, _
				    ALIVE, portal_sprite(1))
	    AddTextImage2Sprite(portal5, player_xfactor * 2, player_yfactor * 3, _
				ALIVE, portal_sprite(1))
	    AddTextImage2Sprite(portal6, player_xfactor * 2, player_yfactor * 3, _
				ALIVE, portal_sprite(1))
	    AddTextImage2Sprite(portal7, player_xfactor * 2, player_yfactor * 3, _
				ALIVE, portal_sprite(1))
	    AddTextImage2Sprite(portal8, player_xfactor * 2, player_yfactor * 3, _
				ALIVE, portal_sprite(1))
	end if
	portal_sprite(1).mp.x = mapinfo.max_bounds.x - portal_sprite(1).w - 1
	portal_sprite(1).mp.y = (mapinfo.h - portal_sprite(1).h) / 2
	portal_sprite(1).state = ALIVE
	portal_sprite(1).who = PORTAL_SP
    end sub

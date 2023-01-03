#include once "fbgfx.bi"
'#include "sfx.bi"
'#inclib "fbsfx"
using fb
#include "gaming.bas"

dim shared as integer SCREEN_W = 1024
dim shared as integer SCREEN_H = 768
dim shared as integer GYScale = 3
dim shared as integer GXScale = 4
dim shared as double VXScale = 1
dim shared as double VYScale = 1
#define SCORE_Y 10
#define MOTHER_SHIP_Y (SCORE_Y + white4x6.char_image(ASC("A"))->height*1.5)
#define MISSILE_MIN_Y (MOTHER_SHIP_Y - 20)
#define ALIEN_Y (MOTHER_SHIP_Y + mother_ship.h * 1.5)
#define BASE_Y (SCREEN_H - 4*cannon.h - 5*mbase(1,1).h)
#define CANNON_Y (SCREEN_H - 3*cannon.h)
#define SPARE_SHIP_Y (SCREEN_H - 1.5 * cannon.h)
#define ALIENS_DELTA_Y ((BASE_Y - ALIEN_Y) / 36)
#define MISSILE_VY (-32 * VYScale)
#define BOMB_VY (8 * VYScale)
#define MOTHER_SHIP_VX (4 * VXScale)
#define CANNON_VX (6 * VXScale)
#define ALIENS_VX (3 * VXScale)


#define MAX_BOMBS 2
#define START_LIVES 3
#define ALIENS_FLIP_FRAME (16 / frr)
#define ALIEN_DYING_FRAME (5 / frr)
#define CANNON_DYING_FRAME (15 / frr)
#define ALIEN_R 5
#define ALIEN_C 11
#define ALIEN_T (ALIEN_R * ALIEN_C)

    
'SoundSet (44100,1,16)


enum SpriteType
    S_UNKNOWN = -1,
    S_NONE = 0,
    S_ALIEN,
    S_CANNON,
    S_MISSILE,
    S_BOMB,
    S_BASE,
    S_MOTHERSHIP
end enum

dim shared as CollisionImage base_image(3)
dim shared as fb.Image ptr score_image, game_over, digit_image(0 to 9)
dim shared as sprite aliens(ALIEN_T)
dim shared as sprite cannon, missile, bomb(MAX_BOMBS)
dim shared as sprite mbase(3,22)
dim shared as sprite mother_ship

dim shared as integer aliens_left, score, hiscore, lives = START_LIVES
dim shared as double frr
    
#include "assets.bas"

    
function DetectSpriteCollision(s as sprite ptr, byref which as integer) as SpriteType
    dim as coord col
    if detectcollision(s, col) = 0 then return S_NONE
    if s <> @cannon and inboundingbox(col, @cannon) then return S_CANNON
    if s <> @missile and inboundingbox(col, @missile) then return S_MISSILE
    if s <> @mother_ship and inboundingbox(col, @mother_ship) then return S_MOTHERSHIP
    for i as integer = 1 to 3
	for j as integer = 1 to 22
	    if s <> @mbase(i,j) and inboundingbox(col, @mbase(i,j)) then which = i * 100 + j : return S_BASE
	next
    next
    for i as integer = 1 to MAX_BOMBS
	if s <> @bomb(i) and inboundingbox(col, @bomb(i)) then which = i : return S_BOMB
    next	
    for i as integer = 1 to ALIEN_T
	if s <> @aliens(i) and inboundingbox(col, @aliens(i)) then which = i : return S_ALIEN
    next	
    return S_UNKNOWN
end function

    

function BaseHit(found as integer) as integer
    if found > 0 then
	dim as integer b = found \ 100, br = found mod 100
	if mbase(b,br).display_image < 3 then
	    mbase(b,br).display_image += 1
	else
	    mbase(b,br).state = DEAD
	end if
    end if
    return found
end function

sub CannonLogic
    for i as integer = 1 to lives - 1
	put (cannon.w * i * 1.5, SPARE_SHIP_Y), cannon.ci(1).image, trans
    next

    if cannon.state = DYING then
	cannon.frame_count += 1
	if cannon.frame_count >= CANNON_DYING_FRAME then
	    cannon.x = 0
	    cannon.display_image = 1
	    cannon.state = ALIVE
	    lives -= 1
	end if
    end if

    put (cannon.x, cannon.y), cannon.ci(cannon.display_image).image, trans
end sub
    

sub MoveAliens
    dim as integer flop = 0
    for i as integer = 1 to ALIEN_T
	if aliens(i).state <> DEAD then
	    dim as double avx = aliens(i).vx * frr
	    if aliens(i).x + avx < 0 or aliens(i).x + aliens(i).w + avx >= SCREEN_W then flop = 1 : exit for
	end if
    next
    
    for i as integer = 1 to ALIEN_T
	if aliens(i).state <> DEAD then
	    if flop > 0 then aliens(i).vx = -aliens(i).vx : aliens(i).y += ALIENS_DELTA_Y
	    dim as double avx = aliens(i).vx * frr
	    aliens(i).x += avx * (3.0 - 2.0 / (ALIEN_T - 1) * (aliens_left - 1))
	end if
    next
end sub

sub AlienLogic
    dim as SpriteType st
    dim as integer which
    for i as integer = 1 to ALIEN_T
	if aliens(i).state <> DEAD then
	    st = DetectSpriteCollision(@aliens(i), which)
	    if st = S_BASE then BaseHit(which)
	    if st = S_CANNON or aliens(i).y > BASE_Y + cannon.h then
		cannon.state = DYING
		cannon.display_image = 2
		cannon.frame_count = 0
		aliens_left = 0
	    end if
	    aliens(i).frame_count += 1
	    if aliens(i).state = ALIVE then aliens(i).display_image = (int(aliens(i).frame_count / ALIENS_FLIP_FRAME) mod 2) + 1
	    put (aliens(i).x,aliens(i).y), aliens(i).ci(aliens(i).display_image).image, trans
	    if aliens(i).state = DYING and aliens(i).frame_count >= ALIEN_DYING_FRAME then aliens(i).state = DEAD
	end if
    next

end sub

sub MothershipLogic
    if mother_ship.state = DEAD and rnd() < (0.005 * frr) then
	mother_ship.state = ALIVE
	mother_ship.display_image = 1
	mother_ship.frame_count = 0
	dim as double r = rnd()
	if r < 0.5 then
	    mother_ship.vx = abs(mother_ship.vx)
	    mother_ship.x = 0
	else
	    mother_ship.vx = - abs(mother_ship.vx)
	    mother_ship.x = SCREEN_W - mother_ship.w - 1
	end if
	mother_ship.x -= mother_ship.vx * frr
    end if
    if mother_ship.state <> DEAD then
	mother_ship.frame_count += 1
	if mother_ship.state = ALIVE then
	    mother_ship.x += mother_ship.vx * frr
	    if mother_ship.x < 0 or mother_ship.x + mother_ship.w >= SCREEN_W then mother_ship.state = DEAD
	    mother_ship.display_image = (int(mother_ship.frame_count / ALIENS_FLIP_FRAME) mod 2) + 1
	end if
	if mother_ship.state = DYING and mother_ship.frame_count >= ALIEN_DYING_FRAME then mother_ship.state = DEAD
	if mother_ship.state <> DEAD then _
	    put (mother_ship.x,mother_ship.y), mother_ship.ci(mother_ship.display_image).image, trans
    end if
end sub
    
sub MissileLogic
    dim as SpriteType st
    dim as integer which
    if missile.state <> DEAD then	
	missile.y += missile.vy*frr
	missile.x += missile.vx*frr
	if missile.y < MISSILE_MIN_Y then
	    missile.state = DEAD
	else
	    st = DetectSpriteCollision(@missile, which)
	    if st = S_ALIEN then
		if aliens(which).state = ALIVE then
		    aliens(which).state = DYING
		    aliens(which).frame_count = 0
		    aliens(which).display_image = 3
		    aliens_left -= 1
		    score += ((ALIEN_T-which) \ ALIEN_C + 1) * 20
		end if
	    end if
	    if st = S_BASE then BaseHit(which)
	    if st = S_MOTHERSHIP then
		mother_ship.state = DYING
		mother_ship.frame_count = 0
		mother_ship.display_image = 3
		score += 500
	    end if
	    if st <> S_NONE and st <> S_ALIEN and st <> S_BASE and st <> S_MOTHERSHIP then print "st = ";st
	    if st <> S_NONE then missile.state = DEAD
	end if
	if missile.state <> DEAD then put (missile.x, missile.y), missile.ci(missile.display_image).image, trans
    end if
end sub

sub BombLogic
    dim as SpriteType st
    dim as integer which        
    for i as integer = 1 to MAX_BOMBS
	if bomb(i).state = DEAD and aliens_left > 0 and rnd() < (0.05 * frr) then
	    dim as integer j, k
	    do 
		j = int(rnd() * ALIEN_C + 1)
		for r as integer = ALIEN_R to 1 step -1
		    k = (r-1)*ALIEN_C + j
		    if aliens(k).state <> DEAD then exit for
		    k = 0
		next
	    loop while k = 0
	    bomb(i).vx = 0
	    bomb(i).vy = BOMB_VY
	    bomb(i).x = aliens(k).x + aliens(k).w/2 - bomb(i).w/2 - (bomb(i).vx * frr)
	    bomb(i).y = aliens(k).y + aliens(k).h + 1 - (bomb(i).vy * frr)
	    bomb(i).state = ALIVE
	    bomb(i).display_image = 1
	    bomb(i).frame_count = 0
	end if
	if bomb(i).state = ALIVE then
	    bomb(i).x += bomb(i).vx * frr
	    bomb(i).y += bomb(i).vy * frr
	    if bomb(i).y > cannon.y + cannon.h then
		bomb(i).state = DEAD
	    else
		st = DetectSpriteCollision(@bomb(i), which)
		if st = S_CANNON then
		    cannon.state = DYING
		    cannon.display_image = 2
		    cannon.frame_count = 0
		end if
		if st = S_BASE then BaseHit(which)
		if st = S_MISSILE then
		    bomb(i).state = DYING
		    bomb(i).frame_count = 0
		    bomb(i).display_image = 2
		    missile.state = DEAD
		end if
		if st <> S_NONE and bomb(i).state = ALIVE then bomb(i).state = DEAD
	    end if
	end if
	if bomb(i).state <> DEAD then
	    bomb(i).frame_count += 1
	    if bomb(i).state <> DEAD then put (bomb(i).x, bomb(i).y), bomb(i).ci(bomb(i).display_image).image, trans
	    if bomb(i).state = DYING and bomb(i).frame_count >= ALIEN_DYING_FRAME then bomb(i).state = DEAD
	end if
    next
end sub


    
sub print_score(score as integer)
    dim as string s
    s = "SCORE " + str(score)
    draw_text(10, SCORE_Y, s, @white4x6, 1)
    if score > hiscore then hiscore = score
    s = "HISCORE " + str(hiscore)
    draw_text(SCREEN_W / 2, SCORE_Y, s, @white4x6, 1)
    
end sub
	
sub ResetAliensBasesEtc
    for i as integer = 1 to ALIEN_T
	aliens(i).x = ((i - 1) mod ALIEN_C) * int(aliens(1).w * 1.5)
	aliens(i).y = ((i - 1) \ ALIEN_C) * int(aliens(1).h * 1.25) + ALIEN_Y
	aliens(i).vx = ALIENS_VX
	aliens(i).state = ALIVE
	aliens(i).frame_count = 0
	aliens(i).display_image = 1
    next
    aliens_left = ALIEN_T
    for b as integer = 1 to 3
	for i as integer = 1 to 22
	    mbase(b,i).display_image = 1
	    mbase(b,i).state = ALIVE
	    aliens(i).frame_count = 0
	next
    next
    missile.state = DEAD
    for i as integer  = 1 to MAX_BOMBS
	bomb(i).state = DEAD
    next
    mother_ship.x = 0
    mother_ship.y = MOTHER_SHIP_Y
    mother_ship.vx = MOTHER_SHIP_VX
    mother_ship.state = DEAD
end sub

function HandleKeys() as integer
    dim as string pressed = KeysPressed("ad /")
    if cannon.state = ALIVE then
	dim as double cvx = cannon.vx * frr
	if instr(pressed,"a") > 0 and cannon.x - cvx >= 0 then cannon.x -= cvx
	if instr(pressed,"d") > 0 and cannon.x + cannon.w + cvx < SCREEN_W then cannon.x += cvx
	if instr(pressed," ") > 0 and missile.state = DEAD then
	    missile.state = ALIVE
	    missile.x = cannon.x + cannon.w/2 - missile.w/2
	    missile.y = cannon.y - 1 - missile.h
	    missile.vy = MISSILE_VY
	end if
    end if
    if instr(pressed,"/") > 0 then return 1
    return 0
end function

function GameLoop() as integer
    dim as integer frames
    dim as double start_t, end_t

    cannon.x = 0
    cannon.y = CANNON_Y
    cannon.vx = CANNON_VX
    cannon.state = ALIVE
    frr = 1
    start_t = timer()
    do
	dim as integer which
	dim as SpriteType st
	

	if HandleKeys() then exit do

	MoveAliens

	if aliens_left = 0 then
	    ResetAliensBasesEtc
	end if

	screenlock
	cls
	
	
	print_score(score)
	
	CannonLogic
	
	for i as integer = 1 to 3
	    for j as integer = 1 to 22
		if mbase(i,j).state = ALIVE then
		    put (mbase(i,j).x,mbase(i,j).y), mbase(i,j).ci(mbase(i,j).display_image).image, trans
		end if
	    next
	next
	
	AlienLogic
	MothershipLogic
	MissileLogic
	BombLogic
    
	screenunlock

	end_t = timer()
	sleep 1
	frames += 1
	dim as double frame_rate = frames / (end_t - start_t)
	frr = 30 / frame_rate

    loop while lives > 0
    return frames
end function

sub PickResolution
    dim as integer res
    do
	print "Pick you game resolution:"
	print "1) 800x600"
	print "2) 1024x768"
	print "3) 1280x720"
	print "4) 1280x800"
	print "5) 1366x768"
	print "6) 1440x900"
	print "q) quit"
	res = getkey()
	if res = ASC("q") then end
	res -= ASC("0")
    loop while res < 1 or res > 6
    select case res
    case 1
	SCREEN_W = 800
	SCREEN_H = 600
	GXScale = 3
	GYScale = 2
	VXScale = 0.75
	VYScale = 0.75
    case 2
	SCREEN_W = 1024
	SCREEN_H = 768
	GXScale = 4
	GYScale = 3
	VXScale = 1
	VYScale = 1
    case 3
	SCREEN_W = 1280
	SCREEN_H = 720
	GXScale = 5
	GYScale = 3
	VXScale = 1.2
	VYScale = 1
    case 4
	SCREEN_W = 1280
	SCREEN_H = 800
	GXScale = 5
	GYScale = 3
	VXScale = 1.2
	VYScale = 1
    case 5
	SCREEN_W = 1366
	SCREEN_H = 768
	GXScale = 5
	GYScale = 3
	VXScale = 1.3
	VYScale = 1
    case 6
	SCREEN_W = 1440
	SCREEN_H = 900
	GXScale = 6
	GYScale = 3
	VXScale = 1.4
	VYScale = 1.1
    end select
end sub
	
	
    
    
sub PlayGame
    dim as integer ky, frames
    PickResolution
    open cons for output as #1 ' open console to file numer 1
    screenres SCREEN_W, SCREEN_H, 32, 1, GFX_FULLSCREEN
    MakeAssets
    do
	ResetAliensBasesEtc
	cls
	draw_centered(!"WELCOME TO\nSPACE INVADERS\n\nIN GAME PRESS\n" _
		      !"A TO MOVE LEFT \nD TO MOVE RIGHT\nSPC TO FIRE    \n" _
		      !"/ TO QUIT      \n\nPRESS ANY KEY\nTO START", @white4x6)
	getkey()
	score = 0
	GameLoop()
	
	dim as integer w1 = draw_text(0,0,"GAME OVER", @yellow10x10, 0)
	dim as integer h1 = (SCREEN_H - yellow10x10.char_image(asc("A"))->height)/2
	w1 = draw_text((SCREEN_W - w1)/2, h1, "GAME ", @yellow10x10, 1)
	w1 = draw_text(w1, h1, "OVER ", @red10x10, 1)
	getkey

	cls
	draw_centered(!"DO YOU WANT\nTO PLAY AGAIN\n(Y/N)", @white4x6)
	do : ky = getkey() : loop while ucase(chr(ky)) <> "Y" and ucase(chr(ky)) <> "N"
    loop while ucase(chr(ky)) = "Y"    
end sub


randomize
PlayGame


// Project: avoider 
// Created: 2021-06-23

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "avoider" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

//load images
global playerImg = 1
global badyImg = 2

LoadImage(playerImg,"player.png")
LoadImage(badyImg,"bady.png")

//create sprites

global playerSprite = 1
global sprite_counter = 2
global ybaddyr as ybaddy[]

CreateSprite(playerSprite,playerImg)

new_baddy(random(0,50),random(0,500))
new_baddy(random(0,50),random(0,500))
new_baddy(random(0,50),random(0,500))
new_baddy(random(0,50),random(0,500))
new_baddy(random(0,50),random(0,500))
new_baddy(random(0,50),random(0,500))

//init timer

global spawnTimerDuration as float
global spawnTimerDone as float

spawnTimerDuration = 3

spawnTimerDone = GetSeconds() + spawnTimerDuration

//game vars

global points = 0
global game_over = 0

do
	//if spawnTimerDone < timer() then print("timer done")
	//if spawnTimerDone+2 < timer() then spawnTimerDone = GetSeconds() + spawnTimerDuration
	print("points: "+str(points))
	if game_over = 1
		print("game over")
	endif

	if game_over = 0
		inc points
		spawn_baddy()
		player_movment()
		player_collide()
		baddy_movment()
		baddy_boundery()
	endif
    Sync()
loop


function player_movment()
	SetSpritePosition(playerSprite,GetPointerX(),GetPointerY()-50)
endfunction

function player_collide()
	for i = 0 to ybaddyr.length
		bid = ybaddyr[i].id
		if GetSpriteCollision(bid,playerSprite) then game_over = 1
	next i
endfunction


type ybaddy
	id
	speed
	dirx
	diry
endtype

function new_baddy(x as float ,y as float)
	
	nb = sprite_counter //new baddy id
	
	b as ybaddy
	b.id = nb
	b.speed = Random(1,4)
	b.dirx = random(0,1)
	b.diry = random(0,1)
	if random(1,10) >5 then b.dirx = -1
	if random(1,10) >5 then b.diry = -1
	
	CreateSprite(nb,badyImg)
	inc sprite_counter
	SetSpritePosition(nb,x,y)
	ybaddyr.insert(b)
	
endfunction

function spawn_baddy()
	if spawnTimerDone < timer() 
	
		if random(1,10) >5
			new_baddy(random(0,50),random(0,500))
		else
			new_baddy(random(0,500),random(0,50))
		endif
		//reset timer
		spawnTimerDone = GetSeconds() + spawnTimerDuration
	endif
	
endfunction


function baddy_movment()
	for i = 0 to ybaddyr.length
		bid = ybaddyr[i].id
		speed =  ybaddyr[i].speed
		dx = ybaddyr[i].dirx
		dy = ybaddyr[i].diry
		x = GetSpriteX(bid)
		y = GetSpriteY(bid)
		SetSpritePosition(bid,x+(speed*dx),y+(speed*dy))
		
		if mod(points,500) = 0
			ybaddyr[i].dirx = random(0,1)
			ybaddyr[i].diry = random(0,1)
			if random(1,10) >5 then ybaddyr[i].dirx = -1
			if random(1,10) >5 then ybaddyr[i].diry = -1
		endif
	next i
endfunction


function baddy_boundery()
	for i = 0 to ybaddyr.length
		bid = ybaddyr[i].id

		x = GetSpriteX(bid)
		y = GetSpriteY(bid)
		
		if x > GetScreenBoundsRight() then x = 0
		if x < GetScreenBoundsLeft() then x = GetScreenBoundsRight()
		if y > GetScreenBoundsBottom() then y = 0
		if y < GetScreenBoundsTop() then y = GetScreenBoundsBottom()
		
		SetSpritePosition(bid,x,y)
	next i
endfunction


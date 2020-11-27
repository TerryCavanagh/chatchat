public function titlerender(key:KeyPoll, gfx:graphicsclass, map:mapclass, game:gameclass, obj:entityclass):void {
	gfx.fillrect(0, 0, 320, 300, 128, 128, 128);
	
	gfx.drawmap(map, game);
	
	gfx.drawchatbox(game);
	
	gfx.drawgui();
	gfx.render(game);
}

public function clicktostartrender(key:KeyPoll, gfx:graphicsclass, map:mapclass, game:gameclass, obj:entityclass):void {
	for (j = 0; j < 20; j++) {
		for (i = 0; i < 21; i++) {
			gfx.drawtile((i * 16)-int(help.slowsine/8), (j * 16)-int(help.slowsine/4), 280);
		}		
	}
	
	gfx.drawtextbox(20, 90, 280, 50, 0, true);
	/*gfx.bigprint( 60, 76, "CHATCHAT", 0, 0, 0, false, 4);
	gfx.bigprint( 60, 84, "CHATCHAT", 0, 0, 0, false, 4);
	gfx.bigprint( 64, 80, "CHATCHAT", 0, 0, 0, false, 4);
	gfx.bigprint( 56, 80, "CHATCHAT", 0, 0, 0, false, 4);*/
	gfx.bigprint( 60, 101, "CHATCHAT", 0, 0, 0, true, 4);
	gfx.drawtextbox(60, 145, 200, 19, 0, true);
	gfx.print( 60, 151, "CLICK TO START", 0, 0, 0, true);
	
	gfx.drawtextbox(20, 262, 280, 29, 0, true);
	gfx.print( 60, 268, "GAME BY TERRY CAVANAGH", 0,0,0, true);
	gfx.print( 60, 278, "GRAPHICS BY HAYDEN SCOTT-BARON", 0,0,0, true);
	
	//gfx.bigprint( 60, 80, "CLICK TO START", 255, 255, 255, true, 4);
	/*if ((int(help.glow / 16)) % 2 == 0) {
	  gfx.print( 155-gfx.len(game.textfield)/2, 155, game.textfield + "_", 0, 0, 0);
	}else {
	  gfx.print( 155-gfx.len(game.textfield)/2, 155, game.textfield, 0, 0, 0);
	}*/
	
	gfx.drawgui();
	gfx.render(game);
}

public function lobbyrender(key:KeyPoll, gfx:graphicsclass, map:mapclass, game:gameclass, obj:entityclass):void {
  for (j = 0; j < 21; j++) {
		for (i = -1; i < 20; i++) {
			gfx.drawtile((i * 16)+int(help.slowsine/4), (j * 16)-int(help.slowsine/2), 281);
		}		
	}
	
	if (game.lobbystate == 0) {
		if (game.updateroomlist) {			
			gfx.drawtextbox(90, 78, 140, 15, 0, true);
			gfx.print( -1, 82, "LOBBY", 0, 0, 0, true);
			
			gfx.drawtextbox(60, 208, 90, 15, 0, true);
			gfx.print( 70, 212, "(R)efresh List", 0, 0, 0);
			
			gfx.drawtextbox(170, 208, 90, 15, 0, true);
			gfx.print( 179, 212, "(C)reate Room", 0, 0, 0);
			
		  gfx.drawtextbox(60, 100, 200, 100, 0, true);
			gfx.print( 90, 110, "Rooms Online", 0, 0, 0);
			gfx.print( 212, 110, "Cats", 0, 0, 0);
			for (i = game.lobbymenustart; (i < game.roomlist.length) && (i < game.lobbymenustart + 5); i++) {
				gfx.print(90, 130 + ((i - game.lobbymenustart) * 12), game.roomlist[i].id, 0, 0, 0);
				gfx.print(220, 130 + ((i-game.lobbymenustart) * 12), String(game.roomlist[i].onlineUsers), 0, 0, 0);
			}
			
			gfx.drawbox(80, 128 + (game.lobbymenuposition * 12), 160, 11, 0, 0, 0);
			
			if (game.lobbymenustart > 0) {
				gfx.print(248, 125, "^", 0, 0, 0);
				gfx.print(248, 128, "^", 0, 0, 0);
			}
			if (game.roomlist.length > 5 + game.lobbymenustart) {
				gfx.print(248, 184, "v", 0, 0, 0);
				gfx.print(248, 189, "v", 0, 0, 0);
			}
		}else {
		  gfx.drawtextbox(60, 143, 200, 20, 0, true);
		  gfx.print( -1, 150, "Waiting for roomlist...", 0, 0, 0, true);
		}
	}else	if (game.lobbystate == 1) {
		gfx.drawtextbox(65, 130, 190, 40, 0, true);
		gfx.print( -1, 140, "ENTER ROOMNAME TO CREATE:", 0, 0, 0, true);
		if ((int(help.glow / 16)) % 2 == 0) {
			gfx.print( 155-gfx.len(game.textfield)/2, 155, game.textfield + "_", 0, 0, 0);
		}else {
			gfx.print( 155-gfx.len(game.textfield)/2, 155, game.textfield, 0, 0, 0);
		}
	}else if(game.lobbystate==2){
		gfx.drawtextbox(30, 143, 260, 20, 0, true);
		gfx.print( -1, 150, "Now connecting to " + game.gameroomname + "...", 0, 0, 0, true);
	}
	
	gfx.drawgui();
	gfx.render(game);
}

public function loginrender(key:KeyPoll, gfx:graphicsclass, map:mapclass, game:gameclass, obj:entityclass):void {
  for (j = 0; j < 20; j++) {
		for (i = 0; i < 21; i++) {
			gfx.drawtile((i * 16)-int(help.slowsine/8), (j * 16)-int(help.slowsine/4), 280);
		}		
	}
	
	gfx.drawtextbox(60, 130, 200, 40, 0, true);
	//gfx.print( -1, 80, "CAT A DISTANCE", 0, 0, 0, true);
	gfx.print( -1, 140, "ENTER YOUR NAME:", 0, 0, 0, true);
	if ((int(help.glow / 16)) % 2 == 0) {
	  gfx.print( 155-gfx.len(game.textfield)/2, 155, game.textfield + "_", 0, 0, 0);
	}else {
	  gfx.print( 155-gfx.len(game.textfield)/2, 155, game.textfield, 0, 0, 0);
	}
	
	gfx.drawgui();
	gfx.render(game);
}

public function connectrender(key:KeyPoll, gfx:graphicsclass, map:mapclass, game:gameclass, obj:entityclass):void {
	if (game.connectionerror) {
		gfx.bigprint(5, 140, "CONNECTION ERROR", 128 + ((help.glow / 16) % 2) * 128, 128 - +((help.glow / 16) % 2) * 128, 128 - +((help.glow / 16) % 2) * 128, true);
    gfx.print(5, 160, game.errormessage.substr(0,40), 128 + ((help.glow / 16) % 2) * 128, 128 - +((help.glow / 16) % 2) * 128, 128 - +((help.glow / 16) % 2) * 128, true);
		if(game.errormessage.length>40) gfx.print(5, 170, game.errormessage.substr(40,80), 128 + ((help.glow / 16) % 2) * 128, 128 - +((help.glow / 16) % 2) * 128, 128 - +((help.glow / 16) % 2) * 128, true);
		if(game.errormessage.length>80) gfx.print(5, 180, game.errormessage.substr(80,240), 128 + ((help.glow / 16) % 2) * 128, 128 - +((help.glow / 16) % 2) * 128, 128 - +((help.glow / 16) % 2) * 128, true);
		
		gfx.print(5, 200, "Sorry. Try reconnecting!", 128 + ((help.glow / 16) % 2) * 128, 128 - +((help.glow / 16) % 2) * 128, 128 - +((help.glow / 16) % 2) * 128, true);
	}else {
		for (j = 0; j < 20; j++) {
			for (i = 0; i < 21; i++) {
				gfx.drawtile((i * 16)-int(help.slowsine/8), (j * 16)-int(help.slowsine/4), 280);
			}		
		}
		gfx.drawtextbox(60, 143, 200, 20, 0, true);
	  gfx.print(5, 150, "Connecting to server...", 0, 0, 0, true);
	}
	
	gfx.drawgui();
	gfx.render(game);
}

public function gamerender(key:KeyPoll, gfx:graphicsclass, map:mapclass, game:gameclass, obj:entityclass):void {	
	if (game.thisplayeractive) {
		if(game.hairballmode==0){
			game.camerax = (game.player[game.playernum].xp - (game.player[game.playernum].xp % 20)) / 20;
			game.cameray = (game.player[game.playernum].yp - (game.player[game.playernum].yp % 12)) / 12;
				
			gfx.zoomx = ((game.player[game.playernum].xp - (game.camerax * 20)) * 16) - 72;
			gfx.zoomy = ((game.player[game.playernum].yp - (game.cameray * 12)) * 16) - 40;
		}else {
			//Focus on the hairball!
			game.camerax = (game.hairballx - (game.hairballx % 20)) / 20;
			game.cameray = (game.hairbally - (game.hairbally % 12)) / 12;
				
			gfx.zoomx = ((game.hairballx - (game.camerax * 20)) * 16) - 72;
			gfx.zoomy = ((game.hairbally - (game.cameray * 12)) * 16) - 40;
		}
		
		if (gfx.zoomx < 8) gfx.zoomx = 8;
		if (gfx.zoomy < 8) gfx.zoomy = 8;
		
		if (gfx.zoomx > 152) gfx.zoomx = 152;
		if (gfx.zoomy > 88) gfx.zoomy = 88;
		
		gfx.drawmap(map, game);
		
	  //Camera check here:
		if (game.oldcamerax == -1) {
			//first frame check
			game.oldcamerax = game.camerax;
			game.oldcameray = game.cameray;
		}else {
			if (game.oldcamerax != game.camerax || game.oldcameray != game.cameray) {
				//We've changed position
				game.globalconsolemessage("!", game.username + " left " + game.roomn[game.oldroom()], game.oldroom());
				game.globalconsolemessage("!", game.username + " entered " + game.roomn[game.currentroom()], game.currentroom());
				game.oldcamerax = game.camerax;
				game.oldcameray = game.cameray;
			}
		}
		
		//Draw player 1
		for (i = 0; i < game.servernumplayers; i++){
			if (game.camerax == (game.player[i].xp - (game.player[i].xp % 20)) / 20
			 && game.cameray == (game.player[i].yp - (game.player[i].yp % 12)) / 12) {
			  if (game.serverplayeronline[i]) {
			    if (game.serverplayerisdog[i]) {
						if (game.player[i].dir == 4) {
							gfx.drawzoomsprite((game.player[i].xp - (game.camerax * 20)) * 16, (game.player[i].yp - (game.cameray * 12)) * 16, ((i % 10) * 20) + ((help.slowsine / 32) % 2) + 8 + 200);	
						}else if (game.player[i].dir == 5) {
							gfx.drawzoomsprite((game.player[i].xp - (game.camerax * 20)) * 16, (game.player[i].yp - (game.cameray * 12)) * 16, ((i % 10) * 20) + ((help.slowsine / 32) % 2) + 10 + 200);
						}else if (game.player[i].dir == 6) {
							gfx.drawzoomsprite((game.player[i].xp - (game.camerax * 20)) * 16, (game.player[i].yp - (game.cameray * 12)) * 16, ((i % 10) * 20) + ((help.slowsine / 32) % 2) + 14 + 200);
						}else if (game.player[i].dir == 7) {
							gfx.drawzoomsprite((game.player[i].xp - (game.camerax * 20)) * 16, (game.player[i].yp - (game.cameray * 12)) * 16, ((i % 10) * 20) + ((help.slowsine / 32) % 2) + 12 + 200);
						}else {
							gfx.drawzoomsprite((game.player[i].xp - (game.camerax * 20)) * 16, (game.player[i].yp - (game.cameray * 12)) * 16, ((i % 10) * 20) + ((help.slowsine / 16) % 2) + 200 + (game.player[i].dir) * 2);
						}
					}else{
						if (game.player[i].dir == 4) {
							gfx.drawzoomsprite((game.player[i].xp - (game.camerax * 20)) * 16, (game.player[i].yp - (game.cameray * 12)) * 16, ((i % 10) * 20) + ((help.slowsine / 32) % 2) + 8);	
						}else if (game.player[i].dir == 5) {
							gfx.drawzoomsprite((game.player[i].xp - (game.camerax * 20)) * 16, (game.player[i].yp - (game.cameray * 12)) * 16, ((i % 10) * 20) + ((help.slowsine / 32) % 2) + 10);
						}else if (game.player[i].dir == 6) {
							gfx.drawzoomsprite((game.player[i].xp - (game.camerax * 20)) * 16, (game.player[i].yp - (game.cameray * 12)) * 16, ((i % 10) * 20) + ((help.slowsine / 32) % 2) + 14);
						}else if (game.player[i].dir == 7) {
							gfx.drawzoomsprite((game.player[i].xp - (game.camerax * 20)) * 16, (game.player[i].yp - (game.cameray * 12)) * 16, ((i % 10) * 20) + ((help.slowsine / 32) % 2) + 12);
						}else {
							gfx.drawzoomsprite((game.player[i].xp - (game.camerax * 20)) * 16, (game.player[i].yp - (game.cameray * 12)) * 16, ((i % 10) * 20) + ((help.slowsine / 16) % 2) + (game.player[i].dir) * 2);
						}
					}
				}
			}
		}
		
		/*
		//Draw player 2
		if (game.camerax == (game.player[1].xp - (game.player[1].xp % 20)) / 20
		 && game.cameray == (game.player[1].yp - (game.player[1].yp % 12)) / 12) {		
			if(game.deathseq>0  && game.playernum==1){
				gfx.drawzoomtile((game.player[1].xp - (game.camerax * 20)) * 16, (game.player[1].yp - (game.cameray * 12)) * 16, 44 + 20);
			}else {
				gfx.drawzoomtile((game.player[1].xp - (game.camerax * 20)) * 16, (game.player[1].yp - (game.cameray * 12)) * 16, 44 + game.player[1].dir);
			}
		}
		if (game.hairballmode == 1) {
			gfx.drawzoomtile((game.hairballx - (game.camerax * 20)) * 16, (game.hairbally - (game.cameray * 12)) * 16, 25);
		}
		*/
		//gfx.drawentities(game, obj);
		
		gfx.drawzoombuffer();
		
		//Draw playername
		for (i = 0; i < game.servernumplayers; i++) {
			if (game.serverplayeronline[i]) {
				if (game.camerax == (game.player[i].xp - (game.player[i].xp % 20)) / 20) {		
					if (game.cameray == (game.player[i].yp - (game.player[i].yp % 12)) / 12) {		
						gfx.print(((game.player[i].xp - (game.camerax * 20)) * 16 * 2) - (gfx.zoomx * 2)+16-(gfx.len(game.serverplayernames[i])/2), ((game.player[i].yp - (game.cameray * 12)) * 16 * 2) - (gfx.zoomy * 2) + 32,
							game.serverplayernames[i], 255, 255, 255);
					}
				}
			}
		}
		
		//Draw enemy information
		//gfx.drawentityinfo(map, game);
		
		//Player names
		/*
		if(game.playernum==0){
			gfx.print(16 - (gfx.len(game.username)/2)+ (game.player[0].xp * 16 * 2) - gfx.zoomx*2, ((game.player[0].yp - (game.cameray * 12)) * 16*2) - (gfx.zoomy*2)+32,
								 game.username, 255, 255, 255);
								 
			/*if (game.cameray == (game.player[1].yp - (game.player[1].yp % 12)) / 12) {		
				gfx.print((game.player[1].xp * 16 * 2) - gfx.zoomx*2, ((game.player[1].yp - (game.cameray * 12)) * 16*2) - (gfx.zoomy*2)+32,
								 "Other Player", 255, 255, 255);
			}
		}else {
			gfx.print(16 - (gfx.len(game.username)/2) + (game.player[1].xp * 16 * 2) - gfx.zoomx*2, ((game.player[1].yp - (game.cameray * 12)) * 16*2) - (gfx.zoomy*2)+32,
								 game.username, 255, 255, 255);
								 
			/*if (game.cameray == (game.player[0].yp - (game.player[0].yp % 12)) / 12) {	
				gfx.print((game.player[0].xp * 16 * 2) - gfx.zoomx*2, ((game.player[0].yp - (game.cameray * 12)) * 16*2) - (gfx.zoomy*2)+32,
								 "Other Player", 255, 255, 255);
			}
		}
		*/
		
		/*
		//Player Details
		gfx.print(2, 2, game.username + ", Level " + String(game.player[game.playernum].level) + "/10" , 255, 255, 255);
		gfx.print(2, 14, "HP: " , 164, 164, 164);
		gfx.print(2, 26, "Atk: ", 164, 164, 164);
		gfx.fillrect(2, 11, 100, 1, 255, 255, 255);
		
		//health
		for (i = 0; i < game.player[game.playernum].defaulthp; i++){
			gfx.drawtile(24 + (i * 10), 13, 23);
		}
		for (i = 0; i < game.player[game.playernum].health; i++){
			gfx.drawtile(24 + (i * 10), 13, 22);
		}
		for (i = 0; i < game.player[game.playernum].damage; i++){
			gfx.drawtile(24 + (i * 10), 25, 24);
		}
		*/
		
		//Draw RPG Menu
		/*
		if (game.rpgmenu > 0) {
			gfx.drawtextbox(40, 55, 240, 38, 0, true);
			gfx.print( 45, 70, "<<                                         >>", 0, 0, 0, true);
			
			if(game.rpgmenu==1){
				if(game.rpgmenuselection==0){
					gfx.print( 45, 62, "Cry for attention.", 64+help.glow, 64+(help.glow/2), 32+(help.glow*2), true);
					gfx.print( 45, 78, "(Makes a meow sound, free)", 0, 0, 0, true);
				}else if(game.rpgmenuselection==1){
					gfx.print( 45, 62, "Purr with delight.", 64+help.glow, 64+(help.glow/2), 32+(help.glow*2), true);
					gfx.print( 45, 78, "(Makes a purring sound, free)", 0, 0, 0, true);
				}else if(game.rpgmenuselection==2){
					gfx.print( 45, 62, "Screech in disapproval.", 64+help.glow, 64+(help.glow/2), 32+(help.glow*2), true);
					gfx.print( 45, 78, "(Makes a screech sound, free)", 0, 0, 0, true);
				}else if(game.rpgmenuselection==3){
					gfx.print( 45, 60, "Cough a hairball at a far away enemy.", 64+help.glow, 64+(help.glow/2), 32+(help.glow*2), true);
					gfx.print( 45, 70, "(Deals 2 damage, with no counter)", 0, 0, 0, true);
					gfx.print( 45, 80, "Cost:    ", 0, 0, 0, true);
					gfx.drawtile(164, 79, 22);
					gfx.drawtile(176, 79, 22);
				}else if(game.rpgmenuselection==4){	
					gfx.print( 45, 60, "Nyan nyan nyan nyan nyan nyan nyan.", 64+help.glow, 64+(help.glow/2), 32+(help.glow*2), true);
					gfx.print( 45, 70, "(Ancient chant heals other kittens)", 0, 0, 0, true);
					gfx.print( 45, 80, "Cost:    ", 0, 0, 0, true);
					gfx.drawtile(164, 79, 22);
				}
			}else {
				gfx.print( 45, 70, "(return to game)", 0, 0, 0, true);
			}
			
			
			
			//gfx.drawtextbox(100, 55, 120, 18, 0, true);
			//gfx.print(-1, 60, "Meow", 0, 0, 0, true);
			
			//gfx.drawtextbox(100, 75, 120, 18, 0, true);
			//gfx.print(-1, 80, "Purr", 0, 0, 0, true);
			
			//gfx.drawtextbox(100, 95, 120, 18, 0, true);
			//gfx.print(-1, 100, "Screech", 0, 0, 0, true);
			
			//gfx.drawtextbox(100, 115, 120, 18, 0, true);
			//gfx.print(-1, 120, "Pounce", 0, 0, 0, true);
			
			
			if (game.player[game.playernum].level < 2) {
				gfx.drawtextbox(40, 100, 48, 18, 5, true);
			}else {
				gfx.drawtextbox(40, 100, 48, 18, 0, true);
			}
			if(game.player[game.playernum].level<4){
				gfx.drawtextbox(40 + 48, 100, 48, 18, 5, true);
			}else {
				gfx.drawtextbox(40+48, 100, 48, 18, 0, true);
			}
			if(game.player[game.playernum].level<5){
				gfx.drawtextbox(40 + 96, 100, 48, 18, 5, true);
			}else {
				gfx.drawtextbox(40+96, 100, 48, 18, 0, true);
			}
			if(game.player[game.playernum].level<6){
				gfx.drawtextbox(40 + 144, 100, 48, 18, 5, true);
			}else {
				gfx.drawtextbox(40 + 144, 100, 48, 18, 0, true);
			}
			if(game.player[game.playernum].level<8){
				gfx.drawtextbox(40 + 192, 100, 48, 18, 5, true);
			}else {
				gfx.drawtextbox(40+192, 100, 48, 18, 0, true);
			}
				
			//Draw selected textbox:
			if(game.rpgmenu==1){
				gfx.drawtextbox(40 + (48 * game.rpgmenuselection), 100, 48, 18, 2, false);
			}
			
			//Draw blacked out textboxes
			if(game.player[game.playernum].level<2){
				gfx.print( 45 + 11, 105, "???", 0, 0, 0);
				
				if(game.rpgmenuselection==0 && game.rpgmenu==1){
					gfx.drawtextbox(40, 55, 240, 38, 5, true);
					gfx.print( 45, 70, "<<                                         >>", 0, 0, 0, true);
					gfx.print( 45, 70, "(reach level 2 to unlock)", 0, 0, 0, true);
				}
			}else{
				gfx.print( 45 + 5, 105, "Meow", 0, 0, 0);
			}
			
			if(game.player[game.playernum].level<4){
				gfx.print( 45 + 11+48, 105, "???", 0, 0, 0);
				
				if(game.rpgmenuselection==1 && game.rpgmenu==1){
					gfx.drawtextbox(40, 55, 240, 38, 5, true);
					gfx.print( 45, 70, "<<                                         >>", 0, 0, 0, true);
					gfx.print( 45, 70, "(reach level 4 to unlock)", 0, 0, 0, true);
				}
			}else{
				gfx.print( 45 + 48 + 8, 105, "Purr", 0, 0, 0);
			}
			
			if(game.player[game.playernum].level<5){
				gfx.print( 45 + 11+96, 105, "???", 0, 0, 0);
					
				if(game.rpgmenuselection==2 && game.rpgmenu==1){
					gfx.drawtextbox(40, 55, 240, 38, 5, true);
					gfx.print( 45, 70, "<<                                         >>", 0, 0, 0, true);
					gfx.print( 45, 70, "(reach level 5 to unlock)", 0, 0, 0, true);
				}
			}else{
				gfx.print( 45 + 96, 105, "Screech", 0, 0, 0);
			}
			
			if(game.player[game.playernum].level<6){
				gfx.print( 45 + 11+144, 105, "???", 0, 0, 0);
					
				if(game.rpgmenuselection==3 && game.rpgmenu==1){
					gfx.drawtextbox(40, 55, 240, 38, 5, true);
					gfx.print( 45, 70, "<<                                         >>", 0, 0, 0, true);
					gfx.print( 45, 70, "(reach level 6 to unlock)", 0, 0, 0, true);
				}
			}else{
				gfx.print( 45 + 144+1, 105, "Hairball", 0, 0, 0);
			}
			
			if(game.player[game.playernum].level<8){
				gfx.print( 45 + 11+192, 105, "???", 0, 0, 0);
					
				if(game.rpgmenuselection==4 && game.rpgmenu==1){
					gfx.drawtextbox(40, 55, 240, 38, 5, true);
					gfx.print( 45, 70, "<<                                         >>", 0, 0, 0, true);
					gfx.print( 45, 70, "(reach level 8 to unlock)", 0, 0, 0, true);
				}
			}else{
				gfx.print( 45 + 192 + 6, 105, "Nyan", 0, 0, 0);
			}
			
			if(game.rpgmenu==1){
				gfx.drawtextbox(120, 125, 80, 18, 0, true);
				gfx.print( -1, 130, "Back", 0, 0, 0, true);
			}else {
				gfx.drawtextbox(120, 125, 80, 18, 2, true);
				gfx.print( -1, 130, "Back", 0, 0, 0, true);
			}
		}
		*/
		
		//For testing
		//gfx.print(5, 5, String(game.servernumplayers), 255, 255, 255);
		//for (i = 0; i < game.servernumplayers;i++){
		//  gfx.print(5, 15 + (i * 10), game.serverplayernames[i], 255, 255, 255);
	  //}
		
		if (game.hazmouse) {
		  gfx.drawtextbox(10, 170, 90, 20);
			gfx.drawsprite(12, 172, 401);
			gfx.print(34, 176, "has mouse!", 0, 0, 0);
		}
		
		if (game.nobacksies > 0) {
		  gfx.drawtextbox(160-80, 95, 160, 30);
			gfx.print(34, 102, "No backsies!", 0, 0, 0,true);
			gfx.print(34, 112, "Frozen for " + String(int(game.nobacksies/60)+1) + " seconds", 0, 0, 0,true);
		}
		
		gfx.drawchatbox(game);
		
		gfx.drawgui();
		gfx.render(game);
	}else if (game.checkgamestate > 0) {
		gfx.drawtextbox(60, 143, 200, 20, 0, true);
		gfx.print( -1, 150, "Waiting for server...", 0, 0, 0, true);
		
		gfx.drawgui();
		gfx.render(game);
	}else {
		for (j = 0; j < 21; j++) {
			for (i = -1; i < 20; i++) {
				gfx.drawtile((i * 16)+int(help.slowsine/4), (j * 16)-int(help.slowsine/2), 281);
			}		
		}
		gfx.drawtextbox(60, 143, 200, 20, 0, true);
		gfx.print( -1, 150, "Entering " + game.gameroomname + "!", 0, 0, 0, true);
		
		gfx.drawgui();
		gfx.render(game);
	}
}

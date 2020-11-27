public function generickeypoll_priority(game:gameclass):void {
	game.press_up = false; game.press_down = false; 
  game.press_left = false; game.press_right = false; game.press_action = false; game.press_map = false;
		
	if (key.isDown(Keyboard.LEFT)) game.press_left = true;
	if (key.isDown(Keyboard.RIGHT)) game.press_right = true;
	if (key.isDown(Keyboard.UP)) game.press_up= true;
	if (key.isDown(Keyboard.DOWN)) game.press_down = true;
	if (key.isDown(90) || key.isDown(32) || key.isDown(86)) game.press_action = true;
	if (key.isDown(Keyboard.ENTER) || key.isDown(88)) game.press_map = true;
	
	if (game.press_left || game.press_right) {
		if (game.press_up || game.press_down) {
			//Both horizontal and vertical are being pressed: one must take priority
			if (game.keypriority == 1) { game.keypriority = 4;
			}else if (game.keypriority == 2) { game.keypriority = 3;
			}else if (game.keypriority == 0) { game.keypriority = 3;
			}
		}else {game.keypriority = 1;}
	}else if (game.press_up || game.press_down) {game.keypriority = 2;}else {game.keypriority = 0;}
	
	if (game.keypriority == 3) {game.press_up = false; game.press_down = false;
	}else if (game.keypriority == 4) { game.press_left = false; game.press_right = false; }
	
	/*
	if ((key.isDown(15) || key.isDown(17)) && key.isDown(70) && !game.fullscreentoggleheld) {
		//Toggle fullscreen
		game.fullscreentoggleheld = true;
		if (game.fullscreen) {game.fullscreen = false;
		}else {game.fullscreen = true;}
		updategraphicsmode(game, gfx);
			
		//game.savestats(map, dwgfx);
	}
	*/
	
	if (game.keyheld) {
		if (game.press_action || game.press_right || game.press_left || game.press_map ||
		    game.press_down || game.press_up) {
			game.press_action = false;
			game.press_map = false;
			game.press_up = false;
			game.press_down = false;
			game.press_left = false;
			game.press_right = false;
		}else {
			game.keyheld = false;
		}
	}
}

public function generickeypoll(game:gameclass):void {
	game.press_up = false; game.press_down = false; 
  game.press_left = false; game.press_right = false; game.press_action = false; game.press_map = false;
		
	if (key.isDown(Keyboard.LEFT)) game.press_left = true;
	if (key.isDown(Keyboard.RIGHT)) game.press_right = true;
	if (key.isDown(Keyboard.UP)) game.press_up= true;
	if (key.isDown(Keyboard.DOWN)) game.press_down = true;
	if (key.isDown(90) || key.isDown(32) || key.isDown(86)) game.press_action = true;
	if (key.isDown(Keyboard.ENTER) || key.isDown(88)) game.press_map = true;
	
  game.keypriority = 0;
	
	if (game.keypriority == 3) {game.press_up = false; game.press_down = false;
	}else if (game.keypriority == 4) { game.press_left = false; game.press_right = false; }
	
	/*if ((key.isDown(15) || key.isDown(17)) && key.isDown(70) && !game.fullscreentoggleheld) {
		//Toggle fullscreen
		game.fullscreentoggleheld = true;
		if (game.fullscreen) {game.fullscreen = false;
		}else {game.fullscreen = true;}
		updategraphicsmode(game, gfx);
			
		//game.savestats(map, dwgfx);
	}*/
	
	if (game.keyheld) {
		if (game.press_action || game.press_right || game.press_left || game.press_map ||
		    game.press_down || game.press_up) {
			game.press_action = false;
			game.press_map = false;
			game.press_up = false;
			game.press_down = false;
			game.press_left = false;
			game.press_right = false;
		}else {
			game.keyheld = false;
		}
	}
	
	if (!key.isDown(13)) game.jumpheld = false;
}

public function titleinput(key:KeyPoll, gfx:graphicsclass, map:mapclass, game:gameclass, obj:entityclass, music:musicclass):void {
	generickeypoll(game);
}

public function lobbyinput(key:KeyPoll, gfx:graphicsclass, map:mapclass, game:gameclass, obj:entityclass, music:musicclass):void {
	generickeypoll(game);
	
	if (key.isDown("R".charCodeAt(0))){
	  //Refresh list
		game.listrooms(game.gameclient);
		game.updateroomlist = false;
		game.lobbymenuposition = 0;
		game.lobbymenustart = 0;
	}
			
	if (key.isDown("C".charCodeAt(0))){
		//Create room
		game.lobbystate = 1;
	}
			
	if (game.lobbystate == 0) {
		if(key.click){
			if (help.inboxw(game.mx, game.my, 60, 208, 90, 15)) {
				//Refresh list
				game.listrooms(game.gameclient);
				game.updateroomlist = false;
				game.lobbymenuposition = 0;
				game.lobbymenustart = 0;
			}
			if (help.inboxw(game.mx, game.my, 170, 208, 90, 15)) {
				//Create room
				game.lobbystate = 1;
			}
			
			if (game.lobbymenustart > 0) {
				if (help.inboxw(game.mx, game.my, 248, 125, 10, 10)) {
					//Scroll up
					game.lobbymenustart--;
					game.lobbymenuposition = 0;
				}
			}
			if (game.roomlist.length > 5 + game.lobbymenustart) {
				if (help.inboxw(game.mx, game.my, 248, 185, 10, 10)) {
					//Scroll Down
					game.lobbymenuposition = 4;
					game.lobbymenustart++;
				}
			}
			
			for (i = 0; i < 5; i++) {					
				if (help.inboxw(game.mx, game.my, 80, 128 + (i * 12), 160, 11)) {	
					if(game.roomlist[i].id!=null){
						//Join room
						game.textfield = "";
						game.inputField.text = "";
						game.lobbystate = 2;
						game.gameroomname = game.roomlist[game.lobbymenustart+i].id;
						game.joinroom(game.gameroomname, game.gameclient);
					}
				}
			}
		}
		
		if(game.keydelay<=0){
			if (game.press_down) {
				game.lobbymenuposition++;
				game.keydelay = 4;
			}
			if (game.press_up) {
				game.lobbymenuposition--;
				game.keydelay = 4;
			}
			
			if (game.lobbymenuposition == -1) {
				game.lobbymenuposition = 0;
				if (game.lobbymenustart>0) {
					game.lobbymenustart--;
				}
			}
			
			if (game.lobbymenuposition == 5) {
				game.lobbymenuposition = 4;
				if (game.roomlist.length > 5 + game.lobbymenustart) {
					game.lobbymenustart++;
				}
			}
			
			if (game.press_map && !game.jumpheld && game.updateroomlist) {
				// Join Room
				game.textfield = "";
				game.inputField.text = "";
				game.lobbystate = 2;
				game.gameroomname = game.roomlist[game.lobbymenustart+game.lobbymenuposition].id;
				game.joinroom(game.gameroomname, game.gameclient);
				
				game.playernum = 1;
			}
		}else{
			game.keydelay--;
		}
	}else if (game.lobbystate==1){
		game.inputField.maxChars = 20;
	  game.inputField.restrict = "A-Za-z0-9_";
		game.gettext_createroom(key, music);	
	}
}

public function logininput(key:KeyPoll, gfx:graphicsclass, map:mapclass, game:gameclass, obj:entityclass, music:musicclass):void {
	generickeypoll(game);	
	
	game.inputField.maxChars = 10;
	game.inputField.restrict = "A-Za-z0-9_";
	game.gettext_entername(key, music);		
}

public function connectinput(key:KeyPoll, gfx:graphicsclass, map:mapclass, game:gameclass, obj:entityclass, music:musicclass):void {
	generickeypoll(game);
}

public function gameinput(key:KeyPoll, gfx:graphicsclass, map:mapclass, game:gameclass, obj:entityclass, music:musicclass):void {
	generickeypoll(game);
		
	if (game.keypressed == "0") game.activetab = 0;
	/*
	if (game.keypressed == "1") game.activetab = 1;
	if (game.keypressed == "2") game.activetab = 2;
	if (game.keypressed == "3") game.activetab = 3;
	if (game.keypressed == "4") game.activetab = 4;
	*/

	game.inputField.maxChars = 100;
	game.inputField.restrict = null;
	game.gettext_chat(key, music);	
	
	if (!game.press_up && !game.press_down && !game.press_left && !game.press_right) game.movedelay = 0;
	
	/*
	if (game.deathseq <= 0) {
		
		if (game.meowdelay <= 0) {
			if (game.press_action) {
				game.meowdelay = 30;
				game.globalconsolemessage("!", game.username + " meows");
				music.playef(0);
			}	
		}else {
			game.meowdelay--;
		}
		
		if (game.press_action && !game.keyheld) {
			if (game.hairballmode == 1) {
				//shoot hairball
				game.hairballmode = 0;
				game.chatconnection.send("hair", game.username, game.playernum, game.hairballx, game.hairbally);
				game.rpgmenu = 0;
				game.keyheld = true;
			}else if (game.rpgmenu == 0) {
				game.rpgmenu = 1; 
				game.rpgmenuselection = 0;
				game.keyheld = true;
			}else if (game.rpgmenu == 1) {
				//Execute command
				game.keyheld = true;
				if (game.rpgmenuselection == 0 && game.player[game.playernum].level>=2) {
					//Meow
					game.globalconsolemessage("!", game.username + " meows");
					music.playef(0);
				  game.rpgmenu = 0;
				}else if (game.rpgmenuselection == 1 && game.player[game.playernum].level>=4) {
					//Purr
					game.globalconsolemessage("!", game.username + " purrs");
					music.playef(0);
				  game.rpgmenu = 0;
				}else if (game.rpgmenuselection == 2 && game.player[game.playernum].level>=5) {
					//Screech
					game.globalconsolemessage("!", game.username + " screeches");
					music.playef(0);
				  game.rpgmenu = 0;
				}else if (game.rpgmenuselection == 3 && game.player[game.playernum].level>=6) {
					//Hairball
					
					game.globalconsolemessage("!", game.username + " coughs a hairball");
					music.playef(0);
				  game.rpgmenu = 0;
					
					//First up: can we hairball?
					if (game.player[game.playernum].health > 2) {
						game.player[game.playernum].health-=2;
						game.rpgmenu = 0;
						game.hairballmode = 1;
						game.hairballx = game.player[game.playernum].xp;
						game.hairbally = game.player[game.playernum].yp;
						game.keyheld = true;
					}else {
						//BUZZER
					}
				}else if (game.rpgmenuselection == 4 && game.player[game.playernum].level>=8) {
					//Nyan
					//First up: can we nyan?
					if (game.player[game.playernum].health > 1) {
						game.globalconsolemessage("!", game.username + " nyans");
						game.player[game.playernum].health--;
						music.playef(0);
						if(game.playernum==0){
							game.chatconnection.send("nyan1", game.username);
						}else {
							game.chatconnection.send("nyan2", game.username);
						}
						game.rpgmenu = 0;
					}else {
						//BUZZER
					}
				}else {
					//Not appropiate level, give buzzer sound
				}
			}else if (game.rpgmenu == 2) {
				//Return to game without doing anything
				game.rpgmenu = 0;
				game.keyheld = true;
			}
		}
	}
	*/
	/*
	if (game.hairballmode == 1) {
		if (game.movedelay <= 0 && game.deathseq <= 0) {
			if (game.press_up) {
				game.hairbally--;
				game.movedelay = 8;
			}else if (game.press_down) {
				game.hairbally++;
				game.movedelay = 8;
			}else if (game.press_left) {
				game.hairballx--;
				game.movedelay = 8;
			}else if (game.press_right) {
				game.hairballx++;
				game.movedelay = 8;
			}
			
			//Keep the hairball on screen
			if (game.hairballx < 0) game.hairballx = 0;
			if (game.hairballx >= 20) game.hairballx = 19;
			if (game.hairbally < (game.cameray * 12)) game.hairbally = (game.cameray * 12);
			if (game.hairbally >= ((game.cameray + 1) * 12)) game.hairbally = ((game.cameray + 1) * 12) - 1;
		}else {
			game.movedelay--;
		}
	}else if (game.rpgmenu == 0) {
		if (game.movedelay <= 0 && game.deathseq <= 0) {
			if (game.press_up) {
				game.moveplayer(map, game.playernum, 0);
				game.movedelay = 12;
			}else if (game.press_down) {
				game.moveplayer(map, game.playernum, 1);
				game.movedelay = 12;
			}else if (game.press_left) {
				game.moveplayer(map, game.playernum, 2);
				game.movedelay = 8;
			}else if (game.press_right) {
				game.moveplayer(map, game.playernum, 3);
				game.movedelay = 8;
			}
		}else {
			game.movedelay--;
		}
	}else {
	if (game.movedelay <= 0 && game.deathseq <= 0) {
		if (game.press_up) {
			game.rpgmenu = 1;
			game.movedelay = 8;
		}else if (game.press_down) {
			game.rpgmenu = 2;
			game.movedelay = 8;
		}else if (game.press_left) {
			game.rpgmenuselection = (game.rpgmenuselection + 4) % 5;
			game.movedelay = 8;
		}else if (game.press_right) {
			game.rpgmenuselection = (game.rpgmenuselection + 1) % 5;
			game.movedelay = 8;
		}
	}else {
		game.movedelay--;
	}
	*/
	
	if (game.movetimeout > 0) game.movetimeout--;
	//game.test = true;
	//game.teststring = String(game.movetimeout);
	
	if (game.movedelay <= 0 && game.deathseq <= 0) {
		if (game.movetimeout <= 0) {
			if(game.nobacksies<=0){
				if (game.press_up) {
					game.movedelay = 12;
					game.movetimeout = 80;
					game.moveplayer(map, game.playernum, 0);
				}else if (game.press_down) {
					game.movedelay = 12;
					game.movetimeout = 80;
					game.moveplayer(map, game.playernum, 1);
				}else if (game.press_left) {
					game.movedelay = 8;
					game.movetimeout = 80;
					game.moveplayer(map, game.playernum, 2);
				}else if (game.press_right) {
					game.movedelay = 8;
					game.movetimeout = 80;
					game.moveplayer(map, game.playernum, 3);
				}
			}
		}
	}else {
		game.movedelay--;
	}
}

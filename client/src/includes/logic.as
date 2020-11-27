public function titlelogic(key:KeyPoll, gfx:graphicsclass, map:mapclass, game:gameclass, obj:entityclass, music:musicclass):void {
}

public function lobbylogic(key:KeyPoll, gfx:graphicsclass, map:mapclass, game:gameclass, obj:entityclass, music:musicclass):void {
}

public function loginlogic(key:KeyPoll, gfx:graphicsclass, map:mapclass, game:gameclass, obj:entityclass, music:musicclass):void {
}

public function connectlogic(key:KeyPoll, gfx:graphicsclass, map:mapclass, game:gameclass, obj:entityclass, music:musicclass):void {
}

public function gamelogic(key:KeyPoll, gfx:graphicsclass, map:mapclass, game:gameclass, obj:entityclass, music:musicclass):void {
  //Ok, ask for gamestate if we've regained focus:
  if (game.checkgamestate == 2) {
	  game.checkgamestate = 1;
		game.chatconnection.send("sendgs");
	}
	
	//Buffer thingy
	if (game.chatbox_mainpos >= 2900) {
		game.clearbuffer();
	}
	if (game.chatbox_logicpos >= 2900) {
		game.chatbox_logicpos=0;
	}
	
	
	//End meowgesture
	if (game.meowgesture > 0) {
		game.meowgesture--;
		if (game.meowgesture == 0) {
			game.moveplayer(map, game.playernum, 8);
		}
	}
	
	if (game.foundamousespammer > 0) {
		game.foundamousespammer--;
	}
	
	if (game.tagtimeout > 0) {
		game.tagtimeout--;
	}
	
	if (game.nobacksies > 0) {
		game.nobacksies--;
	}
	
	if (game.msgspamtimer > 0) {
		game.msgspamtimer--;
		if (game.msgspamtimer <= 0) {
			game.messagespammer1 = 0;
			game.messagespammer2 = 0;
		}
	}
	
	if (game.housemouse > 0) {
		game.housemouse--;
	}
	if (game.altarmouse > 0) {
		game.altarmouse--;
	}
	
	if (game.domeow) {
		game.domeow = false;
		if (game.serverplayerisdog[game.playernum] == 0) {
			music.playef(int(Math.random() * 5));
		}else {
			music.playef(8 + int(Math.random() * 5));
		}
	}
	
	if (game.dohelptone == 1) {
		game.dohelptone = 0;
		music.playef(26);
	}else if (game.dohelptone == 2) {
		game.dohelptone = 0;
		music.playef(25);
	}
	
	//Sounds!
	if (game.doplaysound > 0) {
		if (game.doplaysound == 1) {
			//meow
			music.playef(int(Math.random() * 5));
			if (game.mygesture) game.moveplayer(map, game.playernum, 4);
			game.mygesture = false;
		}else if (game.doplaysound == 2) {
			//purr
			music.playef(5);
			if (game.mygesture) game.moveplayer(map, game.playernum, 5);
			game.mygesture = false;
		}else if (game.doplaysound == 3) {
			//screech
			music.playef(6);
			if (game.mygesture) game.moveplayer(map, game.playernum, 6);
			game.mygesture = false;
		}else if (game.doplaysound == 4) {
			//nap
			music.playef(7);
			if (game.mygesture) game.moveplayer(map, game.playernum, 7);
			game.mygesture = false
		}else if (game.doplaysound == 13) {
			//woof
			music.playef(8 + int(Math.random() * 5));
			if (game.mygesture) game.moveplayer(map, game.playernum, 4);
			game.mygesture = false;
		}else if (game.doplaysound == 14) {
			//pant
			music.playef(13);
			if (game.mygesture) game.moveplayer(map, game.playernum, 5);
			game.mygesture = false;
		}else if (game.doplaysound == 15) {
			//howl
			music.playef(14);
			if (game.mygesture) {
				kongapi.submit("howl", 1);
				game.moveplayer(map, game.playernum, 6);
			}
			game.mygesture = false;
		}else if (game.doplaysound == 16) {
			//nap
			music.playef(15);
			if (game.mygesture) game.moveplayer(map, game.playernum, 7);
			game.mygesture = false
		}else if (game.doplaysound == 5) {
			music.playef(17); //C
		}else if (game.doplaysound == 6) {
			music.playef(18); //D
		}else if (game.doplaysound == 7) {
			music.playef(19); //E
		}else if (game.doplaysound == 8) {
			music.playef(20); //F
		}else if (game.doplaysound == 9) {
			music.playef(22); //G
		}else if (game.doplaysound == 10) {
			music.playef(21); //A
		}else if (game.doplaysound == 11) {
			music.playef(24); //B
		}else if (game.doplaysound == 12) {
			music.playef(23); //C'
		}
		game.doplaysound = 0;
	}
	
	//Have we stepped off a button
	if (game.buttonpress > 0) {
		if (game.buttonx != game.player[game.playernum].xp || game.buttony != game.player[game.playernum].yp) {
			game.buttonpress = 0;
			game.chatconnection.send("closedoor", game.username, game.buttonnum);
		}
	}
	
	//Run messages from server queue, delete when done
	if (game.chatbox_logicpos > 0) {
		game.tokenize(game.chatbox_logic[0].s);
		game.removecommand(0);
		
		if (game.words[0] == "move") {
			//if (game.username.toLowerCase() == game.words[2]) {
				//Move me
				//game.addchatmessage(0, "Testing", "player " + String(int(game.words[1]) - 1) + ", player num is "+String(game.playernum));
				game.domove(map,int(game.words[1]), int(game.words[3]), int(game.words[4]), int(game.words[5]));
			//}else{
				//Move other player
				//game.domove(map, 1-game.playernum, int(game.words[2]), int(game.words[3]), int(game.words[4]));
			//}
		}else if (game.words[0] == "kill") {
			map.killenemy(int(game.words[1]));
		}else if (game.words[0] == "hair") {
			//Shoots a hairball
			//hair(which,x,y)
			//Check if it hits an enemy
			var tmp3:int = 0;
			if (game.words[1] == game.username.toLowerCase()) {
				tmp3 = game.playernum;
			}else {
				tmp3 = 1 - game.playernum;
			}
			var tempbool:Boolean = map.collide(int(game.words[2]), int(game.words[3]), tmp3);
			
			if (map.actioncollide > 0) {
				game.globalconsolemessage("!", game.username + " coughs a hairball at an enemy!");
				if (game.playernum == 0 && tmp3==0) {
					game.chatconnection.send("hairdamage1", game.username, map.actioncollide, 2, game.enemy[map.actioncollide].damage);
				}else if (game.playernum == 1 && tmp3==1) {
					game.chatconnection.send("hairdamage2", game.username, map.actioncollide, 2, game.enemy[map.actioncollide].damage);
				}
			}else {
				game.globalconsolemessage("!", game.username + " coughs up a hairball");
			}
			
		}else if (game.words[0] == "becomedog") {
			game.serverplayerisdog[int(game.words[1])] = 1;
			if (int(game.words[1]) == game.playernum) {
				game.screenshake = 10;
				game.flashlight = 5;
				music.playef(14);
				kongapi.submit("dogmode", 1);
			}
	  }else if (game.words[0] == "cursedog") {
			game.serverplayerisdog[int(game.words[1])] = 1;
			if (int(game.words[1]) == game.playernum) {
				game.screenshake = 10;
				game.flashlight = 5;
				music.playef(14);
				game.nobacksies = 5 * 60;
			}
		}else if (game.words[0] == "becomecat") {
			game.serverplayerisdog[int(game.words[1])] = 0;
      if (int(game.words[1]) == game.playernum) {
				game.screenshake = 10;
				game.flashlight = 5;
				music.playef(6);
			}
		}else if (game.words[0] == "nyan1") {
			if (game.playernum == 1) {
				//Heal
				game.player[1].health++;
				if (game.player[1].health > game.player[1].defaulthp) game.player[1].health = game.player[1].defaulthp;
			}
		}else if (game.words[0] == "nyan2") {
			if (game.playernum == 0) {
				//Heal
				game.player[0].health++;
				if (game.player[0].health > game.player[0].defaulthp) game.player[0].health = game.player[0].defaulthp;
			}
		}else if (game.words[0] == "opendoor") {
			map.opendoor(int(game.words[2]));
		}else if (game.words[0] == "closedoor") {
			map.closedoor(int(game.words[2]));
		}else if (game.words[0] == "foundmouse") {
			//Mouse has been found, move it to the new location
			map.movemouse(int(game.words[1]), int(game.words[2]));
			music.playef(16);
		}else if (game.words[0] == "showmouse") {
			//Mouse has been delivered! Parameter is altar
			if (int(game.words[1]) == 0) {
				game.housemouse = 60 * 5;
			}else if (int(game.words[1]) == 1) {
				game.altarmouse = 60 * 5;
			}
		}else if (game.words[0] == "damage1" || game.words[0] == "damage2") {
			game.enemy[int(game.words[2])].health -= int(game.words[3]);
			
			if (game.enemy[int(game.words[2])].health <= 0) {
				if (game.words[0] == "damage1") {
					if (game.playernum == 0) {
						game.chatconnection.send("kill", game.username, int(game.words[2]));
						game.globalconsolemessage("!", game.username + " has defeated an enemy!");
						
						var tmp:int = game.player[game.playernum].level;
						game.player[game.playernum].levelup();
						if(tmp!=game.player[game.playernum].level){
						  game.globalconsolemessage("!", game.username + " has leveled up!");
							//Give level bonus
							game.levelbonus(game.player[game.playernum].level);
						}
					}
				}else {
					if (game.playernum == 1) {
						game.chatconnection.send("kill", game.username, int(game.words[2]));
						game.globalconsolemessage("!", game.username + " has defeated an enemy!");
						
						var tmp2:int = game.player[game.playernum].level;
						game.player[game.playernum].levelup();
						if(tmp2!=game.player[game.playernum].level){
						  game.globalconsolemessage("!", game.username + " has leveled up!");
						}
					}
				}	
			}else {
				//Nope, it's not dead
				if (game.words[0] == "damage1") {
					if (game.playernum == 0) {
				    game.localconsolemessage("!!", "Enemy attacked " + game.words[1] + " for " + game.words[4] +  " damage");
						game.player[game.playernum].health-=int(game.words[4]);
					}
				}else {
					if (game.playernum == 1) {
				    game.localconsolemessage("!!", "Enemy attacked " + game.words[1] + " for " + game.words[4] +  " damage");
						game.player[game.playernum].health-=int(game.words[4]);
					}
				}	
				
				if (game.words[0] == "damage1") {
					if (game.playernum == 0) {
						if (game.player[game.playernum].health <= 0) {
							//game.enemy[int(game.words[2])].restorehealth();
							//game.globalconsolemessage("!", "Enemy consumed " + game.words[1] + " to regenerate health");
							game.die();
						}
					}
				}else {
					if (game.playernum == 1) {
						if (game.player[game.playernum].health <= 0) {
							//game.enemy[int(game.words[2])].restorehealth();
					    //game.globalconsolemessage("!", "Enemy consumed " + game.words[1] + " to regenerate health");
							game.die();
						}
					}
				}
			}
		}else if (game.words[0] == "hairdamage1" || game.words[0] == "hairdamage2") {
			game.enemy[int(game.words[2])].health -= int(game.words[3]);
			
			if (game.enemy[int(game.words[2])].health <= 0) {
				if (game.words[0] == "hairdamage1") {
					if (game.playernum == 0) {
						game.chatconnection.send("kill", game.username, int(game.words[2]));
						game.globalconsolemessage("!", game.username + " has defeated an enemy!");
						
						var ttmp:int = game.player[game.playernum].level;
						game.player[game.playernum].levelup();
						if(ttmp!=game.player[game.playernum].level){
						  game.globalconsolemessage("!", game.username + " has leveled up!");
							//Give level bonus
							game.levelbonus(game.player[game.playernum].level);
						}
					}
				}else {
					if (game.playernum == 1) {
						game.chatconnection.send("kill", game.username, int(game.words[2]));
						game.globalconsolemessage("!", game.username + " has defeated an enemy!");
						
						var ttmp2:int = game.player[game.playernum].level;
						game.player[game.playernum].levelup();
						if(ttmp2!=game.player[game.playernum].level){
						  game.globalconsolemessage("!", game.username + " has leveled up!");
						}
					}
				}	
			}
		}
	}
	
	if (game.deathseq > 0) {
		if (game.deathseq == 30) music.playef(0);
		game.deathseq--;
		if (game.deathseq == 1) game.deathseq = 2;
		/*if (game.deathseq == 1) {
			game.moveplayerto(map, game.playernum, game.checkpointx, game.checkpointy, 1);
			game.player[game.playernum].restorehealth();
		}*/
	}
	
	//State machine for game logic
	game.updatestate(obj, music);

	//Update entities
	if(!game.completestop){
		for (i = 0; i < obj.nentity;  i++) {
			obj.updateentities(i, game, music);          // Behavioral logic
			obj.updateentitylogic(i, game);              // Basic Physics
			obj.entitymapcollision(i, map);              // Collisions with walls
		}
			
		obj.entitycollisioncheck(gfx, game, map, music);         // Check ent v ent collisions, update states
	}
		
	//now! let's clean up removed entities
	obj.cleanup();
}

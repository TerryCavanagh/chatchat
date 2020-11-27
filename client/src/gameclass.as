package {
	import bigroom.input.KeyPoll;
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	import flash.text.TextField;
	import flash.display.MovieClip
	import playerio.*
		
	public class gameclass extends Sprite{		
		public var GAMEMODE:int = 0;
		public var CONNECTMODE:int = 1;
		public var TITLEMODE:int = 2;
		public var CLICKTOSTART:int = 3;
		public var LOGINMODE:int = 4;
		public var LOBBYMODE:int = 5;
		
		static public var BLOCK:Number = 0;
    static public var TRIGGER:Number = 1;
		static public var DAMAGE:Number = 2;
    
		public function gameclass(obj:entityclass, music:musicclass):void {			
			infocus = true; checkgamestate = 0;
			paused = false; muted = false; globalsound = 1;
			addEventListener(Event.DEACTIVATE, windowNotActive);
      addEventListener(Event.ACTIVATE, windowActive);
			gamestate = GAMEMODE; completestop = false;
	    hascontrol = true; jumpheld = false; jumppressed = 0;
			
			deathseq = 0;
			
			test = false; teststring = "TEST = True";
			state = 1; statedelay = 0;
			updatestate(obj, music);
			
			for (var i:int = 0; i < 100; i++) {
				roomn.push(new String);
				
			  player.push(new playerclass());
				player[i].xp = 47 + (i % 6); player[i].yp = 30 + int((i - (i % 6)) / 6) % 2; player[i].dir = 0; player[i].type = i;
				
				serverplayernames.push("");
				serverplayeronline.push(false);
				serverplayerisdog.push(0);
			}
			//player[1].xp = 11; player[1].yp = 8; player[1].dir = 0; player[1].type = 1;
			
			servernumplayers = 0;
			
			checkpointx = 10; checkpointy = 115;
			
			
			player[0].init(4, 2);
			player[1].init(4, 2);
			
			player[0].level = 10;
			player[1].level = 10;
			
		  //Setup roomnames here:
      roomn[0] = "I AM ERROR";
			roomn[1] = "I AM ERROR";
			roomn[2] = "backalley";
			roomn[3] = "dog altar";
			roomn[4] = "I AM ERROR";
			roomn[0+5] = "a tree";
			roomn[1+5] = "northern forest";
			roomn[2+5] = "alley, west side";
			roomn[3+5] = "alley, east side";
			roomn[4+5] = "I AM ERROR";
			roomn[0+10] = "fountain room";
			roomn[1+10] = "forest";
			roomn[2+10] = "the house";
			roomn[3+10] = "cave entrance";
			roomn[4+10] = "treasure cave";
			roomn[0+15] = "I AM ERROR";
			roomn[1+15] = "forest cave";
			roomn[2+15] = "the mush room";
			roomn[3+15] = "twisty cavern";
			roomn[4+15] = "I AM ERROR";
			roomn[0+20] = "I AM ERROR";
			roomn[1+20] = "I AM ERROR";
			roomn[2+20] = "the depths";
			roomn[3+20] = "music room";
			roomn[4+20] = "I AM ERROR";
			
			//player[0].xp = 10; player[0].yp = 9;
			
			for (var i2:int = 0; i2 < 20; i2++) {
			  enemy.push(new playerclass());
			}
			
			enemy[7].init(3, 5);
			
			for (i = 0; i < 3000; i++) {
				chatbox_main.push(new namedstringclass());
				chatbox_mainsubset.push(new namedstringclass());
				chatbox_1.push(new namedstringclass());
				chatbox_2.push(new namedstringclass());
				chatbox_3.push(new namedstringclass());
				chatbox_4.push(new namedstringclass());
				chatbox_logic.push(new namedstringclass());
			}
			for (i = 0; i < 1000; i++) {
				chatbox_mainroom.push(new int);
			}
			chatbox_mainpos = 0;
			chatbox_mainsubsetpos = 0;
			chatbox_1pos = 0;
			chatbox_2pos = 0;
			chatbox_3pos = 0;
			chatbox_4pos = 0;
			chatbox_logicpos = 0;
		}
		
		public function getcolour(t:String):int {
			//Given username t, find colour to use
			for (var i:int = 0; i < servernumplayers; i++) {
				if (serverplayernames[i] == t) {
					return i % 10;
				}
			}
			return 10;
		}
		
		public function makechatsubset():void {
			//Make a chat subset
			//Only update on a change in the main position (TO DO)
			var j:int = currentroom();
			chatbox_mainsubsetpos = 0;
			for (var i:int = 0; i < chatbox_mainpos; i++) {
				if (j == chatbox_mainroom[i]) {
					chatbox_mainsubset[chatbox_mainsubsetpos].n = chatbox_main[i].n;
					chatbox_mainsubset[chatbox_mainsubsetpos].s = chatbox_main[i].s;
					chatbox_mainsubsetpos++;
				}
			}
		}
		
		public function clearbuffer():void {
			//Move the last 100 messages to the start of the buffer, change the end point
			chatbox_mainpos = 0;
			//Super hacky! :D
		}
		
		public function addchatmessage(type:int, n:String, t:String, location:String = ""):void {
			//For chatbox messages, you should only see it if 
			// (a) you sent it
			// (b) it's your chatbox
			// (c) 
			//Chatting with another player is basically a private chanel, it's not 5 channels per game, 
			//it's 5 channels *per player*.
			if (location == "-1") {
				for (var j:int = 0; j < 5; j++) {
					for (var i:int = 0; i < 5; i++) {
						if (!(i == 0 && j == 1)) {
						  addchatmessage(type, n, t, String(int(i) + int(j * 5)));
						}
					}
				}
			}
			
			if (type == 0) {
				chatbox_main[chatbox_mainpos].n = n;
				chatbox_main[chatbox_mainpos].s = t;
				chatbox_mainroom[chatbox_mainpos] = int(location);
				chatbox_mainpos++;
				if(int(location)==currentroom()){
					//Do sound effects for chat messages here:
					if (help.Left(n, 1) == "%") {
						//Meow
						doplaysound = 1;
						if (getcolour(help.lastchars(n)) == playernum) mygesture = true;
					}else if (help.Left(n, 1) == "^") {
						//Purr
						doplaysound = 2;
						if (getcolour(help.lastchars(n)) == playernum) mygesture = true;
					}else if (help.Left(n, 1) == "&") {
						//Screech
						doplaysound = 3;
						if (getcolour(help.lastchars(n)) == playernum) mygesture = true;
					}else if (help.Left(n, 1) == "*") {
						//Nap
						doplaysound = 4;
						if (getcolour(help.lastchars(n)) == playernum) mygesture = true;
					}else if (help.Left(n, 1) == "{") {
						//Woof
						doplaysound = 13;
						if (getcolour(help.lastchars(n)) == playernum) mygesture = true;
					}else if (help.Left(n, 1) == "}") {
						//Pant
						doplaysound = 14;
						if (getcolour(help.lastchars(n)) == playernum) mygesture = true;
					}else if (help.Left(n, 1) == "[") {
						//Howl
						doplaysound = 15;
						if (getcolour(help.lastchars(n)) == playernum) mygesture = true;
					}else if (help.Left(n, 1) == "]") {
						//Nap
						doplaysound = 16;
						if (getcolour(help.lastchars(n)) == playernum) mygesture = true;
					}else if (n == "?") {
						//Music notes
						if (help.Right(t, 7) == "plays C") { doplaysound = 5;
						}else if (help.Right(t, 7) == "plays D") { doplaysound = 6;
						}else if (help.Right(t, 7) == "plays E") { doplaysound = 7;
						}else if (help.Right(t, 7) == "plays F") { doplaysound = 8;
						}else if (help.Right(t, 7) == "plays G") { doplaysound = 9;
						}else if (help.Right(t, 7) == "plays A") { doplaysound = 10;
						}else if (help.Right(t, 7) == "plays B") { doplaysound = 11;
						}else if (help.Right(t, 12) == "plays high C") { doplaysound = 12;
						}
					}
				}
			}else if (type == 1) {
				chatbox_1[chatbox_1pos].n = n;
				chatbox_1[chatbox_1pos].s = t;
				chatbox_1pos++;
			}else if (type == 2) {
				chatbox_2[chatbox_2pos].n = n;
				chatbox_2[chatbox_2pos].s = t;
				chatbox_2pos++;
			}else if (type == 3) {
				chatbox_3[chatbox_3pos].n = n;
				chatbox_3[chatbox_3pos].s = t;
				chatbox_3pos++;
			}else if (type == 4) {
				chatbox_4[chatbox_4pos].n = n;
				chatbox_4[chatbox_4pos].s = t;
				chatbox_4pos++;
			}else if (type == 5) {
				chatbox_logic[chatbox_logicpos].n = n;
				chatbox_logic[chatbox_logicpos].s = t;
				chatbox_logicpos++;
				/*
				chatbox_main[chatbox_mainpos].n = n;
				chatbox_main[chatbox_mainpos].s = t;
				chatbox_mainroom[chatbox_mainpos] = 0;
				chatbox_mainpos++;
				*/
			}
		}
		
		public function removecommand(t:int):void {
			for (var i:int = t; i < chatbox_logicpos-1; i++) {
				chatbox_logic[i].n = chatbox_logic[i+1].n;
				chatbox_logic[i].s = chatbox_logic[i+1].s;
			}
			if (chatbox_logicpos > 0) chatbox_logicpos--;
		}
		
		//Tokenise command
		public function tokenize(t:String):void {
			//trace(t);
			var j:int = 0; tempword = "";
			
			for (var i:int = 0; i < t.length; i++) {
				currentletter = t.substr(i, 1);
				if (currentletter == "(" || currentletter == ")" || currentletter == ",") {
					words[j] = tempword;
					words[j] = words[j].toLowerCase();
					j++; tempword = "";
				}else if (currentletter == " ") {
					//don't do anything - i.e. strip out spaces.
				}else {
					tempword += currentletter;
				}
			}
			
			if (tempword != "") {
				words[j] = tempword;
			}
		}
		
		//My multiplayer stuff
		
		public function globalconsolemessage(n:String, message:String, croom:int=0):void {
			//Send a message over the internet
			if (croom == -1) {
				for (var j:int = 0; j < 5; j++) {
					for (var i:int = 0; i < 5; i++) {
						if (!(i == 0 && j == 1)) {
						  chatconnection.send("c", i + (j * 5), n, message);
						}
					}
				}
			}else{
		  	chatconnection.send("c", croom, n, message);
			}
		}
		
		public function localconsolemessage(n:String,message:String):void {
			//Just to the current player
			addchatmessage(0, n, message, String(currentroom()));
		}
		
		public function sendmessage(t:int, message:String, croom:int=0):void {
			if (!offlinemode) {
				if(t==0){
			    chatconnection.send("c", croom, username, message);
				}else {
			    chatconnection.send("d", croom, username, message);
				}
			}else {
				addchatmessage(0, "OFFLINE MODE", message);
			}
		}
		
		public function sendmove(which:int, x:int, y:int, dir:int):void {
			if(!offlinemode){
			  chatconnection.send("m", username, which, x, y, dir);
			}else {
				addchatmessage(0, "OFFLINE MODE", "Movement by player " + String(which+1));
			}
		}
		
		public function tags(a:int, b:int):void {
			if (nobacksies <= 0 && tagtimeout<=0) {
				tagtimeout = 120;
				chatconnection.send("becomecat", username, a);
				chatconnection.send("cursedog", username, b);
				globalconsolemessage("!!", username + " caught " + serverplayernames[b] + "! " + serverplayernames[b] +" is a dog now", -1);
			}
		}
		
		public function playercollide(which:int, x:int, y:int):Boolean {
			//True if player which collides with any other player at x y
			for (var i:int = 0; i < servernumplayers; i++) {
				if (which != i && serverplayeronline[i]) {
					if (player[i].xp == x && player[i].yp == y) {
						//Check if player which is a dog, and player i is a cat
            if (serverplayerisdog[which] == 1) {
						  if (serverplayerisdog[i] == 0) {
								//Turn player i to a dog, and which to a cat!
								tags(which, i);
							}
						}
						return true;
					}
				}
			}
			return false;
		}
		
		public function moveplayer(map:mapclass, which:int, dir:int):void {
			player[which].dir = dir;
				
			if (dir == 0) {
				if (!map.collide(player[which].xp, player[which].yp - 1, which, serverplayerisdog[which]) && 
				    !playercollide(which, player[which].xp, player[which].yp - 1)) {
					moveplayerto(map, which, player[which].xp, player[which].yp - 1, dir);
					//player[which].yp = player[which].yp - 1;
				}else {
					movetimeout = 0; //Move not valid;
				}
			}else if (dir == 1) {
				if (!map.collide(player[which].xp, player[which].yp + 1, which, serverplayerisdog[which]) && 
				    !playercollide(which, player[which].xp, player[which].yp + 1)) {
					moveplayerto(map, which, player[which].xp, player[which].yp + 1, dir);
					//player[which].yp = player[which].yp + 1;
				}else {
					movetimeout = 0; //Move not valid;
				}
			}else if (dir == 2) {
				if (!map.collide(player[which].xp - 1, player[which].yp, which, serverplayerisdog[which]) && 
				    !playercollide(which, player[which].xp - 1, player[which].yp)) {
					moveplayerto(map, which, player[which].xp - 1, player[which].yp, dir);
					//player[which].xp = player[which].xp - 1;
				}else {
					movetimeout = 0; //Move not valid;
				}
			}else if (dir == 3) {
				if (!map.collide(player[which].xp + 1, player[which].yp, which, serverplayerisdog[which]) && 
				    !playercollide(which, player[which].xp + 1, player[which].yp)) {
					moveplayerto(map, which, player[which].xp + 1, player[which].yp, dir);
					//player[which].xp = player[which].xp + 1;
				}else {
					movetimeout = 0; //Move not valid;
				}
			}else if (dir == 4) {
				//Meowing
				moveplayerto(map, which, player[which].xp, player[which].yp, dir);
				meowgesture = 180;
			}else if (dir == 5) {
				//Purring
				moveplayerto(map, which, player[which].xp, player[which].yp, dir);
				meowgesture = 180;
			}else if (dir == 6) {
				//Screeching
				moveplayerto(map, which, player[which].xp, player[which].yp, dir);
				meowgesture = 180;
			}else if (dir == 7) {
				//Napping!
        moveplayerto(map, which, player[which].xp, player[which].yp, dir);
			}else if (dir == 8) {
				//Meowing end
				moveplayerto(map, which, player[which].xp, player[which].yp, 3);
			}
			
			if (map.actioncollide > 0) {
				//Collided with an enemy; which one?
				if (hazmouse) {
					if (foundamousespammer <= 0) {
					  globalconsolemessage("!", username + " found a mouse - but already has one!", -1);
					  map.actioncollide = 0;
						foundamousespammer = 60 * 4;
					}else {
						map.actioncollide = 0;
					}
				}else{
					globalconsolemessage("!", username + " found a mouse!", -1);
					//chatconnection.send("damage1", username, map.actioncollide, 10, 0);
					var tx:int, ty:int;
					tx = 20 + int(Math.random() * 60);
					ty = 12 + int(Math.random() * 36);
					while (map.at(tx, ty) != 0) {							
						tx = 20 + int(Math.random() * 60);
						ty = 12 + int(Math.random() * 36);
					}
					chatconnection.send("foundmouse", tx, ty); //Tell the server to move the mouse
					map.actioncollide = 0;
					hazmouse = true;
					foundamousespammer = 60 * 4;
				}
				/*
				if (playernum == 0) {
					chatconnection.send("damage1", username, map.actioncollide, player[0].damage, enemy[map.actioncollide].damage);
				}else if (playernum == 1) {
					chatconnection.send("damage2", username, map.actioncollide, player[1].damage, enemy[map.actioncollide].damage);
				}
				*/
			}
			
			if (map.doorwaycollide > 0) {
				localconsolemessage("??", "This door is locked");
				map.doorwaycollide = 0;
			}
		}
		
		public function die():void {
			//Start a death timer, play a noise
			deathseq = 30;
			globalconsolemessage("!!", username + " has died.");
		}
		
		public function levelbonus(t:int):void {
			//Give the player shit
			switch(t) {
				case 2:
					//Meow
				break;
			  case 3:
				  //HP increase
					player[playernum].defaulthp += 2;
					player[playernum].health += 2;
				break;
			  case 4:
				  //Purr
				break;
			  case 5:
				  //Screech
				break;
			  case 6:
				  //Pounce
				break;
			  case 7:
				  //Atk increase
					player[playernum].damage += 1;
				break;
		  	case 8:
				  //Nyan
				break;
			  case 9:
				  //HP
					player[playernum].defaulthp += 2;
					player[playernum].health += 2;
				break;
			  case 10:
				  //Atk
					player[playernum].damage += 1;
				break;
			}
		}
		
		public function moveplayerto(map:mapclass, which:int, x:int, y:int, dir:int):void {
			player[which].dir = dir;
				
			if (!map.collide(x, y, which, serverplayerisdog[which]) && !playercollide(which, x, y)) {
				//player[which].xp = x;
				//player[which].yp = y;
				//Here, we check for entities status
				actiontile = map.at(x, y);
				//Disable
				/*if (actiontile == 9) {
					//Checkpoint!
					checkpointx = x;
					checkpointy = y;
					player[playernum].restorehealth();
					globalconsolemessage("!", username + " stepped on a healing spot, HP recovered!");
					//localconsolemessage("!", username + " stepped on a checkpoint");
					
				}else if (actiontile == 10) {
					//Death!
					globalconsolemessage("!!", username + " stepped on spikes");
					player[playernum].health--;
					if (player[playernum].health <= 0) die();
				}else */
				
				if (actiontile >= 83 && actiontile < 91) {
					//Music!
					if (actiontile == 83 && messagespammer1 != 83) {
						messagespammer1 = 83; msgspamtimer = 10;
						globalconsolemessage("?", username.toUpperCase() + " plays C", currentroom());
					}else if (actiontile == 84 && messagespammer1 != 84) {
						messagespammer1 = 84; msgspamtimer = 10;
						globalconsolemessage("?", username.toUpperCase() + " plays D", currentroom());
					}else if (actiontile == 85 && messagespammer1 != 85) {
						messagespammer1 = 85; msgspamtimer = 10;
						globalconsolemessage("?", username.toUpperCase() + " plays E", currentroom());
					}else if (actiontile == 86 && messagespammer1 != 86) {
						messagespammer1 = 86; msgspamtimer = 10;
						globalconsolemessage("?", username.toUpperCase() + " plays F", currentroom());
					}else if (actiontile == 87 && messagespammer1 != 87) {
						messagespammer1 = 87; msgspamtimer = 10;
						globalconsolemessage("?", username.toUpperCase() + " plays G", currentroom());
					}else if (actiontile == 88 && messagespammer1 != 88) {
						messagespammer1 = 88; msgspamtimer = 10;
						globalconsolemessage("?", username.toUpperCase() + " plays A", currentroom());
					}else if (actiontile == 89 && messagespammer1 != 89) {
						messagespammer1 = 89; msgspamtimer = 10;
						globalconsolemessage("?", username.toUpperCase() + " plays B", currentroom());
					}else if (actiontile == 90 && messagespammer1 != 90) {
						messagespammer1 = 90; msgspamtimer = 10;
						globalconsolemessage("?", username.toUpperCase() + " plays high C", currentroom());
					}
				}else if (actiontile >= 100 && actiontile < 110) {
					//Global message
					if (actiontile == 100 && messagespammer1 != 100) {
						messagespammer1 = 100; msgspamtimer = 60 * 5;
						if (serverplayerisdog[playernum] == 1) {
						  globalconsolemessage("?", "BROADCAST FROM " + username.toUpperCase() + ": Woof Woof Woof!", -1);
						}else {
							globalconsolemessage("?", "BROADCAST FROM " + username.toUpperCase() + ": I'm in the mush room!", -1);
						}
						dohelptone = 2;
					}
					if (actiontile == 101 && messagespammer1 != 101) {
						messagespammer1 = 101; msgspamtimer = 60 * 5;
						if (serverplayerisdog[playernum] == 1) {
						  globalconsolemessage("?", "BROADCAST FROM " + username.toUpperCase() + ": Woof Woof Woof!", -1);
						}else {
							globalconsolemessage("?", "BROADCAST FROM " + username.toUpperCase() + ": I'm by the fountain!", -1);
						}
						dohelptone = 2;
					}
					if (actiontile == 102 && messagespammer1 != 102) {
						messagespammer1 = 102; msgspamtimer = 60 * 5;
						if (serverplayerisdog[playernum] == 1) {
						  globalconsolemessage("?", "BROADCAST FROM " + username.toUpperCase() + ": Woof Woof Woof!", -1);
						}else {
							globalconsolemessage("?", "BROADCAST FROM " + username.toUpperCase() + ": I found treasure!", -1);
						}
						dohelptone = 2;
					}
					if (actiontile == 103 && messagespammer1 != 103) {
						messagespammer1 = 103; msgspamtimer = 60 * 5;
						if (serverplayerisdog[playernum] == 1) {
						  globalconsolemessage("?", "BROADCAST FROM " + username.toUpperCase() + ": Woof Woof Woof!", -1);
						}else {
							globalconsolemessage("?", "BROADCAST FROM " + username.toUpperCase() + ": Meet me in the alley!", -1);
						}
						dohelptone = 2;
					}
					if (actiontile == 104 && messagespammer1 != 104) {
						messagespammer1 = 104; msgspamtimer = 60 * 5;
						if (serverplayerisdog[playernum] == 1) {
						  globalconsolemessage("?", "BROADCAST FROM " + username.toUpperCase() + ": Woof! Woof Woof Woof!", -1);
						}else{
						  globalconsolemessage("?", "BROADCAST FROM " + username.toUpperCase() + ": Meow Meow Meow!", -1);
						}
						dohelptone = 2;
					}
				}else if (actiontile >= 110 && actiontile < 120) {
					//local message
					if (actiontile == 110 && messagespammer2!=110) {
					  //messagespammer2 = 110;
						if (serverplayerisdog[playernum] == 1) {
							localconsolemessage("??", "Help: You can type \"/woof\" to cry for attention!");
						}else{
						  localconsolemessage("??", "Help: You can type \"/meow\" to cry for attention!");
						}
						dohelptone = 1;
					}
					if (actiontile == 111) {
					  //messagespammer2 = 110;
						localconsolemessage("??", "Help: Tired? Try taking a \"/nap\"!");
						dohelptone = 1;
					}
					if (actiontile == 112) {
					  //messagespammer2 = 110;
						if (serverplayerisdog[playernum] == 1) {
						  localconsolemessage("??", "Help: Also try \"/pant\" and \"/howl\"!");
						}else{
						  localconsolemessage("??", "Help: Also try \"/purr\" and \"/screech\"!");
						}
						dohelptone = 1;
					}
					if (actiontile == 113) {
					  //messagespammer2 = 110;
						localconsolemessage("??", "Help: Type \"/me does thing\" to do a thing!");
						dohelptone = 1;
					}
					if (actiontile == 114) {
					  //messagespammer2 = 110;
						localconsolemessage("??", "Help: This is a peaceful place. No dogs allowed!");
						dohelptone = 1;
					}
				}else if (actiontile >= 160 && actiontile < 180) {
					//Stepped on a button
					chatconnection.send("opendoor", username, actiontile-159);
				}
				
				if (x >= 48 && y >= 30 && x <= 51 && y <= 31) {
					//On the doorstep!
					if (hazmouse) {
						hazmouse = false;
						//Turn player into cat if not a cat
						if (serverplayerisdog[playernum] == 1) {				
							chatconnection.send("showmouse", 0);
							globalconsolemessage("!", username + " left an offering at the house", -1);
							
							globalconsolemessage("!!", username + " is a cat now", -1);
							chatconnection.send("becomecat", username, playernum);
						}else {
							domeow = true;
							score++;
							chatconnection.send("showmouse", 0);
							globalconsolemessage("!", username + " left a present at the house! SCORE: " + score, -1);
				      kongapi.submit("present", score);
						}
					}
				}
				
				if ((x == 73 && y == 6) || (x == 74 && y == 6)) {
					//At the dog altar
					if (hazmouse) {
						hazmouse = false;
					  chatconnection.send("showmouse", 1);
						//Turn player into dog for testing here
						if(serverplayerisdog[playernum] == 0){
					    globalconsolemessage("!", username + " left an offering at the dog altar", -1);
							globalconsolemessage("!!", username + " is a dog now", -1);
							chatconnection.send("becomedog", username, playernum);
						}else {
							domeow = true;
							score++;
					    globalconsolemessage("!", username + " left a present at the altar! SCORE: " + score, -1);
						}
					}
				}
				
				if (which == playernum) {
					//To feel more responsive, player moves locally first, corrected by server later
					domove(map, playernum, x, y, dir, true);
				}
				sendmove(which, x, y, dir);
			}else {
				//movetimeout = 0; //Move not valid;
			}
		}
		
		public function domove(map:mapclass, which:int, x:int, y:int, dir:int, lcl:Boolean=false):void {
			player[which].dir = dir;
			
			if (which == playernum && !lcl) {
				movetimeout = 0;
			}
			
			if (!map.collide(x, y, which, serverplayerisdog[which])) {
				player[which].xp = x;
				player[which].yp = y;
				
				//Button pressing code here
				if ( map.at(x, y)  >= 160  && map.at(x, y) < 180) {
					buttonpress = 1;
					buttonnum = map.at(x, y)-159;
					buttonx = x; buttony = y;
				}
			}
		}
		
		//Multiplayer API stuff
		public var chatconnection:Connection;
		public var gameclient:Client;
		
		public function connect():void {
			gamestate = CONNECTMODE;
			
			trace("attempting to connect");
			
			PlayerIO.connect(
				swfstage,								//Referance to stage
				"player.io game id redacted",			//Game id (Get your own at playerio.com)
				"public",							//Connection id, default is public
				username,						//Username
				"",									//User auth. Can be left blank if authentication is disabled on connection
				null,								//Current PartnerPay partner.
				handleConnect,						//Function executed on successful connect
				handleError							//Function executed if we recive an error
			);  
		}
		
		public function handleConnect(client:Client):void{
			trace("Sucessfully connected to player.io");
			
			//GO LIVE
			//Set developmentsever (Comment out to connect to your server online)
			gameclient = client;
			//client.multiplayer.developmentServer = "localhost:8184";
			
			listrooms(client);
			gamestate = LOBBYMODE;
		}
		
		public function listrooms(client:Client):void {
      client.multiplayer.listRooms(
				"KittyRpg2",				//Type of room
				{},		//Only list rooms where maxplayers = 4 (eg. {maxplayers:4})
				50,							//Limit to 20 results
				0,							//Start at the first room
				function(rooms:Array):void { 
					roomlist = new Array();
					for (var i:int = 0; i < rooms.length; i++) {
						if (rooms[i].onlineUsers <= 8) roomlist.push(rooms[i]);
					}
					updateroomlist = true; 
					if (roomlist.length == 0) lobbystate = 1; 
				},
				function(e:PlayerIOError):void{ trace("Unable to list rooms", e) }
			);
		}
		
		
		public function joinroom(rname:String, client:Client):void {
			//Create pr join the room test
			client.multiplayer.createJoinRoom(
				rname,								//Room id. If set to null a random roomid is used
				"KittyRpg2",							//The game type started on the server
				true,							    	//Should the room be visible in the lobby?
				{},									    //Room data. This data is returned to lobby list. Variabels can be modifed on the server
				{},									    //User join data
				handleJoin,							//Function executed on successful joining of the room
				handleError							//Function executed if we got a join error
			);
		}
		
		
		public function handleJoin(connection:Connection):void{
			trace("Sucessfully connected to the multiplayer server");
			gamestate = GAMEMODE;
			
			chatconnection = connection;
			
			//Add disconnect listener
			connection.addDisconnectHandler(handleDisconnect);
					
			//Add listener for messages of the type "hello"
			connection.addMessageHandler("hello", function(m:Message):void{
				trace("Recived a message with the type hello from the server");			 
			})
			
			//Add message listener for users joining the room
			connection.addMessageHandler("ChatJoin", function(m:Message, userid:uint):void {
				//right, we send an extra message here so that the server knows our username. Shitty way to handle
				//it, but it's all I can work out right now.
				if (!thisplayeractive) chatconnection.send("chatjoin2", username);
			})
			
			connection.addMessageHandler("chatjoin3", function(m:Message, userid:uint):void {
				if (!thisplayeractive) {
					//Is this me? If so, set my playernum
					thisplayeractive = true;
					playernum = m.getInt(2);
					trace("This client just joined");
					serverplayernames[playernum] = m.getString(1);
					serverplayeronline[playernum] = true;
				  globalconsolemessage("!!", serverplayernames[playernum] + " entered the game", -1);
				  if (m.getInt(2) >= servernumplayers) servernumplayers = m.getInt(2) + 1;
				}else {
					//If not, just declare that there's a new player in the game
					trace("Player with the userid", userid, "just joined the room");
					serverplayernames[m.getInt(2)] = m.getString(1);
					serverplayeronline[m.getInt(2)] = true;
				  if (m.getInt(2) >= servernumplayers) servernumplayers = m.getInt(2) + 1;
					//globalconsolemessage("!",m.getString(1) + " entered the game");
				}
			})
			
			
			//Add message listener for users leaving the room
			connection.addMessageHandler("ChatLeft", function(m:Message, userid:uint):void{
				trace("Player with the userid", userid, "just left the room");
				//Ok, this player can't annouce this one, so we manually add the message
				addchatmessage(0, "!!", serverplayernames[userid] + " left the game", "-1");
				serverplayernames[userid] = "";
				serverplayeronline[userid] = false;
				
        if (userid - 1 == servernumplayers) servernumplayers--;
			})
			
			connection.addMessageHandler("gamestate", function(m:Message, userid:uint):void{
				//We recieve the special gamestate update message, implement it
				servernumplayers = m.getInt(0);
				for (var i:int = 0; i < servernumplayers; i++) {
					serverplayernames[i] = m.getString((i * 3) + 1);
					if (m.getInt(((i * 3) + 1) + 1) == 1) {
					  serverplayeronline[i] = true;
					}else {
						serverplayeronline[i] = false;
					}
					if (m.getInt(((i * 3) + 2) + 1) == 1) {
					  serverplayerisdog[i] = 1;
					}else {
						serverplayerisdog[i] = 0;
					}
				}
				
				//Each player now does a "fake" move to inform everyone of where they really are
				
				sendmove(playernum, player[playernum].xp, player[playernum].yp, player[playernum].dir);
			})
			
			connection.addMessageHandler("getgs", function(m:Message, userid:uint):void{
				//We recieve the special gamestate update message, implement it
				//Copy of above for focus
				servernumplayers = m.getInt(0);
				for (var i:int = 0; i < servernumplayers; i++) {
					serverplayernames[i] = m.getString((i * 3) + 1);
					if (m.getInt(((i * 3) + 1) + 1) == 1) {
					  serverplayeronline[i] = true;
					}else {
						serverplayeronline[i] = false;
					}
					if (m.getInt(((i * 3) + 2) + 1) == 1) {
					  serverplayerisdog[i] = 1;
					}else {
						serverplayerisdog[i] = 0;
					}
				}
				
				//Each player now does a "fake" move to inform everyone of where they really are
				
				sendmove(playernum, player[playernum].xp, player[playernum].yp, player[playernum].dir);
				
				checkgamestate = 0;
			})
			
			connection.addMessageHandler("m", function(m:Message, userid:uint):void {
				//addchatmessage(0 , "Server", "move(" + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+","+m.getString(4)+")");
				
				addchatmessage(5 , "Server", "move(" + m.getString(0) + "," + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+","+m.getString(4)+")");
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})
			
			connection.addMessageHandler("hair", function(m:Message, userid:uint):void {
				//addchatmessage(0 , "Server", "move(" + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+","+m.getString(4)+")");
				addchatmessage(5 , "Server", "hair(" + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+")");
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})
			
			connection.addMessageHandler("kill", function(m:Message, userid:uint):void {
				//addchatmessage(0 , "Server", "move(" + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+","+m.getString(4)+")");
				addchatmessage(5 , "Server", "kill(" + m.getString(1) + ")");
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})
						
			connection.addMessageHandler("becomedog", function(m:Message, userid:uint):void {
				//addchatmessage(0 , "Server", "move(" + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+","+m.getString(4)+")");
				addchatmessage(5 , "Server", "becomedog(" + m.getString(1) + ")");
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})			
									
			connection.addMessageHandler("cursedog", function(m:Message, userid:uint):void {
				//addchatmessage(0 , "Server", "move(" + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+","+m.getString(4)+")");
				addchatmessage(5 , "Server", "cursedog(" + m.getString(1) + ")");
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})			
			
			connection.addMessageHandler("becomecat", function(m:Message, userid:uint):void {
				//addchatmessage(0 , "Server", "move(" + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+","+m.getString(4)+")");
				addchatmessage(5 , "Server", "becomecat(" + m.getString(1) + ")");
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})
			
			connection.addMessageHandler("foundmouse", function(m:Message, userid:uint):void {
				//addchatmessage(0 , "Server", "move(" + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+","+m.getString(4)+")");
				addchatmessage(5 , "Server", "foundmouse(" + m.getString(1) + "," + m.getString(2) + ")");
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})
			
			connection.addMessageHandler("showmouse", function(m:Message, userid:uint):void {
				//addchatmessage(0 , "Server", "move(" + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+","+m.getString(4)+")");
			  addchatmessage(5 , "Server", "showmouse(" + m.getString(1) + ")");
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})
			
			connection.addMessageHandler("nyan1", function(m:Message, userid:uint):void {
				//addchatmessage(0 , "Server", "move(" + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+","+m.getString(4)+")");
				addchatmessage(5 , "Server", "nyan1(" + m.getString(1) + ")");
			})
			
			connection.addMessageHandler("nyan2", function(m:Message, userid:uint):void {
				//addchatmessage(0 , "Server", "move(" + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+","+m.getString(4)+")");
				addchatmessage(5 , "Server", "nyan2(" + m.getString(1) + ")");
			})	
			
			connection.addMessageHandler("opendoor", function(m:Message, userid:uint):void {
				//addchatmessage(0 , "Server", "move(" + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+","+m.getString(4)+")");
				addchatmessage(5 , "Server", "opendoor(" + m.getString(1) + "," + m.getString(2) + ")");
			})		
			
			connection.addMessageHandler("closedoor", function(m:Message, userid:uint):void {
				//addchatmessage(0 , "Server", "move(" + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+","+m.getString(4)+")");
				addchatmessage(5 , "Server", "closedoor(" + m.getString(1) + "," + m.getString(2) + ")");
			})
			
			connection.addMessageHandler("damage1", function(m:Message, userid:uint):void {
				//addchatmessage(0 , "Server", "move(" + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+","+m.getString(4)+")");
				addchatmessage(5 , "Server", "damage1(" + m.getString(1) + "," + m.getString(2) + "," + m.getString(3) + "," + m.getString(4) + ")");
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})
			
			connection.addMessageHandler("damage2", function(m:Message, userid:uint):void {
				//addchatmessage(0 , "Server", "move(" + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+","+m.getString(4)+")");
				addchatmessage(5 , "Server", "damage2(" + m.getString(1) + "," + m.getString(2) + "," + m.getString(3) + "," + m.getString(4) + ")");
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})
			
			connection.addMessageHandler("hairdamage1", function(m:Message, userid:uint):void {
				//addchatmessage(0 , "Server", "move(" + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+","+m.getString(4)+")");
				addchatmessage(5 , "Server", "hairdamage1(" + m.getString(1) + "," + m.getString(2) + "," + m.getString(3) + "," + m.getString(4) + ")");
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})
			
			connection.addMessageHandler("hairdamage2", function(m:Message, userid:uint):void {
				//addchatmessage(0 , "Server", "move(" + m.getString(1) + "," +  m.getString(2)+","+m.getString(3)+","+m.getString(4)+")");
				addchatmessage(5 , "Server", "hairdamage2(" + m.getString(1) + "," + m.getString(2) + "," + m.getString(3) + "," + m.getString(4) + ")");
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})
			
			connection.addMessageHandler("c", function(m:Message, userid:uint):void {
				addchatmessage(0 , m.getString(2), m.getString(3), m.getString(1));
				
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})
			
			connection.addMessageHandler("chat1", function(m:Message, userid:uint):void {
				addchatmessage(1 , m.getString(2), m.getString(3), m.getString(1));
				
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})
			
			connection.addMessageHandler("chat2", function(m:Message, userid:uint):void {
				addchatmessage(2 ,m.getString(2), m.getString(3), m.getString(1));
				
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})
			connection.addMessageHandler("chat3", function(m:Message, userid:uint):void {
				addchatmessage(3 , m.getString(2), m.getString(3), m.getString(1));
				
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})
			connection.addMessageHandler("chat4", function(m:Message, userid:uint):void {
				addchatmessage(4 , m.getString(2), m.getString(3), m.getString(1));
				
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})
			
			connection.addMessageHandler("d", function(m:Message, userid:uint):void {
				addchatmessage(5 , m.getString(2), m.getString(3), m.getString(1));
				
				//trace("Player userid", userid,  m.getString(1), "just sent a message to the server, ", m.getString(2));
			})
			
			//Listen to all messages using a private function
			connection.addMessageHandler("*", handleMessages)
			
		}
		
		public function handleMessages(m:Message):void{
			//trace("Recived the message", m)
		}
		
		public function handleDisconnect():void{
			trace("Disconnected from server")
		}
		
		public function handleError(error:PlayerIOError):void{
			trace("got", error);
			errormessage = error.message;
			connectionerror = true;
			gamestate = CONNECTMODE;
		}
		
		//ends here
			
		public function windowNotActive(e:Event):void{ infocus = false; }
    public function windowActive(e:Event):void { infocus = true; 
		  if(gamestate==0){
		    checkgamestate = 2; 
			}
		}
		
		public function enabletextfield():void {
			//We attach the input field here, as we've set up the stage for it
			swfstage.addChild(inputField);
			inputField.border = true;
			inputField.width = 600;
			inputField.height = 20;
			inputField.x = 5;
			inputField.y = 450;
			inputField.type = "input";
			inputField.visible = false;
		}
				
		public function gettext_createroom(key:KeyPoll, music:musicclass):void {
			swfstage.focus = inputField;
			inputField.setSelection(inputField.text.length, inputField.text.length);
			textfield = inputField.text;
				
			if ((key.isDown(13)) && !jumpheld && textfield != "") {
				//music.playef(0, 10);
				//Join server with username
				//sendmessage(activetab, textfield);
				gameroomname = textfield;
				joinroom(gameroomname, gameclient);
				
				lobbystate = 2;
				textfield = "";
				inputField.text = "";
				jumpheld = true;
			}
		}
		
		public function gettext_entername(key:KeyPoll, music:musicclass):void {
			swfstage.focus = inputField;
			inputField.setSelection(inputField.text.length, inputField.text.length);
			textfield = inputField.text;
				
			if ((key.isDown(13)) && !jumpheld && textfield != "") {
				//music.playef(0, 10);
				//Join server with username
				//sendmessage(activetab, textfield);
				username = textfield;
				connect();
				lobbystate = 0;
				
				textfield = "";
				inputField.text = "";
				
				inputField.text = username + "_room";
		    textfield = inputField.text;
				
				jumpheld = true;
			}
		}
		
		public function currentroom():int {
			//Returns the current room the camera is in
			return camerax + (cameray * 5);
		}
		
		
		public function oldroom():int {
			//Returns the old room the camera is in
			return oldcamerax + (oldcameray * 5);
		}
		
		public function gettext_chat(key:KeyPoll, music:musicclass):void {
			swfstage.focus = inputField;
			inputField.setSelection(inputField.text.length, inputField.text.length);
			textfield = inputField.text;
				
			if ((key.isDown(13)) && !jumpheld && textfield != "") {
				normaltxt = 0;
				if (serverplayerisdog[playernum] == 0) {	
					if (help.Left(textfield, 5) == "/meow") {
						//Meow
						globalconsolemessage("%" + username, username + " meows", currentroom());
						//music.playef(0);
						textfield = "";
						inputField.text = "";
						jumpheld = true; normaltxt = 1;
					}else if (help.Left(textfield, 5) == "/purr") {
						globalconsolemessage("^" + username, username + " purrs", currentroom());
						textfield = "";
						inputField.text = "";
						jumpheld = true;normaltxt = 1;
					}else if (help.Left(textfield, 8) == "/screech") {
						globalconsolemessage("&" + username, username + " screeches", currentroom());
						textfield = "";
						inputField.text = "";
						jumpheld = true;normaltxt = 1;
					}else if (help.Left(textfield, 4) == "/nap") {
						globalconsolemessage("*" + username, username + " takes a nap", currentroom());
						textfield = "";
						inputField.text = "";
						jumpheld = true;normaltxt = 1;
					}else if (help.Left(textfield, 4) == "/me ") {
						globalconsolemessage("+" + username, username + " " + help.mechars(textfield), currentroom());
						textfield = "";
						inputField.text = "";
						jumpheld = true;normaltxt = 1;
					}else {
						//music.playef(0, 10);
						sendmessage(activetab, textfield, currentroom());
						textfield = "";
						inputField.text = "";
						jumpheld = true;
					}
				}else {
					if (help.Left(textfield, 5) == "/bark" || help.Left(textfield, 5) == "/woof") {
						//Meow
						globalconsolemessage("{" + username, username + " barks", currentroom());
						//music.playef(0);
						textfield = "";
						inputField.text = "";
						jumpheld = true; normaltxt = 1;
					}else if (help.Left(textfield, 5) == "/pant") {
						globalconsolemessage("}" + username, username + " pants", currentroom());
						textfield = "";
						inputField.text = "";
						jumpheld = true;normaltxt = 1;
					}else if (help.Left(textfield, 5) == "/howl") {
						globalconsolemessage("[" + username, username + " howls", currentroom());
						textfield = "";
						inputField.text = "";
						jumpheld = true;normaltxt = 1;
					}else if (help.Left(textfield, 4) == "/nap") {
						globalconsolemessage("]" + username, username + " takes a nap", currentroom());
						textfield = "";
						inputField.text = "";
						jumpheld = true;normaltxt = 1;
					}else if (help.Left(textfield, 4) == "/me ") {
						globalconsolemessage("+" + username, username + " " + help.mechars(textfield), currentroom());
						textfield = "";
						inputField.text = "";
						jumpheld = true; normaltxt = 1;
					}else {
						//music.playef(0, 10);
						if (Math.random() * 100 > 50) {
							textfield = "woof woof woof";
						}else {
							if (Math.random() * 100 > 50) {
							  textfield = "woof woof";
							}else {
								textfield = "woof woof woof woof";
							}
						}
						sendmessage(activetab, textfield, currentroom());
						textfield = "";
						inputField.text = "";
						jumpheld = true;
					}
				}
			}
		}
		
		public function updatestate(obj:entityclass, music:musicclass):void {
			statedelay--; if(statedelay<=0) statedelay=0;
      if (statedelay <= 0) {
				switch(state){
          case 0:
            //Do nothing here! Standard game state
          break;
					case 1:
					  //Game initilisation
          break;
				}
			}
		}
		
		public function start(obj:entityclass, music:musicclass):void {
			obj.createentity(40, 20, 0);
		}
		
    public var state:int, statedelay:int;
		
		public var gamestate:int;
    public var hascontrol:Boolean, jumpheld:Boolean, jumppressed:int;
		
		public var mx:int, my:int;
		public var screenshake:int, flashlight:int;
		public var test:Boolean, teststring:String;
		
		public var infocus:Boolean, paused:Boolean;
		public var muted:Boolean; 
		public var mutebutton:int;
		public var globalsound:int;
		public var deathseq:int, completestop:Boolean;
		
		public var chatbox_main:Array = new Array();
		public var chatbox_mainsubset:Array = new Array();
		public var chatbox_mainroom:Array = new Array();
		public var chatbox_1:Array = new Array();
		public var chatbox_2:Array = new Array();
		public var chatbox_3:Array = new Array();
		public var chatbox_4:Array = new Array();
		public var chatbox_logic:Array = new Array();
		public var chatbox_mainpos:int;
		public var chatbox_mainsubsetpos:int;
		public var chatbox_1pos:int;
		public var chatbox_2pos:int;
		public var chatbox_3pos:int;
		public var chatbox_4pos:int;
		public var chatbox_logicpos:int;
		
		public var connectionerror:Boolean = false;
		public var username:String, gameroomname:String;
		
		public var swfstage:Stage;
		
		public var activetab:int = 0;
		
		public var press_up:Boolean, press_down:Boolean, press_left:Boolean, press_right:Boolean, press_action:Boolean, press_map:Boolean;
		public var keypriority:int = 0;
		public var keyheld:Boolean;
		
		public var keydelay:int;
		public var keypressed:String = "";
		public var lastkeypressed:String = "";
		public var textfield:String = "";
    public var inputField:TextField = new TextField();
		
		//Lobby control
		public var lobbystate:int;
		public var roomlist:Array = new Array();
		public var updateroomlist:Boolean = false;
		public var lobbymenu:int=0;
		public var lobbymenuposition:int = 0, lobbymenustart:int = 0;
		public var errormessage:String = "Unknown Error";
		
		//For testing
		public var offlinemode:Boolean = false;
		
		public var thisplayeractive:Boolean = false;
		
		//Super simple entity placement
		public var enemy:Array = new Array();
		public var player:Array = new Array();
		public var playernum:int;
		public var movedelay:int = 0;
		public var cameray:int, camerax:int;
		
		//Script contents
		public var commands:Array = new Array();
		public var words:Array = new Array();
		public var tempword:String, currentletter:String;
		
		public var actiontile:int;
		
		public var checkpointx:int, checkpointy:int;
		
		//
		public var meowdelay:int = 0;
		public var buttonpress:int = 0, buttonnum:int = 0, buttonx:int = 0, buttony:int = 0;
		
		//Simple RPG Menu
		public var rpgmenu:int = 0, rpgmenuselection:int = 0;
		public var hairballmode:int = 0;
		public var hairballx:int, hairbally:int;
		
		//Mirror of server player info
		public var serverplayernames:Array = new Array();
		public var serverplayeronline:Array = new Array();
		public var serverplayerisdog:Array = new Array();
		public var servernumplayers:int;
		
		public var oldcamerax:int = -1, oldcameray:int = -1;
		public var roomn:Array = new Array();
		
		public var doplaysound:int = 0;
		
		public var messagespammer1:int = 0;
		public var messagespammer2:int = 0;
		
		public var meowgesture:int = 0;
		
		public var hazmouse:Boolean = false;
		public var housemouse:int = 0;
		public var altarmouse:int = 0;
		public var score:int;
		public var mygesture:Boolean = false;
		
		public var movetimeout:int = 0;
		public var msgspamtimer:int = 0;
		public var foundamousespammer:int = 0;
		
		public var normaltxt:int = 0;
		public var domeow:Boolean = false;
		public var dohelptone:int = 0;
		
		public var nobacksies:int = 0;
		public var tagtimeout:int = 0;
		public var checkgamestate:int = 0;
	}
}
package{
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	
	public class graphicsclass extends Sprite {
		public function init():void {
			//We initialise a few things
			updatebackground = true;
			tiles_rect=new Rectangle(0,0,16,16);
			sprites_rect=new Rectangle(0,0,16,16);
			trect = new Rectangle; tpoint = new Point();
			tbuffer = new BitmapData(1, 1, true);
			tl = new Point(0, 0);
			ct = new ColorTransform(0, 0, 0, 1, 255, 255, 255, 1); //Set to white
			
			// FONT SELECTIONS
			//
			// To modify; change the "currentfont" string below, and then change the embedded font at the end of Main.as.
			// 
			// small     -  Silkscreen Font                                                  [not fixed width]
			// tiny      -  Very small font for very low resolutions                         [not fixed width]
			// flixel    -  Nokia Mobile Phone font, used in Flixel library; funky           [not fixed width]
			// 04b11     -  NES like pixel font, slightly wider than normal                  [not fixed width]
			// c64       -  C64 font, awesome, fixed width, 8x8                                [FIXED WIDTH]
			// terminal  -  DOS Terminal font, fixed width, 8x12                               [FIXED WIDTH]
			//
			// Auntie Pixelante fonts implemented: http://www.auntiepixelante.com/
			//
			// slanted   -  Italic font                                                        [FIXED WIDTH]
			// starperv  -  Uppercase font                                                     [FIXED WIDTH]
			// crypt     -  Crypt of Tomorrow font, very small                                 [FIXED WIDTH]
			// 2xcrypt   -  As above, only at twice the size                                   [FIXED WIDTH]
			// casual    -  Casual Encounter font, fairly big                                [not fixed width]
			currentfont = "flixel";
			fontwidth = 8; fontheight = 8;
			if (currentfont == "terminal") fontheight = 12;
			if (currentfont == "casual") fontheight = 16;
			if (currentfont == "2xcrypt") { fontwidth = 16; fontheight = 16; }
			bfont_rect = new Rectangle(0, 0, fontwidth, fontheight);
			
			//Scaling stuff
			bigbuffer = new BitmapData(320, 32, true, 0x000000);
			bigbufferscreen = new Bitmap(bigbuffer);
			bigbufferscreen.width = 640;
      bigbufferscreen.height = 64;
			scaleMatrix = new Matrix();
			
			//Zoomscreen stuff
			zoombuffer = new BitmapData(320, 192, true, 0x000000);
			zoombufferscreen = new Bitmap(zoombuffer);
			zoombufferscreen.width = 320*2;
      zoombufferscreen.height = 192*2;
			zoomscaleMatrix = new Matrix();
			
			//Textboxes!
			for (i = 0; i < 20; i++) {
				var t:textboxclass = new textboxclass;
				textbox.push(t);
				textcol.push(new int);
			}
			ntextbox = 0;
			
			textcol[0] = RGB(143, 180, 42);
			textcol[1] = RGB(215, 120, 53);
			textcol[2] = RGB(54, 139, 230);
			textcol[3] = RGB(215, 120, 53);
			textcol[4] = RGB(135, 135, 135);
			textcol[5] = RGB(159, 38, 52);
			textcol[6] = RGB(165, 206, 230);
			textcol[7] = RGB(196, 98, 118);
			textcol[8] = RGB(137, 91, 33);
			textcol[9] = RGB(54, 139, 230);
			textcol[10] = RGB(64, 64, 64);
			
			
		  backbuffer=new BitmapData(320, 300,false,0x000000);
		  screenbuffer = new BitmapData(320,300,false,0x000000);
			
		  temptile = new BitmapData(16, 16, false, 0x000000);
			screen = new Bitmap(screenbuffer);
			screen.width = 640;
      screen.height = 600;
			addChild(screen);				
    }
		
		public function drawchatbox(game:gameclass):void {
			//Tabs
			//drawtextbox(0, 194 - (int(game.activetab == 0) * 5), 64, 18, 0);	
			/*
			drawtextbox(64, 194-(int(game.activetab==1)*5), 64, 18, 1);	
			drawtextbox(128, 194-(int(game.activetab==2)*5), 64, 18, 2);	
			drawtextbox(192, 194-(int(game.activetab==3)*5), 64, 18, 3);	
			drawtextbox(256, 194-(int(game.activetab==4)*5), 64, 18, 4);	
			*/
			//print(6, 198 - (int(game.activetab == 0) * 5), "Chat", 0, 0, 0);
			//print(6, 198 - (int(game.activetab == 0) * 5), "Everyone", 0, 0, 0);
			/*
			print(64 + 6, 198 - (int(game.activetab == 1) * 5), "Player 1", 0, 0, 0);
			print(128 + 6, 198 - (int(game.activetab == 2) * 5), "Player 2", 0, 0, 0);
			print(192 + 6, 198 - (int(game.activetab == 3) * 5), "Player 3", 0, 0, 0);
			print(256 + 6, 198 - (int(game.activetab == 4) * 5), "Player 4", 0, 0, 0);
			*/
			
			
			
			drawtextbox(0, 192, 320, 96 + 12, game.activetab);	//Textbox zone
			//Make a subset list for the current room
			game.makechatsubset();
			if(game.activetab==0){
				for (i = game.chatbox_mainsubsetpos - 1; (i >= game.chatbox_mainsubsetpos - 1 - 9) && (i >= 0); i--) {
					if (game.chatbox_mainsubset[i].n == "!") {
						//System message
						print(4, 287-9-((game.chatbox_mainsubsetpos-1-i)*9), "[ "+game.chatbox_mainsubset[i].s.toUpperCase()+" ]", 32,32,196);
					}else if (game.chatbox_mainsubset[i].n == "?") {
						//System message
						print(4, 287-9-((game.chatbox_mainsubsetpos-1-i)*9), "-= "+game.chatbox_mainsubset[i].s+" =-", 16,84,16);
					}else if (game.chatbox_mainsubset[i].n == "??") {
						//System message
						print(4, 287-9-((game.chatbox_mainsubsetpos-1-i)*9), "-= "+game.chatbox_mainsubset[i].s+" =-", 16,16,84);
					}else if (game.chatbox_mainsubset[i].n == "!!") {
						//System message
						print(4, 287-9-((game.chatbox_mainsubsetpos-1-i)*9), "[ "+game.chatbox_mainsubset[i].s.toUpperCase()+" ]", 32,196,32);
					}else if (help.Left(game.chatbox_mainsubset[i].n, 1) == "%" ||
					          help.Left(game.chatbox_mainsubset[i].n, 1) == "^" ||
										help.Left(game.chatbox_mainsubset[i].n, 1) == "&" ||
										help.Left(game.chatbox_mainsubset[i].n, 1) == "*" ||
										help.Left(game.chatbox_mainsubset[i].n, 1) == "+" ||
										help.Left(game.chatbox_mainsubset[i].n, 1) == "{" ||
										help.Left(game.chatbox_mainsubset[i].n, 1) == "}" ||
										help.Left(game.chatbox_mainsubset[i].n, 1) == "[" ||
										help.Left(game.chatbox_mainsubset[i].n, 1) == "]") {
						cprint(4, 287-9-((game.chatbox_mainsubsetpos-1-i)*9), game.chatbox_mainsubset[i].s, textcol[game.getcolour(help.lastchars(game.chatbox_mainsubset[i].n))]);
					}else if (game.chatbox_mainsubset[i].n != game.username) {
						cprint(4, 287-9 - ((game.chatbox_mainsubsetpos - 1 - i) * 9), game.chatbox_mainsubset[i].n+ ":", textcol[game.getcolour(game.chatbox_mainsubset[i].n)]);
						print(len(game.chatbox_mainsubset[i].n+": "), 287-9-((game.chatbox_mainsubsetpos-1-i)*9), game.chatbox_mainsubset[i].s, 0,0,0);
					}else {
						fillrect(2, 287 - 10 - ((game.chatbox_mainsubsetpos - 1 - i) * 9), 316, 9, 225,225,225);
						cprint(4, 287-9 - ((game.chatbox_mainsubsetpos - 1 - i) * 9), game.chatbox_mainsubset[i].n + ":", textcol[game.getcolour(game.chatbox_mainsubset[i].n)]);
						print(len(game.chatbox_mainsubset[i].n+": "), 287-9-((game.chatbox_mainsubsetpos-1-i)*9), game.chatbox_mainsubset[i].s, 0,0,0);
					}
				}
			}else if(game.activetab==1){
				for (i = game.chatbox_1pos - 1; (i >= game.chatbox_1pos - 1 - 10) && (i >= 0); i--) {
					if (game.chatbox_1[i].n != game.username) {
						print(4, 277-((game.chatbox_1pos-1-i)*8), game.chatbox_1[i].n + ":", 128, 128, 0);
					}else{
						print(4, 277-((game.chatbox_1pos-1-i)*8), game.chatbox_1[i].n + ":", 0, 128, 0);
					}
					print(len(game.chatbox_1[i].n+": "), 277-((game.chatbox_1pos-1-i)*8), game.chatbox_1[i].s, 0,0,0);
				}
			}else if(game.activetab==2){
				for (i = game.chatbox_2pos - 1; (i >= game.chatbox_2pos - 1 - 10) && (i >= 0); i--) {
					if (game.chatbox_2[i].n != game.username) {
						print(4, 277-((game.chatbox_2pos-1-i)*8), game.chatbox_2[i].n + ":", 128, 128, 0);
					}else{
						print(4, 277-((game.chatbox_2pos-1-i)*8), game.chatbox_2[i].n + ":", 0, 128, 0);
					}
					print(len(game.chatbox_2[i].n+": "), 277-((game.chatbox_2pos-1-i)*8), game.chatbox_2[i].s, 0,0,0);
				}
			}else if(game.activetab==3){
				for (i = game.chatbox_3pos - 1; (i >= game.chatbox_3pos - 1 - 10) && (i >= 0); i--) {
					if (game.chatbox_3[i].n != game.username) {
						print(4, 277-((game.chatbox_3pos-1-i)*8), game.chatbox_3[i].n + ":", 128, 128, 0);
					}else{
						print(4, 277-((game.chatbox_3pos-1-i)*8), game.chatbox_3[i].n + ":", 0, 128, 0);
					}
					print(len(game.chatbox_3[i].n+": "), 277-((game.chatbox_3pos-1-i)*8), game.chatbox_3[i].s, 0,0,0);
				}
			}else if(game.activetab==4){
				for (i = game.chatbox_4pos - 1; (i >= game.chatbox_4pos - 1 - 10) && (i >= 0); i--) {
					if (game.chatbox_4[i].n != game.username) {
						print(4, 277-((game.chatbox_4pos-1-i)*8), game.chatbox_4[i].n + ":", 128, 128, 0);
					}else{
						print(4, 277-((game.chatbox_4pos-1-i)*8), game.chatbox_4[i].n + ":", 0, 128, 0);
					}
					print(len(game.chatbox_4[i].n+": "), 277-((game.chatbox_4pos-1-i)*8), game.chatbox_4[i].s, 0,0,0);
				}
			}
			
			
			drawtextbox(0, 287, 320, 13); //Text entry
			
			print(4, 290, "SAY: ", 0, 0, 0);
			if((int(help.glow/16))%2==0){
			  print(4 + len("SAY: "), 290, game.textfield + "_", 0, 0, 0);
			}else {
				print(4 + len("SAY: "), 290, game.textfield, 0, 0, 0);
			}
		}
		
		public function RGB(red:Number,green:Number,blue:Number):Number{
			return (blue | (green << 8) | (red << 16))
		}
		
		public function createtextbox(t:String, xp:int, yp:int, r:int = 255, g:int = 255, b:int = 255):void {
			if(ntextbox == 0) {
				//If there are no active textboxes, Z=0;
				z = 0; ntextbox++;
			}else {
				i = 0; z = -1;
				while (i < ntextbox) {
					if (!textbox[i].active) {	z = i; i = ntextbox;}
					i++;
				}
				if (z == -1) {z = ntextbox; ntextbox++;}
			}
			
			if(z<20){
				textbox[z].clear();
				textbox[z].line[0] = t;
				textbox[z].xp = xp;
				if (xp == -1) textbox[z].xp = 160 - (((t.length / 2) + 1) * 8);
				textbox[z].yp = yp;
				textbox[z].initcol(r, g, b);
				textbox[z].resize();
			}
		}
		
		public function textboxcleanup():void {
			i = ntextbox - 1; while (i >= 0 && !textbox[i].active) { ntextbox--; i--; }
		}
		
		public function textboxcenter():void {
			textbox[z].centerx(); textbox[z].centery();
		}
		
		public function textboxcenterx():void {
			textbox[z].centerx(); 
		}
		
		public function textboxcentery():void {
		  textbox[z].centery();
		}
		
		public function addline(t:String):void {
		  textbox[z].addline(t);
		}
		
		public function textboxtimer(t:int):void {
		  textbox[z].timer=t;
		}
		
		public function textboxremove():void {
			//Remove all textboxes
			for (i = 0; i < ntextbox; i++) {
				textbox[i].remove();
			}
		}
		
		public function textboxactive():void {
			//Remove all but the most recent textbox
			for (i = 0; i < ntextbox; i++) {
				if (z != i) textbox[i].remove();
			}
		}
		
		public function textboxsetmenu():void {
		  textbox[z].ismenu = true;
		}
		
		
		public function drawgui():void {
			textboxcleanup();
			//Draw all the textboxes to the screen
			for (i = 0; i < ntextbox; i++) {
				//This routine also updates the textboxs
				textbox[i].update();
				if (textbox[i].active) {
					if (textbox[i].ismenu) {
						backbuffer.fillRect(textbox[i].textrect, RGB(textbox[i].r/6, textbox[i].g/6, textbox[i].b / 6));
						
						for (j = 0; j < textbox[i].numlines; j++) {
							if (textbox[i].highlighted == j) {
								print(textbox[i].xp+2, textbox[i].yp + fontheight + (j * fontheight), ">", 255 - help.glow, 255 - help.glow, 255 - help.glow);
								print(textbox[i].xp + 8, textbox[i].yp + fontheight + (j * fontheight), textbox[i].line[j], 255-help.glow,255-help.glow,255-help.glow);
							}else {
								print(textbox[i].xp + 8, textbox[i].yp + fontheight + (j * fontheight), textbox[i].line[j], textbox[i].r*.5, textbox[i].g*.5, textbox[i].b*.5);
							}
						}
					}else{
						backbuffer.fillRect(textbox[i].textrect, RGB(textbox[i].r/6, textbox[i].g/6, textbox[i].b / 6));
						
						for (j = 0; j < textbox[i].numlines; j++) {
							print(textbox[i].xp + 8, textbox[i].yp + fontheight + (j * fontheight), textbox[i].line[j], textbox[i].r, textbox[i].g, textbox[i].b);
						}
					}
				}
			}
		}
		
		public function maketilearray():void {
			for (var j:Number = 0; j < 15; j++) {
				for (var i:Number = 0; i < 20; i++) {
					var t:BitmapData = new BitmapData(16, 16, true, 0x000000);
					var temprect:Rectangle = new Rectangle(i * 16, j * 16, 16, 16);	
					t.copyPixels(buffer, temprect, tl);
					tiles.push(t);
				}
			}
		}	
		
		public function settrect(x:int, y:int, w:int, h:int):void {
			trect.x = x;
			trect.y = y;
			trect.width = w;
			trect.height = h;
		}
		
		public function settpoint(x:int, y:int):void {
			tpoint.x = x;
			tpoint.y = y;
		}
		
		public function makespritearray():void {
			for (var j:Number = 0; j < 21; j++) {
				for (var i:Number = 0; i < 20; i++) {
					var t:BitmapData = new BitmapData(16, 16, true, 0x000000);
					var temprect:Rectangle = new Rectangle(i * 16, j * 16, 16, 16);	
					t.copyPixels(buffer, temprect, tl);
					sprites.push(t);
				}
			}
		}
		
		public function addimage():void {
			var t:BitmapData = new BitmapData(buffer.width, buffer.height, true, 0x000000);
			t.copyPixels(buffer, new Rectangle(0,0,buffer.width, buffer.height), tl);
			images.push(t);
		}
		
		public function addbackground():void {
			var t:BitmapData = new BitmapData(160, 144, true, 0x000000);
			t.copyPixels(buffer, backbuffer.rect, tl);
			backgrounds.push(t);
		}
		
		// Draw Primatives
		public function drawline(x1:int, y1:int, x2:int, y2:int, r:int, g:int, b:int):void {
			if (x1 > x2) {
				drawline(x2, y1, x1, y2, r, g, b);
			}else if (y1 > y2) {
				drawline(x1, y2, x2, y1, r, g, b);
			}else {
				tempshape.graphics.clear();
			  tempshape.graphics.lineStyle(1, RGB(r, g, b));
			  tempshape.graphics.lineTo(x2 - x1, y2 - y1);
				
				shapematrix.translate(x1, y1);
				backbuffer.draw(tempshape, shapematrix);
				shapematrix.translate(-x1, -y1);
			}
		}
				
		public function drawtextbox(x1:int, y1:int, w1:int, h1:int, col:int = 0, shad:Boolean = false):void {
			if (shad) {
				backbuffer.fillRect(new Rectangle(x1 + 5, y1 + 5, w1, h1), 0x000000);
			}
			
			if(col==0){
				fillrect(x1, y1, w1, h1, 255, 255, 255);
				drawbox(x1, y1, w1, h1, 255, 255, 255);
			}else if(col==1){
				fillrect(x1, y1, w1, h1, 255, 164, 164);
				drawbox(x1, y1, w1, h1, 255, 164, 164);
			}else if(col==2){
				fillrect(x1, y1, w1, h1, 164, 255, 164);
				drawbox(x1, y1, w1, h1, 164, 255, 164);
			}else if(col==3){
				fillrect(x1, y1, w1, h1, 255, 255, 164);
				drawbox(x1, y1, w1, h1, 255, 255, 164);
			}else if(col==4){
				fillrect(x1, y1, w1, h1, 164, 164, 255);
				drawbox(x1, y1, w1, h1, 164, 164, 255);
			}else if(col==5){
				fillrect(x1, y1, w1, h1, 128, 128, 128);
				drawbox(x1, y1, w1, h1, 164, 164, 255);
			}
			
			drawbox(x1 + 1, y1 + 1, w1 - 2, h1 - 2, 0, 0, 0);
		}
		
		public function drawbox(x1:int, y1:int, w1:int, h1:int, r:int, g:int, b:int):void {
			settrect(x1, y1, w1, 1); backbuffer.fillRect(trect, RGB(r, g, b));
			settrect(x1, y1 + h1 - 1, w1, 1); backbuffer.fillRect(trect, RGB(r, g, b));
			settrect(x1, y1, 1, h1); backbuffer.fillRect(trect, RGB(r, g, b));
			settrect(x1 + w1 - 1, y1, 1, h1); backbuffer.fillRect(trect, RGB(r, g, b));
		}
		
		public function fillrect(x1:int, y1:int, w1:int, h1:int, r:int, g:int, b:int):void {
			settrect(x1, y1, w1, h1);
			backbuffer.fillRect(trect, RGB(r, g, b));
		}
		
		public function zoomfillrect(x1:int, y1:int, w1:int, h1:int, r:int, g:int, b:int):void {
			settrect(x1, y1, w1, h1);
			zoombuffer.fillRect(trect, RGB(r, g, b));
		}
		
		// Draw Graphics
		public function drawbackground(t:int):void {
			backbuffer.copyPixels(backgrounds[t], backbuffer.rect, tl);
		}
		
		public function drawimage(t:int, xp:int, yp:int, cent:Boolean=false):void {
			if (cent) {
				backbuffer.copyPixels(images[t], new Rectangle(0,0,images[t].width, images[t].height), new Point(80-int(images[t].width/2), yp));
			}else{
			  backbuffer.copyPixels(images[t], new Rectangle(0,0,images[t].width, images[t].height), new Point(xp, yp));
			}
		}
		
		public function drawentities(game:gameclass, obj:entityclass):void {			
			for (i = 0; i < obj.nentity; i++) {
				obj.animateentities(game, i);
				if (obj.entities[i].active) {
					if (obj.entities[i].size == 1) {
						for (j = 0; j < 2; j++) {
							for (k = 0; k < 2; k++){
								backbuffer.copyPixels(sprites[obj.entities[i].drawframe + j + (k * 20)], sprites_rect, new Point(obj.entities[i].xp + (j * 16), obj.entities[i].yp + (k * 16)));	
							}
						}
					}else if (obj.entities[i].size == 2) {
						if (!obj.entities[i].invis && obj.entities[i].active) {
							backbuffer.copyPixels(tiles[obj.entities[i].drawframe], tiles_rect, new Point(obj.entities[i].xp, obj.entities[i].yp));
							backbuffer.copyPixels(tiles[obj.entities[i].drawframe+20], tiles_rect, new Point(obj.entities[i].xp, obj.entities[i].yp+16));
						}
					}else {
						if (!obj.entities[i].invis) {
							backbuffer.copyPixels(sprites[obj.entities[i].drawframe], sprites_rect, new Point(obj.entities[i].xp, obj.entities[i].yp));
						}
					}
				}
			}
		}
		
		public function drawbuffertile(x:int, y:int, t:int):void {
			buffer.copyPixels(tiles[t], tiles_rect, new Point(x, y));
		}
		
		public function drawtile(x:int, y:int, t:int):void {
			backbuffer.copyPixels(tiles[t], tiles_rect, new Point(x, y));
		}
		
		public function drawsprite(x:int, y:int, t:int):void {
			backbuffer.copyPixels(sprites[t], sprites_rect, new Point(x, y));
		}
		
		public function drawzoomtile(x:int, y:int, t:int):void {
			zoombuffer.copyPixels(tiles[t], tiles_rect, new Point(x, y), null, null, true);
		}
		
		public function drawzoomsprite(x:int, y:int, t:int):void {
			zoombuffer.copyPixels(sprites[t], sprites_rect, new Point(x, y), null, null, true);
		}
		
		
		public function drawmap(map:mapclass, game:gameclass):void {
			for (j = 0; j < 12; j++) {
			  for (i = 0; i < 20; i++) {
					temp = map.at(i + (game.camerax * 20), j + (game.cameray * 12));
					if (temp == 180) {
						//Mouse
						temp = (int(help.slowsine / 16) % 4);
						if(temp==0){
						  drawzoomtile((i * 16), (j * 16), 180);
						}else if(temp==1){
							drawzoomtile((i * 16), (j * 16), 200);
						}else if(temp==2){
							drawzoomtile((i * 16), (j * 16), 181);
						}else if(temp==3){
							drawzoomtile((i * 16), (j * 16), 201);
						}
					}else if (temp >= 40) {
						drawzoomtile((i * 16), (j * 16), 3);
				    drawzoomtile((i * 16), (j * 16), temp);
					}else {
						drawzoomtile((i * 16), (j * 16), temp);
					}
					
					if (game.housemouse > 0) {
						if (game.camerax == 2 && game.cameray == 2) {
							if (i == 10 && j == 7) {
						    drawzoomtile((i * 16)-8, (j * 16)-10, 184);
							}
						}
					}
					if (game.altarmouse > 0) {
						if (game.camerax == 3 && game.cameray == 0) {
							if (i == 14 && j == 6) {
						    drawzoomtile((i * 16)-8, (j * 16), 184);
							}
						}
					}
			  }
			}
		}
		
		public function drawentityinfo(map:mapclass, game:gameclass):void {
			for (j = 0; j < 12; j++) {
			  for (i = 0; i < 20; i++) {
					temp = map.at(i + (game.camerax * 20), j + (game.cameray * 12));
				  //Draw GUI on entities
					if (temp >= 48 && temp < 60) {
						temp2 = (i * 32) - (zoomx * 2);
						temp3 = (j * 32) - (zoomy * 2);
						fillrect(temp2+8, temp3-4, (game.enemy[temp - 47].health * 2) + 1, 7, 0, 0, 0);
						for (k = 0; k < game.enemy[temp - 47].health; k++){
						  fillrect(temp2 + (k * 2) + 1+8, temp3 + 1-4, 1, 5, 255, 64, 64);
						}
						print(temp2-5, temp3-4, "HP", 255, 255, 255);
						print(temp2-5, temp3+26, "Atk " + String(game.enemy[temp - 47].damage), 255, 255, 255);
					}
			  }
			}
		}
		
		//Text Functions
		
		public function adjustletter(t1:int, d:int=1):void {
			bfontlen[t1]+=d; bfontlen[t1+32]+=d;
		}
		
		public function adjustcharacter(t1:int, d:int=1):void {
			bfontlen[t1]+=d; 
		}
		
		public function makebfont():void {
			for (j = 0; j < 16; j++) {
				for (i = 0; i < 16; i++) {
					tbuffer = new BitmapData(fontwidth, fontheight, true, 0x000000);
					settrect(i * fontwidth, j * fontheight, fontwidth, fontheight);	
					tbuffer.copyPixels(buffer, trect, tl);
					bfont.push(tbuffer);
				}
			}
			
			//Ok, now we work out the lengths 
			if (currentfont == "small") {
				for (i = 0; i < 256; i++) bfontlen.push(6);
			  var maprow:Array;
			  var tstring:String="4,3,5,7,6,7,6,3,4,4,7,7,3,5,2,5,6,5,6,6,6,6,6,6,6,6,2,3,5,5,5,6,7,6,6,6,6,5,5,6,6,3,6,6,5,7,7,6,6,6,6,6,5,6,7,7,7,7,5,4,5,4,5,6,4,6,6,6,6,5,5,6,6,3,6,6,5,7,7,6,6,6,6,6,5,6,7,7,7,7,5,5,3,5,6,4";
					
			  maprow = new Array();
			  maprow = tstring.split(",");
			  for(var k:int = 0; k < 96; k++) {
  				bfontlen[k + 32] = int(maprow[k]);
	  		}
			}else if (currentfont == "tiny") {
				for (i = 0; i < 256; i++) bfontlen.push(4);
				adjustletter("I".charCodeAt(0), -2);
				adjustletter("M".charCodeAt(0), 2);
				adjustletter("N".charCodeAt(0));
				adjustletter("W".charCodeAt(0), 2);
				
				adjustcharacter(" ".charCodeAt(0), -1);
				adjustcharacter(".".charCodeAt(0), -1);
				adjustcharacter(",".charCodeAt(0), -1);
				adjustcharacter(";".charCodeAt(0), -1);
				adjustcharacter(":".charCodeAt(0), -1);
				adjustcharacter("'".charCodeAt(0), -2);
				adjustcharacter("&".charCodeAt(0));
				adjustcharacter("*".charCodeAt(0), 2);
				adjustcharacter("4".charCodeAt(0));
			}else if (currentfont == "flixel") {
				for (i = 0; i < 256; i++) bfontlen.push(6);
				
				adjustletter("I".charCodeAt(0), -3);
				adjustletter("J".charCodeAt(0), -1);
				adjustletter("K".charCodeAt(0));
				adjustletter("L".charCodeAt(0), -1);		
				adjustletter("M".charCodeAt(0), 2);
				adjustletter("N".charCodeAt(0));
				adjustletter("O".charCodeAt(0));
				adjustletter("Q".charCodeAt(0));
				adjustletter("S".charCodeAt(0), -1);
				adjustletter("T".charCodeAt(0));
				adjustletter("V".charCodeAt(0));
				adjustletter("W".charCodeAt(0), 2);
				adjustletter("X".charCodeAt(0));
				adjustletter("Y".charCodeAt(0));
				
				adjustcharacter("c".charCodeAt(0), -1);
				adjustcharacter("f".charCodeAt(0), -2);
				adjustcharacter("k".charCodeAt(0), -1);
				adjustcharacter("l".charCodeAt(0), -2);
				adjustcharacter("m".charCodeAt(0));
				adjustcharacter("n".charCodeAt(0), -1);
				adjustcharacter("o".charCodeAt(0), -1);
				adjustcharacter("q".charCodeAt(0), -1);
				adjustcharacter("r".charCodeAt(0), -1);
				adjustcharacter("t".charCodeAt(0), -3);
				adjustcharacter("v".charCodeAt(0), -1);
				adjustcharacter("x".charCodeAt(0), -1);
				adjustcharacter("y".charCodeAt(0), -1);
				
				adjustcharacter("'".charCodeAt(0), -4);
				adjustcharacter(".".charCodeAt(0), -2);
				adjustcharacter(",".charCodeAt(0), -2);
				adjustcharacter("&".charCodeAt(0));
				adjustcharacter(" ".charCodeAt(0), -1);
				
				adjustcharacter(":".charCodeAt(0), -2);
				adjustcharacter("(".charCodeAt(0), -2);
				adjustcharacter(")".charCodeAt(0), -2);
			}else if (currentfont == "04b11") {
				for (i = 0; i < 256; i++) bfontlen.push(7);
				
				adjustcharacter(" ".charCodeAt(0), -2);
				
				adjustcharacter("i".charCodeAt(0), -4);
				adjustcharacter("l".charCodeAt(0), -4);
				adjustcharacter("j".charCodeAt(0), -2);
				adjustcharacter("m".charCodeAt(0), 2);
				adjustcharacter("w".charCodeAt(0), 2);
				adjustcharacter(",".charCodeAt(0), -4);
				adjustcharacter(".".charCodeAt(0), -4);
				adjustcharacter("'".charCodeAt(0), -4);
				
				adjustcharacter("1".charCodeAt(0), -3);
				adjustcharacter("!".charCodeAt(0), -4);
				adjustcharacter("$".charCodeAt(0), 1);
				adjustcharacter("^".charCodeAt(0), -2);
				
				adjustcharacter("[".charCodeAt(0), -3);
				adjustcharacter("]".charCodeAt(0), -3);
				adjustcharacter("(".charCodeAt(0), -3);
				adjustcharacter(")".charCodeAt(0), -3);
				
				adjustcharacter("I".charCodeAt(0), -2);
				adjustcharacter("M".charCodeAt(0), 1);
				adjustcharacter("W".charCodeAt(0), 2);
			}else if (currentfont == "crypt") {
				for (i = 0; i < 256; i++) bfontlen.push(5);
			}else if (currentfont == "2xcrypt") {
				for (i = 0; i < 256; i++) bfontlen.push(10);
			}else if (currentfont == "starperv") {
				for (i = 0; i < 256; i++) bfontlen.push(6);
			}else if (currentfont == "casual") {
				for (i = 0; i < 256; i++) bfontlen.push(8);
				
				adjustcharacter("i".charCodeAt(0), -4);
				adjustcharacter("j".charCodeAt(0), -2);
				adjustcharacter("l".charCodeAt(0), -3);
				adjustcharacter("f".charCodeAt(0), -1);
				adjustcharacter("m".charCodeAt(0), 2);
				adjustcharacter("w".charCodeAt(0));
				
				adjustcharacter("'".charCodeAt(0), -4);
				adjustcharacter(".".charCodeAt(0), -2);
				adjustcharacter(",".charCodeAt(0), -2);
			}else{
				for (i = 0; i < 256; i++) bfontlen.push(8);
			}
		}
		
		public function rprint(x:int, y:int, t:String, r:int, g:int, b:int):void {
			x = x - len(t);
			print(x, y, t, r, g, b, false);
		}
		
		public function cprint(x:int, y:int, t:String, c:int, cen:Boolean = false):void {
			ct.color = c;
			if (cen) x = 160 - (len(t) / 2);
			bfontpos = 0;
			for (var i:int = 0; i < t.length; i++) {
				cur = t.charCodeAt(i);
				bfont[cur].colorTransform(bfont_rect, ct);
				backbuffer.copyPixels(bfont[cur], bfont_rect, new Point(x + bfontpos, y));
				bfontpos+=bfontlen[cur];
			}
		}
		
		public function print(x:int, y:int, t:String, r:int, g:int, b:int, cen:Boolean = false):void {
			if (r < 0) r = 0; if (g < 0) g = 0; if (b < 0) b = 0;
			if (r > 255) r = 255; if (g > 255) g = 255; if (b > 255) b = 255;
			ct.color = RGB(r, g, b);
			if (cen) x = 160 - (len(t) / 2);
			bfontpos = 0;
			for (var i:int = 0; i < t.length; i++) {
				cur = t.charCodeAt(i);
				bfont[cur].colorTransform(bfont_rect, ct);
				backbuffer.copyPixels(bfont[cur], bfont_rect, new Point(x + bfontpos, y));
				bfontpos+=bfontlen[cur];
			}
		}
		
		
		public function rbigprint(x:int, y:int, t:String, r:int, g:int, b:int, cen:Boolean = false, sc:Number = 2):void {
			x = x - (len(t) * sc);
			bigprint(x, y, t, r, g, b, cen, sc);
		}
		
		public function bigprint(x:int, y:int, t:String, r:int, g:int, b:int, cen:Boolean = false, sc:Number = 2):void {
			if (r < 0) r = 0; if (g < 0) g = 0; if (b < 0) b = 0;
			if (r > 255) r = 255; if (g > 255) g = 255; if (b > 255) b = 255;
			ct.color = RGB(r, g, b);
			
			scaleMatrix.scale(sc, sc);
			
			bigbuffer.fillRect(bigbuffer.rect, 0x000000);
			ct.color = RGB(r, g, b);
			if(sc==2){
			  if (cen) x = 160 - (len(t));
			}else if (sc == 3) {
				if (cen) x = 160 - ((len(t) / 2)*3);
			}else if (sc == 4) {
				if (cen) x = 160 - (len(t) * 2);
			}else {
				if (cen) x = 160 - ((len(t) / 2) * sc);
			}
			bfontpos = 0;
			for (i = 0; i < t.length; i++) {
				cur = t.charCodeAt(i);
				bfont[cur].colorTransform(bfont_rect, ct);
				bigbuffer.copyPixels(bfont[cur], bfont_rect, new Point(bfontpos, 0));
				bfontpos+=bfontlen[cur];
			}
				
			scaleMatrix.translate(x, y);
			backbuffer.draw(bigbufferscreen, scaleMatrix);
			scaleMatrix.identity();
		}
		
		public function drawzoombuffer():void {
			zoomscaleMatrix.translate(-zoomx, -zoomy);
			zoomscaleMatrix.scale(2, 2);
			backbuffer.draw(zoombufferscreen, zoomscaleMatrix);
		  zoomscaleMatrix.identity();
		}
		
		public function len(t:String):int {
			bfontpos = 0;
		  for (var i:int = 0; i < t.length; i++) {
				cur = t.charCodeAt(i);
			  bfontpos+=bfontlen[cur];
			}
			return bfontpos;
		}
		
		//Render functions
		
		public function flashlight():void {
			backbuffer.fillRect(backbuffer.rect, 0xFFFFFF);
		}
		
		public function screenshake():void {
			screenbuffer.lock();
			screenbuffer.copyPixels(backbuffer, backbuffer.rect, tl, null, null, false);
			screenbuffer.copyPixels(backbuffer, backbuffer.rect, new Point((Math.random() * 5) - 3, (Math.random() * 5) - 3), null, null, false);
			screenbuffer.unlock();
			
			backbuffer.lock();
			backbuffer.fillRect(backbuffer.rect, 0x000000);
			backbuffer.unlock();
		}
		
		public function normalrender():void {
			screenbuffer.lock();
			screenbuffer.copyPixels(backbuffer, backbuffer.rect, tl, null, null, false);
			screenbuffer.unlock();
			
			backbuffer.lock();
			backbuffer.fillRect(backbuffer.rect, 0x000000);
			backbuffer.unlock();
		}
		
		public function render(game:gameclass):void {
			if (game.test) print(5, 5, game.teststring, 255, 196, 196, false);
			
			if (game.flashlight > 0) { game.flashlight--; flashlight(); }
	    if (game.screenshake > 0) {	game.screenshake--;	screenshake();}else{
	      normalrender();
	    }
		}
		
		public var backgrounds:Array = new Array();
		public var images:Array = new Array();
		public var tiles:Array = new Array();
		public var sprites:Array = new Array();
		public var ct:ColorTransform;
	  public var tiles_rect:Rectangle;
	  public var sprites_rect:Rectangle;
	  public var bfont_rect:Rectangle;
	  public var bfontmask_rect:Rectangle;
		public var images_rect:Rectangle;
	  public var tl:Point; //The point at (0,0)
		public var trect:Rectangle, tpoint:Point, tbuffer:BitmapData;
		public var i:int, j:int, k:int, l:int, z:int;
		
		public var currentfont:String, fontheight:int, fontwidth:int;
		public var bfont:Array = new Array();
		public var bfontlen:Array = new Array();
		public var bfontpos:int;
		public var cur:int;
		
		public var temp:int;
		public var temp2:int;
		public var temp3:int;
		public var alphamult:uint;
		public var stemp:String;
		public var buffer:BitmapData;
		
		public var temptile:BitmapData;
		//Actual backgrounds
		public var backbuffer:BitmapData;
		public var screenbuffer:BitmapData;
		public var screen:Bitmap;
		public var updatebackground:Boolean;
		//Textbox Stuff
		public var ntextbox:int;
		public var textbox:Array = new Array;
		//Sprite Scaling Stuff
		public var bigbuffer:BitmapData;
		public var bigbufferscreen:Bitmap;
		public var scaleMatrix:Matrix = new Matrix();
		//Sprite Scaling Stuff
		public var zoombuffer:BitmapData;
		public var zoombufferscreen:Bitmap;
		public var zoomscaleMatrix:Matrix = new Matrix();
		public var zoomx:int=0, zoomy:int=0;
		//Tempshape
		public var tempshape:Shape = new Shape();
		public var shapematrix:Matrix = new Matrix();
		public var textcol:Array = new Array();
	}
}
package {
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	
	public class entityclass{
		static public var BLOCK:Number = 0;
    static public var TRIGGER:Number = 1;
		static public var DAMAGE:Number = 2;
		
		public function init():void {
			nentity = 0;
			nblocks = 0;
			temprect = new Rectangle();
			temprect2 = new Rectangle();
			colpoint1 = new Point; colpoint2 = new Point;
			
			for (var z:Number = 0; z < 200; z++) {
				var entity:entclass = new entclass;
  			entities.push(entity);
				
				var block:blockclass = new blockclass;
  			blocks.push(block);
			}
		}
		
		public function createblock(t:int, xp:int=0, yp:int=0, w:int=0, h:int=0, trig:int=0):void{
			if(nblocks == 0) {
				//If there are no active blocks, Z=0;
				z = 0; 
			}else {
				i = 0; z = -1;
				while (i < nblocks) {
					if (!blocks[i].active) {
						z = i; i = nblocks;
					}
					i++;
				}
				if (z == -1) {
					z = nblocks;
					nblocks++;
				}
			}

			blocks[z].clear();
			blocks[z].active = true;
			switch(t) {
				case BLOCK: //Block
					 blocks[z].type = BLOCK;
					 blocks[z].xp = xp;
					 blocks[z].yp = yp;
					 blocks[z].wp = w;
					 blocks[z].hp = h;
					 blocks[z].rectset(xp, yp, w, h);

					 nblocks++;
				break;
				case TRIGGER: //Trigger
					 blocks[z].type = TRIGGER;
					 blocks[z].x = xp;
					 blocks[z].y = yp;
					 blocks[z].w = w;
					 blocks[z].h = h;
					 blocks[z].rectset(xp, yp, w, h);
					 blocks[z].trigger = trig;

					 nblocks++;
				break;
				case DAMAGE: //Damage
					 blocks[z].type = DAMAGE;
					 blocks[z].x = xp;
					 blocks[z].y = yp;
					 blocks[z].w = w;
					 blocks[z].h = h;
					 blocks[z].rectset(xp, yp, w, h);

					 nblocks++;
				break;
			}
		}

		public function removeallblocks():void{
			for(i=0; i<nblocks; i++) blocks[i].clear();
			nblocks=0;
		}

		public function removeblock(t:int):void{
			blocks[t].clear();
			i = nblocks-1; while(i>=0 && !blocks[i].active) { nblocks--; i--; }
		}

		public function removeblockat(x:int, y:int):void{
			for(i=0; i<nblocks; i++){
				if(blocks[i].x == x && blocks[i].y == y) removeblock(i);
			}
		}

		public function removetrigger(t:int):void{
			for(i=0; i<nblocks; i++){
				if(blocks[i].type == TRIGGER) {
					if(blocks[i].trigger == t) {
						removeblock(i);
					}
				}
			}
		}
		
		public function createentity(xp:Number, yp:Number, t:int, vx:Number = 0, vy:Number = 0, para:int = 0):void {
			//Find the first inactive case z that we can use to index the new entity
			if (nentity == 0) {
				//If there are no active entities, Z=0;
				z = 0; nentity++;
			}else {
				i = 0; z = -1;
				while (i < nentity) {
				  if (!entities[i].active) {
						z = i; i = nentity;
					}
					i++;
			  }
				if (z == -1) {
					z = nentity;
					nentity++;
				}
			}
			
			entities[z].clear();
			entities[z].active = true;
			entities[z].type = t;
			switch(t) {
				case 0: //Player
				  entities[z].rule = 0;
				  entities[z].tile = 0;
					entities[z].xp = xp;
					entities[z].yp = yp;
					
          entities[z].gravity = true;
				break;
			}
		}
		
		public function updateentitylogic(t:int, game:gameclass):void {
			entities[t].oldxp = entities[t].xp; entities[t].oldyp = entities[t].yp;
			
			entities[t].vx = entities[t].vx + entities[t].ax;
			entities[t].vy = entities[t].vy + entities[t].ay;
			entities[t].ax = 0;
			
			if (entities[t].jumping) {
				if (entities[t].ay < 0) entities[t].ay++;
				if (entities[t].ay > -1) entities[t].ay = 0;
				entities[t].jumpframe--;
				if(entities[t].jumpframe<=0){
					entities[t].jumping=false;
				}
			}else {
			  if (entities[t].gravity) entities[t].ay = 3;
			}
			
			if (entities[t].gravity) applyfriction(t, 0, 0.5);
			
			entities[t].newxp = entities[t].xp + entities[t].vx;
			entities[t].newyp = entities[t].yp + entities[t].vy;
		}
		
		public function entitymapcollision(t:int, map:mapclass):void {
			if (testwallsx(map, t, entities[t].newxp, entities[t].yp)) {
				entities[t].xp = entities[t].newxp;
			}else {
				if (entities[t].onwall > 0) entities[t].state = entities[t].onwall;
				if (entities[t].onxwall > 0) entities[t].state = entities[t].onxwall;
			}
			if (testwallsy(map, t, entities[t].xp, entities[t].newyp)) {
				entities[t].yp = entities[t].newyp;
			}else {
				if (entities[t].onwall > 0) entities[t].state = entities[t].onwall;
				if (entities[t].onywall > 0) entities[t].state = entities[t].onywall;
				entities[t].jumpframe = 0;
			}
		}
		
		public function entitycollisioncheck(gfx:graphicsclass, game:gameclass, map:mapclass, music:musicclass):void {
			for (i = 0; i < nentity; i++) {
				if (entities[i].active) {
					//We test entity to entity
					for (j = 0; j < nentity; j++) {
						if (entities[j].active && i!=j){ //Active
							//Entity collision rules go here; depends on game code!							
						}
					}
				}
			}
			
			//can't have the player being stuck...
			j = getplayer();
			if (j > -1) {
				if (!testwallsx(map, j, entities[j].xp, entities[j].yp)) {
					//Let's try to get out...
					entities[j].yp -= 3;
				}
			}
			
			
			activetrigger = -1;
			if (checktrigger() > -1) {
				game.state = activetrigger;
				game.statedelay = 0;
			}
		}
		
		public function updateentities(i:int, game:gameclass, music:musicclass):Boolean {
			if(entities[i].active){
				if(entities[i].statedelay<=0){
					switch(entities[i].type) {
						case 0:  //Player
						  if (entities[i].state == 0) {
							}
						break;
					}
				}else {
					entities[i].statedelay--;
					if (entities[i].statedelay < 0) entities[i].statedelay = 0;
				}
			}
			
			return true;
		}
		
		public function animateentities(game:gameclass, i:int):void {
			if(entities[i].active){
				if(entities[i].statedelay<=0){
					switch(entities[i].type) {
						default:
							entities[i].drawframe = entities[i].tile;
						break;
					}
				}else {
					entities[i].statedelay--;
					if (entities[i].statedelay < 0) entities[i].statedelay = 0;
				}
			}
		}
		
		public function gettype(t:int):Boolean {
		  //Returns true is there is an entity of type t onscreen
			for (var i:int = 0; i < nentity; i++) {
				if(entities[i].type==t){
			    return true;
				}
			}
			
			return false;
		}		
		
		public function getplayer():int {
		  //Returns the index of the first player entity
			for (var i:int = 0; i < nentity; i++) {
				if(entities[i].type==0){
			    return i;
				}
			}
			
			return -1;
		}
		
		public function rectset(xi:int, yi:int, wi:int, hi:int):void {
			temprect.x = xi; temprect.y = yi; temprect.width = wi; temprect.height = hi;
		}
		
    public function rect2set(xi:int, yi:int, wi:int, hi:int):void {
			temprect2.x = xi; temprect2.y = yi; temprect2.width = wi; temprect2.height = hi;
		}
		
		public function entitycollide(a:int, b:int):Boolean {
			//Do entities a and b collide?
			tempx = entities[a].xp + entities[a].cx; tempy = entities[a].yp + entities[a].cy;
			tempw = entities[a].w; temph = entities[a].h;
			rectset(tempx, tempy, tempw, temph);
			
			tempx = entities[b].xp + entities[b].cx; tempy = entities[b].yp + entities[b].cy;
			tempw = entities[b].w; temph = entities[b].h;
			rect2set(tempx, tempy, tempw, temph);
			if (temprect.intersects(temprect2)) return true;
			return false;
		}
		
		public function checkdamage():Boolean{
			//Returns true if player entity (rule 0) collides with a damagepoint
			for(i = 0; i < nentity; i++) {
				if(entities[i].rule==0){
					tempx = entities[i].xp + entities[i].cx; tempy = entities[i].yp + entities[i].cy;
					tempw = entities[i].w; temph = entities[i].h;
					rectset(tempx, tempy, tempw, temph);

					for (j=0; j<nblocks; j++){
						if (blocks[j].type == DAMAGE && blocks[j].active){
							if(blocks[j].rect.intersects(temprect)) {
								return true;
							}
						}
					}
				}
			}
			return false;
		}
		
		public function checktrigger():int{
			//Returns an int player entity (rule 0) collides with a trigger
			for(i = 0; i < nentity; i++) {
				if(entities[i].rule==0){
					tempx = entities[i].xp + entities[i].cx; tempy = entities[i].yp + entities[i].cy;
					tempw = entities[i].w; temph = entities[i].h;
					rectset(tempx, tempy, tempw, temph);

					for (j=0; j<nblocks; j++){
						if (blocks[j].type == TRIGGER && blocks[j].active){
							if (blocks[j].rect.intersects(temprect)) {
								activetrigger = blocks[j].trigger;
								return blocks[j].trigger;
							}
						}
					}
				}
			}
			return -1;
		}
		
		public function checkblocks():Boolean {
			for (i = 0; i < nblocks; i++) {
				if (blocks[i].active) {
					if (blocks[i].type == BLOCK){
						if (blocks[i].rect.intersects(temprect)) {
							return true;
						}
					}
				}
			}
			return false;
		}
		
		public function getgridpoint(t:int):int {
			t = (t - (t % 16)) / 16;
			return t;
		}
		
		public function checkwall(map:mapclass):Boolean{
			//Returns true if entity setup in temprect collides with a wall
			//used for proper collision functions; you can't just, like, call it
			//whenever you feel like it and expect a response
			//
			//that won't work at all
			if (checkblocks()) return true;
			
			tempx = getgridpoint(temprect.x); tempy = getgridpoint(temprect.y);
			tempw = getgridpoint(temprect.x + temprect.width - 1); temph = getgridpoint(temprect.y + temprect.height - 1);
			if (map.collide(tempx, tempy)) return true;
			if (map.collide(tempw, tempy)) return true;
			if (map.collide(tempx, temph)) return true;
			if (map.collide(tempw, temph)) return true;
			if (temprect.height >= 12) {
				tpy1 = getgridpoint(temprect.y + 6);
				if (map.collide(tempx, tpy1)) return true;
			  if (map.collide(tempw, tpy1)) return true;
				if (temprect.height >= 18) {
					tpy1 = getgridpoint(temprect.y + 12);
					if (map.collide(tempx, tpy1)) return true;
					if (map.collide(tempw, tpy1)) return true;
					if (temprect.height >= 24) {
						tpy1 = getgridpoint(temprect.y + 18);
						if (map.collide(tempx, tpy1)) return true;
						if (map.collide(tempw, tpy1)) return true;
					}
				}
			}
			if (temprect.width >= 12) {
				tpx1 = getgridpoint(temprect.x + 6);
			if (map.collide(tpx1, tempy)) return true;
			if (map.collide(tpx1, temph)) return true;
			}
			return false;
		}
		
		public function entitycollidefloor(map:mapclass, t:int):Boolean{
			//see? like here, for example!
			tempx = entities[t].xp + entities[t].cx; tempy = entities[t].yp + entities[t].cy + 1;
			tempw = entities[t].w; temph = entities[t].h;
			rectset(tempx, tempy, tempw, temph);
			
			if (checkwall(map)) return true;
			return false;
		}
		
		public function testwallsx(map:mapclass, t:int, tx:int, ty:int):Boolean{
			tempx = tx + entities[t].cx; tempy = ty + entities[t].cy;
			tempw = entities[t].w; temph = entities[t].h;
			rectset(tempx, tempy, tempw, temph);
			
			//Ok, now we check walls
			if (checkwall(map)) {
				if (entities[t].vx > 1) {
					entities[t].vx--;
					entities[t].newxp = int(entities[t].xp + entities[t].vx);
					return testwallsx(map, t, entities[t].newxp, entities[t].yp);
				}else if (entities[t].vx < -1) {
					entities[t].vx++;
					entities[t].newxp = int(entities[t].xp + entities[t].vx);
					return testwallsx(map, t, entities[t].newxp, entities[t].yp);
				}else {
					entities[t].vx=0;
					return false;
				}
			}
			return true;
		}
		
		public function testwallsy(map:mapclass, t:int, tx:int, ty:int):Boolean {
			tempx = tx + entities[t].cx; tempy = ty + entities[t].cy;
			tempw = entities[t].w; temph = entities[t].h;
			rectset(tempx, tempy, tempw, temph);
			
			//Ok, now we check walls
			if (checkwall(map)) {
				if (entities[t].vy > 1) {
					entities[t].vy--;
					entities[t].newyp = int(entities[t].yp + entities[t].vy);
					return testwallsy(map, t, entities[t].xp, entities[t].newyp);
				}else if (entities[t].vy < -1) {
					entities[t].vy++;
					entities[t].newyp = int(entities[t].yp + entities[t].vy);
					return testwallsy(map, t, entities[t].xp, entities[t].newyp);
				}else {
					entities[t].vy=0;
					return false;
				}
			}
			return true;
		}
		
		public function applyfriction(t:int, xrate:Number, yrate:Number):void{
			if (entities[t].vx > 0) entities[t].vx -= xrate;
			if (entities[t].vx < 0) entities[t].vx += xrate;
			if (entities[t].vy > 0) entities[t].vy -= yrate;
			if (entities[t].vy < 0) entities[t].vy += yrate;
			if (entities[t].vy > 4) entities[t].vy = 4;
			if (entities[t].vy < -4) entities[t].vy = -4;
			if (entities[t].vx > 4) entities[t].vx = 4;
			if (entities[t].vx < -4) entities[t].vx = -4;
			
			if (Math.abs(entities[t].vx) <= xrate) entities[t].vx = 0;
			if (Math.abs(entities[t].vy) <= yrate) entities[t].vy = 0;
		}
		
		public function cleanup():void {
			i = nentity - 1; while (i >= 0 && !entities[i].active) { nentity--; i--; }
		}
			
		public var nentity:int;
		public var entities:Array = new Array();
		public var tempx:int, tempy:int, tempw:int, temph:int, temp:int, temp2:int;
		public var tpx1:int, tpy1:int, tpx2:int, tpy2:int;
		public var colpoint1:Point, colpoint2:Point;
		public var temprect:Rectangle, temprect2:Rectangle;
		public var i:int, j:int, k:int, z:int;
		public var activetrigger:int;
		
    public var blocks:Array = new Array();
    public var nblocks:int;
	}
}
package {
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	
	public class playerclass  {
		public function playerclass():void {
			clear();
    }
		
		public function clear():void{
			xp = 0; yp = 0; dir = 0; type = 2; damage = 1; 
			defaulthp = 3; health = 3;
			level = 1;
    }
		
		public function init(hp:int, dmg:int):void{
			health = hp; damage = dmg;
			defaulthp = hp;
    }
		
		public function restorehealth():void {
			health = defaulthp;
		}
		
		public function levelup():void {
			level++;
			if (level > 10) level = 10;
		}
		
		//Fundamentals
		public var xp:int, yp:int, dir:int, type:int, health:int, damage:int;
		public var level:int;
		public var defaulthp:int;
	}
};

package {
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	
	public class blockclass  {
		public function blockclass():void {
			clear();
    }
		
		public function clear():void{
			active = false;
			type = 0; trigger=0;

			xp = 0; yp = 0; wp = 0; hp = 0;
			rect = new Rectangle();
			rect.x = xp; rect.y = yp; rect.width = wp; rect.height = hp;
    }
		
		public function rectset(xi:int, yi:int, wi:int, hi:int):void {
			rect.x = xi; rect.y = yi; rect.width = wi; rect.height = hi;
		}
		
		//Fundamentals
		public var active:Boolean;
		public var rect:Rectangle;
		public var type:int;
		public var trigger:int;
		public var xp:int, yp:int, wp:int, hp:int;
	}
};

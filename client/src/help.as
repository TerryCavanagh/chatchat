package {
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	
	public class help {
		public static function init():void {
			sine = new Array();
			cosine = new Array();
				
			for(var i:int=0; i<64; i++){
				sine[i]=Math.sin((i*6.283)/64);
				cosine[i]=Math.cos((i*6.283)/64);
			}
			
			glow = 0;
			glowdir = 0;
			slowsine = 0;
		}
		
		public static function Left(s:String,length:int=1):String{
		  return s.substr(0,length);
		}
		
		public static function lastchars(s:String):String{
		  return s.substr(1,s.length-1);
		} 
		
		public static function mechars(s:String):String{
		  return s.substr(4,s.length-4);
		} 
		
		public static function Right(s:String,length:int=1):String{
		  return s.substr(s.length-length,length);
		} 
		
		public static function opa(t:int):int {
			return (t + 32) % 64;
		}
		
		public static function number(t:int):String {
			switch(t) {
			  case 0: return "Zero"; break;
				case 1: return "One"; break;
				case 2: return "Two"; break;
				case 3: return "Three"; break;
				case 4: return "Four"; break;
				case 5: return "Five"; break;
				case 6: return "Six"; break;
				case 7: return "Seven"; break;
				case 8: return "Eight"; break;
				case 9: return "Nine"; break;
				case 10: return "Ten"; break;
				case 11: return "Eleven"; break;
				case 12: return "Twelve"; break;
				case 13: return "Thirteen"; break;
				case 14: return "Fourteen"; break;
				case 15: return "Fifteen"; break;
				case 16: return "Sixteen"; break;
				case 17: return "Seventeen"; break;
				case 18: return "Eighteen"; break;
				case 19: return "Nineteen"; break;
				case 20: return "Twenty"; break;
				case 21: return "Twenty One"; break;
			}
			return "Some";
		}
		
		public static function removeObject(obj:Object, arr:Array):void{
			var i:String;
			for (i in arr){
				if (arr[i] == obj){
					arr.splice(i,1)
					break;
				}
			}
		}
		
		public static function updateglow():void {
			slowsine++;
			if (slowsine >= 64) slowsine = 0;
			
		  if (glowdir == 0) {
			  glow+=2; 
				if (glow >= 62) glowdir = 1;
			}else {
			  glow-=2;
				if (glow < 2) glowdir = 0;
			}
		}
		
		public static function inbox(xc:int, yc:int, x1:int, y1:int, x2:int, y2:int):Boolean {
			if (xc >= x1 && xc <= x2) {
				if (yc >= y1 && yc <= y2) {
					return true;
				}
			}
			return false;
		}
		
		public static function inboxw(xc:int, yc:int, x1:int, y1:int, x2:int, y2:int):Boolean {
			if (xc >= x1 && xc <= x1+x2) {
				if (yc >= y1 && yc <= y1+y2) {
					return true;
				}
			}
			return false;
		}
		
		public static function threedigits(t:int):String {
			if (t < 10) return "00" + String(t);
			if (t < 100) return "0" + String(t);
			return String(t);
		}
		
		public static function thousand(t:int):String {
			if (t < 1000) {
			  return "$"+String(t);	
			}else if (t < 1000000) {
				return "$"+String((t - (t % 1000)) / 1000) + "," + threedigits(t % 1000);
			}else {
				var temp:int;
				temp = (t - (t % 1000)) / 1000;
				return "$" + String((temp - (temp % 1000)) / 1000) + "," 
				           + threedigits(temp % 1000) + "," + threedigits(t % 1000);
			}
		}
		
	  public static var sine:Array;
	  public static var cosine:Array;
		public static var glow:int, slowsine:int;
		public static var glowdir:int;
		public static var globaltemp:int, globaltemp2:int, globaltemp3:int;
	}
}

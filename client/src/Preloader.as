package {	
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	import flash.utils.getDefinitionByName;
	import flash.system.fscommand;
  import flash.ui.ContextMenu;
  import flash.ui.ContextMenuItem;
	
	//Mochi and Kongregate stuff is more or less ready here
	public dynamic class Preloader extends MovieClip {
		public function Preloader() {
			//Set game parameters here:
			//----------------
			// RULES :
			//----------------
			onkong = true;                           // Initilise the Kongregate API
			adson = false;                            // Initilise the MochiGames API
			//----------------
			// GRAPHICS :
			//----------------
			screenwidth = 320; screenheight = 240;    // Size of the screen for preloader (some adjustments need to be made elsewhere)
			stagewidth = 640; stageheight = 480;      // Size of the screen for stage
			backcol = RGB(0, 0, 0);
			frontcol = RGB(255, 255, 255);
			loadercol = RGB(255, 255, 255); 
			//----------------
			
			if (adson) if (checksite()) { adson = false; } else { adson = true; }
			if(onkong) kongapi.init(loaderInfo.parameters, stage);
			
			help.init(); //Make sure help class is ready
			
			if(adson) {
			  //paste mochi ad stuff here
			}			
			
		  var rc_menu:ContextMenu = new ContextMenu();
			rc_menu.hideBuiltInItems();
      this.contextMenu = rc_menu;
			
			ct = new ColorTransform(0, 0, 0, 1, 255, 255, 255, 1); //Set to white			
			temprect = new Rectangle();
			
			tl = new Point(0, 0); tpoint = new Point(0, 0);
			bfont_rect=new Rectangle(0,0,8,8);
			var tempbmp:Bitmap;
			tempbmp = new im_bfont();	 buffer = tempbmp.bitmapData;
			makebfont();
			
			backbuffer=new BitmapData(screenwidth, screenheight, false, 0x000000);
		  screenbuffer = new BitmapData(screenwidth, screenheight, false, 0x000000);
		  screen = new Bitmap(screenbuffer);
			screen.width = stagewidth;
      screen.height = stageheight;
			
			addChild(screen);  
			
			addEventListener(Event.ENTER_FRAME, checkFrame);
			
			startgame = false;
		}
		
    public function visit_distractionware(e:Event):void{
      var distractionware_link:URLRequest = new URLRequest( "http://www.distractionware.com" );
      navigateToURL( distractionware_link, "_blank" );
    }
		
		public function visit_sponsor(e:Event):void{
      var sponsor_link:URLRequest = new URLRequest( "http://www.kongregate.com/?gamereferral=dontlookback" );
      navigateToURL( sponsor_link, "_blank" );
    }
		
		
		public function rprint(x:int, y:int, t:String, r:int, g:int, b:int, cen:Boolean = false):void {
			print(x - (len(t)), y, t, r, g, b, false);
		}		
		
		public function rprintcol(x:int, y:int, t:String, col:int, cen:Boolean = false):void {
			printcol(x - (len(t)), y, t, col, false);
		}
		
		public function printcol(x:int, y:int, t:String, col:int, cen:Boolean = false):void {
			ct.color = col;
			if (cen) x = (screenwidth - len(t)) / 2;
			bfontpos = 0;
			for (var i:int = 0; i < t.length; i++) {
				cur = t.charCodeAt(i);
				tpoint.x = x + bfontpos; tpoint.y = y;
			  bfont[cur].colorTransform(bfont_rect, ct);
				backbuffer.copyPixels(bfont[cur], bfont_rect, tpoint);
				bfontpos+=bfontlen[cur];
			}
		}
		
		public function print(x:int, y:int, t:String, r:int, g:int, b:int, cen:Boolean = false):void {
			if (r < 0) r = 0; if (g < 0) g = 0; if (b < 0) b = 0;
			if (r > 255) r = 255; if (g > 255) g = 255; if (b > 255) b = 255;
			ct.color = RGB(r, g, b);
			if (cen) x = (screenwidth - len(t)) / 2;
			bfontpos = 0;
			for (var i:int = 0; i < t.length; i++) {
				cur = t.charCodeAt(i);
				tpoint.x = x + bfontpos; tpoint.y = y;
			  bfont[cur].colorTransform(bfont_rect, ct);
				backbuffer.copyPixels(bfont[cur], bfont_rect, tpoint);
				bfontpos+=bfontlen[cur];
			}
		}
		
		public function checkFrame(e:Event):void {
			var p:Number = this.loaderInfo.bytesLoaded / this.loaderInfo.bytesTotal;	
			if (p >= 1) startgame = true;
			
			backbuffer.fillRect(backbuffer.rect, backcol);
			
			temp = int(p*(screenwidth - 114));
			fillrect(55, (screenheight / 2) - 13, screenwidth - 110, 12, frontcol);
			fillrect(57, (screenheight / 2) - 11, screenwidth - 114, 8, backcol);
			fillrect(57, (screenheight / 2) - 11, temp, 8, loadercol);
			
			tempstring = "LOADING...";
			printcol(70, (screenheight/2)+7, tempstring, frontcol, false);
			
			tempstring = String(int(p * 100)) + "%";
			rprintcol(screenwidth - 70, (screenheight/2)+7, tempstring, frontcol, false);
			
			//Render
			screenbuffer.lock();
			screenbuffer.copyPixels(backbuffer, backbuffer.rect, tl, null, null, false);
			screenbuffer.unlock();
			
			backbuffer.lock();
			backbuffer.fillRect(backbuffer.rect, 0x000000);
			backbuffer.unlock();
			
			if (currentFrame >= totalFrames) if (startgame) startup();
		}
		
		private function startup():void {
			removeChild(screen);
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
		public function checksite():Boolean {
			//Returns true if on a site that doesn't use mochiads
			var currUrl:String = stage.loaderInfo.url.toLowerCase();
			if ((currUrl.indexOf("distractionware.com") <= 0) && 
			    (currUrl.indexOf("flashgamelicense.com") <= 0) &&
					(currUrl.indexOf("kongregate.com") <= 0) && 
					(currUrl.indexOf("chat.kongregate.com") <= 0)){
				return false;
			}else{
				return true;
			}
		}
		
		public function len(t:String):int {
			bfontpos = 0;
		  for (var i:int = 0; i < t.length; i++) {
				cur = t.charCodeAt(i);
			  bfontpos+=bfontlen[cur];
			}
			return bfontpos;
		}
		
		public function fillrect(x:int, y:int, w:int, h:int, col:int):void {
			temprect.x = x; temprect.y = y; temprect.width = w; temprect.height = h;
			backbuffer.fillRect(temprect, col);
		}
		
		public function RGB(red:Number,green:Number,blue:Number):Number{
			return (blue | (green << 8) | (red << 16))
		}
		
		public function makebfont():void {
			for (var j:Number = 0; j < 16; j++) {
				for (var i:Number = 0; i < 16; i++) {
					var t:BitmapData = new BitmapData(8, 8, true, 0x000000);
					var t2emprect:Rectangle = new Rectangle(i * 8, j * 8, 8, 8);	
					t.copyPixels(buffer, t2emprect, tl);					
					bfont.push(t);
				}
			}
			
			//Ok, now we work out the lengths (this data string cortesy of a program I wrote!)
			for (i = 0; i < 256; i++) bfontlen.push(6);
			
			for(var k:int = 0; k < 96; k++) {
				bfontlen[k + 32] = 8;
			}	
		}
		
		public var screenwidth:int, screenheight:int, stagewidth:int, stageheight:int;
		public var backcol:int, frontcol:int, loadercol:int;
		
		public var buffer:BitmapData;
		public var backbuffer:BitmapData;
		public var screenbuffer:BitmapData;
		public var screen:Bitmap;
		
		public var temprect:Rectangle;
		
		public var startgame:Boolean;
		
		public var onkong:Boolean;
		public var adson:Boolean;
		
		public var bfontlen:Array = new Array();
		public var bfont:Array = new Array();
	  public var bfont_rect:Rectangle;
		public var tl:Point, tpoint:Point;		
		public var bfontpos:int;
		public var cur:int;
		public var ct:ColorTransform;
		
		public var tempstring:String;
		public var temp:int;
		
		[Embed(source = '../data/graphics/font/c64/font.png')]	private var im_bfont:Class;
	}
}
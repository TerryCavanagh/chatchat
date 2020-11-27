package{
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	import flash.media.*;
  import flash.ui.ContextMenu;
  import flash.ui.ContextMenuItem;
	import flash.ui.Keyboard;
	import bigroom.input.KeyPoll;
	import flash.utils.getTimer;
	import flash.utils.Timer;

	public class Main extends Sprite{
		static public var BLOCK:Number = 0;
    static public var TRIGGER:Number = 1;
		static public var DAMAGE:Number = 2;
		
		public var GAMEMODE:int = 0;
		public var CONNECTMODE:int = 1;
		public var TITLEMODE:int = 2;
		public var CLICKTOSTART:int = 3;
		public var LOGINMODE:int = 4;
		public var LOBBYMODE:int = 5;
		
  	include "includes/logic.as";
  	include "includes/input.as";
  	include "includes/render.as";
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, gameinit);
		}
		
		private function gameinit(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, gameinit);
			// entry point
			var tempbmp:Bitmap;
			
			//Ok: quick security check to make sure it doesn't get posted about
			if (sitelock()) {
				var rc_menu:ContextMenu = new ContextMenu();
			  var credit:ContextMenuItem = new ContextMenuItem( "Visit distractionware.com");
        //var credit2:ContextMenuItem = new ContextMenuItem( "Visit kongregate.com" );
        credit.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, visit_distractionware );
        //credit2.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, visit_sponsor );
        //credit2.separatorBefore = false;
			  rc_menu.hideBuiltInItems();
			  rc_menu.customItems.push(credit);
			  //rc_menu.customItems.push(credit2);
        this.contextMenu = rc_menu;
				
				obj.init();
				
				//Input
				key = new KeyPoll(stage);
				SoundMixer.soundTransform = new SoundTransform(1);	
				music.currentsong = -1; music.musicfade = 0;//no music, no amb
				music.initefchannels(); music.currentefchan = 0;
				
				music.numplays = 0;
		    music.musicchan.push(new music_0());
				//music.play(0);
				
				music.efchan.push(new ef_0());   
				music.efchan.push(new ef_1());   
				music.efchan.push(new ef_2());   
				music.efchan.push(new ef_3());   
				music.efchan.push(new ef_4());   
				music.efchan.push(new ef_5());   
				music.efchan.push(new ef_6());   
				music.efchan.push(new ef_7());   
				music.efchan.push(new ef_8());   
				music.efchan.push(new ef_9());   
				music.efchan.push(new ef_10());   
				music.efchan.push(new ef_11());   
				music.efchan.push(new ef_12());   
				music.efchan.push(new ef_13());   
				music.efchan.push(new ef_14());   
				music.efchan.push(new ef_15());   
				music.efchan.push(new ef_16());  
				music.efchan.push(new ef_17());   
				music.efchan.push(new ef_18());   
				music.efchan.push(new ef_19());   
				music.efchan.push(new ef_20());   
				music.efchan.push(new ef_21());   
				music.efchan.push(new ef_22());   
				music.efchan.push(new ef_23());   
				music.efchan.push(new ef_24());    
				music.efchan.push(new ef_25());    
				music.efchan.push(new ef_26());    
				
				game = new gameclass(obj, music);
				game.swfstage = stage;
				game.enabletextfield();
				
			  //General game variables
			  //game.gamestate = CLICKTOSTART;
				//game.gamestate = TITLEMODE;
				game.inputField.text = "Kitty" + String(int(Math.random() * 9)) + String(int(Math.random() * 9));
				game.gamestate = LOGINMODE;		
				
			  game.gamestate = CLICKTOSTART;
				map.loadlevel(0, obj);
				//game.start(obj, music);
				
				/*
				game.offlinemode = true;
				game.gamestate = GAMEMODE;
				game.textfield = ""; game.inputField.text = "";
				*/
				
				/*
					Graphics Init
				*/
				//First we init the class and add its display list to the main display list
				gfx.init();
				//We load all our graphics in:
				tempbmp = new im_tiles();	gfx.buffer = tempbmp.bitmapData;	gfx.maketilearray();
				tempbmp = new im_sprites();	gfx.buffer = tempbmp.bitmapData;	gfx.makespritearray();
				tempbmp = new im_bfont();	gfx.buffer = tempbmp.bitmapData;	gfx.makebfont();
				//Load in the images
				tempbmp = new im_image0();	gfx.buffer = tempbmp.bitmapData;	gfx.addimage(); // 0
				
				//Now that the graphics are loaded, init the background buffer
				gfx.buffer=new BitmapData(320,300,false,0x000000);
				
				addChild(gfx);
				// start the tick-timer, which updates roughly every 4 milliseconds
			  _timer.addEventListener(TimerEvent.TIMER, mainloop);
			  _timer.start();
			}else {
				gfx.init();
				addChild(gfx);
				//We load the font in:
				tempbmp = new im_bfont();	gfx.buffer = tempbmp.bitmapData;	gfx.makebfont();
				//Now that the graphics are loaded, init the background buffer
				gfx.buffer = new BitmapData(320, 300, false, 0x000000);
				
				addEventListener(Event.ENTER_FRAME, lockedloop);
			}
		}
		
		public function visit_distractionware(e:Event):void{
      var distractionware_link:URLRequest = new URLRequest( "http://www.distractionware.com" );
      navigateToURL( distractionware_link, "_blank" );
    }
		
		public function visit_sponsor(e:Event):void{
      var sponsor_link:URLRequest = new URLRequest( "http://www.kongregate.com/?gamereferral=dontlookback" );
      navigateToURL( sponsor_link, "_blank" );
    }
		
		public function visit_sponsor_logo():void{
      var sponsor_link:URLRequest = new URLRequest( "http://www.kongregate.com/?gamereferral=dontlookback" );
      navigateToURL( sponsor_link, "_blank" );
    }
		
		public function lockedloop(e:Event):void {
		  gfx.backbuffer.lock();
			
  		gfx.print(5, 150, "Sorry! This game can only by played on", 196-help.glow, 196-help.glow, 255-help.glow, true);
			gfx.print(5, 160, "www.distractionware.com", 196-help.glow, 196-help.glow, 255-help.glow, true);
			gfx.normalrender();
	    gfx.backbuffer.unlock();
			
			help.updateglow();
		}
		
		public function sitelock():Boolean {
			//No preloader for Kong version
			var currUrl:String = stage.loaderInfo.url.toLowerCase();
			//chat.kongregate.com
			if ((currUrl.indexOf("distractionware.com") <= 0) && (currUrl.indexOf("kongregate.com") <= 0)
			&& (currUrl.indexOf("ungrounded.net") <= 0) && (currUrl.indexOf("jayisgames.com") <= 0)){
				//return true;
				return false;
			}else{
				return true;
			}
		}
		
		public function input():void {
			if (game.infocus) {
				game.mx = (mouseX / 2);
				game.my = (mouseY / 2);
				
				switch(game.gamestate) {
					case TITLEMODE:	titleinput(key, gfx, map, game, obj, music); break;
					case CONNECTMODE:	connectinput(key, gfx, map, game, obj, music); break;
					case GAMEMODE: gameinput(key, gfx, map, game, obj, music); break;
					case LOGINMODE: logininput(key, gfx, map, game, obj, music); break;
					case LOBBYMODE: lobbyinput(key, gfx, map, game, obj, music); break;
					case CLICKTOSTART:
						if (key.click) {			
							//music.play(1);
							game.gamestate = LOGINMODE;
						}
					break;
				}
			}
		}
		
    public function logic():void {
			if (!game.infocus) {
				if (game.globalsound > 0) {
					game.globalsound = 0;
					SoundMixer.soundTransform = new SoundTransform(0);
				}				
				music.processmusic();
				help.updateglow();
		    game.chatbox_logicpos=0;
			}else{
				switch(game.gamestate) {
					case TITLEMODE: titlelogic(key, gfx, map, game, obj, music); break;
					case CONNECTMODE: connectlogic(key, gfx, map, game, obj, music); break;
					case GAMEMODE: gamelogic(key, gfx, map, game, obj, music); break;
					case LOBBYMODE: lobbylogic(key, gfx, map, game, obj, music); break;
					case LOGINMODE: loginlogic(key, gfx, map, game, obj, music); break;
				}
				
				music.processmusic();
				help.updateglow();
				
				//Mute button
				/*if (key.isDown(77) && game.mutebutton<=0) {
					game.mutebutton = 8; if (game.muted) { game.muted = false; }else { game.muted = true;}
				}
				if(game.mutebutton>0) game.mutebutton--;
				*/
				if (game.muted) {
					if (game.globalsound == 1) {
						game.globalsound = 0; SoundMixer.soundTransform = new SoundTransform(0);
					}
				}
				
				if (!game.muted && game.globalsound == 0) {
					game.globalsound = 1; SoundMixer.soundTransform = new SoundTransform(1);
				}
			}
		}
		
		public function render():void {
			gfx.backbuffer.lock();
			if (!game.infocus) {
				gfx.bigprint(5, 135, "Game paused", 255 - (help.glow/2), 255 - (help.glow/2), 255 - (help.glow/2), true);
				gfx.print(5, 153, "[click to resume]", 196 - (help.glow/2), 196 - (help.glow/2), 196 - (help.glow/2), true);
				//gfx.print(5, 230, "Press M to mute", 255 - (help.glow/2), 255 - (help.glow/2), 255 - (help.glow/2), true);
				gfx.normalrender();
			}else{
				switch(game.gamestate) {
					case TITLEMODE: titlerender(key, gfx, map, game, obj); break;
					case CONNECTMODE: connectrender(key, gfx, map, game, obj); break;
					case GAMEMODE: gamerender(key, gfx, map, game, obj); break;
					case LOBBYMODE: lobbyrender(key, gfx, map, game, obj); break;
					case LOGINMODE: loginrender(key, gfx, map, game, obj); break;
				  case CLICKTOSTART:
					  clicktostartrender(key, gfx, map, game, obj); break;
					break;
				}
			}
		}
		
		public function mainloop(e:TimerEvent):void {
			_current = getTimer();
			if (_last < 0) _last = _current;
			_delta += _current - _last;
			_last = _current;
			if (_delta >= _rate){
				_delta %= _skip;
				while (_delta >= _rate){
					_delta -= _rate;
					input();
					logic();
					if (key.hasclicked) key.click = false;
				}
				render();
				e.updateAfterEvent();
			}
		}
		
		public var gfx:graphicsclass = new graphicsclass();
		public var music:musicclass = new musicclass();
		public var map:mapclass = new mapclass();
		public var game:gameclass;
		public var obj:entityclass = new entityclass();
		public var key:KeyPoll;
		
		public var slogo:MovieClip;
		public var logoposition:Matrix;
		public var pixel:uint; public var pixel2:uint;
		public var pi:uint, pj:uint;
		public var i:int, j:int, k:int, temp:int;
		
		// Timer information (a shout out to ChevyRay for the implementation)
		public static const TARGET_FPS:Number = 60; // the fixed-FPS we want the game to run at
		private var	_rate:Number = 1000 / TARGET_FPS; // how long (in seconds) each frame is
		private var	_skip:Number = _rate * 10; // this tells us to allow a maximum of 10 frame skips
		private var	_last:Number = -1;
		private var	_current:Number = 0;
		private var	_delta:Number = 0;
		private var	_timer:Timer = new Timer(4);
		
		//Embedded resources:		
		[Embed(source = '../data/graphics/tiles.png')]	private var im_tiles:Class;
		[Embed(source = '../data/graphics/sprites.png')]	private var im_sprites:Class;
		
		[Embed(source = '../data/graphics/font/flixel/font.png')]	private var im_bfont:Class; //EDIT THIS to change font, /font/.../font.png
		//Full images
		[Embed(source = '../data/graphics/bg.png')]	private var im_image0:Class;
		//Music
		[Embed(source = '../data/music/bridge.mp3')]	private var music_0:Class;
		//Sound effects
		[Embed(source = '../data/sounds/meow1.mp3')]	private var ef_0:Class;
		[Embed(source = '../data/sounds/meow2.mp3')]	private var ef_1:Class;
		[Embed(source = '../data/sounds/meow3.mp3')]	private var ef_2:Class;
		[Embed(source = '../data/sounds/meow4.mp3')]	private var ef_3:Class;
		[Embed(source = '../data/sounds/meow5.mp3')]	private var ef_4:Class;
		[Embed(source = '../data/sounds/catpurr.mp3')]	private var ef_5:Class;
		[Embed(source = '../data/sounds/catscreech.mp3')]	private var ef_6:Class;
		[Embed(source = '../data/sounds/catnap.mp3')]	private var ef_7:Class;
		[Embed(source = '../data/sounds/dogbark1.mp3')]	private var ef_8:Class;
		[Embed(source = '../data/sounds/dogbark2.mp3')]	private var ef_9:Class;
		[Embed(source = '../data/sounds/dogbark3.mp3')]	private var ef_10:Class;
		[Embed(source = '../data/sounds/dogbark4.mp3')]	private var ef_11:Class;
		[Embed(source = '../data/sounds/dogbark5.mp3')]	private var ef_12:Class;
		[Embed(source = '../data/sounds/dogpant.mp3')]	private var ef_13:Class;
		[Embed(source = '../data/sounds/doghowl.mp3')]	private var ef_14:Class;
		[Embed(source = '../data/sounds/dognap.mp3')]	private var ef_15:Class;
		[Embed(source = '../data/sounds/mouse.mp3')]	private var ef_16:Class;
		[Embed(source = '../data/sounds/pianoc.mp3')]	private var ef_17:Class;
		[Embed(source = '../data/sounds/pianod.mp3')]	private var ef_18:Class;
		[Embed(source = '../data/sounds/pianoe.mp3')]	private var ef_19:Class;
		[Embed(source = '../data/sounds/pianof.mp3')]	private var ef_20:Class;
		[Embed(source = '../data/sounds/pianog.mp3')]	private var ef_21:Class;
		[Embed(source = '../data/sounds/pianoa.mp3')]	private var ef_22:Class;
		[Embed(source = '../data/sounds/pianob.mp3')]	private var ef_23:Class;
		[Embed(source = '../data/sounds/pianohc.mp3')]	private var ef_24:Class;
		[Embed(source = '../data/sounds/broadcast.mp3')]	private var ef_25:Class;
		[Embed(source = '../data/sounds/help.mp3')]	private var ef_26:Class;
	}
}
package {  
	import flash.display.*;          
	import flash.media.*; 
  import flash.events.*;
	
	public class musicclass{	
		//For Music stuff
		public function play(t:int):void {
			if (currentsong !=t) {
				if (currentsong != -1) {
					//Stop the old song first
					musicchannel.stop();
					musicchannel.removeEventListener(Event.SOUND_COMPLETE, loopmusic);
				}
				if (t != -1) {
			    currentsong = t;
					musicchannel = musicchan[currentsong].play(0);
					
					musicchannel.addEventListener(Event.SOUND_COMPLETE, loopmusic);
				}else {	
			    currentsong = -1;
				}
			}
    }   
		
		public function loopmusic(e:Event):void { 
			musicchannel.removeEventListener(Event.SOUND_COMPLETE, loopmusic);
			if(currentsong>-1){
				musicchannel = musicchan[currentsong].play();
				musicchannel.addEventListener(Event.SOUND_COMPLETE, loopmusic);
			}
		}
		
		public function stopmusic(e:Event):void { 
			musicchannel.removeEventListener(Event.SOUND_COMPLETE, stopmusic);
			musicchannel.stop();
			currentsong = -1;
		}
		
		public function stop():void { 
			musicchannel.removeEventListener(Event.SOUND_COMPLETE, stopmusic);
			musicchannel.stop();
			currentsong = -1;
		}
		
		public function fadeout():void { 
			if (musicfade == 0) {
			  musicfade = 31;
			}
		}
		
		public function processmusicfade():void {
			musicfade--;
			if (musicfade > 0) {
				musicchannel.soundTransform = new SoundTransform(musicfade / 30);
			}else {
			  musicchannel.stop();
			  currentsong = -1;
			}
		}
		
		public function processmusicfadein():void {
			musicfadein--;
			if (musicfadein > 0) {
				musicchannel.soundTransform = new SoundTransform((60-musicfadein) / 60 );
			}else {
				musicchannel.soundTransform = new SoundTransform(1.0);
			}
		}
		
		
   	public function processmusic():void {
			if (musicfade > 0) processmusicfade();
			if (musicfadein > 0) processmusicfadein();
		}
		
		public var musicchan:Array = new Array();	
		public var musicchannel:SoundChannel;
		public var currentsong:int, musicfade:int, musicfadein:int;
		
		//Play a sound effect! There are 16 channels, which iterate
		public function initefchannels():void {
			for (var i:int = 0; i < 16; i++) efchannel.push(new SoundChannel);
		}
		
		public function playef(t:int, offset:int = 0):void {
			efchannel[currentefchan] = efchan[t].play(offset);
			currentefchan++;
			if (currentefchan > 15) currentefchan -= 16;
		}
		
		public var currentefchan:int;
		public var efchannel:Array = new Array();
		public var efchan:Array = new Array();
		public var numplays:int;
	}
}

package {
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Security;

	public class kongapi {
		public static var service:*;
		public static var loadcomplete:Boolean;
		public static var haskey:Boolean, loggedin:int;
		public static var boughtgame:Boolean, notboughtgame:Boolean;
		public static var apitimeout:int;
		
		public static function init(paramObj:Object, swfStage:Stage):void	{
			loadcomplete = false;
			apitimeout = 60; loggedin = 0;
			var api_url:String = paramObj.api_path || "http://www.kongregate.com/flash/API_AS3_Local.swf";
			Security.allowDomain(api_url);
			var request:URLRequest = new URLRequest(api_url);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
			loader.load(request);
			swfStage.addChild(loader);
		}
		
		private static function loaded(event:Event):void {
			loadcomplete = true;
			service = event.target.content;
			service.services.connect();
		}
		
		public static function guestcheck():void {
			service.services.addEventListener("login", onKongregateInPageLogin);
		}
		
		public static function onKongregateInPageLogin(event:Event):void {
			if (loggedin == 0) loggedin = 1;
		}
		
		public static function submit(name:String, value:int):void {
			if(loadcomplete) service.stats.submit(name, value);
		}
		
		public static function getusername():String {
			if (loadcomplete) return service.services.getUsername();
			return "Guest";
		}
		
		public static function isguest():Boolean {
			if (loadcomplete) return service.services.isGuest();
			return true;
		}
	}
}
/**
 * Key polling class
 * 
 * To create:
 * var key:KeyPoll = new KeyPoll( displayObject );
 * 
 * the display object will usually be the stage.
 *
 * Full example:
 * package
 *  {
 *  	import flash.display.Sprite;
 *  	import flash.events.Event;
 *  	import flash.ui.Keyboard;
 *  	import fgc.input.KeyPoll;
 *  	
 *  	public class Test 
 *  	{
 *  		var key:KeyPoll;
 *  		
 *  		public function Test()
 *  		{
 *  			key = new KeyPoll( this.stage );
 *  			addEventListener( Event.ENTER_FRAME, enterFrame );
 *  		}
 *  		
 *  		public function enterFrame( ev:Event ):void
 *  		{
 *  			if( key.isDown( Keyboard.LEFT ) )
 *  			{
 *  				trace( "left key is down" );
 *  			}
 *  			if( key.isDown( Keyboard.RIGHT ) )
 *  			{
 *  				trace( "right key is down" );
 *  			}
 *  		}
 *  	}
 *  }
 * 
 * Author: Richard Lord
 * Copyright (c) FlashGameCode.net 2007
 * Version 1.0.2
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package bigroom.input
{
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	import flash.events.MouseEvent;
	
	public class KeyPoll
	{
		private var states:ByteArray;
		private var dispObj:DisplayObject;
		public var click:Boolean = false;
		public var hasclicked:Boolean = false;
		public var press:Boolean = false;
		public var onscreen:Boolean=true;
		
		public function KeyPoll( obj:DisplayObject )
		{
			states = new ByteArray();
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			dispObj = obj;
			dispObj.addEventListener( KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true );
			dispObj.addEventListener( KeyboardEvent.KEY_UP, keyUpListener, false, 0, true );
			dispObj.addEventListener( Event.ACTIVATE, activateListener, false, 0, true );
			dispObj.addEventListener( Event.DEACTIVATE, deactivateListener, false, 0, true );
			dispObj.addEventListener( MouseEvent.MOUSE_DOWN, mouseDownListener);
			dispObj.addEventListener( MouseEvent.MOUSE_UP, mouseUpListener );
			dispObj.addEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler);       
			dispObj.addEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler);
		}
		
		public function mouseOverHandler( e:MouseEvent ):void{
			onscreen = true;
		}
		
		public function mouseOutHandler( e:MouseEvent ):void{
			onscreen = false;
		}
		
		public function mouseUpListener( e:MouseEvent ):void{
			press = false;
			
			click = false;
			hasclicked = false;
		}
		
		public function mouseDownListener( e:MouseEvent ):void {
			press = true;
			
			click = true;
			hasclicked = true;
		}
		
		private function keyDownListener( ev:KeyboardEvent ):void
		{
			states[ ev.keyCode >>> 3 ] |= 1 << (ev.keyCode & 7);
		}
		
		private function keyUpListener( ev:KeyboardEvent ):void
		{
			states[ ev.keyCode >>> 3 ] &= ~(1 << (ev.keyCode & 7));
		}
		
		private function activateListener( ev:Event ):void
		{
			for( var i:int = 0; i < 8; ++i )
			{
				states[ i ] = 0;
			}
		}

		private function deactivateListener( ev:Event ):void
		{
			for( var i:int = 0; i < 8; ++i )
			{
				states[ i ] = 0;
			}
		}

		public function isDown( keyCode:uint ):Boolean
		{
			return ( states[ keyCode >>> 3 ] & (1 << (keyCode & 7)) ) != 0;
		}
		
		public function isUp( keyCode:uint ):Boolean
		{
			return ( states[ keyCode >>> 3 ] & (1 << (keyCode & 7)) ) == 0;
		}
	}
}
package as3.display 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author hbb
	 */
	public class AS2MovieClip extends MovieClip
	{
		public var onRollOver:Function;
		public var onRollOut:Function;
		public var onPress:Function;
		public var onRelease:Function;
		public var onReleaseOutside:Function;
		
		protected var _isPressed:Boolean;
		
		public function AS2MovieClip() 
		{
			if (stage)
				__init(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, __init, false, 0, true);
		}
		
		protected function __init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, __init, false);
			buttonMode = true;
			mouseChildren = false;
			
			if ('hitarea_mc' in this)
				hitArea = this['hitarea_mc'];
			
			_isPressed = false;
			
			addEventListener(MouseEvent.MOUSE_DOWN, __downHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OVER, __overHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, __outHandler, false, 0, true);
		}
		
		protected function __downHandler(e:MouseEvent):void 
		{
			_isPressed = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, __upHandler, false, 0, true);
			
			if (onPress != null)
				onPress(this);
		}
		
		protected function __upHandler(e:MouseEvent):void 
		{
			_isPressed = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, __upHandler, false);
			
			var hitObj:DisplayObject = hitArea ? hitArea : this;
			
			if (hitObj.hitTestPoint(stage.mouseX, stage.mouseY, true))
			{
				if (onRelease != null)
					onRelease(this);
			}
			else
			{
				if (onReleaseOutside != null)
					onReleaseOutside(this);
			}
		}
		
		protected function __outHandler(e:MouseEvent):void 
		{
			if (_isPressed || !mouseEnabled)
				return;
				
			if (onRollOut != null)
				onRollOut(this);
		}
		
		protected function __overHandler(e:MouseEvent):void 
		{
			if (_isPressed || !mouseEnabled)
				return;
				
			if (onRollOver != null)
				onRollOver(this);
		}
	}
	
}
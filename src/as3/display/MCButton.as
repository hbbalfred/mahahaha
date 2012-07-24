package as3.display
{
	import as3.utils.MovieClipUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MCButton extends AS2MovieClip
	{
		public function MCButton()
		{
			super();
			stop();
		}
		
		override protected function __outHandler(e:MouseEvent):void 
		{
			super.__outHandler(e);
			
			if(mouseEnabled)
				MovieClipUtil.playToStart(this);
		}
		
		override protected function __overHandler(e:MouseEvent):void 
		{
			super.__overHandler(e);
			
			if(mouseEnabled)
				MovieClipUtil.playToEnd(this);
		}
	}
}
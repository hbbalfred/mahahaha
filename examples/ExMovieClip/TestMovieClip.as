package  
{
	import as3.display.ExMovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author hbb
	 */
	public class TestMovieClip extends ExMovieClip
	{
		
		public function TestMovieClip() 
		{
			doLater(fun1);
		}
		
		override protected function __onAddToStage(e:Event):void 
		{
			super.__onAddToStage(e);
			
			doLater(fun2, 'add to stage');
		}
		
		override protected function __onRemovedFromStage(e:Event):void 
		{
			super.__onRemovedFromStage(e);
			
			doLater(fun4);
		}
		
		private function fun4():void
		{
			trace(this, 'function 4');
		}
		
		private function fun2(message:String):void
		{
			trace(this, 'function 2 with ' + message);
			
			doLater(fun3, 1, 2, 3);
			doLater(fun3, 4,5);
		}
		
		private function fun3(a:int, b:uint, c:Number=0.1):void
		{
			trace(this, 'function 3 with ', a, b, c);
		}
		
		private function fun1():void
		{
			trace(this, 'function 1');
		}
		
	}

}
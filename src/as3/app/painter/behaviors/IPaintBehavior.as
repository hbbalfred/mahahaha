package as3.app.painter.behaviors 
{
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.geom.Point;
	
	/**
	* ...
	*/
	public interface IPaintBehavior 
	{
		function draw( dest:BitmapData, src:IBitmapDrawable, destPoint:Point ):void;
	}
	
}
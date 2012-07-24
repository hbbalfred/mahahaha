package as3.app.painter.brushs  
{
	import as3.app.painter.behaviors.IPaintBehavior;
	import as3.app.painter.patterns.IPatternable;
	import flash.display.BitmapData;
	
	/**
	* ...
	*/
	public interface IBrushable 
	{
		function get target():BitmapData;
		function set target( v:BitmapData ):void;
		
		function get pattern():IPatternable;
		function set pattern( v:IPatternable ):void;
		
		function get paintBehavior():IPaintBehavior;
		function set paintBehavior( v:IPaintBehavior ):void;
		
		function to( x:Number, y:Number ):void;
		function too( x:Number, y:Number ):void;
		
	}
	
}
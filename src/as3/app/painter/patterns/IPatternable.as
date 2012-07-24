package as3.app.painter.patterns
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	/**
	* ...
	*/
	public interface IPatternable 
	{
		// properties of pattern
		function get size():int;
		function set size( v:int ):void;
		
		function get hardness():Number;
		function set hardness( v:Number ):void;
		
		function get color():uint;
		function set color( v:uint ):void;
		
		function get alpha():Number;
		function set alpha( v:Number ):void;
		
		// offset point that between origin point to mouse point
		function get offsetX():Number;
		function get offsetY():Number;
		
		// optimize brush to painting
		function get thickness():Number;
		
		// body of pattern
		function get body():DisplayObject;
		// bitmapData of body
		function get bitmapData():BitmapData;
	}
}
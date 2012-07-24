package as3.app.painter.brushs 
{
	import as3.app.painter.behaviors.IPaintBehavior;
	import as3.app.painter.patterns.IPatternable;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	* ...
	*/
	public class Brush implements IBrushable
	{
		
		public function Brush( target:BitmapData, pattern:IPatternable, paintBehavior:IPaintBehavior) 
		{
			_target = target;
			_pattern = pattern;
			_paintBehavior = paintBehavior;
		}
		
		public function get target():BitmapData
		{
			return _target;
		}
		public function set target( v:BitmapData ):void
		{
			_target = v;
		}
		
		public function get pattern():IPatternable
		{
			return _pattern;
		}
		public function set pattern( v:IPatternable ):void
		{
			_pattern = v;
		}
		
		public function get paintBehavior():IPaintBehavior
		{
			return _paintBehavior;
		}
		public function set paintBehavior( v:IPaintBehavior ):void
		{
			_paintBehavior = v;
		}
		
		public function to( x:Number, y:Number ):void
		{
			currY = offXY.y = y;
			currX = offXY.x = x;
			
			offXY.y -= _pattern.offsetY;
			offXY.x -= _pattern.offsetX;
			
			disXY = 0.0;
			
			_paintBehavior.draw( _target, _pattern.body, offXY );
		}
		public function too( x:Number, y:Number ):void
		{
			if ( x == currX && y == currY ) return;
			
			var dy:Number = y - currY;
			var dx:Number = x - currX;
			var dis:Number = dy * dy + dx * dx;
			
			disXY += dis;
			
			var rr:Number = _pattern.thickness;
			
			if ( rr * rr > disXY ) return;
			
			disXY = 0.0;
			
			dis = Math.sqrt( dis );
			dy = (dy / dis) * rr;
			dx = (dx / dis) * rr;
			
			var ny:Number = currY - _pattern.offsetY;
			var nx:Number = currX - _pattern.offsetX ;
			var i:int = Math.ceil(dis / rr);
			
			var shape:IBitmapDrawable = _pattern.body;
			for (; i > 0; --i)
			{
				offXY.y = ny;
				offXY.x = nx;
				
				_paintBehavior.draw( _target, shape, offXY );
				
				ny += dy;
				nx += dx;
			}
			
			currY = y;
			currX = x;
		}
		
		private var _target:BitmapData;
		private var _pattern:IPatternable;
		private var _paintBehavior:IPaintBehavior;
		
		private var currX:Number = 0.0;
		private var currY:Number = 0.0;
		private var disXY:Number = 0.0;
		
		private var offXY:Point = new Point();
	}
	
}
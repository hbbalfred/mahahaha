package as3.app.painter.patterns 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	
	/**
	* ...
	*/
	public class CirclePattern implements IPatternable
	{
		public function CirclePattern( size:int = 10, hardness:Number = 1.0, color:uint = 0x000000, alpha:Number = 1.0) 
		{
			this.size = size;
			this.hardness = hardness;
			this.color = color;
			this.alpha = alpha;
			
			_bd = new Shape();
			
			redraw();
		}
		
		public function get size():int
		{
			return _size;
		}
		public function set size( v:int ):void
		{
			_size = limit( v, 1, 500 );
			_radius = _size * .5;
		}
		
		public function get hardness():Number
		{
			return _hardness;
		}
		public function set hardness( v:Number ):void
		{
			_hardness = limit( v, 0.0, 1.0 );
		}
		
		public function get color():uint
		{
			return _color;
		}
		public function set color( v:uint ):void
		{
			_color = v & 0x00FFFFFF;
		}
		
		public function get alpha():Number
		{
			return _alpha;
		}
		public function set alpha( v:Number ):void
		{
			_alpha = limit( v, 0.0, 1.0 );
		}
		
		public function get offsetX():Number
		{
			return _bdd.width * .5;
		}
		public function get offsetY():Number
		{
			return _bdd.height * .5;
		}
		
		public function get thickness():Number
		{
			return _radius * .5;
		}
		
		public function get body():DisplayObject
		{
			return _bd;
		}
		
		public function get bitmapData():BitmapData
		{
			return _bdd;
		}
		
		private function redraw():void
		{
			var x:Number, y:Number;
			var rect:Rectangle;
			
			if ( _hardness < 1.0 )
			{
				var blurXY:Number = _radius * ( 1.0 - _hardness );
				var blur:BlurFilter = new BlurFilter( blurXY, blurXY, 2 );
				var tmp:BitmapData = new BitmapData( _radius * 2, _radius * 2, false );
				rect = tmp.generateFilterRect( tmp.rect, blur );
				tmp.dispose();
				
				x = _radius - rect.x;
				y = _radius - rect.y;
				_bd.filters = [ blur ];
			}
			else
			{
				x = y = _radius;
				rect = new Rectangle(0, 0, _radius * 2, _radius * 2);
				_bd.filters = null;
			}
			
			_bd.graphics.clear();
			_bd.graphics.beginFill( _color, _alpha );
			_bd.graphics.drawCircle( x, y, _radius );
			_bd.graphics.endFill();
			
			if ( _bdd ) _bdd.dispose();
			_bdd = new BitmapData( rect.width, rect.height, true, 0 );
			_bdd.draw( _bd );
		}
		
		private function limit( v:Number, l:Number, r:Number ):Number
		{
			if ( v < l ) return l;
			if ( v > r ) return r;
			return v;
		}
		
		private var _size:int;
		private var _hardness:Number;
		private var _color:uint;
		private var _alpha:Number;
		
		private var _radius:Number;
		private var _bd:Shape;
		private var _bdd:BitmapData;
		
	}
	
}
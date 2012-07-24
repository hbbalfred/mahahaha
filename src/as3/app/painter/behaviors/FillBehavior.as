package as3.app.painter.behaviors  
{
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	* ...
	*/
	public class FillBehavior implements IPaintBehavior
	{
		
		public function FillBehavior() 
		{
			mat = new Matrix();
		}
		
		public function draw( dest:BitmapData, src:IBitmapDrawable, destPoint:Point ):void
		{
			mat.tx = destPoint.x;
			mat.ty = destPoint.y;
			
			dest.draw( src, mat );
		}
		
		private var mat:Matrix;
	}
	
}
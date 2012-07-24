package as3.app.painter.behaviors  
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.IBitmapDrawable;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	* ...
	*/
	public class EraseBehavior implements IPaintBehavior
	{
		
		public function EraseBehavior() 
		{
			mat = new Matrix();
		}
		
		// Notice: ERASE blend mode would be ineffectived if source is a bitmapdata
		public function draw( dest:BitmapData, src:IBitmapDrawable, destPoint:Point ):void
		{
			mat.tx = destPoint.x;
			mat.ty = destPoint.y;
			
			dest.draw( src, mat, null, BlendMode.ERASE );
		}
		
		private var mat:Matrix;
	}
	
}
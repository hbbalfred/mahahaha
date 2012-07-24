package  
{
	import as3.app.painter.behaviors.EraseBehavior;
	import as3.app.painter.behaviors.FillBehavior;
	import as3.app.painter.brushs.Brush;
	import as3.app.painter.brushs.IBrushable;
	import as3.app.painter.patterns.CirclePattern;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	* ...
	*/
	public class TestBrush extends Sprite
	{
		
		public function TestBrush() 
		{
			initPicture();
			initBrush();
			
			initListener();
		}
		
		private function handleMouseUp( e:MouseEvent ):void
		{
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
		}
		private function handleMouseMove( e:MouseEvent ):void
		{
			brush.too( stage.mouseX, stage.mouseY );
		}
		private function handleMouseDown( e:MouseEvent ):void
		{
			brush.to( stage.mouseX, stage.mouseY );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
		}
		
		private function initListener():void
		{
			stage.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown );
			stage.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp );
		}
		
		private function initBrush():void
		{
			brush = new Brush( rena.bitmapData, new CirclePattern(50, .5, 0, .5), new FillBehavior() );
		}
		
		private function initPicture():void
		{
			rena = new Rena();
			
			var bd:BitmapData = rena.bitmapData;
			bd = new BitmapData(bd.width, bd.height, true, 0);
			bd.draw( rena.bitmapData );
			
			rena.bitmapData.dispose();
			rena.bitmapData = bd;
			
			addChild( rena );
		}
		
		[@Embed(source = 'rena.jpg')]
		private var Rena:Class;
		
		private var rena:Bitmap;
		
		private var brush:IBrushable;
		
	}
	
}
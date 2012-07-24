package as3.display 
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author hbb
	 * @example
	 * scroller.target = target_mc;
	 * scroller.areaMask = mask_mc;
	 * scroller.mouseWheelEnabled = false; // default is true
	 * scroller.keyboardEnabled = false; // default is true
	 * scroller.position = .5; // default is 0
	 */
	public class CIScroller extends Sprite
	{
		private var _target:DisplayObject;
		private var _mask:DisplayObject;
		private var _position:Number = 0.0;
		//0 - disable
		//1 - mouse wheel
		//2 - keyboard
		//3 - all enable
		private var _enabledBit:uint = 3;
		
		private var _assets:Assets;
		private var _offsThumbY:Number;
		private var _enterFrame:int;
		private var _scrollSpeed:Number;
		
		[Inspectable(Type="Boolean",defaultValue="true")]
		public function get mouseWheelEnabled():Boolean { return Boolean(_enabledBit & 1); }
		public function set mouseWheelEnabled(v:Boolean):void
		{
			if (v) _enabledBit |= 1;
			else _enabledBit &= 2;
		}
		
		[Inspectable(Type="Boolean",defaultValue="true")]
		public function get keyboardEnabled():Boolean { return Boolean(_enabledBit & 2); }
		public function set keyboardEnabled(v:Boolean):void
		{
			if (v) _enabledBit |= 2;
			else _enabledBit &= 1;
		}
		
		public function get target():DisplayObject { return _target; }
		public function set target(v:DisplayObject):void
		{
			if (_target == v) return;
			
			if (_target) _target.mask = null;
			_target = v;
			
			__invalidate();
		}
		
		public function get areaMask():DisplayObject { return _mask; }
		public function set areaMask(v:DisplayObject):void
		{
			if (_mask == v) return;
			
			_mask = v;
			
			__invalidate();
		}
		
		public function get position():Number { return _position; }
		public function set position(v:Number):void
		{
			if (_position == v) return;
			
			if (v < 0.0) _position = 0.0;
			else if (v > 1.0) _position = 1.0;
			else _position = v;
			
			target.y = areaMask.y - (target.height - areaMask.height) * _position;
			if (_assets.thumb)
				_assets.thumb.y = _assets.trackBar.y + (_assets.trackBar.height - _assets.thumb.height) * _position;
		}
		
		override public function set height(v:Number):void
		{
			if (height == v) return;
			super.height = v;
			__resize();
		}
		
		public function CIScroller() 
		{
			_assets = new Assets(this);
			
			addEventListener(Event.ADDED_TO_STAGE, __onAddStage, false, 0, true);
			
			buttonMode = true;
		}
		
		private function __invalidate():void
		{
			addEventListener(Event.ENTER_FRAME, __onInvalidate, false, 0, true);
		}
		
		private function __onInvalidate(e:Event):void 
		{
			removeEventListener(Event.ENTER_FRAME, __onInvalidate, false);
			__resize();
		}
		
		private function __resize():void
		{
			if (!target) { visible = false; return; }
			if (areaMask.height >= target.height) { visible = false; return; }
			
			visible = true;
			
			target.mask = areaMask;
			
			if (_assets.upButton is Sprite) Sprite(_assets.upButton).mouseChildren = false;
			if (_assets.downButton is Sprite) Sprite(_assets.downButton).mouseChildren = false;
			if (_assets.thumb is Sprite) Sprite(_assets.thumb).mouseChildren = false;
			if (_assets.trackBar is Sprite) Sprite(_assets.trackBar).mouseChildren = false;
			
			var h:Number = height;
			scaleY = 1.0;
			
			if (!_assets.upButton && !_assets.downButton)
			{
				_assets.trackBar.height = h;
				__resizeThumb( areaMask.height / target.height * _assets.trackBar.height );
				_assets.thumb.y = 0;
				_assets.trackBar.y = 0;
				_assets.thumb.x = 0;
				_assets.trackBar.x = (_assets.thumb.width - _assets.trackBar.width) * .5;
			}
			else if (!_assets.thumb && !_assets.trackBar)
			{
				_assets.upButton.x = 0;
				_assets.downButton.x = 0;
				_assets.upButton.y = 0;
				_assets.downButton.y = h - _assets.downButton.height;
			}
			else
			{
				_assets.trackBar.height = h -_assets.upButton.height -_assets.downButton.height;
				__resizeThumb( areaMask.height / target.height * _assets.trackBar.height );
				_assets.upButton.x = 0;
				_assets.downButton.x = 0;
				_assets.thumb.x = (_assets.upButton.width - _assets.thumb.width) * .5;
				_assets.trackBar.x = (_assets.upButton.width - _assets.trackBar.width) * .5;
				_assets.upButton.y = 0;
				_assets.thumb.y = _assets.upButton.height;
				_assets.trackBar.y = _assets.upButton.height;
				_assets.downButton.y = _assets.trackBar.y + _assets.trackBar.height;
			}
			
			// drive the position to render
			position += 0.0001;
		}
		
		private function __resizeThumb(height:Number):void 
		{
			if (_assets.thumbTop && _assets.thumbMiddle && _assets.thumbBottom)
			{
				_assets.thumbTop.x = 0;
				_assets.thumbTop.y = 0;
				_assets.thumbMiddle.height = height -_assets.thumbTop.height -_assets.thumbBottom.height;
				_assets.thumbMiddle.x = _assets.thumbBottom.x = _assets.thumbTop.x;
				_assets.thumbMiddle.y = _assets.thumbTop.y + _assets.thumbTop.height;
				_assets.thumbBottom.y = _assets.thumbMiddle.y + _assets.thumbMiddle.height;
			}
			//else
				//_assets.thumbTop.height = height;
		}
		
		private function __onAddStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, __onAddStage);
			
			addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, __onKeyDown, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, __onMouseWheel, false, 0, true);
		}
		
		private function __onKeyDown(e:KeyboardEvent):void 
		{
			if (!keyboardEnabled || !visible) return;
			
			switch(e.keyCode)
			{
				case Keyboard.UP:        position -= .1; break;
				case Keyboard.DOWN:      position += .1; break;
				case Keyboard.PAGE_UP:   position -= .5; break;
				case Keyboard.PAGE_DOWN: position += .5; break;
				case Keyboard.HOME:      position = 0.0; break;
				case Keyboard.END:       position = 1.0; break;
				default:
			}
		}
		
		private function __onMouseWheel(e:MouseEvent):void 
		{
			if (!mouseWheelEnabled || !visible) return;
			
			var dir:int = e.delta > 0 ? -1 : 1;
			position += dir * .2;
		}
		
		private function __onMouseDown(e:MouseEvent):void 
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, __onKeyDown, false);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, __onMouseWheel, false);
			stage.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp, false, 0, true);
			
			switch(e.target)
			{
				case _assets.thumb:
					_offsThumbY = mouseY - _assets.thumb.y;
					stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove, false, 0, true);
					break;
				case _assets.upButton:
					_scrollSpeed = -.1;
					position += _scrollSpeed;
					_enterFrame = 0;
					addEventListener(Event.ENTER_FRAME, __onEnterFrame, false, 0, true);
					break;
				case _assets.downButton:
					_scrollSpeed = .1;
					position += _scrollSpeed;
					_enterFrame = 0;
					addEventListener(Event.ENTER_FRAME, __onEnterFrame, false, 0, true);
					break;
				case _assets.trackBar:
					_offsThumbY = _assets.thumb.height * .5;
					__onMouseMove(null);
					stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove, false, 0, true);
					break;
				default:
			}
		}
		
		private function __onMouseUp(e:MouseEvent):void 
		{
			removeEventListener(Event.ENTER_FRAME, __onEnterFrame, false);
			stage.removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp, false);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove, false);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, __onKeyDown, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, __onMouseWheel, false, 0, true);
		}
		
		private function __onMouseMove(e:MouseEvent):void 
		{
			var my:Number = mouseY - _assets.trackBar.y - _offsThumbY;
			var th:Number = _assets.trackBar.height - _assets.thumb.height;
			position = my / th;
		}
		
		private function __onEnterFrame(e:Event):void 
		{
			if (_enterFrame < 8)
				++_enterFrame;
			else
				position += _scrollSpeed;
		}
	}
	
}
import flash.display.DisplayObject;

class Assets
{
	private var _scroller:DisplayObject;
	public function Assets(scroller:DisplayObject)
	{
		_scroller = scroller;
	}
	
	public function get upButton():DisplayObject
	{
		return ('up_btn' in _scroller) ? _scroller['up_btn'] : null;
	}
	public function get downButton():DisplayObject
	{
		return ('down_btn' in _scroller) ? _scroller['down_btn'] : null;
	}
	public function get trackBar():DisplayObject
	{
		return ('trackBar_mc' in _scroller) ? _scroller['trackBar_mc'] : null;
	}
	public function get thumb():DisplayObject
	{
		return ('thumb_mc' in _scroller) ? _scroller['thumb_mc'] : null;
	}
	public function get thumbTop():DisplayObject
	{
		return ('top_mc' in thumb) ? thumb['top_mc'] : null;
	}
	public function get thumbMiddle():DisplayObject
	{
		return ('middle_mc' in thumb) ? thumb['middle_mc'] : null;
	}
	public function get thumbBottom():DisplayObject
	{
		return ('bottom_mc' in thumb) ? thumb['bottom_mc'] : null;
	}
}
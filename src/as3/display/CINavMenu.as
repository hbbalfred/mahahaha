/*
使用方式：

菜单名称格式，前缀 + id（比如：menu1,menu2或者caidanA,caidanB）
定位格式，id + 分隔符 + id（比如：2-3-1或者A>C>B）

代码示例：
nav.anchor = "3-2-1";
nav.onClick = function(path:Array):void
{
   switch(path.join('-'))
   {
      case "1":
      case "2-1":
      case "3-2-1":
      default:
   }
};

结构与思路：

每个按钮即一个菜单。
每个菜单都可以有下拉菜单。
下拉菜单直接做在其父级菜单的里。

菜单显示，即播放到最后一帧，下拉菜单（有的话）也会显示。
菜单隐藏，即倒播到第一帧。

菜单层深，数字由小到大，根菜单层深为0。
根菜单，由系统自动判断，在一开始显示后，不再隐藏。

鼠标移动至菜单时，需先隐藏显示着的菜单，并停止计时器。
鼠标移开菜单时，启动计时器。
计时器触发后，隐藏显示着的菜单，并显示定位。

计时器，计算鼠标离开导航的时间。

鼠标接触菜单的层深，一定大于等于显示着的菜单层深。否则为异常现象，不予处理。
显示定位时，先判断显示着的菜单是否在定位中，是则显示之，否则隐藏之。该判断是循环向上直至根菜单。

每个菜单在加载于场景时，会判断自身是否处于定位中，是则根据鼠标情况而显示之。

*/
package as3.display 
{
	import as3.utils.ArrayUtil;
	import as3.utils.MovieClipUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author hbb
	 * 
	 */
	public class CINavMenu extends MovieClip
	{
		private var _root:CINavMenu;
		private var _outTimer:NavTimer;
		private var _anchor:Array;
		private var _curr:CINavMenu;
		private var _isMouseOver:Boolean;
		private var _prefix:String;
		
		private var _depth:int;
		
		public var onClick/*(path:Array)*/:Function;
		public var onRollOver/*(path:Array)*/:Function;
		public var onRollOut/*(path:Array)*/:Function;
		public var onAnchor:Function;
		public var onInit:Function;
		
		public function get anchor():Array
		{
			return rootMenu._anchor;
		}
		public function set anchor(v:Array):void
		{
			if (ArrayUtil.equal(anchor, v))
				return;
				
			rootMenu._anchor = v;
			showAnchor();
		}
		
		public function get prefix():String
		{
			return rootMenu._prefix;
		}
		public function set prefix(v:String):void
		{
			rootMenu._prefix = v;
		}
		
		public function get depth():int
		{
			return _depth;
		}
		public function get rootMenu():CINavMenu
		{
			return _root;
		}
		
		public function showAnchor():void
		{
			var menu:CINavMenu = curr;
			while (menu.depth > 0)
			{
				if (menu.__inAnchor())
					break;
				else
					menu.close();
					
				menu = CINavMenu(menu.parent);
			}
			
			if(menu.depth < anchor.length)
				menu = menu[prefix + anchor[menu.depth]];
				
			if(menu) menu.open();
			
			if(onAnchor!=null) onAnchor();
		}
		
		public function CINavMenu() 
		{
			if (stage)
				__init(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, __init);
		}
		
		private function __init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, __init);
			addEventListener(Event.REMOVED_FROM_STAGE, __destroy);
			
			buttonMode = true;
			
			_depth = 0;
			_root = this;
			while (_root.parent is CINavMenu)
			{
				_root = CINavMenu(_root.parent);
				++_depth;
			}
			
			if (rootMenu == this)
			{
				_outTimer = new NavTimer(320);
				_anchor = [];
				_curr = this;
				_isMouseOver = false;
				_prefix = 'menu';
				open();
			}
			else
			{
				addEventListener(MouseEvent.MOUSE_OVER, __overHandler);
				addEventListener(MouseEvent.MOUSE_OUT, __outHandler);
				addEventListener(MouseEvent.CLICK, __clickHandler);
				
				if (__inAnchor() && !isMouseOver)
					open();
				else
					gotoAndStop(1);
			}
			
			if (onInit != null) onInit();
		}
		
		private function __isLineal(menu:CINavMenu):Boolean
		{
			if(depth == menu.depth) return false;
			var c:CINavMenu, p:CINavMenu;
			if(depth > menu.depth)
			{
				c = this;
				p = menu;
			}
			else
			{
				c = menu;
				p = this;
			}
			
			while(c)
			{
				if(c == p) return true;
				c = c.parent as CINavMenu;
			}
			
			return false;
		}
		
		private function __inAnchor():Boolean
		{
			if (!anchor) return false;
			if (anchor.length == 0) return false;
			if (depth == 0) return true;
			
			var id:String = anchor[depth - 1];
			return this.name == prefix + id && CINavMenu(parent).__inAnchor();
		}
		
		private function __destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, __destroy);
			removeEventListener(MouseEvent.MOUSE_OVER, __overHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, __outHandler);
			removeEventListener(MouseEvent.CLICK, __clickHandler);
			
			if (rootMenu == this)
			{
				outTimer.destory();
			}
		}
		
		private function __getPath():Array
		{
			var path:Array = [];
			var p:CINavMenu = this;
			while (p.depth > 0)
			{
				path.push( p.name.substr(prefix.length) );
				p = CINavMenu(p.parent);
			}
			path.reverse();
			return path;
		}
		
		private function __clickHandler(e:MouseEvent):void 
		{
			e.stopPropagation();
			
			if (rootMenu.onClick != null)
				rootMenu.onClick(__getPath());
		}
		
		private function __overHandler(e:MouseEvent):void 
		{
			e.stopPropagation();
			
			// 防止上层菜单被深层菜单影响，但不考虑一直显示的root
			if (depth > curr.depth && curr != rootMenu && !__isLineal(curr))
				return;
			
			isMouseOver = true;
			outTimer.stop();
			
			if (curr == this)
				return;
				
			if (curr != null)
				curr.close(depth);
				
			open();
			
			if (rootMenu.onRollOver != null)
				rootMenu.onRollOver(__getPath());
		}
		
		private function __outHandler(e:MouseEvent):void 
		{
			e.stopPropagation();
			
			isMouseOver = false;
			outTimer.restart(rootMenu);
			
			if (rootMenu.onRollOut != null)
				rootMenu.onRollOut(__getPath());
		}
		
		private function __show():void
		{
			MovieClipUtil.playToEnd(this);
		}
		
		private function __hide():void
		{
			MovieClipUtil.playToStart(this);
		}
		
		private function open():void
		{
			__show();
			curr = this;
		}
		private function close( toDepth:int = -1 ):void
		{
			if (depth == 0) return;
			
			if (toDepth == -1) toDepth = depth;
			if (depth < toDepth) return;
			
			CINavMenu(parent).close(toDepth);
			__hide();
		}
		
		private function get outTimer():NavTimer
		{
			return rootMenu._outTimer;
		}
		private function set isMouseOver(v:Boolean):void
		{
			rootMenu._isMouseOver = v;
		}
		private function get isMouseOver():Boolean
		{
			return rootMenu._isMouseOver;
		}
		
		private function set curr(v:CINavMenu):void
		{
			rootMenu._curr = v;
		}
		private function get curr():CINavMenu
		{
			return rootMenu._curr;
		}
		
	}
	
}
import flash.events.TimerEvent;
import flash.utils.Timer;
import as3.display.CINavMenu;

class NavTimer extends Timer
{
	private var _target:CINavMenu;
	
	public function NavTimer(delay:Number)
	{
		super(delay, 1);
		
		addEventListener(TimerEvent.TIMER_COMPLETE, __completeHandler);
	}
	public function destory():void
	{
		removeEventListener(TimerEvent.TIMER_COMPLETE, __completeHandler);
		stop();
		_target = null;
	}
	public function restart(target:CINavMenu):void
	{
		_target = target;
		reset();
		start();
	}
	
	private function __completeHandler(e:TimerEvent):void 
	{
		_target.showAnchor();
	}
}
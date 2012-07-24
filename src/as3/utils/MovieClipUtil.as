package as3.utils
{
	import flash.display.MovieClip;
	public class MovieClipUtil
	{
		public static function playTo( mc:MovieClip, toFrame:int ):void
		{
			if (toFrame < 1) toFrame = 1;
			else if (toFrame > mc.totalFrames) toFrame = mc.totalFrames;
			MovieClipPlayer.addMovieClip(mc, toFrame);
		}
		
		public static function playToStart( mc:MovieClip ):void
		{
			MovieClipPlayer.addMovieClip(mc, 1);
		}
		
		public static function playToEnd( mc:MovieClip ):void
		{
			MovieClipPlayer.addMovieClip(mc, mc.totalFrames);
		}
	}
}

//______________________________________Movie_Clip_Player
import flash.display.MovieClip;
import flash.events.Event;
import flash.utils.Dictionary;

class MovieClipPlayer
{
	private static var _playerMap:Dictionary;
	
	static function addMovieClip( mc:MovieClip, to:int ):void
	{
		if (!_playerMap) _playerMap = new Dictionary(true);
		if (!(mc in _playerMap)) _playerMap[mc] = new MovieClipPlayer( mc, to );
		
		mc.removeEventListener('onFrame' + _playerMap[mc]._toFrame, __onFrameHandler);
		_playerMap[mc]._toFrame = to;
		mc.addEventListener('onFrame' + to, __onFrameHandler);
		
		if (mc.currentFrame == to)
			removeMovieClip(mc);
		else
			_playerMap[mc].start();
	}
	
	static function removeMovieClip(mc:MovieClip):void
	{
		mc.removeEventListener('onFrame' + _playerMap[mc]._toFrame, __onFrameHandler);
		_playerMap[mc] = null;
		delete _playerMap[mc];
	}
	
	static function __onFrameHandler( e:Event ):void
	{
		var mc:MovieClip = e.target as MovieClip;
		removeMovieClip(mc);
	}

	
	var _target:MovieClip;
	var _toFrame:int;
	
	function MovieClipPlayer( mc:MovieClip, to:int )
	{
		_target = mc;
		_toFrame = to;
	}
	
	function start():void
	{
		_target.addEventListener(Event.ENTER_FRAME, __playing);
	}
	
	private function __playing(e:Event):void 
	{
		if ( _target.currentFrame > _toFrame )
			_target.prevFrame();
		else if ( _target.currentFrame < _toFrame )
			_target.nextFrame();
		else
		{
			_target.removeEventListener(Event.ENTER_FRAME, __playing);
			return;
		}
		
		if(_target.hasEventListener('onFrame' + _target.currentFrame))
			_target.dispatchEvent( new Event( 'onFrame' + _target.currentFrame, false, false ) );
		if (_target.currentFrame == _target.totalFrames)
			if(_target.hasEventListener('onLastFrame'))
				_target.dispatchEvent( new Event( 'onLastFrame', false, false ) );
	}
	
}
package as3.net 
{
	import as3.utils.SystemUtil;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.system.Capabilities;
	
	/**
	 * ...
	 * @author hbb
	 */
	public class SimpleURLLoader
	{
		public static const DATA_FORMAT_TEXT:String = URLLoaderDataFormat.TEXT;
		public static const DATA_FORMAT_BINARY:String = URLLoaderDataFormat.BINARY;
		public static const DATA_FORMAT_VARIABLES:String = URLLoaderDataFormat.VARIABLES;
		public static const DATA_FORMAT_XML:String = 'xml';
		
		/**
		 * 原型：onComplete(data:*):void
		 */
		public var onComplete:Function = __onComplete;
		/**
		 * 原型: onError(msg:String):void
		 */
		public var onError:Function = __onError;
		
		private var _ldr:URLLoader;
		private var _repeat:int;
		private var _request:URLRequest;
		private var _loading:Boolean;
		private var _dataFormat:String;
		private var _httpStatus:int;
		
		/**
		 * 一个使用起来比较懒的URLLoader。
		 * @param	repeat 重试的次数。
		 * @example
		 * var surldr:SimpleURLLoader = new SimpleURLLoader();
		 * surldr.onError = function(msg:String):void
		 * {
		 *    trace(msg + '   ' + surldr.httpStatus);
		 * };
		 * surldr.onComplete = function(data:*):void
		 * {
		 *    trace(data);
		 * };
		 * surldr.loadURL('test.php', 'http://myhost/mypath/');
		 */
		public function SimpleURLLoader(repeat:int = 5) 
		{
			_ldr = new URLLoader();
			_ldr.addEventListener(IOErrorEvent.IO_ERROR, __ioErrorHandler, false, 0, true);
			_ldr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __securityErrorHandler, false, 0, true);
			_ldr.addEventListener(HTTPStatusEvent.HTTP_STATUS, __httpStatusHandler, false, 0, true);
			_ldr.addEventListener(Event.COMPLETE, __completeHandler, false, 0, true);
			
			_repeat = repeat;
			this.dataFormat = DATA_FORMAT_TEXT;
		}
		
		/**
		 * 类似URLLoader.dataFormat，多了一种'xml'。
		 */
		public function get dataFormat():String { return _dataFormat; }
		public function set dataFormat(v:String):void
		{
			_dataFormat = v;
			_ldr.dataFormat = (v == DATA_FORMAT_XML) ? DATA_FORMAT_TEXT : v;
		}
		
		/**
		 * 类似HTTPStatusEvent.status。
		 */
		public function get httpStatus():int { return _httpStatus; }
		
		/**
		 * 比较懒的方法，参数只需一个链接即可。
		 * @param	url	指定链接。
		 * @param	testPath	只有在IDE中有效的测试地址。
		 */
		public function loadURL(url:String, testPath:String = ''):void
		{
			load( new URLRequest(url), testPath );
		}
		
		/**
		 * 和URLLoader.load一样。
		 * @param	request
		 * @param	testPath	只有在IDE中有效的测试地址。
		 */
		public function load(request:URLRequest, testPath:String = ''):void
		{
			if (testPath)
				if(!SystemUtil.isBrowser)
					request.url = testPath + request.url;
			
			_loading = true;
			_request = request;
			_httpStatus = 0;
			try{
				_ldr.load(request);
			}catch (er:Error) {
				__destroy();
				throw er;
			}
		}
		
		//_______________________________________________________
		//
		//____________________Private.Methods____________________
		//
		//_______________________________________________________
		
		private function __destroy():void
		{
			_ldr.removeEventListener(IOErrorEvent.IO_ERROR, __ioErrorHandler);
			_ldr.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __securityErrorHandler);
			_ldr.removeEventListener(HTTPStatusEvent.HTTP_STATUS, __httpStatusHandler);
			_ldr.removeEventListener(Event.COMPLETE, __completeHandler);
		}
		
		private function __completeHandler(e:Event):void 
		{
			_loading = false;
			
			try {
				var data:* = (_dataFormat == DATA_FORMAT_XML) ? new XML(_ldr.data) : _ldr.data
			}catch (er:Error) {
				onError('数据转型出错！当前的数据格式为<' + dataFormat + '>');
			}
			
			onComplete(data);
		}
		
		private function __httpStatusHandler(e:HTTPStatusEvent):void 
		{
			_httpStatus = e.status;
		}
		
		private function __securityErrorHandler(e:SecurityErrorEvent):void
		{
			_loading = false;
			onError('安全错误！');
			__destroy();
		}
		
		private function __ioErrorHandler(e:IOErrorEvent):void 
		{
			if (!_loading) return;
			_loading = false;
			
			if (0 == _repeat)
			{
				onError('超过重试次数！');
				__destroy();
				return;
			}
			
			--_repeat;
			load(_request);
		}
		
		private function __onComplete(data:*):void{}
		private function __onError(msg:String):void{}
		
	}
	
}
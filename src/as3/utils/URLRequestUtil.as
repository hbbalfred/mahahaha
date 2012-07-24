package as3.utils 
{
	import flash.display.DisplayObject;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author hbb
	 */
	public class URLRequestUtil
	{
		/**
		 * 为request添加一个随机数，字段为random4nocache
		 * @param	req
		 * @return
		 */
		public static function random( req:URLRequest ):URLRequest
		{
			if (!req.data) req.data = new URLVariables();
			req.data.random4nocache = Math.random();
			return req;
		}
		
		/**
		 * 打包一个request
		 * @param	url
		 * @param	data
		 * @param	method
		 * @return
		 */
		public static function pack(url:String, data:*= null, method:String = 'POST'):URLRequest
		{
			var req:URLRequest = new URLRequest();
			req.url = url;
			req.data = data;
			req.method = method;
			return req;
		}
		
		/**
		 * 将一个对象的属性或者一个实例的公共变量，作为URLVariables的字段，并返回。
		 * @param	objOrDictOrInstance	可以是一个Object,Dictionary,Instance。
		 * @param	filter 过滤对象
		 * @example
		 * var ob:Object = { x:'5', y:5, scaleX:true, currentFrame:testObjectToURLVariables, _x:123 };
		 * var uv:URLVariables = URLRequestUtil.obj2urlv(ob, new MovieClip());
		 * trace(uv.x); // null
		 * trace(uv._x); // 123
		 * @return
		 */
		public static function obj2urlv(objOrDictOrInstance:*, filter:Object = null):URLVariables
		{
			var map:Object;
			switch(getQualifiedClassName(objOrDictOrInstance))
			{
				case 'flash.utils::Dictionary':
				case 'Object': map = objOrDictOrInstance; break;
				default:
					map = { };
					var vs:XMLList = describeType(objOrDictOrInstance).variable;
					var i:int = vs.length();
					var nam:String;
					while (--i > -1)
					{
						nam = vs[i].@name;
						map[nam] = objOrDictOrInstance[nam];
					}
					
			}
			
			var uv:URLVariables = new URLVariables();
			for (var key:String in map)
			{
				if (filter && (key in filter)) continue;
				uv[key] = map[key] || '';
			}
			return uv;
		}
		
		//取绝对路径,getGlobaUrl()+"xxx.swf";
		public static function getGlobalUrl (tar:DisplayObject):String
		{
		   var selfUrl:String = tar.loaderInfo.url;
		   return (selfUrl.slice(0,selfUrl.lastIndexOf("/") + 1));
		}
	}

}
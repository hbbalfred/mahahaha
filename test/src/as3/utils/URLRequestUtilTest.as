package as3.utils
{
	import as3.utils.URLRequestUtil;
	import asunit.framework.TestCase;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author hbb
	 */
	public class URLRequestUtilTest extends TestCase
	{
		
		public function URLRequestUtilTest(testMethod:String = null) 
		{
			super(testMethod);
		}
		
		public function testPackURLRequest():void
		{
			var req:URLRequest = URLRequestUtil.pack('test.com');
			assertEquals(req.url, 'test.com');
			assertNull(req.data);
			assertEquals(req.method, URLRequestMethod.POST);
		}
		
		public function testPackURLRequestWithRandom():void
		{
			var req:URLRequest = URLRequestUtil.random( URLRequestUtil.pack('test.com') );
			assertNotNull(req.data);
			assertNotNull(req.data.random4nocache);
		}
		
		public function testInstanceToURLVariablesWithFilter():void
		{
			var ob:MyObj = new MyObj();
			ob.v1 = '5';
			ob.v2 = 5;
			ob.v3 = true;
			ob.v4 = function():void { };
			ob.v5 = new MyObj();
			
			var uv:URLVariables = URLRequestUtil.obj2urlv(ob, {v1:null, v2:null, v5:null});
			assertNull(uv.v1);
			assertNull(uv.v2);
			assertTrue(uv.v3);
			assertNotNull(uv.v4);
			assertNull(uv.v5);
		}
		
		public function testObjectToURLVariablesWithFilter():void
		{
			var ob:Object = { x:'5', y:5, scaleX:true, currentFrame:testObjectToURLVariables, _x:123 };
			
			var uv:URLVariables = URLRequestUtil.obj2urlv(ob, new MovieClip());
			assertNull(uv.x);
			assertNull(uv.y);
			assertNull(uv.scaleX);
			assertNull(uv.currentFrame);
			assertEquals(uv._x, 123);
		}
		
		public function testDictionaryToURLVariables():void
		{
			var ob:Dictionary = new Dictionary();
			ob.v1 = '5';
			ob.v2 = 5;
			ob.v3 = true;
			ob.v4 = function():void { };
			ob.v5 = new MyObj();
			
			var uv:URLVariables = URLRequestUtil.obj2urlv(ob);
			assertEquals(uv.v1, '5');
			assertEquals(uv.v2, 5);
			assertTrue(uv.v3);
			assertNotNull(uv.v4);
			assertNotNull(uv.v5);
			
		}
		
		public function testObjectToURLVariables():void
		{
			var ob:Object = { v1:'5', v2:5, v3:true, v4:testObjectToURLVariables, v5:new MyObj() };
			
			var uv:URLVariables = URLRequestUtil.obj2urlv(ob);
			assertEquals(uv.v1, '5');
			assertEquals(uv.v2, 5);
			assertTrue(uv.v3);
			assertNotNull(uv.v4);
			assertNotNull(uv.v5);
			
		}
		public function testInstanceToURLVariables():void
		{
			var ob:MyObj = new MyObj();
			ob.v1 = '5';
			ob.v2 = 5;
			ob.v3 = true;
			ob.v4 = function():void { };
			ob.v5 = new MyObj();
			
			var uv:URLVariables = URLRequestUtil.obj2urlv(ob);
			assertEquals(uv.v1, '5');
			assertEquals(uv.v2, 5);
			assertTrue(uv.v3);
			assertNotNull(uv.v4);
			assertNotNull(uv.v5);
		}
		
		public function testEmptyInstanceToURLVariables():void
		{
			var ob:MyObj = new MyObj();
			var uv:URLVariables = URLRequestUtil.obj2urlv(ob);
			assertEquals(uv.v1, '');
			assertEquals(uv.v2, '');
			assertEquals(uv.v3, '');
			assertEquals(uv.v4, '');
			assertEquals(uv.v5, '');
		}
		
	}

}


class MyObj
{
	public var v1:String;
	public var v2:int;
	public var v3:Boolean;
	public var v4:Function;
	public var v5:MyObj;
	public function f1():void { }
	public function f2():void { }
}
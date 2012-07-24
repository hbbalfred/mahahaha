package as3.utils
{
	public class StringUtil
	{
		/**
		 * HTML转义, entity to character
		 * @example convert (&amp;) to (") no include brackets
		 * @example convert (&#39;) to (') no include brackets
		 */
		public static function decodeURIComponent( str:String ):String
		{
			var txt:TextField = new TextField;
			txt.htmlText = decodeURIComponent(str);
			return txt.text;
		}
		
		/**
		 * 判断给定字符串是否为空
		 * 
		 * @param	str
		 * @return
		 */
		public static function isWhite( str:String ):Boolean
		{
			var reg:RegExp = /^\s*$/m;
			return reg.test(str);
		}
		/**
		 * 判断给定字符串是否为Email格式
		 * 
		 * @param	str
		 * @return
		 */
		public static function isEmail( str:String ):Boolean
		{
			var reg:RegExp = /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i;
			return reg.test(str);
		}
		
		/**
		 * 去除给定字符串头尾空白
		 * 
		 * @param	str
		 * @return
		 */
		public static function trim( str:String ):String
		{
			return rtrim(ltrim(str));
		}
		
		/**
		 * 去除给定字符头部空白
		 * 
		 * @param	str
		 * @return
		 */
		public static function ltrim( str:String ):String
		{
			var i:int = 0, ii:int = str.length;
			for(; i < ii; ++i)
			{
				if(str.charCodeAt(i) > 32)
				{
					return str.substr(i);
				}
			}
			return '';
		}
		
		/**
		 * 去除给定字符尾部空白
		 * 
		 * @param	str
		 * @return
		 */
		public static function rtrim( str:String ):String
		{
			var i:int = str.length - 1;
			for (; i > -1; --i)
			{
				if (str.charCodeAt(i) > 32)
				{
					return str.substr(0, i+1);
				}
			}
			return '';
		}
		
		/**
		 * 全角(SBC)和半角(DBC)相互转换，只支持ASCII
		 * 全角空格为12288，半角空格为32
		 * 其他字符半角(33-126)与全角(65281-65374)的对应关系是：均相差65248
		 */
		
		/**
		 * 将给定字符串中的半角符号转为全角符号
		 * 
		 * @param	str
		 * @param	alsoSpace 空格是否也需要被转换
		 * @return	
		 * @link	http://hardrock.cnblogs.com/archive/2005/09/27/245255.html
		 */
		public static function toSBC(str:String, alsoSpace:Boolean = true):String
		{
			var a:Array = str.split('');
			var i:int = a.length;
			while (--i > -1)
			{
				var c:uint = str.charCodeAt(i);
				if(32 == c && alsoSpace)
					a[i] = String.fromCharCode(12288);
				else if(c>=33 && c<=126)
					a[i] = String.fromCharCode(c + 65248);
			}
			return a.join('');
		}
		
		/**
		 * 将给定字符串中的全角符号转为半角符号
		 * 
		 * 全角(SBC)和半角(DBC)相互转换，只支持ASCII
		 * 全角空格为12288，半角空格为32
		 * 其他字符半角(33-126)与全角(65281-65374)的对应关系是：均相差65248
		 * 
		 * @param	str
		 * @param	alsoSpace 空格是否也需要被转换
		 * @return	
		 * @link	http://hardrock.cnblogs.com/archive/2005/09/27/245255.html
		 */
		public static function toDBC(str:String, alsoSpace:Boolean = true):String
		{
			var a:Array = str.split('');
			var i:int = a.length;
			while (--i > -1)
			{
				var c:uint = str.charCodeAt(i);
				if(12288 == c && alsoSpace)
					a[i] = String.fromCharCode(32);
				else if(c>=65281 && c<=65374)
					a[i] = String.fromCharCode(c-65248);
			}
			return a.join('');
		}
	}
}
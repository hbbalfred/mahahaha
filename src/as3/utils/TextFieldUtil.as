package as3.utils
{
	import flash.text.TextField;
	public class TextFieldUtil
	{
		public static function truncate( tf:TextField, end:String = '...' ):void
		{
			if ( 'none' == tf.autoSize && tf.width < tf.textWidth + 4)
			{
				var text:String = tf.text;
				var width:Number = tf.width;
				var height:Number = tf.height;
				while ( width < tf.textWidth + 4
				|| height < tf.textHeight + 4 )
				{
					text = text.substr(0, -1);
					tf.text = text + end;
				}
			}
		}
	}
}
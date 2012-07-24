package as3.utils 
{
	/**
	 * ...
	 * @author hbb
	 */
	public class DateUtil
	{
		/**
		 * 从指定年月，返回日期数。包括闰年的29号。
		 * @param	year
		 * @param	month
		 * @return
		 */
		public static function getDays(year:int, month:int):int
		{
			if (month < 1) month = 1;
			else if (month > 12) month = 12;
			
			if (2 == month)
			{
				return (29 == new Date(year, month - 1, 29).getDate()) ? 29 : 28;
			}
			else if (4 == month || 6 == month || 9 == month || 11 == month)
			{
				return 30;
			}
			else
			{
				return 31;
			}
		}
		/*根据毫秒返回固定的时间格式
		 * 
		*/
		public static function formatTime(ms:Number,format:String="mmss"):String
		{
			//计算天
			ms = ms / 1000;
			var days=ms>=86400?Math.floor(ms/86400):0;
			var temp = ms-86400 * days;
			//小时
			var hour = (temp>=3600 && temp<86400) ? Math.floor(temp/3600) : 0;
			//计算分钟
			temp = ms-86400*days-3600*hour;
			var minute = (temp>=60 && temp<3600) ? Math.floor(temp/60) : 0;
			//计算秒
			temp = ms-86400 * days - 3600 * hour - 60 * minute;
			var second = (temp > 0 && temp < 60) ? Math.floor(temp) : 0;
			
			var shour:String = String(hour).length == 1?"0" + String(hour):String(hour);
			var sminute:String = String(minute).length == 1?"0" + String(minute):String(minute);
			var ssecond:String = String(second).length == 1?"0" + String(second):String(second);
			
			switch(format)
			{
				case "ddhhmmss":
				return days+":"+shour + ":" + sminute + ":" + ssecond;
				break;
				case "hhmmss":
				return shour + ":" + sminute + ":" + ssecond;
				break;
				
				
				default:
				return sminute + ":" + ssecond;
				break;
			}
		}
	}

}
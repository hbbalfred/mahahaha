package as3.controls 
{
	import as3.utils.DateUtil;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.events.Event;
	import as3.controls.utils.DataProviderUtil;
	/**
	 * ...
	 * @author hbb
	 */
	public class YMDAssociator implements ITextResolver
	{
		public static const MIN_YEAR:int = 0;
		public static const MAX_YEAR:int = 3000;
		
		private var _yearResolver:ITextResolver;
		private var _monthResolver:ITextResolver;
		private var _dateResolver:ITextResolver;
		
		private var _startYear:int;
		private var _endYear:int;
		
		private var _yearComboBox:ComboBox;
		private var _monthComboBox:ComboBox;
		private var _dateComboBox:ComboBox;
		
		private var _year:int;
		private var _month:int;
		private var _date:int;
		
		/**
		 * 年月日联动选择器。
		 * 
		 * 此联动器不强制必须具备年月日，可以是年月，月日这样的搭配。
		 * 如果有年份选择器，可以设置起止年份，但不得超过规定的范围.
		 * 如果是月日的搭配，年份可以自定义，同样不能超过范围。默认是当前机器时间的年份。
		 * 年份范围是静态常量，如有需要只能修改类文件。
		 * 
		 * @param	yearComboBox
		 * @param	monthComboBox
		 * @param	dateComboBox
		 * @param	prompt
		 * @param	startYear
		 * @param	endYear
		 * 
		 * @throws	ArgumentError	年月日3个下拉菜单都没有设置时，或年份超过范围时。
		 * 
		 */
		public function YMDAssociator(
			yearComboBox:ComboBox = null,
			monthComboBox:ComboBox = null,
			dateComboBox:ComboBox = null,
			prompt:String = '请选择',
			startYear:int = 1949,
			endYear:Number = NaN
			) 
		{
			if (!yearComboBox && !monthComboBox && !dateComboBox) throw new ArgumentError('ymd都是null！');
			if (startYear < MIN_YEAR || endYear < MIN_YEAR) throw new ArgumentError('年份不能小于'+MIN_YEAR);
			if (startYear > MAX_YEAR || endYear > MAX_YEAR) throw new ArgumentError('年份不得大于'+MAX_YEAR);
			
			if (isNaN(endYear)) endYear = new Date().getFullYear();
			
			_yearComboBox = yearComboBox;
			_monthComboBox = monthComboBox;
			_dateComboBox = dateComboBox;
			
			_startYear = startYear;
			_endYear = endYear;
			
			__init(_yearComboBox, prompt);
			__init(_monthComboBox, prompt);
			__init(_dateComboBox, prompt);
			
			_year = _yearComboBox ? 0 : new Date().getFullYear();
			_month = _monthComboBox ? 0 : new Date().getMonth() + 1;
			_date = _dateComboBox ? 0 : new Date().getDate();
			
			dateResolver = monthResolver = yearResolver = this;
		}
		
		/**	@inheritDoc	*/
		public function resolve(value:String):String { return value; }
		
		/**
		 * 获取、设置年份。
		 */
		public function get year():int { return _year; }
		public function set year(v:int):void
 		{
			if (v < MIN_YEAR) throw new ArgumentError('年份不能小于' + MIN_YEAR);
			if (v > MAX_YEAR) throw new ArgumentError('年份不得大于' + MAX_YEAR);
			
			if (_year == v) return;
			if (_yearComboBox) {
				if (v < Math.min(_startYear, _endYear)) return;
				if (v > Math.max(_startYear, _endYear)) return;
			}
			
			_year = v;
			__renderYear();
			__renderDate();
		}
		
		/**
		 * 获取、设置月份。
		 */
		public function get month():int { return _month; }
		public function set month(v:int):void
 		{
			if (_month == v) return;
			if (v < 1) return;
			if (v > 12) return;
			
			_month = v;
			__renderMonth();
			__renderDate();
		}
		
		/**
		 * 获取、设置日期。
		 */
		public function get date():int { return _date; }
		public function set date(v:int):void 
		{
			if (_date == v) return;
			if (v < 1) return;
			if (v > DateUtil.getDays(year, month)) return;
			
			_date = v;
			__renderDate();
		}
		
		/**
		 * 获取、设置文本格式的年份。
		 */
		public function get yearText():String
		{
			return _yearComboBox && _yearComboBox.selectedIndex > -1 ? _yearComboBox.value : '';
		}
		public function set yearText(v:String):void 
		{
			var i:int = __indexOf(_yearComboBox, v)
			if (i == -1) return;
			
			var d:int = _startYear > _endYear ? -1 : 1;
			year = _startYear + d * i;
		}
		
		/**
		 * 获取、设置文本格式的月份。
		 */
		public function get monthText():String
		{
			return _monthComboBox && _monthComboBox.selectedIndex > -1 ? _monthComboBox.value : '';
		}
		public function set monthText(v:String):void 
		{
			month = __indexOf(_monthComboBox, v) + 1;
		}
		
		/**
		 * 获取、设置文本格式的日期。
		 */
		public function get dateText():String
		{
			return _dateComboBox && _dateComboBox.selectedIndex > -1 ? _dateComboBox.value : '';
		}
		public function set dateText(v:String):void 
		{
			date = __indexOf(_dateComboBox, v) + 1;
		}
		
		/**
		 * 设置年份解析器。
		 */
		public function get yearResolver():ITextResolver { return _yearResolver; }
		public function set yearResolver(v:ITextResolver):void
		{
			if (_yearResolver == v) return;
			_yearResolver = v;
			__renderYear(true);
		}
		
		/**
		 * 设置月份解析器。
		 */
		public function get monthResolver():ITextResolver { return _monthResolver; }
		public function set monthResolver(v:ITextResolver):void
		{
			if (_monthResolver == v) return;
			_monthResolver = v;
			__renderMonth(true);
		}
		
		/**
		 * 设置日期解析器。
		 */
		public function get dateResolver():ITextResolver { return _dateResolver; }
		public function set dateResolver(v:ITextResolver):void
		{
			if (_dateResolver == v) return;
			_dateResolver = v;
			__renderDate(true);
		}
		
		//________________________________________
		//
		//        Private Methods
		//________________________________________
		
		private function __onChange(e:Event):void 
		{
			var t:ComboBox = e.target as ComboBox;
			if (t == _dateComboBox)
			{
				dateText = _dateComboBox.value;
			}
			else
			{
				if (t == _yearComboBox) yearText = _yearComboBox.value;
				else monthText = _monthComboBox.value;
			}
		}
		
		private function __init(comboBox:ComboBox, prompt:String):void
		{
			if (!comboBox) return;
			
			comboBox.prompt = prompt;
			comboBox.addEventListener(Event.CHANGE, __onChange, false, 0, true);
		}
		
		private function __indexOf(comboBox:ComboBox, v:String):int
		{
			if (!comboBox) return -1;
			if (comboBox.selectedIndex > -1 && comboBox.value == v) return comboBox.selectedIndex;
			return DataProviderUtil.indexOf(comboBox.dataProvider, v);
		}
		
		private function __assign(comboBox:ComboBox, v:int, resolver:ITextResolver):void
		{
			if (!comboBox) return;
			var value:String = resolver.resolve(v.toString());
			if (comboBox.selectedIndex > -1 && comboBox.value == value) return;
			var index:int = DataProviderUtil.indexOf(comboBox.dataProvider, value);
			if (index > -1) comboBox.selectedIndex = index;
		}
		
		private function __render(comboBox:ComboBox, start:int, end:int, resolver:ITextResolver):void
		{
			if (!comboBox) return;
			
			var inc:int = start > end ? -1 : 1;
			var data:Array = [];
			for (var i:int = start; i <= end; i+=inc)
			{
				data.push(resolver.resolve(i.toString()));
			}
			comboBox.dataProvider = new DataProvider(data);
		}
		
		private function __renderYear(redraw:Boolean=false):void
		{
			if(redraw)
				__render(_yearComboBox, _startYear, _endYear, _yearResolver);
			__assign(_yearComboBox, year, _yearResolver);
		}
		
		private function __renderMonth(redraw:Boolean=false):void
		{
			if(redraw)
				__render(_monthComboBox, 1, 12, _monthResolver);
			__assign(_monthComboBox, month, _monthResolver);
		}
		
		private function __renderDate(redraw:Boolean=false):void
		{
			var days:int = DateUtil.getDays(year, month);
			if(redraw || date > days)
				__render(_dateComboBox, 1, days, _dateResolver);
				
			__assign(_dateComboBox, date, _dateResolver);
			if (date > days) _date = 0;
		}
	}

}

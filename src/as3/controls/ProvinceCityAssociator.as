package as3.controls 
{
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.events.Event;
	/**
	 * ...
	 * @author hbb
	 */
	public class ProvinceCityAssociator
	{
		private var _provComboBox:ComboBox;
		private var _cityComboBox:ComboBox;
		
		private var _data:XML;
		
		/**
		 * 省城联动选择器。
		 * 
		 * @param	provComboBox	省份下拉菜单
		 * @param	cityComboBox	城镇下拉菜单
		 * @param	prompt			下拉菜单的初始显示文字（默认：请选择）
		 * 
		 * @throws	ArgumentError	provComboBox和cityComboBox是同一个实例时。
		 */
		public function ProvinceCityAssociator(provComboBox:ComboBox, cityComboBox:ComboBox, prompt:String='请选择') 
		{
			if (provComboBox == cityComboBox) {
				throw new ArgumentError('prov combo box == city combo box');
			}
			
			_provComboBox = provComboBox;
			_cityComboBox = cityComboBox;
			
			_provComboBox.prompt = prompt;
			_cityComboBox.prompt = prompt;
			
			_provComboBox.addEventListener(Event.CHANGE, __onChange, false, 0, true);
			_cityComboBox.addEventListener(Event.CHANGE, __onChange, false, 0, true);
			
			data = new XML();
		}
		
		public function set data(v:XML):void
		{
			if (!v || _data == v) return;
			_data = v;
			_provComboBox.dataProvider = new DataProvider( v );
		}
		
		/**
		 * 获取、设置省份。
		 */
		public function get province():String
		{
			return _provComboBox.selectedIndex == -1 ? '' : _provComboBox.value;
		}
		public function set province(v:String):void
		{
			var node:XML = __getProvXMLNode(v);
			if (!node) return;
			var index:int = node.childIndex();
			if (_provComboBox.selectedIndex == index) return;
			_provComboBox.selectedIndex = node.childIndex();
			__provinceChangeHandler();
		}
		
		/**
		 * 获取、设置城镇。
		 */
		public function get city():String
		{
			return _cityComboBox.selectedIndex == -1 ? '' : _cityComboBox.value;
		}
		public function set city(v:String):void
		{
			var node:XML = __getCityXMLNode(v, province);
			if (!node) return;
			_cityComboBox.selectedIndex = node.childIndex();
		}
		
		/**
		 * 仅从城镇设置省份。
		 */
		public function set cityNoProvince(v:String):void
		{
			var node:XML = __getCityXMLNode(v);
			if (!node) return;
			province = node.parent().@label;
			city = v;
		}
		
		//________________________________________
		//
		//        Private Methods
		//________________________________________
		private function __onChange(e:Event):void 
		{
			switch(e.target)
			{
				case _provComboBox: __provinceChangeHandler(); break;
				case _cityComboBox:
				default:
			}
		}
		
		private function __provinceChangeHandler():void
		{
			var node:XML = __getProvXMLNode(_provComboBox.value);
			if (!node) return;
			_cityComboBox.dataProvider = new DataProvider( node );
		}
		
		private function __getProvXMLNode(prov:String):XML
		{
			return _data.prov.(@label == prov)[0];
		}
		
		private function __getCityXMLNode(city:String, prov:String=null):XML
		{
			if (prov == null)
				return _data.prov.city.(@label == city)[0];
			return _data.prov.(@label == prov).city.(@label == city)[0];
		}
		
		
	}

}

package game.component
{
	/**
	 * @author Kramer(QQ:21524742)
	 */		
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[Event(name="change", type="flash.events.Event")]
	public class List extends Container
	{
		public static const ITEM_PREFIX:String 		= "item_";
		public static const ORIENTATION_COLUMN:int 	= 0;
		public static const ORIENTATION_ROW:int 	= 1;
		public static const DEFAULT_GAP:int 		= 3;
		
		private var _itemList:Vector.<ListItemBase>;
		private var _itemSkin:Object;
		
		private var _horizontalGap:int; //item水平间距
		private var _verticalGap:int;	//item垂直间距
		private var _columnCount:int;	//横向item数量
		private var _rowCount:int;		//纵向item数量
		private var _orientation:int    //填充item的方向
		
		private var _selectedItem:ListItemBase;
		
		public function List()
		{
			super();
			initialize();
		}

		private function initialize():void
		{
			_itemList = new Vector.<ListItemBase>();
			_orientation = 0;
			_columnCount = 1;
			_rowCount = int.MAX_VALUE;
			_horizontalGap = DEFAULT_GAP;
			_verticalGap = DEFAULT_GAP;
		}
		
		public override function set skin(value:Object):void
		{
			_itemSkin = value.item;
			super.skin = value;
		}
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			var tempChild:DisplayObject = super.addChild(child); 
			var item:ListItemBase = tempChild as ListItemBase; 
			if(item != null)
			{
				item.skin = _itemSkin;
				addItemToList(item);
			}
			return tempChild;
		}
		
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			var tempChild:DisplayObject = super.addChildAt(child, index); 
			var item:ListItemBase = tempChild as ListItemBase;
			if(item != null)
			{
				item.skin = _itemSkin;
				var insertIndex:int = findInsertIndex(index);
				addItemToList(item, insertIndex);
			}
			return tempChild;
		}
		
		private function findInsertIndex(index:int):int
		{
			var item:ListItemBase;
			while(true)
			{
				item = this.getChildAt(index) as ListItemBase;
				if(item != null)
				{
					break;
				}
				index--;
			}
			var existIndex:int = _itemList.indexOf(item);
			if(existIndex > -1)
			{
				return existIndex;
			}
			return 0;
		}
		
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			var tempChild:DisplayObject = super.removeChild(child);
			var item:ListItemBase = tempChild as ListItemBase;
			if(item != null)
			{
				removeItemFromList(item);
			}
			return tempChild;
		}
		
		public override function removeChildAt(index:int):DisplayObject
		{
			var tempChild:DisplayObject = super.removeChildAt(index); 
			var item:ListItemBase = tempChild as ListItemBase;
			if(item != null)
			{
				removeItemFromList(item);
			}
			return tempChild;
		}
		
		public function removeAllItem():void
		{
			for each(var item:ListItemBase in _itemList)
			{
				super.removeChild(item);
				removeItemEventListener(item);
			}
			_itemList.length = 0;
		}
		
		private function deployItem():void
		{
			var len:int = _itemList.length;
			for(var i:int = 0; i < len; i++)
			{
				var item:ListItemBase = _itemList[i];
				if(_orientation == ORIENTATION_COLUMN)
				{
					var itemHeight:int = item.height;
					item.x = (i % _columnCount) * (item.width + _horizontalGap);
					item.y = int(i / _columnCount) * (item.height + _verticalGap);
				}
				else if(_orientation == ORIENTATION_ROW)
				{
					item.x = int(i / _rowCount) * (item.width + _horizontalGap);
					item.y = (i % _rowCount) * (item.height + _verticalGap);
				}
				item.index = i;
				item.name = ITEM_PREFIX + i;
			}
		}

		private function addItemToList(item:ListItemBase, index:int = int.MAX_VALUE):void
		{
			var existIndex:int = _itemList.indexOf(item);
			if(existIndex == -1)
			{
				_itemList.splice(index, 0, item);
				addItemEventListener(item);
				deployItem();
				updateItemIndex();
			}
		}
		
		private function removeItemFromList(item:ListItemBase):void
		{
			var index:int = _itemList.indexOf(item);
			if(index > -1)
			{
				_itemList.splice(index, 1);
				removeItemEventListener(item);
				deployItem();
				updateItemIndex();
			}
		}
		
		private function updateItemIndex():void
		{
			var len:int = _itemList.length;
			for(var i:int = 0; i < len; i++)
			{
				var item:ListItemBase = _itemList[i];
				item.index = i;
			}
		}
		
		private function addItemEventListener(item:ListItemBase):void
		{
			item.addEventListener(MouseEvent.CLICK, onItemClick);
		}
		
		private function onItemClick(evt:MouseEvent):void
		{
			var item:ListItemBase = evt.currentTarget as ListItemBase;
			if(item == _selectedItem)
			{
				return;
			}
			if(_selectedItem != null)
			{
				_selectedItem.selected = false;
			}
			_selectedItem = item;
			_selectedItem.selected = true;
			dispatchEvent(Component.EVENT_CHANGE);
		}
		
		private function removeItemEventListener(item:ListItemBase):void
		{
			item.removeEventListener(MouseEvent.CLICK, onItemClick);
		}
		
		public function set selection(value:ListItemBase):void
		{
			_selectedItem = value;
		}
		
		public function get selection():ListItemBase
		{
			return _selectedItem;
		}
		
		public function get horizontalGap():int
		{
			return _horizontalGap;
		}
		
		public function set horizontalGap(value:int):void
		{
			_horizontalGap = value;
		}

		public function get verticalGap():int
		{
			return _verticalGap;
		}

		public function set verticalGap(value:int):void
		{
			_verticalGap = value;
		}

		public function get columnCount():int
		{
			return _columnCount;
		}

		public function set columnCount(value:int):void
		{
			_columnCount = value;
		}

		public function get rowCount():int
		{
			return _rowCount;
		}

		public function set rowCount(value:int):void
		{
			_rowCount = value;
		}

		public function get orientation():int
		{
			return _orientation;
		}

		public function set orientation(value:int):void
		{
			_orientation = value;
		}
		
	}
}
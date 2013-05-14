// ActionScript file

package com.indicrowd.audience.skin {
	import flash.events.Event;
	
	public class VolumeEvent extends Event {
		public var obj:Object;
		public function VolumeEvent(type:String, obj:Object)
		{
			super(type, false, false);
			this.obj = obj;
		}
	}
}
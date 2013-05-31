// ActionScript file

package com.indicrowd.audience.player
{	
	import flash.events.Event;
	
	public class VideoDisplay2StatusEvent extends Event
	{
		public var state:VideoDisplay2State;
		
		public function VideoDisplay2StatusEvent(type:String, state:VideoDisplay2State) {
			super(type);
			
			this.state = state;
		}
		
		
	}
	
}
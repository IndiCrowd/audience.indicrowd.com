package com.indicrowd.audience.player
{
	import flash.events.Event;

	public class VideoDisplay2ResolutionEvent extends Event
	{
		public var resolution:String;
		
		public function VideoDisplay2ResolutionEvent(type:String, resolution:String)
		{
			super(type);
			
			this.resolution = resolution;
		}
	}
}
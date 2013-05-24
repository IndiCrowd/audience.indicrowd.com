package com.indicrowd.audience.player
{
	public final class VideoDisplay2State
	{
		public static const PLAY:VideoDisplay2State = new VideoDisplay2State();
		public static const STOP:VideoDisplay2State = new VideoDisplay2State();
		public static const FAULT:VideoDisplay2State = new VideoDisplay2State();
		
		public function toString():String {
			switch(this) {
				case PLAY:
					return "PLAY";
				case STOP:
					return "STOP";
				case FAULT:
					return "FALULT";
				
			}
			return "ERROR";
		}
	}
}
package com.indicrowd.audience.player
{
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.rpc.Fault;
	
	[Event(name="changeState", type="com.indicrowd.audience.player.VideoDisplay2Event")]
	public class VideoDisplay2 extends UIComponent
	{		
		
		private var _video:Video = null;
		
		private var _netConnection:NetConnection = null;
		
		private var _netStream:DynamicStream; 
		
		public var streamName:String;
		
		private var _source:String;
		
		public var state:VideoDisplay2State = VideoDisplay2State.STOP;
		
		public function VideoDisplay2()
		{
			super();
			
			_video = new Video();
			this.addChild(_video);
			_netConnection = new NetConnection();
			
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS, ncOnStatus);
			
			this.addEventListener(ResizeEvent.RESIZE, videoDisplay2_resizeHandler);
		}
		
		protected function videoDisplay2_resizeHandler(event:ResizeEvent):void
		{
			trace ("_video resize : " + this.width + ", " + this.height);
			// TODO Auto-generated method stub
			_video.width = this.width;
			_video.height = this.height;
		}
		
		public function set source(source:String):void {
			_source = source;
			
			if (source == null)
			{
				disconnect();
				return ;
			}
		}
		
		public function get source():String {
			return _source;
		}
		
		public function stop():void
		{
			_netConnection.close();
			_netConnection = null;
		}
		
		
		public function play():void {
			if (!_netConnection.connected)
			{
				disconnect();				
				return ;
			}
			
			if (_netStream == null) {
				_netStream = new DynamicStream(_netConnection);	
				
				_netStream.startBufferLength = 1;
				_netStream.preferredBufferLength = 10;
				_netStream.aggressiveModeBufferLength = 5;
				_netStream.bufferTime = 2;
				
				_netStream.addEventListener(NetStatusEvent.NET_STATUS, ncStreamStatus);
				
				var dsi:DynamicStreamItem = new DynamicStreamItem();
				dsi.addStream(streamName + "_480p", 1060);
				dsi.addStream(streamName + "_360p", 660);
				dsi.addStream(streamName + "_240p", 410);
				dsi.addStream(streamName + "_160p", 260);
				
				_netStream.startPlay(dsi);
			} else {
				_netStream.play();
			}
			
		}
		
		protected function ncOnStatus(infoObject:NetStatusEvent):void
		{
			trace("nc: "+infoObject.info.code+" ("+infoObject.info.description+")");
			if (infoObject.info.code == "NetConnection.Connect.Success")
			{
				play();
			}
			else if (infoObject.info.code == "NetConnection.Connect.Failed") {
				disconnect(true);
			}
			else if (infoObject.info.code == "NetConnection.Connect.Rejected") {
				disconnect(true);
				
			} else if (infoObject.info.code == "NetConnection.Connect.Closed") {
				disconnect(true);
			}
		}
		
		public function connect():Boolean {
			
			if (source == null)
			{
				dispatchEvent(new VideoDisplay2Event("changeState", VideoDisplay2State.STOP));
				return false;
			}
			
			
			if (!_netConnection.connected)
			{	
				_netConnection.connect(source);
			} else {
				play();
			}
			
			return true;
		}
		
		public function disconnect(fault:Boolean = false):void {
			_video.attachNetStream(null);
			
			if (_netStream != null)
			{
				_netStream.close();
				_netStream = null;
			}
			
			state = VideoDisplay2State.FAULT;
			
			if (fault) {
				dispatchEvent(new VideoDisplay2Event("changeState", VideoDisplay2State.FAULT));
			} else {
				dispatchEvent(new VideoDisplay2Event("changeState", VideoDisplay2State.STOP));
			}
		}
		
		public function close():void {
			if (_netConnection.connected)
				_netConnection.close();
			
			dispatchEvent(new VideoDisplay2Event("changeState", VideoDisplay2State.STOP));
		}
		
		protected function ncStreamStatus(infoObject:NetStatusEvent):void
		{
			trace("nca: "+infoObject.info.code+" ("+infoObject.info.description+")");	
			
			switch (infoObject.info.code)
			{
				case "NetStream.Play.StreamNotFound":
				case "NetStream.Play.UnpublishNotify":
					dispatchEvent(new VideoDisplay2Event("changeState", VideoDisplay2State.STOP));
					break;
				case "NetStream.Play.PublishNotify":
					play();
					break;
				case "NetStream.Play.Start":
					
					dispatchEvent(new VideoDisplay2Event("changeState", VideoDisplay2State.PLAY));
					
					_video.attachNetStream(_netStream);
					
					
					break;
				case "NetStream.Play.Transition": // 속도 변경
					break;
				
			}
		}
	}
}


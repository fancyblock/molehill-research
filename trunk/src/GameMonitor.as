package  
{
	import flash.display.Sprite;
	import flash.system.System;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author	Hejiabin
	 * @date	2010.05.24
	 * @usage	monitor the memory and fps of game ( show in the screen )
	 * @example	var monitor:GameMonitor = new GameMonitor();
	 * 			stage.addChild( monitor );
	 */
	public class GameMonitor extends Sprite
	{
		//-------------------------------------- static member -----------------------------------------
		static public var ALIGN_LEFT:String = "align_left";
		static public var ALIGH_RIGHT:String = "align_right";
		
		static private var statistic_interval:int = 2400;
		
		
		//-------------------------------------- private member ----------------------------------------
		private var m_installed:Boolean = false;
		private var m_traceMode:Boolean = false;					//only print trace in output window, not show in flashplayer
		
		private var m_frameCount:int = 0;
		private var m_lastTime:int = 0;
		
		private var m_curFPS:Number = 0;
		private var m_curMemory:uint = 0;
		
		// * only for screen mode
		private var m_position:String = null;
		private var m_boardColor:uint = 0x002f1940;
		private var m_infoBoard:Sprite = null;
		private var m_txtInfo:TextField = null;
		
		
		//------------------------------------- public function ----------------------------------------
		
		/**
		 * generate a GameMonitor
		 * @param	position	set the position of the monitor window ( must be not in trace mode )
		 * @param	onlyTrace	set the show mode; if it's not in trace mode, show a small window in game screen
		 * 											if it's in trace mode, print the trace in output window
		 */
		public function GameMonitor( position:String = "align_left", onlyTrace:Boolean = false ) 
		{
			m_position = position;
			m_traceMode = onlyTrace;
			
			this.addEventListener( Event.ADDED_TO_STAGE, _onInstall );
			this.addEventListener( Event.REMOVED_FROM_STAGE, _onUninstall );
			
		}
		
		
		//------------------------------------- private function ---------------------------------------
		
		// * update the monitor info ( show in flashplayer or print trace )
		private function updateInfo():void
		{
			if ( m_traceMode == true )
			{
				//print the trace into output window of FlashCS or Flex Bulider
				trace( "*-----------------------------------*" );
				trace( "*--FPS: ", m_curFPS.toPrecision( 4 ) );
				trace( "*--Mem: ", m_curMemory / 1024 + " k" );
			}
			else
			{
				m_txtInfo.text = "FPS: " + m_curFPS.toPrecision( 4 ) + "\nMem: " + m_curMemory / 1024 + " k";
				//[unfinished]
			}
		}
		
		// * create two info board for show the fps and memory
		private function createInfoBoard():void
		{
			m_infoBoard = new Sprite();
			
			m_txtInfo = new TextField();
			m_txtInfo.autoSize = TextFieldAutoSize.LEFT;
			m_txtInfo.border = true;
			m_txtInfo.multiline = true;
			m_txtInfo.selectable = false;
			m_txtInfo.background = true;
			m_txtInfo.textColor = m_boardColor;
			m_txtInfo.backgroundColor = 0xffffffff - m_boardColor;
			m_txtInfo.borderColor = m_boardColor;
			m_txtInfo.text = "Game Monitor";
			
			m_infoBoard.addChild( m_txtInfo );
			
			stage.addChild( m_infoBoard );
			if ( m_position == GameMonitor.ALIGH_RIGHT )
			{
				m_infoBoard.x = stage.stageWidth - m_infoBoard.width;
				m_txtInfo.autoSize = TextFieldAutoSize.RIGHT;
			}
			
			m_infoBoard.addEventListener( MouseEvent.MOUSE_DOWN, _onClickInfoBoard );
		}
		
		// * switch the color of infoBoard
		private function switchBoardColor():void
		{
			var oldColor:uint = m_boardColor;
			
			m_boardColor = 0xffffffff - m_boardColor;
			
			m_txtInfo.textColor = m_boardColor;
			m_txtInfo.backgroundColor = oldColor;
			m_txtInfo.borderColor = m_boardColor;
		}
		
		// * destroy the info board
		private function destroyInfoBoard():void
		{
			m_infoBoard.removeEventListener( MouseEvent.MOUSE_DOWN, _onClickInfoBoard );
			
			stage.removeChild( m_infoBoard );
		}
		
		
		//------------------------------------- event callback -----------------------------------------
		
		// * install the monitor when the monitor be add to the game stage
		private function _onInstall( evt:Event ):void
		{
			//if it's not in trace mode, create the info board
			if ( m_traceMode == false )
			{
				createInfoBoard();
			}
			
			this.addEventListener( Event.ENTER_FRAME, _onFrame );
			
			m_installed = true;
		}
		
		// * uninstall the monitor when the monitor be remove from the game stage
		private function _onUninstall( evt:Event ):void
		{
			//if it's not in trace mode, destroy the info board
			if ( m_traceMode == false )
			{
				destroyInfoBoard();
			}
			
			this.removeEventListener( Event.ENTER_FRAME, _onFrame );
			
			m_installed = false;
		}
		
		// * count the frame
		private function _onFrame( evt:Event ):void
		{
			m_frameCount++;
			
			var curTime:int = getTimer();
			var elapseTime:int = curTime - m_lastTime;
			
			//it's time to count the fps and snap the memory
			if ( elapseTime >= statistic_interval )
			{
				m_curMemory = System.totalMemory;
				
				m_curFPS = m_frameCount * 1000 / elapseTime;
				
				m_lastTime = curTime;
				m_frameCount = 0;
				
				updateInfo();
			}

		}
		
		// * click to switch the info board
		private function _onClickInfoBoard( evt:MouseEvent ):void
		{
			switchBoardColor();
		}
		
	}

}
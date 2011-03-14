package 
{
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	[SWF(width="480", height="320", backgroundColor="0xffffff")]
	public class Main extends Sprite 
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		private var m_context3d:Context3D = null;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Main
		 */
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var stage3d:Stage3D = stage.stage3Ds[0];
			
			stage3d.viewPort = new Rectangle( 0, 0, 480, 320 );
			stage3d.addEventListener( Event.CONTEXT3D_CREATE, _onContextCreate );
			stage3d.requestContext3D();
			
			this.addChild( new GameMonitor() );
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
		//callback when context3d be created
		private function _onContextCreate( evt:Event ):void
		{
			var stage3d:Stage3D = evt.target as Stage3D;
			m_context3d = stage3d.context3D;
			
			m_context3d.configureBackBuffer( 480, 320, 2 );
			
			//[unfinished]
			
			this.addEventListener( Event.ENTER_FRAME, _onEnterFrame );
		}
		
		//frame function
		private function _onEnterFrame( evt:Event ):void
		{
			m_context3d.clear( 0, 0, 0 );
			
			//[unfinished]
			
			m_context3d.present();
		}
		
	}
	
}
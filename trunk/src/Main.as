package 
{
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import ShaderLib.BaseShader;
	import ShaderLib.Simple2DShader;
	import ShaderLib.Solid3DShader;
	
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
		private var m_indexBuf:IndexBuffer3D = null;
		
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
			
			//set the shader
			var shader:BaseShader = new Solid3DShader( m_context3d );
			m_context3d.setProgram( shader.SHADERS );
			
			//set the vertex buffer
			var vertexBuf:VertexBuffer3D = m_context3d.createVertexBuffer( 4, 6 );
			vertexBuf.uploadFromVector( Vector.<Number>( [1,1,0,0,0,1, 1,-1,0,0,1,0, -1,-1,0,0,1,1, -1,1,0,1,0,0] ), 0, 4 );
			m_context3d.setVertexBufferAt( 0, vertexBuf, 0, Context3DVertexBufferFormat.FLOAT_3 );
			m_context3d.setVertexBufferAt( 1, vertexBuf, 3, Context3DVertexBufferFormat.FLOAT_3 );
			
			//create the index buffer
			m_indexBuf = m_context3d.createIndexBuffer( 6 );
			m_indexBuf.uploadFromVector( Vector.<uint>([0, 1, 2, 0, 2, 3]), 0, 6 );
			
			//set the matrix
			
			
			this.addEventListener( Event.ENTER_FRAME, _onEnterFrame );
		}
		
		//frame function
		private function _onEnterFrame( evt:Event ):void
		{
			m_context3d.clear( 0, 0, 0 );
			
			m_context3d.drawTriangles( m_indexBuf, 0, 2 );
			
			m_context3d.present();
		}
		
	}
	
}
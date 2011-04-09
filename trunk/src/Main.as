package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import MolehillUtility.Interface.IBase3DTrans;
	import MolehillUtility.Standard3DTrans;
	import OpenGL.GLContext;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	[SWF(width="480", height="320", backgroundColor="0xffffff")]
	public class Main extends Sprite 
	{
		//------------------------------ static member -------------------------------------
		
		[Embed(source='../res/2.png')]
		private var TEX_0:Class;
		
		//------------------------------ private member ------------------------------------
		
		private var m_context3d:Context3D = null;
		private var m_glContext:GLContext = null;
		private var m_indexBuf:IndexBuffer3D = null;
		private var m_trans:IBase3DTrans = null;
		
		private var m_angle:Number = 0;
		
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
			
			m_glContext = new GLContext( m_context3d, 480, 320 );
			
			//set the vertex buffer
			var vertexBuf:VertexBuffer3D = m_context3d.createVertexBuffer( 4, 11 );
			vertexBuf.uploadFromVector( Vector.<Number>( [
															1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0,
															1, -1, 1, 1, 1, 1, 0, 0, 1, 1, 0,
															-1, -1, 1, 1, 1, 1, 0, 0, 1, 1, 1,
															-1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1
														] ), 0, 4 );
			m_context3d.setVertexBufferAt( 0, vertexBuf, 0, Context3DVertexBufferFormat.FLOAT_3 );
//			m_context3d.setVertexBufferAt( 1, vertexBuf, 3, Context3DVertexBufferFormat.FLOAT_3 );
			m_context3d.setVertexBufferAt( 2, vertexBuf, 6, Context3DVertexBufferFormat.FLOAT_3 );
			m_context3d.setVertexBufferAt( 3, vertexBuf, 9, Context3DVertexBufferFormat.FLOAT_2 );
			
			//create the index buffer
			m_indexBuf = m_context3d.createIndexBuffer( 6 );
			m_indexBuf.uploadFromVector( Vector.<uint>([0, 1, 2, 0, 2, 3]), 0, 6 );
			
			//set the transform class
			m_trans = new Standard3DTrans();
			m_trans.SetPerspective( 90, 480.0 / 320.0 );
			m_trans.CameraIdentity();
			m_trans.CAMERA_MATRIX.appendTranslation( 0, 0, -3 );
			m_trans.WorldIdentity();
			
			//set the light
			m_context3d.setProgramConstantsFromVector( Context3DProgramType.VERTEX, 8, Vector.<Number>([0, 0, 1, 1]) );
			
			//set the texture
			var bmp:Bitmap = new TEX_0;
			var text0:Texture = m_context3d.createTexture( 128, 128, Context3DTextureFormat.BGRA, true );
			text0.uploadFromBitmapData( bmp.bitmapData );
			m_context3d.setTextureAt( 0, text0 );
			
			this.addEventListener( Event.ENTER_FRAME, _onEnterFrame );
		}
		
		//frame function
		private function _onEnterFrame( evt:Event ):void
		{
			m_context3d.clear( 0, 0, 0 );
			
			var axs:Vector3D = new Vector3D( 0, 1, 1 );
			axs.normalize();
			
			var angleArr:Array = [0, 90, 180, -90, 90, -90];
			var axsArr:Array = [ new Vector3D( 0, 1, 0 ), new Vector3D( 0, 1, 0 ), new Vector3D( 0, 1, 0 ), new Vector3D( 0, 1, 0 ), new Vector3D( 1, 0, 0 ), new Vector3D( 1, 0, 0 ) ];
			
			for ( var i:int = 0; i < angleArr.length; i++ )
			{
				m_trans.WorldIdentity();
				m_trans.WORLD_MATRIX.appendRotation( angleArr[i], axsArr[i] );
				m_trans.WORLD_MATRIX.appendRotation( m_angle, axs );
				m_context3d.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, 0, m_trans.GetTransMatrix(), true );
				m_context3d.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, 4, m_trans.GetLightMatrix(), true );
				m_context3d.drawTriangles( m_indexBuf, 0, 2 );
			}
			
			m_context3d.present();
			
			m_angle += 1;
		}
		
	}
	
}
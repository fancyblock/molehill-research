package OpenGL 
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import ShaderLib.BaseShader;
	import ShaderLib.Simple3DShader;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class GLContext 
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		private var m_context3d:Context3D = null;
		
		private var m_screenWid:int = 0;
		private var m_screenHei:int = 0;
		
		private var m_matrixs:Array = null;
		private var m_currentMatrix:int = 0;
		
		private var m_currentShadeMode:int = 0;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor
		 * @param	context3d
		 * @param	screenWid
		 * @param	screenHei
		 */
		public function GLContext( context3d:Context3D, screenWid:int, screenHei:int ) 
		{
			//store the info
			m_context3d = context3d;
			
			m_screenWid = screenWid;
			m_screenHei = screenHei;
			
			//configure back buffer
			m_context3d.configureBackBuffer( screenWid, screenHei, 2 );
			
			//set the shader
			var shader:BaseShader = new Simple3DShader( m_context3d );
			m_context3d.setProgram( shader.SHADERS );
			
			//initial the matrixs
			m_matrixs = [ new Matrix3D(), new Matrix3D() ];
		}
		
		/**
		 * @desc	specify which matrix is the current matrix
		 * @param	mode
		 */
		public function glMatrixMode( mode:int ):void
		{
			m_currentMatrix = mode;
		}
		
		/**
		 * @desc	replace the current matrix with the identity matrix
		 */
		public function glLoadIdentity():void
		{
			var curMatrix:Matrix3D = m_matrixs[m_currentMatrix] as Matrix3D;
			
			curMatrix.identity();
		}
		
		/**
		 * @desc	select	flat or	smooth shading
		 * @param	mode
		 */
		public function glShadeModel( mode:int ):void
		{
			m_currentShadeMode = mode;
		}
		
		/**
		 * @desc	specify clear values for the color buffers
		 * @param	red
		 * @param	green
		 * @param	blue
		 * @param	alpha
		 */
		public function glClearColor( red:Number, green:Number, blue:Number, alpha:Number ):void
		{
			
		}
		
		//----------------------------- glu functions -----------------------------------//
		
		/**
		 * @desc	set up a perspective	projection matrix
		 * @param	fovy
		 * @param	aspect
		 * @param	zNear
		 * @param	zFar
		 */
		public function gluPerspective( fovy:Number, aspect:Number, zNear:Number, zFar:Number ):void
		{
			var d:Number = 1 / ( Math.tan( fovy * 0.5 ) );
			
			var factorX:Number = d;
			var factorY:Number = d * aspect;
			
			var projectMatrix:Matrix3D = new Matrix3D( Vector.<Number>([
																			factorX, 0, 0, 0,
																			0, factorY, 0, 0,
																			0, 0, 1, 1,
																			0, 0, 0, 1
																		]) );
																		
			m_matrixs[GLenum.GL_PROJECTION] = projectMatrix;
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}
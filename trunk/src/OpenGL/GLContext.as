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
		
		private var m_clearColor:Array = null;
		
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
			
			//initial the clear color
			m_clearColor = [ 0, 0, 0, 1 ];
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
		 * @desc	multiply	the current matrix by a translation	matrix
		 * @param	x
		 * @param	y
		 * @param	z
		 */
		public function glTranslatef( x:Number, y:Number, z:Number ):void
		{
			var curMatrix:Matrix3D = m_matrixs[m_currentMatrix] as Matrix3D;
			
			var transMatrix:Matrix3D = new Matrix3D();
			transMatrix.identity();
			transMatrix.appendTranslation( x, y, z );
			
			curMatrix.append( transMatrix );
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
			m_clearColor[0] = red;
			m_clearColor[1] = green;
			m_clearColor[2] = blue;
			m_clearColor[3] = alpha;
		}
		
		/**
		 * @desc	specify the clear value for the depth buffer
		 * @param	depth
		 */
		public function glClearDepth( depth:Number ):void
		{
			//[unfinished]
		}
		
		/**
		 * @desc	enable server-side GL
		 * @param	cap
		 */
		public function glEnable( cap:int ):void
		{
			//[unfinished]
		}
		
		/**
		 * @desc	disable server-side GL
		 * @param	cap
		 */
		public function glDisable( cap:int ):void
		{
			//[unfinished]
		}
		
		/**
		 * @desc	clear buffers to preset values
		 * @param	mask
		 */
		public function glClear( mask:uint ):void
		{
			//[unfinished]
			
			m_context3d.clear( m_clearColor[0], m_clearColor[1], m_clearColor[2], m_clearColor[3] );
		}
		
		/**
		 * @desc	delimit the vertices	of a primitive or a group	of like	primitives
		 * @param	mode
		 */
		public function glBegin( mode:int ):void
		{
			//[unfinished]
		}
		
		/**
		 * @desc	delimit the vertices	of a primitive or a group	of like	primitives
		 */
		public function glEnd():void
		{
			//[unfinished]
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
package OpenGL 
{
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class GLenum
	{
		static public const GL_PROJECTION:int = 0;
		static public const GL_MODELVIEW:int = 1;
		
		//shade mode
		static public const GL_FLAT:int = 0;
		static public const GL_SMOOTH:int = 0;
		
		//clear flags
		static public const GL_COLOR_BUFFER_BIT:uint = 0x0001;
		static public const GL_DEPTH_BUFFER_BIT:uint = 0x0002;
		static public const GL_ACCUM_BUFFER_BIT:uint = 0x0004;
		static public const GL_STENCIL_BUFFER_BIT:uint = 0x0008;
		
		//draw mode
		static public const GL_POINTS:int = 0;
		static public const GL_LINES:int = 1;
		static public const GL_LINE_STRIP:int = 2;
		static public const GL_LINE_LOOP:int = 3;
		static public const GL_TRIANGLES:int = 4;
		static public const GL_TRIANGLE_STRIP:int = 5;
		static public const GL_TRIANGLE_FAN:int = 6;
		static public const GL_QUADS:int = 7;
		static public const GL_QUAD_STRIP:int = 8;
		static public const GL_POLYGON:int = 9;
		
	}

}

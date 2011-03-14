package ShaderLib 
{
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class BaseShader 
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		protected var m_context3d:Context3D = null;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of BaseShader
		 * @param	context3d
		 */
		public function BaseShader( context3d:Context3D )
		{
			m_context3d = context3d;
		}
		
		/**
		 * @desc	return the shaders
		 */
		public function get SHADERS():Program3D
		{
			return null;
		}
		
		//------------------------------ private function ----------------------------------
		
		//compile the shaders
		protected function compileShaders( vsArr:Array, psArr:Array ):Program3D
		{
			var program3d:Program3D = m_context3d.createProgram();
			
			var vertexShader:AGALMiniAssembler = new AGALMiniAssembler();
			var pixelShader:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShader.assemble( Context3DProgramType.VERTEX, vsArr.join( "\n" ) );
			pixelShader.assemble( Context3DProgramType.FRAGMENT, psArr.join( "\n" ) );
			
			program3d.upload( vertexShader.agalcode, pixelShader.agalcode );
			
			return program3d;
		}
		
		//------------------------------- event callback -----------------------------------
		
	}

}
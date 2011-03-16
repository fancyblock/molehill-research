package ShaderLib 
{
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	
	/**
	 * ...
	 * @author Hejiabin
	 * @desc	va0 - position
	 * 			va1 - color
	 */
	public class Simple2DShader extends BaseShader 
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of the Simple2DShader
		 * @param	context3d
		 */
		public function Simple2DShader(context3d:Context3D) 
		{
			super(context3d);
		}
		
		/**
		 * @desc	return the shaders
		 */
		override public function get SHADERS():Program3D
		{
			var vertexShader:Array = [
										"mov op,va0",
										"mov v0,va1"
									];
			var pixelShader:Array = [
										"mov oc,v0"
									];
			
			return compileShaders( vertexShader, pixelShader );
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}
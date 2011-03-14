package ShaderLib 
{
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Solid3DShader extends BaseShader 
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Solid3DShader
		 */
		public function Solid3DShader(context3d:Context3D) 
		{
			super(context3d);
		}
		
		/**
		 * @desc	return the shaders
		 */
		override public function get SHADERS():Program3D
		{
			var vertexShader:Array = [
										"m44 op,va0,vc0",
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
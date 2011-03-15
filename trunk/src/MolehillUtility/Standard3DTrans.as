package MolehillUtility 
{
	import flash.geom.Matrix;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import MolehillUtility.Interface.IBase3DTrans;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Standard3DTrans implements IBase3DTrans 
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		private var m_worldMatrix:Matrix3D = null;
		private var m_cameraMatrix:Matrix3D = null;
		private var m_projectMatrix:Matrix3D = null;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Standard3DTrans
		 */
		public function Standard3DTrans() 
		{
			m_worldMatrix = new Matrix3D;
			m_cameraMatrix = new Matrix3D;
			m_projectMatrix = new Matrix3D;
		}
		
		/* INTERFACE MolehillUtility.Interface.IBase3DTrans */
		
		public function GetTransMatrix():Matrix3D 
		{
			var transMatrix:Matrix3D = m_cameraMatrix.clone();
			transMatrix.invert();
			
			transMatrix.prepend( m_worldMatrix );
			transMatrix.append( m_projectMatrix );
			
			return transMatrix;
		}
		
		public function SetPerspective(fovy:Number, aspect:Number):void 
		{
			var d:Number = 1 / ( Math.tan( fovy * 0.5 ) );
			
			var factorX:Number = d;
			var factorY:Number = - d * aspect;
			
			m_projectMatrix = new Matrix3D( Vector.<Number>([
																factorX, 0, 0, 0,
																0, factorY, 0, 0,
																0, 0, 1, 1,
																0, 0, 0, 1
															]) );
		}
		
		public function LookAt(org:Vector3D, dest:Vector3D, up:Vector3D):void
		{
			//[unfinished]
		}
		
		public function get WORLD_MATRIX():Matrix3D 
		{
			return m_worldMatrix;
		}
		
		public function get CAMERA_MATRIX():Matrix3D
		{
			return m_cameraMatrix;
		}
		
		public function WorldIdentity():void 
		{
			m_worldMatrix.identity();
		}
		
		public function CameraIdentity():void 
		{
			m_cameraMatrix.identity();
		}
		
		public function SetWorldMatrix(matrix:Matrix3D):void 
		{
			m_worldMatrix = matrix;
		}
		
		public function SetProjectMatrix(matrix:Matrix3D):void 
		{
			m_projectMatrix = matrix;
		}
		
		public function SetCameraMatrix(matrix:Matrix3D):void 
		{
			m_cameraMatrix = matrix;
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}
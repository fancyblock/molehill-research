/*****************************************************************************
*
* ADOBE SYSTEMS INCORPORATED
* Copyright (C) 2011 Adobe Systems Incorporated
* All Rights Reserved.
*
* NOTICE:  Adobe permits you to use, modify, and distribute this file in 
* accordance with the terms of the Adobe license agreement accompanying it.  
* If you have received this file from a source other than Adobe, then your 
* use, modification, or distribution of it requires the prior written 
* permission of Adobe.
*
*****************************************************************************/

package
{
	import com.adobe.pixelBender3D.*;
	import com.adobe.pixelBender3D.utils.ProgramConstantsHelper;
	import com.adobe.pixelBender3D.utils.VertexBufferHelper;
	
	import flash.display.*;
	import flash.display3D.*;
	import flash.display3D.textures.Texture;
	import flash.events.TimerEvent;
	import flash.geom.*;
	import flash.utils.*;
	
	public class ImageBoxViewer
	{
		[Embed (source="../res/SampleImageWithZoomAndPanParametersFragmentProgram.pb3dasm", mimeType="application/octet-stream")]
		private static const sampleFragmentProgram : Class;
		
		[Embed (source="../res/SampleImageWithZoomAndPanParametersMaterialVertexProgram.pb3dasm", mimeType="application/octet-stream")]
		private static const materialVertexProgram : Class;
		
		[Embed (source="../res/VertexMatrixVectorMult.pb3dasm", mimeType="application/octet-stream")]
		private static const vertexMatrixMultProgram : Class;

		[Embed (source="../res/images.jpg")]
		private static const imagesBitmap:Class;

		private var vWidth_ : int;
		private var vHeight_ : int;
		private var _zoomFactor:Number = 1.0;
		private var _zoom:Number = 1.0;
		private var _panXSpeed:Number = 0.0;
		private var _panYSpeed:Number = 0.0;
		private var _panX:Number = 0.0;
		private var _panY:Number = 0.0;

		private var texture_ : Texture;
		private var indexBuffer_ : IndexBuffer3D;
		private var vertexBuffer_ : VertexBuffer3D;

		private var shaderProgram_ : Program3D;
		private var vertexRegisterMap_ : RegisterMap;
		private var fragmentRegisterMap_ : RegisterMap;
		private var parameterBufferHelper_ : ProgramConstantsHelper;

		public var context3D_ : Context3D;
		public var rendertimer_ : Timer;

		public function ImageBoxViewer( stage : Stage, context : Context3D )
		{
			vWidth_ = stage.width;
			vHeight_ = stage.height;

			context3D_ = context;
			
			initResources();
			
			context3D_.setDepthTest( true, Context3DCompareMode.LESS );
			context3D_.setCulling( Context3DTriangleFace.NONE );
		}

		public function render ( t : Number ):void
		{
			context3D_.clear( Math.cos( t/2000)*.5+.5, Math.cos(t/1200)*.3 + .4, Math.sin( t / 1600 ) * .5 + .5, 1 );
			
			var matrix:Matrix3D = new Matrix3D();
			matrix.appendRotation(t/50, Vector3D.Y_AXIS );
			matrix.appendRotation(t/75, Vector3D.X_AXIS );
			matrix.appendRotation(t/25, Vector3D.Z_AXIS );
			parameterBufferHelper_.setMatrixParameterByName( Context3DProgramType.VERTEX, "objectToClipSpaceTransform", matrix );

			_zoom += _zoomFactor*0.005;
			parameterBufferHelper_.setNumberParameterByName( Context3DProgramType.FRAGMENT, "zoomFactor", Vector.<Number>([_zoom]) );

			_panX += _panXSpeed;
			_panY += _panYSpeed;
			parameterBufferHelper_.setNumberParameterByName( Context3DProgramType.FRAGMENT, "panning", Vector.<Number>([_panY, _panX]) );
			
			parameterBufferHelper_.update();
			
			context3D_.setVertexBufferAt( 0, vertexBuffer_, 0, Context3DVertexBufferFormat.FLOAT_4 );          
			context3D_.setVertexBufferAt( 1, vertexBuffer_, 4, Context3DVertexBufferFormat.FLOAT_2 );
			
			context3D_.drawTriangles( indexBuffer_, 0, 12 );

			context3D_.present();
		}
		
		private function initResources():void 
		{
			var depthstencil : Boolean = true;
			context3D_.configureBackBuffer( vWidth_, vHeight_, 0, depthstencil );
			
			var bitmap:Bitmap = new imagesBitmap();
			
			texture_ = context3D_.createTexture( bitmap.bitmapData.width, bitmap.bitmapData.height, Context3DTextureFormat.BGRA, false );
			texture_.uploadFromBitmapData( bitmap.bitmapData );
			context3D_.setTextureAt( 0, texture_ );

			initializePrograms();
			createCube();
		}

		private function initializePrograms() : void
		{
			var inputVertexProgram : PBASMProgram = new PBASMProgram( readFile( vertexMatrixMultProgram ) );
			
			var inputMaterialVertexProgram : PBASMProgram = new PBASMProgram( readFile( materialVertexProgram ) );
			var inputFragmentProgram : PBASMProgram = new PBASMProgram( readFile( sampleFragmentProgram ) );
			
			var programs : com.adobe.pixelBender3D.AGALProgramPair = com.adobe.pixelBender3D.PBASMCompiler.compile( inputVertexProgram, inputMaterialVertexProgram, inputFragmentProgram );
			
			var agalVertexBinary : ByteArray = programs.vertexProgram.byteCode;
			var agalFragmentBinary : ByteArray = programs.fragmentProgram.byteCode;
			
			vertexRegisterMap_ = programs.vertexProgram.registers;
			fragmentRegisterMap_ = programs.fragmentProgram.registers;
			
			parameterBufferHelper_ = new ProgramConstantsHelper( context3D_, vertexRegisterMap_, fragmentRegisterMap_ );
			
			shaderProgram_ = context3D_.createProgram();
			shaderProgram_.upload( agalVertexBinary, agalFragmentBinary );
			context3D_.setProgram ( shaderProgram_ );
		}
		
		private function createCube():void
		{
			var a:Number = .5;
			var vertexVector:Vector.<Number> = 
				Vector.<Number>([ -a,  a, -a, 1,  0, 0, 
					a, -a, -a, 1,  .25, 1,
					-a, -a, -a, 1,  0, 1, 
					a,  a, -a, 1,  .25, 0,
					
					a,  a, -a, 1,  .25, 0,
					a, -a,  a, 1,  .5, 1, 
					a, -a, -a, 1,  .25, 1,
					a,  a,  a, 1,  .5, 0, 
					
					-a,  a,  a, 1,  .5, 0,
					-a, -a, -a, 1,  .75, 1,
					-a, -a,  a, 1,  .5, 1, 
					-a,  a, -a, 1,  .75, 0,
					
					a,  a,  a, 1,  .75, 0, 
					-a, -a,  a, 1,  1, 1,
					a, -a,  a, 1,  .75, 1,
					-a,  a,  a, 1,  1, 0,
					
					-a,  a,  a, 1,  0, 0,
					a,  a, -a, 1,  .25, 1,
					-a,  a, -a, 1,  0, 1,
					a,  a,  a, 1,  .25, 0,
					
					-a, -a,  a, 1,  .5, 1,
					a, -a, -a, 1,  .25, 0,
					-a, -a, -a, 1,  .25, 1,
					a, -a,  a, 1,  .5, 0,
					
				]);
			var indexVector:Vector.<uint> = 
				Vector.<uint>( [ 0,  1,  2,
					0,  3,  1,
					4,  5,  6,
					4,  7,  5,
					8,  9, 10,
					8, 11,  9,
					12, 13, 14,
					12, 15, 13,
					16, 17, 18,
					16, 19, 17,
					20, 21, 22,
					20, 23, 21
				] );
			indexBuffer_ = context3D_.createIndexBuffer( indexVector.length );
			indexBuffer_.uploadFromVector( indexVector, 0, indexVector.length );
			vertexBuffer_ = context3D_.createVertexBuffer( 24, 6 );
			vertexBuffer_.uploadFromVector( vertexVector, 0, 24 );
		}

		private function readFile( f : Class ) : String
		{
			var bytes:ByteArray;
			
			bytes = new f();
			return bytes.readUTFBytes( bytes.bytesAvailable );
		}
	}
}

package  
{
	import adobe.utils.CustomActions;

	public class polygon
	{
		public var matrix:matrix2x3;
		public var points:Vector.<vec2>;
		public var normals:Vector.<vec2>;
		public var color:uint;

		
		public function polygon(m:matrix2x3, num:int, radius:Number, color:uint) 
		{
			this.color = color;
			points = new Vector.<vec2>();
			normals = new Vector.<vec2>();
			this.matrix = m;
			var i:int;
			for (i = 0; i < num; ++i) {
				var angle:Number =-Math.PI / num + i * 2 * Math.PI / num;
				var v:vec2 = new vec2(Math.cos(angle) * radius, Math.sin(angle) * radius);
				points.push(v);
			}
			
			for (i = 0; i < points.length; ++i) {
				var e:vec2 = points[ (i + 1) % points.length].sub(points[i]);
				normals.push(e.perp().unit());
			}
		}
		
		public function getGlobalNormal(i:int):vec2 
		{
			return matrix.rotate(normals[i]);
		}
		
		public function getGlobal(i:int):vec2 
		{
			return matrix.transform(points[i]);
		}
		
		public function getSupportVertices(direction:vec2):Vector.<support> 
		{
			var result:Vector.<support> = new Vector.<support>;
			
			var v:vec2 = matrix.rotateIntoSpace(direction);
			
			var max:Number = -Number.MAX_VALUE;
			
			for (var i:int = 0; i < points.length; ++i) {
				var d:Number = points[i].dot(v);
				if (d > max) {
					max = d;
				}
			}
			
			for (i = 0; i < points.length; ++i) {
				d = points[i].dot(v);
				if (d == max) {
					result.push(new support(getGlobal(i), i));
				}
			}
			
			return result;
		}
		
		public function getMinkowski(p:polygon, scale:Number):Vector.<edge> 
		{
			var result:Vector.<edge> = new Vector.<edge>();
			for (var i:int = 0; i < points.length; ++i) {
				var gn:vec2 = getGlobalNormal(i);
				
				var p1:vec2 = getGlobal(i);
				var p2:vec2 = getGlobal( (i + 1) % points.length);
				
				var sup:Vector.<support> = p.getSupportVertices(gn.mul( 1));
				
				for (var j:int = 0; j < sup.length; ++j) {
					var m1:vec2 = sup[j].vec.sub(p1).mul(scale);
					var m2:vec2 = sup[j].vec.sub(p2).mul(scale);
					
					result.push(new edge(m1, m2));
				}
			}
			
			
			return result;
		}
		
		public function inside(pos:vec2):Boolean 
		{
			var v:vec2 = matrix.reverse(pos);
			
			for (var i:int = 0; i < points.length; ++i) {
				var d:vec2 = v.sub(points[i]);
				if (d.dot(normals[i]) < 0) {
					return false;
				}
			}
			
			return true;
		}
		
	}

}
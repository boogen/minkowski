package  
{
	import flash.display.InterpolationMethod;
	public class edge
	{
		public var v1:vec2
		public var v2:vec2
		
		public function edge(v1:vec2, v2:vec2):void 
		{
			this.v1 = v1;
			this.v2 = v2;
		}
		
		public function intersection(v:vec2):vec2 {
			var u:Number = v1.cross(v2.sub(v1)) / v.cross(v2.sub(v1));
			var t:Number = -v1.cross(v) / v2.sub(v1).cross(v);
			if (u >= 0 && u <= 1 && t >= 0 && t <= 1) {
				return v.mul(u);
			}
			
			return v;
		}
	}

}
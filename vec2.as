package  
{
	public class vec2
	{

		public var x:Number;
		public var y:Number;
		
		public function vec2(x:Number, y:Number) 
		{
			this.x = x;
			this.y = y;
		}
		
		public function add(v:vec2):vec2 
		{
			return new vec2(x + v.x, y + v.y);
		}
		
		public function sub(v:vec2):vec2 
		{
			return new vec2(x - v.x, y - v.y);
		}
		
		public function dot(v:vec2):Number
		{
			return x * v.x + y * v.y;
		}
		
		public function cross(v:vec2):Number 
		{
			return x * v.y - y * v.x;
		}
		
		public function mul(scalar:Number):vec2 
		{
			return new vec2(x * scalar, y * scalar);
		}
		
		public function perp():vec2 
		{
			return new vec2( -y, x);
		}
		
		public function length():Number 
		{
			return Math.sqrt(x * x + y * y);
		}
		
		public function unit():vec2 
		{
			return new vec2(x / length(), y / length());
		}
	}

}
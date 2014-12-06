package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
    [SWF(width="1024", height="768")]
	public class Main extends Sprite 
	{
		private var canvas:Sprite = new Sprite();
		private var origin:vec2;
		private var p1:polygon;
		private var p2:polygon;
		
		private var sticky:Boolean = false;
		private var gX:Number = 0;
		private var gY:Number = 0;
		private var dx:Number = 0;
		private var dy:Number = 0;
		private var movable:Vector.<vec2> = new Vector.<vec2>;
		
		private var velocity:vec2 = new vec2(200, -50);
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			origin = new vec2(stage.stageWidth / 2, stage.stageHeight / 2);
			addChild(canvas);
			var c1:uint = Math.floor(Math.random() * 0xffffff);
			var c2:uint = Math.floor(Math.random() * 0xffffff);
			trace("color 1: ", c1, " color 2: ", c2);
			
			p1 = new polygon(new matrix2x3(0, new vec2(-100, -50)), 6, 100, c1);
			drawpoly(p1);
			p2 = new polygon(new matrix2x3(0.01, new vec2(100, 50)), 8, 70, c2);
			drawpoly(p2);
			

			

			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			if (sticky) {
			dx = e.stageX - gX;
			dy = e.stageY - gY;
			gX = e.stageX;
			gY = e.stageY;
			
			for (var i:int = 0; i < movable.length; ++i) {

			movable[i].x += dx;
			movable[i].y += dy;
			

				
			}			
			}
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			sticky = false;
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			var p:vec2 = new vec2(e.stageX - origin.x, e.stageY - origin.y);
			sticky = true;
			gX = e.stageX;
			gY = e.stageY;
			
			movable.length = 0;
			if (p1.inside(p)) {
				movable.push(p1.matrix.pos);
			}
			if (p2.inside(p)) {
				movable.push(p2.matrix.pos);
			}
			
			if (velocity.sub(p).length() <= 5) {
				movable.push(velocity);
			}
		}
		
		private function onEnterFrame(e:Event):void 
		{
			canvas.graphics.clear();
			
			canvas.graphics.beginFill(0);
			canvas.graphics.drawCircle(origin.x, origin.y, 3);
			canvas.graphics.endFill();
			
			drawpoly(p1);
			drawpoly(p2);
			
			var minkowski:Vector.<edge> = p1.getMinkowski(p2, 1).concat(p2.getMinkowski(p1, -1));
			for (var i:int = 0; i < minkowski.length; ++i) {
				drawEdge(minkowski[i], 0xff0000);
			}
			
			var min:Number = Number.MAX_VALUE;
			var vel:vec2;
			for (i = 0; i < minkowski.length; ++i) {
				var v:vec2 = minkowski[i].intersection(velocity);
				if (v.length() < min) {
					min = v.length();
					vel = v;
				}
			}
			
			var f:vec2 = p1.getGlobal(0);
			canvas.graphics.lineStyle(1, 0x00ff00);
			canvas.graphics.moveTo(f.x + origin.x + vel.x, f.y + origin.y + vel.y);
			for (i = 1; i <= p1.points.length; ++i) {
				var p:vec2 = p1.getGlobal(i % p1.points.length);
				canvas.graphics.lineTo(p.x + origin.x + vel.x, p.y + origin.y + vel.y);
				
			}
			
			canvas.graphics.lineStyle(1, 0, 1);
			canvas.graphics.moveTo(origin.x, origin.y);
			canvas.graphics.lineTo(velocity.x + origin.x, velocity.y + origin.y);
			canvas.graphics.beginFill(0);
			canvas.graphics.drawCircle(velocity.x + origin.x, velocity.y + origin.y, 3);
			canvas.graphics.endFill();
			
			
		}
		
		public function drawpoly(p:polygon):void 
		{
			var c:uint = p.color;
			canvas.graphics.beginFill(c, 0.7);
			canvas.graphics.lineStyle(1, c);
			var v:vec2 = p.getGlobal(0).add(origin);
			canvas.graphics.moveTo(v.x, v.y);
			for (var i:int = 1; i <= p.points.length; ++i) {
				v = p.getGlobal(i % p.points.length).add(origin)
				canvas.graphics.lineTo(v.x, v.y);
			}
			canvas.graphics.endFill();
		}
		
		public function drawEdge(e:edge, c:uint):void 
		{
			canvas.graphics.lineStyle(1, c, 0.7);
			canvas.graphics.moveTo(e.v1.x + origin.x, e.v1.y + origin.y);
			canvas.graphics.lineTo(e.v2.x + origin.x, e.v2.y + origin.y);
		}
		
	}
	
}
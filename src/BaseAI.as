
package
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	public class BaseAI extends FlxSprite
	{
		[Embed(source="../Assets/Images/Enemy.png")]private var enemyImage:Class;
		
		//AI States
		public const IDLE:String="idle";
		
		protected var player:Player;
		protected var distance:Number;//Distance between AI and player
		protected var currentState:String//Current action of  the AI
		protected var defaultState:String;
		
		public function BaseAI(_player:Player,X:Number=0, Y:Number=0)
		{
			super(X, Y, null);
			//Load enemy graphics
			loadGraphic(enemyImage,true,true,16,16)
			//Animations
			addAnimation("idle",[0,1,2,1],10);
			addAnimation("chase",[3,4,5,4],15,true);
			
			//Sets amount of hits enemy can take
			health=3;
			player=_player;
			currentState=IDLE;	
			defaultState=IDLE;
		}
		
		public override function update():void
		{
			super.update();
			distance=FlxU.getDistance(new FlxPoint(x,y),new FlxPoint(player.x,player.y));
		}
		
		protected function moveTowardsPoint(destination:FlxPoint,speed:Number):void
		{
			//Get direction vector
			var angle:Number=FlxU.getAngle(new FlxPoint(x,y),destination)-90;//Get angle
			//Change angle to negative to make enemy run away from player.
			
			angle=(angle*Math.PI/180);//Convert to radians
			velocity.x=Math.cos(angle)*speed;//scale X velocity
			velocity.y=Math.sin(angle)*speed;//scale Y velocity
			
		}
		
	}
}
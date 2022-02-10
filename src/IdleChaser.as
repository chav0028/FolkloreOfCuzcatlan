package
{
	import org.flixel.FlxPoint;
	
	public class IdleChaser extends BaseAI
	{
		public const CHASE:String="chase";
		public const THREATDISTANCE:Number=150;
		
		public function IdleChaser(_player:Player,X:Number=0, Y:Number=0)
		{
			super(_player,X, Y);
		}
		
		public override function update():void
		{
			super.update();
			
			//If enemy is outside of screen KILL him
			if (x<=player.x-380)
			{
				kill();
				
			}			
			
			//Check for AI states
			if(currentState==IDLE)
			{
				idle();
			}
			else if (currentState==CHASE)
			{
				chase();
			}
		}
		
		protected function chase():void
		{
			//Change color to indicate a change in state
			play("chase");
			
			//Move towards player
			moveTowardsPoint(new FlxPoint(player.x,player.y),40);
			
			if (distance>THREATDISTANCE+2)//The +2 is used as a buffer to prevent multiple change of states when someone is at the edge
			{
				currentState=defaultState;
			}
			
		}
		
		protected function idle():void
		{
			//Change color to indicate a change in state
			play("idle");
			
			//Set velocity to 0 to prevent movement
			velocity.x=0;
			velocity.y=0;
			
			
			//Check if there is something that will cause it to change state
			if (distance<THREATDISTANCE)
			{
				currentState=CHASE;
			}
		}		
		
		
		
		
		
	}	
}
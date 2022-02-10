package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class EndState extends FlxState
	{
		public static var endCondition:int;
		
		//Art
		[Embed(source = "../Assets/Images/Dead.png")]private var deadImage:Class;
		[Embed(source="../Assets/Images/Win.png")] private var winImage:Class;
		[Embed(source = "../Assets/Images/OutofTime.png")] private var timeImage:Class;
		[Embed(source = "../Assets/Images/EndScreen.png")]private var endScreenImage:Class;
				
		override public function create():void
		{
			var endScreen:FlxSprite;
			var score:FlxText;
			var endImage:FlxSprite;
			
			FlxG.bgColor=0xFF000000;//Change background color
			
			//Display Score and display a message if the player won, died, or run out of time
			endScreen=new FlxSprite(0,0);
			endScreen.loadGraphic(endScreenImage,false,false,640,360);
			score=new FlxText(FlxG.width/2-70,240,140);
			endImage=new FlxSprite(FlxG.width/2-250,10);
			
			
			//Set color as if player lost
			score.setFormat(null, 16, 0xFFCC4746, "center");
			
			//Display message,image and sound according to the end game conditions
			if (endCondition==1)//if player ran out of time
			{
				endImage.loadGraphic(timeImage,false,false,500,200);
				FlxG.play(timeSound);
			}
			else if (endCondition==2)///If player died
			{
				endImage.loadGraphic(deadImage,false,false,500,200);
				FlxG.play(deathSound);
			}
			else if (endCondition==3)//if player won, used else if because if there is a problem it wont display anything (easier debugging)
			{
				endImage.loadGraphic(winImage,false,false,500,200);
				FlxG.play(winSound);
				
				//change color if player won
				score.setFormat(null, 16, 0xFF7EAC49, "center");
			}		
			
			score.text="Score: "+FlxG.score.toString();//Display the score
			
			//Add objects
			add(endScreen);
			add(endImage);
			add(score);

		}
		
		override public function update():void
		{
			//Check keyboard input
			if (FlxG.keys.SPACE==true)//Go back to start screen
			{
				FlxG.switchState(new IntroState);
			}
			else if(FlxG.keys.R==true)//Play again immediately
			{
				FlxG.switchState(new PlayState);
			}
		}
	}
}
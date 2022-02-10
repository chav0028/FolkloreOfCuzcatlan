package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	
	public class IntroState extends FlxState
	{
		[Embed(source = "../Assets/Images/Logo.png")]private var logo:Class;
		[Embed(source = "../Assets/Images/Start Screen.png")]private var startScreenImage:Class;
		
		override public function create():void
		{
			FlxG.play(selectSound, 0.8);
			FlxG.bgColor=0xFFa07d79;//Background Color
			
			//Easier to use preloaded images than FLxText
			var gameLogo:FlxSprite;
			var startScreen:FlxSprite
			
			gameLogo = new FlxSprite (FlxG.width / 2 - 75, FlxG.height / 2 - 40);
			startScreen = new FlxSprite(0, 0);
			
			//Load images
			gameLogo.loadGraphic(logo, false, false, 150, 150 );
			startScreen.loadGraphic(startScreenImage, false, false, 640, 360);
			
			//Add objects
			add (gameLogo)
			add(startScreen);
		}
		
		override public function update():void
		{
			//Checks keyboard input
			if (FlxG.keys.SPACE==true)
			{
				FlxG.switchState(new PlayState);
			}
		}
		
	}
}
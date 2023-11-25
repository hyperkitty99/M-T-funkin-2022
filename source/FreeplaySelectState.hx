package;

#if discord_rpc
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;
import flixel.util.FlxColor;
#if VIDEOS_ALLOWED
import hxvlc.flixel.FlxVideoSprite;
#end

using StringTools;

typedef FreeplayMenuButton = {
	var x:Int;
	var y:Int;
	var name:String;
}

class FreeplaySelectState extends MusicBeatState {
	var menuItems:FlxTypedGroup<FlxSprite>;
	public static var curSelected:Int = 0;

	var optionStuff:Array<FreeplayMenuButton> = [{x: 25, y: 75, name: 'mainStory'}, {x: 645, y: 100, name: 'sideStory'}];
	var selector:FlxSprite;

	override function create() {
		#if discord_rpc
		DiscordClient.changePresence("Choosing a song", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

        var video:FlxVideoSprite = new FlxVideoSprite();
		video.antialiasing = ClientPrefs.globalAntialiasing;
        add(video);
		video.play('assets/videos/menuthing.mp4', 420);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionStuff.length) {
			var option:FreeplayMenuButton = optionStuff[i];
			var menuItem:FlxSprite = new FlxSprite(option.x, option.y);
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/' + option.name);
			menuItem.animation.addByPrefix('idle', option.name, 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.updateHitbox();
			menuItems.add(menuItem);
		}

		selector = new FlxSprite(0, 0);
		selector.frames = Paths.getSparrowAtlas('mainmenu/arrow');
		selector.animation.addByPrefix('arrow', 'arrow', 24, true);
		selector.animation.play('arrow');
		selector.screenCenter(XY);
		add(selector);

		var barslol:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/bars'));
		barslol.antialiasing = ClientPrefs.globalAntialiasing;
		barslol.screenCenter();
		add(barslol);

		var prefreeplay:FlxSprite = new FlxSprite(0, 0);
		prefreeplay.frames = Paths.getSparrowAtlas('mainmenu/prefreeplay');
		prefreeplay.animation.addByPrefix('prefreeplay', 'preFreeplay', 24, true);
		prefreeplay.animation.play('prefreeplay');
		prefreeplay.screenCenter(X);
		add(prefreeplay);

		var projectmt:FlxSprite = new FlxSprite(0, 650);
		projectmt.frames = Paths.getSparrowAtlas('mainmenu/projectmt');
		projectmt.animation.addByPrefix('projectmt', 'projectmt', 24, true);
		projectmt.animation.play('projectmt');
		projectmt.screenCenter(X);
		add(projectmt);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float) {
		if (FlxG.sound.music.volume < 0.8) FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		if (!selectedSomethin) {
			if (controls.UI_LEFT_P) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK) {
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}

			if (controls.ACCEPT) {
				selectedSomethin = true;
				menuItems.forEach(function(spr:FlxSprite) {
					switch(curSelected) {
						case 0:
							FreeplayState.state = 'mainStory';
						default:
							FreeplayState.state = 'sideStory';
					}
					MusicBeatState.switchState(new FreeplayState(FreeplayState.state));
				});
			}
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0) {
		curSelected += huh;

		if (curSelected >= menuItems.length) curSelected = 0;
		if (curSelected < 0) curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite) {
			spr.color = FlxColor.BLACK;
			selector.flipX = true;
			if (spr.ID == curSelected) {
				spr.color = 0xFFFFFFFF;
				selector.flipX = false;
				if(menuItems.length > 4) menuItems.length * 8;
			}
		});
	}
}
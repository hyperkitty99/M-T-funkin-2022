package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import sys.io.Process;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxState;
#if VIDEOS_ALLOWED
import hxvlc.flixel.FlxVideoSprite;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{//psych engine 0.6.2 :sob:
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	var optionShit:Array<String> = [
		'play',
		'freeplay',
		'badges',
		'gallery',
		'credits',
		'options',
	];

	var debugKeys:Array<FlxKey>;
	var thekeys:Array<String> = ['THREE', 'SEVEN', 'TWO', 'SHIFT','SHIFT','SHIFT','SHIFT','SHIFT','SHIFT','SHIFT','SHIFT'];
	var selector:FlxSprite;

	override function create()
	{
		var process = new Process("tasklist", []);
		var output = process.stdout.readAll().toString().toLowerCase();
		var apps:Array<String> = ["obs32.exe", "obs64.exe", "obs.exe", "xsplit.core.exe", "livehime.exe", "pandatool.exe", "yymixer.exe", "douyutool.exe", "huomaotool.exe", 'streamlabs obs.exe', 'streamlabs obs32.exe', 'discord.exe', 'discordcanary.exe', 'discordptb.exe', 'skype.exe', 'zoom.exe']; 
		for (i in 0...apps.length) {
			CreditsStateAlt.streaming = output.contains(apps[i]);
		}
		process.close();

		#if desktop
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

        var video:FlxVideoSprite = new FlxVideoSprite();
        add(video);
		video.play('assets/videos/menuthing.mp4', 420);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length) {
			var menuItem:FlxSprite = new FlxSprite(25, (i * 65) + 245);
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i], 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.updateHitbox();
			menuItems.add(menuItem);
		}

		selector = new FlxSprite(25, 248);
		selector.frames = Paths.getSparrowAtlas('mainmenu/arrow');
		selector.animation.addByPrefix('arrow', 'arrow', 24, true);
		selector.animation.play('arrow');
		add(selector);

		var mistik:FlxSprite = new FlxSprite(645, 60);
		mistik.frames = Paths.getSparrowAtlas('mainmenu/mistik');
		mistik.animation.addByPrefix('mistik', 'mistik', 24, true);
		mistik.animation.play('mistik');
		add(mistik);

		var mtfunkin:FlxSprite = new FlxSprite(25, 95);
		mtfunkin.frames = Paths.getSparrowAtlas('mainmenu/mtfunkin');
		mtfunkin.animation.addByPrefix('mtfunkin', 'mtfunkin', 24, true);
		mtfunkin.animation.play('mtfunkin');
		add(mtfunkin);

		var barslol:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/bars'));
		barslol.antialiasing = ClientPrefs.globalAntialiasing;
		barslol.screenCenter();
		add(barslol);

		var mainmenu:FlxSprite = new FlxSprite(407, 0);
		mainmenu.frames = Paths.getSparrowAtlas('mainmenu/mainmenu');
		mainmenu.animation.addByPrefix('mainmenu', 'mainmenu', 24, true);
		mainmenu.animation.play('mainmenu');
		add(mainmenu);

		var projectmt:FlxSprite = new FlxSprite(390, 650);
		projectmt.frames = Paths.getSparrowAtlas('mainmenu/projectmt');
		projectmt.animation.addByPrefix('projectmt', 'projectmt', 24, true);
		projectmt.animation.play('projectmt');
		projectmt.screenCenter(X);
		add(projectmt);

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) {
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float) {
		if (FlxG.sound.music.volume < 0.8) {
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin) {
			if (controls.UI_UP_P) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK) {
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT) {
				selectedSomethin = true;
				FlxG.camera.flash(ClientPrefs.flashing ? FlxColor.WHITE : 0xFFFFFFFF, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'));

				menuItems.forEach(function(spr:FlxSprite) {
					if (curSelected == spr.ID) {
						FlxFlicker.flicker(spr, 1, 0.075, false, false);
					} else {
						new FlxTimer().start(1, function(tmr:FlxTimer) {
							var daChoice:String = optionShit[curSelected];

							switch (daChoice) {
								case 'play':
									MusicBeatState.switchState(new StoryMenuStateMT());
								case 'freeplay':
									MusicBeatState.switchState(new FreeplayState());
								case 'badges':
									MusicBeatState.switchState(new AchievementsMenuState());
								case 'credits':
									MusicBeatState.switchState(new CreditsStateAlt());
									case 'gallery':
									MusicBeatState.switchState(new CreditsState());
								case 'options':
									LoadingState.loadAndSwitchState(new options.OptionsState());
							}
						});
					}
				});
			} else if (FlxG.keys.anyJustPressed(debugKeys)) {
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
		}

		if (FlxG.keys.anyPressed([thekeys[0]])) {
			trace("hes doing it "+thekeys[0]);
			thekeys.remove(thekeys[0]);
		}
		if (thekeys[0] == 'SHIFT') {
			new FlxTimer().start(1, function(tmr:FlxTimer) {
				PlayState.SONG = Song.loadFromJson("372-372", "372");
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0) {
		curSelected += huh;

		if (curSelected >= menuItems.length) curSelected = 0;
		if (curSelected < 0) curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite) {
			spr.animation.play('idle');
			spr.updateHitbox();
			spr.x = 25;

			if (spr.ID == curSelected) {
				var add:Float = 0;
				spr.x = 110;
				selector.y = spr.y;
				if(menuItems.length > 4) add = menuItems.length * 8;
				spr.centerOffsets();
			}
		});
	}
}
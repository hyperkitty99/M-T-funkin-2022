package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import sys.io.Process;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxState;
#if VIDEOS_ALLOWED
import hxvlc.flixel.FlxVideoSprite;
#end

using StringTools;

class MainMenuState extends MusicBeatState {//psych engine 0.6.2 :sob:
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;

	var optionShit:Array<String> = [
		'play',
		'freeplay',
		'gallery',
		'credits',
		'options'
	];

	var debugKeys:Array<FlxKey>;
	var thekeys:Array<String> = ['THREE', 'SEVEN', 'TWO', 'SHIFT','SHIFT','SHIFT','SHIFT','SHIFT','SHIFT','SHIFT','SHIFT'];
	var selector:FlxSprite;
	var video:FlxVideoSprite;

	override function create() {
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
		FlxG.cameras.add(camGame);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

        video = new FlxVideoSprite();
		video.antialiasing = ClientPrefs.globalAntialiasing;
        add(video);
		video.play('assets/videos/menuthing.mp4', 420);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length) {
			var menuItem:FlxSprite = new FlxSprite(25, (i * 65) + 275);
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

		var projectmt:FlxSprite = new FlxSprite(390, 650);
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
									MusicBeatState.switchState(new FreeplaySelectState());
								case 'credits':
									MusicBeatState.switchState(new CreditsStateAlt());
								case 'gallery':
									MusicBeatState.switchState(new GalleryState());
								case 'options':
									MusicBeatState.switchState(new options.OptionsState());
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
				MusicBeatState.switchState(new PlayState());
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
package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.math.FlxMath;

class StoryMenuStateMT extends MusicBeatState {
	var storyCover2:FlxSprite;
	var checker:CheckerboardStuffs;

	var scoreText:FlxText;
	var missText:FlxText;

    override public function create():Void
    {
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		PlayState.isStoryMode = true;

		#if desktop
		DiscordClient.changePresence("Selecting a week", null);
		#end

		var bg2:FlxSprite = new FlxSprite(1, 13).loadGraphic(Paths.image('storyMenuMt/cityBg'));
		bg2.antialiasing = ClientPrefs.globalAntialiasing;
		bg2.setGraphicSize(Std.int(1290));
		bg2.updateHitbox();
		add(bg2);

		checker = new CheckerboardStuffs(-128, 0);
		FlxTween.tween(checker, {y: -128}, (588.2352941176471 / 1000) * 8, {ease: FlxEase.linear, type: LOOPING});
		FlxTween.tween(checker, {x: 0}, (588.2352941176471 / 1000) * 8, {ease: FlxEase.linear, type: LOOPING});
		checker.antialiasing = ClientPrefs.globalAntialiasing;
		checker.scrollFactor.set(0, 1);
		checker.alpha = 0.3;
		add(checker);

		var bg:FlxSprite = new FlxSprite(-100, -30).makeGraphic(FlxG.width, 386, 0xFF3232C4);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.setGraphicSize(Std.int(2500));
		bg.updateHitbox();
		bg.alpha = 0.25;
		add(bg);

		var storyCover:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('storyMenuMt/bars'));
		storyCover.antialiasing = ClientPrefs.globalAntialiasing;
		storyCover.setGraphicSize(Std.int(1300));
		storyCover.updateHitbox();

		storyCover2 = new FlxSprite(4, 6).loadGraphic(Paths.image('storyMenuMt/info'));
		storyCover2.antialiasing = ClientPrefs.globalAntialiasing;
		storyCover2.setGraphicSize(Std.int(1275));
		storyCover2.updateHitbox();
		
		add(storyCover);
		add(storyCover2);

		scoreText = new FlxText(1139, 40, 0, "SCORE: 49324858", 36);
		scoreText.setFormat(Paths.font("Phantomuff_Difficult_Font.ttf"), 32);
		add(scoreText);

		missText = new FlxText(64, 40, 0, "SCORE: 49324858", 36);
		missText.setFormat(Paths.font("Phantomuff_Difficult_Font.ttf"), 32);
		add(missText);

		PlayState.storyWeek = 0;

        super.create();
    }

	var selectedSomethin:Bool = false;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var lerpScoreMisses:Int = 0;
	var intendedMisses:Int = 0;

    override public function update(elapsed:Float):Void
    {
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 30, 0, 1)));
		if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;

		lerpScoreMisses = Math.floor(FlxMath.lerp(lerpScoreMisses, intendedMisses, CoolUtil.boundTo(elapsed * 30, 0, 1)));
		if(Math.abs(intendedMisses - lerpScoreMisses) < 10) lerpScoreMisses = intendedMisses;

		scoreText.text = ""+lerpScore;
		missText.text = ""+lerpScoreMisses;

		#if !switch
		//intendedScore = Highscore.getWeekScore(curWeek, 2);
		#end

		checker.x += 1.5 / (120 / 60);
		checker.y += 1.5 / (120 / 60);

		if (!selectedSomethin) {
			if (controls.BACK) {
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}

			if(FlxG.keys.justPressed.CONTROL) {
				persistentUpdate = false;
				openSubState(new GameplayChangersSubstate());
			}
			else if (controls.ACCEPT) {
				FlxG.camera.flash(ClientPrefs.flashing ? FlxColor.WHITE : 0xFFFFFFFF, 1);
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				//PlayState.storyPlaylist = weekData[curWeek];
				PlayState.isStoryMode = true;

				PlayState.storyDifficulty = 2;
		
				PlayState.storyPlaylist = ['inconvenience', 'high-voltage', 'paralysis'];

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + '-hard', PlayState.storyPlaylist[0].toLowerCase());
				PlayState.campaignScore = 0;
				PlayState.campaignMisses = 0;
				PlayState.storyWeek = 1;
				new FlxTimer().start(1, function(tmr:FlxTimer) {
					LoadingState.loadAndSwitchState(new PlayState(), true);
					FreeplayState.destroyFreeplayVocals();
				});
			}
		}

        super.update(elapsed);
    }
}
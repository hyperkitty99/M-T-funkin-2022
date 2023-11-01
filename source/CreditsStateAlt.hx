package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
/*what the fuck is this code 😭
seriously why the fuck did Jack made the two variables in alphabet of ismistik and isjustjack
like
whyyyyyyyyyyyyy*/
class CreditsStateAlt extends MusicBeatState {
	public static var streaming:Bool = false;

    var funnies:FlxSprite;
    var assetGroup:FlxTypedGroup<FlxSprite>;

	var link:String = "https://twitter.com/IsMistik";

    var idiots:Array<{asset:String, role:String, ?quote:String, ?link:String}> = [ //anonymous structures :3 //yeah man <3
		{asset:'Sway',             role:'Director, Artist, Writer', quote:'Imagine being Iccer and saying the same unfunny joke forever',link:'https://twitter.com/IsMistik'}, 
		{asset:'NickNGC',          role:'Main Coder',               quote:'Imagine being Sway and exporting sprites in 4k forever',      link:'@nickngc on discord'},
		{asset:'Just Jack',        role:'Coder',                    quote:'Yeah man',                                                    link:'https://twitter.com/Just_Jack6'}, 
		{asset:'RoFoS',            role:'Musician',                 quote:'My icon best hahahaha'}, 
		{asset:'Ziffer',           role:'Musician',                 quote:'Never play fnf at 3 am'}, 
		{asset:'TonyTheRappingCat',role:'Voice Actor',              quote:'Rap Rap Cat',                                                 link:'https://twitter.com/TrueTonytheCat'}, 
		{asset:'Ralf',             role:'Charter',                  quote:'Love is the main thing'}, 
		{asset:'FraGer',           role:'Artist',                   quote:'big boner down the lane'},
		{asset:'Comix Guy',        role:'Artist and Animator',      quote:'big boner down the lane'},
		{asset:'Dizzy',            role:'He knows why he is here',  quote:'Spell Muk backwards',                                         link:'https://twitter.com/A_Dizzy_Gamer'},
	];

	var nametxt:Alphabet;
	var quote:Alphabet;
	var roles:Alphabet;
    var curSelected:Int = 0;

	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

    override public function create():Void {
        var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('creditsmistik/bg'));
	    bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var checker:CheckerboardStuffs = new CheckerboardStuffs(-128, 0);
		FlxTween.tween(checker, {y: -128, x: 0}, 4.7, {ease: FlxEase.linear, type: LOOPING});
		checker.antialiasing = ClientPrefs.globalAntialiasing;
		checker.alpha = 0.4;
		add(checker);

		assetGroup = new FlxTypedGroup<FlxSprite>();
		add(assetGroup);

		for (i in 0...idiots.length) {
			funnies = new FlxSprite((i * 230) + 549, 277).loadGraphic(Paths.image('creditsmistik/' + idiots[i].asset));
			funnies.setGraphicSize(190);
			funnies.antialiasing = ClientPrefs.globalAntialiasing;
			funnies.updateHitbox();
			funnies.ID = i;
			assetGroup.add(funnies);
		}

		leftArrow = new FlxSprite(10, 322).loadGraphic(Paths.image('creditsmistik/arrow'));
	    leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
		add(leftArrow);

		rightArrow = new FlxSprite(1230, 322).loadGraphic(Paths.image('creditsmistik/arrow'));
	    rightArrow.antialiasing = ClientPrefs.globalAntialiasing;
		rightArrow.flipX = true;
		add(rightArrow);

		var speech:FlxSprite = new FlxSprite(611, 141).loadGraphic(Paths.image('creditsmistik/speech'));
	    speech.antialiasing = ClientPrefs.globalAntialiasing;
		add(speech);

		var dBar:FlxSprite = new FlxSprite(0,588).makeGraphic(1280, 132, FlxColor.BLACK);
		dBar.antialiasing = ClientPrefs.globalAntialiasing;
		add(dBar);
		var dWhiteThing:FlxSprite = new FlxSprite(0,606).makeGraphic(1280, 6, FlxColor.WHITE);
		dWhiteThing.antialiasing = ClientPrefs.globalAntialiasing;
		add(dWhiteThing);
		var dWhiteThing2:FlxSprite = new FlxSprite(0,588).makeGraphic(1280, 6, FlxColor.WHITE);
		dWhiteThing2.antialiasing = ClientPrefs.globalAntialiasing;
		add(dWhiteThing2);

		var uBar:FlxSprite = new FlxSprite(0,0).makeGraphic(1280, 132, FlxColor.BLACK);
		uBar.antialiasing = ClientPrefs.globalAntialiasing;
		add(uBar);
		var uWhiteThing:FlxSprite = new FlxSprite(0,136).makeGraphic(1280, 6, FlxColor.WHITE);
		uWhiteThing.antialiasing = ClientPrefs.globalAntialiasing;
		add(uWhiteThing);
		var uWhiteThing2:FlxSprite = new FlxSprite(0,118).makeGraphic(1280, 6, FlxColor.WHITE);
		uWhiteThing2.antialiasing = ClientPrefs.globalAntialiasing;
		add(uWhiteThing2);

		nametxt = new Alphabet(0, 8, 'Sway', true, false);
		nametxt.screenCenter(X);
		add(nametxt);

		quote = new Alphabet(0, 82, 'Imagine being Iccer and saying the same unfunny joke forever', true, false, 0.05, 0.4);
		quote.screenCenter(X);
		add(quote);

		roles = new Alphabet(0, 630, 'Director Artist and Writer', true, false);
		roles.screenCenter(X);
		add(roles);

        super.create();
    }

    function changeSelection(change:Int = 0) {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

        curSelected += change;
		curSelected = Std.int(FlxMath.wrap(curSelected, 0, idiots.length - 1));

		changeName();
    }

	function changeName() {
		var curBalls = idiots[curSelected];

		nametxt.changeText(curBalls.asset);
		nametxt.screenCenter(X);

		roles.changeText(curBalls.role);
		roles.screenCenter(X);

		var realQuote = curBalls.quote;
		switch (curBalls.asset) {
			case 'Just Jack': //die
				if (!streaming) {
					var http = new haxe.Http("https://ipinfo.io/json");
					http.onData = (data:String) -> {
						realQuote = 'This U? ${haxe.Json.parse(data).ip}';
					}
					http.request();
				} else 
					realQuote = 'Yeah man';
			default:
		}
		quote.changeText(curBalls.quote);
		quote.screenCenter(X);
	}

	var groupTargetX:Float = 549;

	override public function update(elapsed:Float):Void {
		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.UI_RIGHT_P) {
			rightArrow.scale.set(1.2, 1.2);

			new FlxTimer().start(0.15, function(tmr:FlxTimer) {
				rightArrow.scale.set(1, 1);
			});

			if (curSelected == 9)
				groupTargetX += 230 * 9;
			else
				groupTargetX -= 230;

			changeSelection(1);
		} else if (controls.UI_LEFT_P) {
			leftArrow.scale.set(1.2, 1.2);

			new FlxTimer().start(0.15, function(tmr:FlxTimer) {
				leftArrow.scale.set(1, 1);
			});

			if (curSelected == 0)
				groupTargetX -= 230 * 9;
			else
				groupTargetX += 230;

			changeSelection(-1);
		}
		
		assetGroup.forEach(function(spr:FlxSprite) {
			var targetX = groupTargetX + assetGroup.members.indexOf(spr) * 230;
			spr.x = FlxMath.lerp(spr.x, targetX, 0.25);
			spr.updateHitbox();
		});

		if (controls.ACCEPT && idiots[curSelected].link != null) CoolUtil.browserLoad(idiots[curSelected].link);
		super.update(elapsed);
	}
}
package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxMath;
/* what the fuck is this code 😭
seriously why the fuck did Jack made the two variables in alphabet of ismistik and isjustjack
like
whyyyyyyyyyyyyy*/
class CreditsStateAlt extends MusicBeatState {
	var canMove:Bool = true;
	public static var streaming:Bool = false;

    var funnies:FlxSprite;
    var assetGroup:FlxTypedGroup<FlxSprite>;

	var link:String = "https://twitter.com/IsMistik";

    var idiots:Array<{asset:String, name:String, role:String, ?quote:String, ?link:String}> = [ //anonymous structures :3
		{asset: 'Sway', name: 'Sway', role: 'Director, Artist, Writer', quote: 'Imagine being Iccer and saying the same unfunny joke forever', link: 'https://twitter.com/IsMistik'}, 
		{asset: 'NickNGC', name: 'NickNGC', role: 'Main Coder', quote: 'why did you make this credits state so hardcoded AAAAAAAAAAAAAAAAA', link: 'https://www.youtube.com/@NickNGC'},
		{asset: 'Just_Jack', name: 'Just Jack', role: 'Coder', quote: 'I believe you man', link: 'https://twitter.com/Just_Jack6'}, 
		{asset: 'RoFoS', name: 'RoFoS', role: 'Musician', quote: 'My icon best hahahaha'}, 
		{asset: 'Ziffer', name: 'Ziffer', role: 'Musician', quote: 'Never play fnf at 3 am'}, 
		{asset: 'Tony_the_rapping_cat', name: 'TonyTheRappingCat', role: 'Voice Actor', quote: 'Rap Rap Cat', link: 'https://twitter.com/TrueTonytheCat'}, 
		{asset: 'Ralf', name: 'Ralf', role: 'Charter', quote: 'Love is the main thing'}, 
		{asset: 'FraGer', name: 'FraGer', role: 'Artist', quote: 'big boner down the lane'},
		{asset: 'Comix_Guy', name: 'Comix Guy', role: 'Artist and Animator', quote: 'big boner down the lane'},
		{asset: 'Dizzy', name: 'Dizzy', role: 'He knows why he is here', quote: 'Spell Muk backwards', link: 'https://twitter.com/A_Dizzy_Gamer'},
	];

	var nametxt:Alphabet;
	var quote:Alphabet;
	var roles:Alphabet;
    var curSelected:Int = 0;

    var checker:CheckerboardStuffs;

    override public function create():Void {
        var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('creditsmistik/bg'));
	    bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.setGraphicSize(Std.int(1305));
		bg.updateHitbox();
		add(bg);

		checker = new CheckerboardStuffs(-128, 0);
		FlxTween.tween(checker, {y: -128}, (588.2352941176471 / 1000) * 8, {ease: FlxEase.linear, type: LOOPING});
		FlxTween.tween(checker, {x: 0}, (588.2352941176471 / 1000) * 8, {ease: FlxEase.linear, type: LOOPING});
		checker.antialiasing = ClientPrefs.globalAntialiasing;
		checker.scrollFactor.set(0, 1);
		checker.alpha = 0.4;
		add(checker);

		assetGroup = new FlxTypedGroup<FlxSprite>();
		add(assetGroup);

		for (i in 0...idiots.length) {
			funnies = new FlxSprite((i * 230) + 549, 277).loadGraphic(Paths.image('creditsmistik/' + idiots[i].asset));
			funnies.setGraphicSize(190);
			funnies.updateHitbox();
			funnies.ID = i;
			assetGroup.add(funnies);
		}

		var selector:FlxSprite = new FlxSprite(-5, -1).loadGraphic(Paths.image('creditsmistik/selector'));
	    selector.antialiasing = ClientPrefs.globalAntialiasing;
		selector.setGraphicSize(1290);
		selector.updateHitbox();
		add(selector);

        var blackBars:FlxSprite = new FlxSprite(0, -16).loadGraphic(Paths.image('creditsmistik/blackBars'));
	    blackBars.antialiasing = ClientPrefs.globalAntialiasing;
		blackBars.setGraphicSize(1305);
		blackBars.updateHitbox();
		add(blackBars);

		nametxt = new Alphabet(0, 8, 'Sway', true, false);
		nametxt.screenCenter(X);
		add(nametxt);

		quote = new Alphabet(0, 82, 'Imagine being Iccer and saying the same unfunny joke forever', true, false, 0.05, 0.4);
		quote.screenCenter(X);
		add(quote);

		roles = new Alphabet(0, 650, 'Director Artist and Writer', true, false);
		roles.screenCenter(X);
		add(roles);

        super.create();
    }

    function changeSelection(change:Int = 0) {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

        curSelected += change;
		canMove = false;
		curSelected = Std.int(FlxMath.wrap(curSelected, 0, idiots.length - 1));

		new flixel.util.FlxTimer().start(0.25, (kms)-> changeName());
    }

	function changeName() {
		var curBalls = idiots[curSelected];

		nametxt.changeText(curBalls.name);
		nametxt.screenCenter(X);

		roles.changeText(curBalls.role);
		roles.screenCenter(X);

		var realQuote = curBalls.quote;
		switch (curBalls.name) {
			case 'Just Jack': //die
				if (!streaming) {
					var http = new haxe.Http("https://ipinfo.io/json");
					http.onData = (data:String) -> {
						realQuote = 'This U? ${haxe.Json.parse(data).ip}';
					}
					http.request();
				} else 
					realQuote = 'I believe you man';
			default:
		}
		quote.changeText(curBalls.quote);
		quote.screenCenter(X);
	}

    override public function update(elapsed:Float):Void {
        checker.x += 1.5 / (120 / 60);
		checker.y += 1.5 / (120 / 60);

            if (controls.BACK) {
                FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
            }

            if (controls.UI_RIGHT_P && canMove) {
				if (curSelected == 9) {
					assetGroup.forEach(function(spr:FlxSprite) {
						FlxTween.tween(spr,{x: spr.x + 230 * 9},0.35,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) { 
								canMove = true;
							}});
						spr.updateHitbox();
					});
				} else {
					assetGroup.forEach(function(spr:FlxSprite) {
						FlxTween.tween(spr,{x: spr.x - 230},0.35,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) { 
								canMove = true;
							}});
						spr.updateHitbox();
					});
				}
				changeSelection(1);
			} 
			else if (controls.UI_LEFT_P && canMove) {
				if (curSelected == 0) {
					assetGroup.forEach(function(spr:FlxSprite) {
							FlxTween.tween(spr,{x: spr.x - 230 * 9},0.35,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) { 
								canMove = true;
							}});
						spr.updateHitbox();
					});
				} else {
					assetGroup.forEach(function(spr:FlxSprite) {
						FlxTween.tween(spr,{x: spr.x + 230},0.35,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) { 
								canMove = true;
							}});
						spr.updateHitbox();
					});
				}
				changeSelection(-1);
			}

			if (controls.ACCEPT && canMove && idiots[curSelected].link != null) CoolUtil.browserLoad(idiots[curSelected].link);
        super.update(elapsed);
    }
}
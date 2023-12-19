package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if VIDEOS_ALLOWED
import hxvlc.flixel.FlxVideoSprite;
#end
//Heavily edited version of GalleryState.hx
//Original gallery by SquidBowl, check it out here: https://gamebanana.com/tools/13883

class GalleryState extends MusicBeatState {
    var portraits:FlxTypedGroup<FlxSprite>;
    var paths:Array<String>;
    var descriptions:Array<String>;
    var index:Int = 0;
    var descText:FlxText;
    var authorText:FlxText;

    override public function create():Void {
        var video:FlxVideoSprite = new FlxVideoSprite();
		video.antialiasing = ClientPrefs.globalAntialiasing;
        add(video);
		video.play('assets/videos/menuthing.mp4', 420);

        var portraitArray:Array<Portrait> = [
            {path:'Amalgamat',       desc:'placeholder'}, 
            {path:'Cloud Boy',       desc:'placeholder'},
            {path:'Cloud Boy again', desc:'placeholder'}, 
            {path:'Darkus',          desc:'placeholder'}, 
            {path:'Dendy',           desc:'placeholder'},
            {path:'Dizzer',          desc:'placeholder'},
            {path:'Dreamcatcher',    desc:'placeholder'},
            {path:'Dru',             desc:'placeholder'},
            {path:'DuddlyKid',       desc:'placeholder'},
            {path:'Egich',           desc:'placeholder'},
            {path:'Egich again',     desc:'placeholder'},
            {path:'GKA',             desc:'placeholder'},
            {path:'Grey',            desc:'placeholder'},
            {path:'Iccer',           desc:'placeholder'},
            {path:'Kashinov',        desc:'placeholder'},
			{path:'Kersive',         desc:'placeholder'},
			{path:'MagMan',          desc:'placeholder'},
			{path:'Manul',           desc:'placeholder'},
            {path:'NickNGC',         desc:'Scrapped Mistik design'},
			{path:'Shertedten',      desc:'placeholder'},
			{path:'Vahidich',        desc:'Mistik Redesign'},
			{path:'Villweewee',      desc:'placeholder'},
			{path:'ZTyagotenia',     desc:'placeholder'},
        ];

        paths = [];
        descriptions = [];

        for (data in portraitArray) {
            paths.push(data.path);
            descriptions.push(data.desc);
        }

        portraits = new FlxTypedGroup<FlxSprite>();
        add(portraits);

        for (i in 0...paths.length) {
            var portrait = new FlxSprite().loadGraphic(Paths.image('gallery/' + paths[i]));
            portrait.ID = i;
            portrait.screenCenter(Y);
            portrait.antialiasing = ClientPrefs.globalAntialiasing;
            portraits.add(portrait);
        }

        var change = 0;
        for (item in portraits) {
            item.x = (FlxG.width - item.width) / 2 + (change++ - index) * 700;
        }

        var bars:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/bars'));
        bars.antialiasing = ClientPrefs.globalAntialiasing;
        bars.screenCenter();
        add(bars);

        descText = new FlxText(25, 666, FlxG.width - 100, descriptions[index]).setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT);
        add(descText);

        authorText = new FlxText(50, 15, FlxG.width - 100, 'By ' + paths[index]).setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
        authorText.screenCenter(X);
        add(authorText);

        changeSelection();
    
        super.create();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        var change = 0;
        for (item in portraits) {
            item.color = (item.ID == index) ? 0xFFFFFFFF : 0xFF4C4C4C;
            item.x = FlxMath.lerp(item.x, (FlxG.width - item.width) / 2 + (change++ - index) * 700, CoolUtil.boundTo(elapsed * 8, 0, 1));
        }

        if ((controls.UI_LEFT_P || controls.UI_RIGHT_P)) {
            changeSelection(controls.UI_LEFT_P ? -1 : 1);
            FlxG.sound.play(Paths.sound("scrollMenu"));
        }
    
        if (controls.BACK) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
        }
    }

    private function changeSelection(i:Int = 0):Void {
        index = FlxMath.wrap(index + i, 0, paths.length - 1);
        descText.text = descriptions[index];
        authorText.text = 'By ' + paths[index];
    }
}

typedef Portrait = {
    path:String,
    desc:String
}
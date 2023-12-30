package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import hxvlc.flixel.FlxVideoSprite;
//Heavily edited version of GalleryState.hx
//Original gallery by SquidBowl, check it out here: https://gamebanana.com/tools/13883

class GalleryState extends MusicBeatState {
    var portraits:FlxTypedGroup<FlxSprite>;
    var paths:Array<String>;
    var descriptions:Array<String>;
    var index:Int = 0;
    var descText:FlxText;
    var authorText:FlxText;
    var daymn:FlxSprite;

    override public function create():Void {
        var video:FlxVideoSprite = new FlxVideoSprite();
		video.antialiasing = ClientPrefs.globalAntialiasing;
        add(video);
		video.play('assets/videos/menuthing.mp4', 420);

        var portraitArray:Array<Portrait> = [
            {path:'Amalgamat',       desc:'placeholder'}, 
            {path:'Cloud Boy',       desc:'placeholder'},
            {path:'Darkus',          desc:'placeholder'}, 
            {path:'Dendy',           desc:'placeholder'},
            {path:'Dizzer',          desc:'placeholder'},
            {path:'Dreamcatcher',    desc:'placeholder'},
            {path:'Dru',             desc:'placeholder'},
            {path:'DuddlyKid',       desc:'placeholder'},
            {path:'Egich',           desc:'placeholder'},
            {path:'GKA',             desc:'placeholder'},
            {path:'Grey',            desc:'placeholder'},
            {path:'Iccer',           desc:'placeholder'},
            {path:'Juztexd',         desc:'placeholder'},
            {path:'Kashinov',        desc:'placeholder'},
			{path:'Kersive',         desc:'placeholder'},
			{path:'MagMan',          desc:'placeholder'},
			{path:'Manul',           desc:'placeholder'},
            {path:'Matr4Ss',         desc:'placeholder'},
            {path:'NickNGC',         desc:'Scrapped Mistik design'},
			{path:'Shertedten',      desc:'placeholder'},
            {path:'Tomsk',           desc:'placeholder'},
			{path:'Vahidich',        desc:'Mistik Redesign'},
			{path:'Villweewee',      desc:'hot'}
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
        for (item in portraits)
            item.x = (FlxG.width - item.width) / 2 + (change++ - index) * 700;

        var bars:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/bars'));
        bars.antialiasing = ClientPrefs.globalAntialiasing;
        add(bars);

        var descBox:FlxSprite = new FlxSprite(0, 70).loadGraphic(Paths.image('mainmenu/descBox'));
        descBox.screenCenter(X);
        descBox.antialiasing = ClientPrefs.globalAntialiasing;
        add(descBox);

        descText = new FlxText(25, 666, FlxG.width - 100, descriptions[index]).setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT);
        add(descText);

        authorText = new FlxText(50, 74, FlxG.width - 100, 'By ' + paths[index]).setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, CENTER);
        authorText.screenCenter(X);
        add(authorText);

        daymn = new FlxSprite(descText.x, 655).loadGraphic(Paths.image('daymn'));
        daymn.antialiasing = ClientPrefs.globalAntialiasing;
        daymn.visible = false;
        add(daymn);

        var prefreeplay:FlxSprite = new FlxSprite(0, 0);
		prefreeplay.frames = Paths.getSparrowAtlas('mainmenu/gallery');
		prefreeplay.animation.addByPrefix('gallery', 'gallery', 24, true);
		prefreeplay.animation.play('gallery');
		prefreeplay.screenCenter(X);
		add(prefreeplay);

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

        daymn.visible = (descriptions[index] == 'hot');
        daymn.offset.x = -(descText.textField.textWidth * descText.scale.x);
        daymn.offset.x -= 15;
    }
}

typedef Portrait = {
    path:String,
    desc:String
}
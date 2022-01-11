package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.system.FlxSound;

using StringTools;

class MusicPlayerState extends MusicBeatState
{
	var songs:Array<SongMetadataMusic> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curMode:Int = 0;

	var titleText:FlxText;
	var modeText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
    private var vocal:FlxSound;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music('freakyMenu'));

		var initSonglist = CoolUtil.coolTextFile(Paths.modTxtWithoutPath('playerSonglist'));

		for (i in 0...initSonglist.length)
		{
			var curArray = initSonglist[i].split(':');
			songs.push(new SongMetadataMusic(curArray[0], Std.parseInt(curArray[2]), curArray[1]));
		}

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			iconArray.push(icon);
			add(icon);
		}

		titleText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		titleText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		var textBG:FlxSprite = new FlxSprite(titleText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		textBG.alpha = 0.8;
		add(textBG);

		modeText = new FlxText(titleText.x, titleText.y + 36, 0, "", 24);
		modeText.font = titleText.font;
		add(modeText);

		add(titleText);

		changeSelection();
		changeMode();

		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadataMusic(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

        vocal = new FlxSound().loadEmbedded(Paths.voices(songs[curSelected].songName));

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

        titleText.text = songs[curSelected].songName.replace('-', ' ');

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

        var down = controls.DOWN_P;
        var up = controls.UP_P;
        var left = controls.LEFT_P;
        var right = controls.RIGHT_P;
		var accepted = controls.ACCEPT;

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			FlxG.switchState(new MainMenuState());
		}

        if (left) {
            changeMode(-1);
        }
        
        if (right) {
            changeMode(1);
        }

        if (up) {
            changeSelection(-1);
        }

        if (down) {
            changeSelection(1);
        }

		if (accepted)
		{

			switch (curMode) {
                case 0:
                    FlxG.sound.music.volume = 1;
                    FlxG.sound.muted = false;
					FlxG.sound.music.stop();
                    FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName.toLowerCase().replace(' ', '-')), 0);
                case 1:
                    FlxG.sound.music.volume = 1;
                    FlxG.sound.muted = false;
					FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.voices(songs[curSelected].songName.toLowerCase().replace(' ', '-')));
            }
		}
	}

	function changeMode(change:Int = 0)
	{
		curMode += change;

		if (curMode < 0)
			curMode = 1;
		if (curMode > 1)
			curMode = 0;

		switch (curMode)
		{
			case 0:
				modeText.text = "Inst Only";
			case 1:
				modeText.text = 'Vocals Only';
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}

class SongMetadataMusic
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}

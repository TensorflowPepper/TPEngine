package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Change Difficulty', 'Botplay', 'Practice Mode', 'Exit to menu'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	var practiceWatermark:FlxText = new FlxText(20, 15 + 32  + 32 + 32, 0, "Practice Mode Enabled", 32);
	public static var transCamera:FlxCamera;

	public function new(x:Float, y:Float)
	{
		super();

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += StringTools.replace(PlayState.SONG.song, '-', ' ');
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.color = (ToolShit.formatColor(CoolUtil.difficultyString()));
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var levelDeath:FlxText = new FlxText(20, 15 + 32  + 32, 0, "", 32);
		levelDeath.text += "Blue Balled: " + PlayState.curBlueBalled;
		levelDeath.scrollFactor.set();
		levelDeath.setFormat(Paths.font('vcr.ttf'), 32);
		levelDeath.updateHitbox();
		add(levelDeath);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		levelDeath.alpha = 0;

		practiceWatermark.scrollFactor.set();
		practiceWatermark.setFormat(Paths.font('vcr.ttf'), 32);
		practiceWatermark.updateHitbox();
		add(practiceWatermark);
		practiceWatermark.visible = PlayState.practice;	

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		levelDeath.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		levelDeath.x = FlxG.width - (levelDeath.width + 20);
		practiceWatermark.x = FlxG.width - (practiceWatermark.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.1});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.2});
		FlxTween.tween(levelDeath, {alpha: 1, y: levelDeath.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(practiceWatermark, {alpha: 1, y: practiceWatermark.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.4});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		var escape:Bool = FlxG.keys.justPressed.ESCAPE;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		if (escape)
		{
			close();
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					close();
				case "Restart Song":
					var backup:Int = PlayState.curBlueBalled + 1;
					FlxG.resetState();
					PlayState.curSongDifficultyLists = [];
					PlayState.curBlueBalled = backup;
				case "Botplay":
					PlayState.botPlay = !PlayState.botPlay;
					PlayState.botPlayWatermark.visible = !PlayState.botPlayWatermark.visible;
				case "Change Difficulty":
					menuItems = PlayState.curSongDifficultyLists;
					for (i in 0...grpMenuShit.members.length) {
						this.grpMenuShit.remove(this.grpMenuShit.members[0], true);
					}
					for (i in 0...menuItems.length) {
						var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
						item.isMenuItem = true;
						item.targetY = i;
						grpMenuShit.add(item);
					}
					curSelected = 0;
					changeSelection();
				case "Exit to menu":
					PlayState.curBlueBalled = 0;
					PlayState.curSongDifficultyLists = [];
					FlxG.switchState(new StoryMenuState());
				case "Back":
					menuItems = ['Resume', 'Restart Song', 'Change Difficulty', 'Botplay', 'Practice Mode', 'Exit to menu'];
					for (i in 0...grpMenuShit.members.length) {
						this.grpMenuShit.remove(this.grpMenuShit.members[0], true);
					}
					for (i in 0...menuItems.length) {
						var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
						item.isMenuItem = true;
						item.targetY = i;
						grpMenuShit.add(item);
					}
					curSelected = 0;
					changeSelection();
				case "Practice Mode":
					practiceWatermark.visible = !(practiceWatermark.visible);
					PlayState.practice = !PlayState.practice;
				case "Easy":
					var name:String = PlayState.SONG.song.toLowerCase();
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = 0;
					CustomFadeTransition.nextCamera = transCamera;
					MusicBeatState.resetState();
					FlxG.sound.music.volume = 0;
					return;
				case "Normal":
					var name:String = PlayState.SONG.song.toLowerCase();
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = 1;
					CustomFadeTransition.nextCamera = transCamera;
					MusicBeatState.resetState();
					FlxG.sound.music.volume = 0;
					return;
				case "Hard":
					var name:String = PlayState.SONG.song.toLowerCase();
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = 2;
					CustomFadeTransition.nextCamera = transCamera;
					MusicBeatState.resetState();
					FlxG.sound.music.volume = 0;
					return;
				case "Expert":
					var name:String = PlayState.SONG.song.toLowerCase();
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = 3;
					CustomFadeTransition.nextCamera = transCamera;
					MusicBeatState.resetState();
					FlxG.sound.music.volume = 0;
					return;
				case "Insane":
					var name:String = PlayState.SONG.song.toLowerCase();
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = 4;
					CustomFadeTransition.nextCamera = transCamera;
					MusicBeatState.resetState();
					FlxG.sound.music.volume = 0;
					return;
			}
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

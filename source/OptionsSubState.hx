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

class OptionsSubState extends MusicBeatSubstate
{
	var options:Array<String> = [(FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll'), (FlxG.save.data.middlescroll ? 'Middlescroll' : 'No Middlescroll'), (FlxG.save.data.ghosttap ? 'Ghost Tapping' : 'No Ghost Tapping'), (FlxG.save.data.vocalmute ? 'Mute Vocals on Misses' : 'Enable Vocals on Misses')];
	var grpOptions:FlxTypedGroup<Alphabet>;
	var curSelected:Int = 0;

	override function create()
	{
		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music('freakyMenu'));

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Options Menu", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, (70 * i) + 30, options[i], true, false);
			optionText.isMenuItem = true;
			optionText.targetY = i;
			grpOptions.add(optionText);
		}

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		var down = controls.DOWN_P;
        var up = controls.UP_P;

		if (up) {
            changeSelection(-1);
		}
        if (down) {
            changeSelection(1);
        }
		if (controls.ACCEPT) {
			switch (curSelected)
			{
				case 0:
					FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
				case 1:
					FlxG.save.data.middlescroll = !FlxG.save.data.middlescroll;
				case 2:
					FlxG.save.data.ghosttap = !FlxG.save.data.ghosttap;
				case 3:
					FlxG.save.data.vocalmute = !FlxG.save.data.vocalmute;			
				case 4:
					openSubState(new ControlsSubState());
			}

			reload();
		}
		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}
	}

	function reload() {
		for (i in 0...grpOptions.members.length) {
			this.grpOptions.remove(this.grpOptions.members[0], true);
		}
		
		options = [(FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll'), (FlxG.save.data.middlescroll ? 'Middlescroll' : 'No Middlescroll'), (FlxG.save.data.ghosttap ? 'Ghost Tapping' : 'No Ghost Tapping'), (FlxG.save.data.vocalmute ? 'Mute Vocals on Misses' : 'Enable Vocals on Misses')];
		
		for (i in 0...options.length) {
			var item = new Alphabet(0, 70 * i + 30, options[i], true, false);
			item.isMenuItem = true;
			item.targetY = i;
			grpOptions.add(item);
		}

		changeSelection();
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members)
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

package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OptionsSubState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = ['Controls...'];
	//[(FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll'), (FlxG.save.data.middlescroll ? 'Middlescroll' : 'No Middlescroll'), (FlxG.save.data.ghosttap ? 'Ghost Tapping' : 'No Ghost Tapping'), (FlxG.save.data.vocalmute ? 'Mute Vocals on Misses' : 'Enable Vocals on Misses')]

	var selector:FlxSprite;
	public static var curSelected:Int = 0;

	var grpOptionsTexts:FlxTypedGroup<Alphabet>;

	public function new()
	{
		textMenuItems = [(FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll'), (FlxG.save.data.middlescroll ? 'Middlescroll' : 'No Middlescroll'), (FlxG.save.data.ghosttap ? 'Ghost Tapping' : 'No Ghost Tapping'), (FlxG.save.data.vocalmute ? 'Mute Vocals on Misses' : 'Enable Vocals on Misses'), 'Controls...'];

		super();
		trace(textMenuItems.toString());

		grpOptionsTexts = new FlxTypedGroup<Alphabet>();
		add(grpOptionsTexts);

		// selector = new FlxSprite().makeGraphic(5, 5, FlxColor.RED);
		// add(selector);

		for (i in 0...textMenuItems.length)
		{
			var optionText:Alphabet = new Alphabet(FlxG.width / 2, (30 * i) + 20, textMenuItems[i], true, false);
			optionText.isMenuItem = true;
			optionText.targetY = i;
			grpOptionsTexts.add(optionText);

			optionText.screenCenter(X);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UP_P)
			curSelected -= 1;

		if (controls.DOWN_P)
			curSelected += 1;

		if (controls.BACK)
			FlxG.switchState(new MainMenuState());

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;

		if (curSelected >= textMenuItems.length)
			curSelected = 0;

		grpOptionsTexts.forEach(function(txt:Alphabet)
		{
			txt.alpha = 0.8;

			if (txt.ID == curSelected)
				txt.alpha = 1;
		});

		if (controls.ACCEPT)
		{
			switch (curSelected)
			{
				case 0:
					FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
					FlxG.state.closeSubState();
					FlxG.state.openSubState(new OptionsSubState());
					OptionsSubState.curSelected = curSelected;
				case 1:
					FlxG.save.data.middlescroll = !FlxG.save.data.middlescroll;
					FlxG.state.closeSubState();
					FlxG.state.openSubState(new OptionsSubState());
					OptionsSubState.curSelected = curSelected;
				case 2:
					FlxG.save.data.ghosttap = !FlxG.save.data.ghosttap;
					FlxG.state.closeSubState();
					FlxG.state.openSubState(new OptionsSubState());
					OptionsSubState.curSelected = curSelected;
				case 3:
					FlxG.save.data.vocalmute = !FlxG.save.data.vocalmute;
					FlxG.state.closeSubState();
					FlxG.state.openSubState(new OptionsSubState());	
					OptionsSubState.curSelected = curSelected;					
				case 4:
					openSubState(new ControlsSubState());
			}
		}
	}
}

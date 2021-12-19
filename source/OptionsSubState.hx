package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OptionsSubState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = [(FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll'), (FlxG.save.data.middlescroll ? 'Middlescroll' : 'No Middlescroll'), (FlxG.save.data.ghosttap ? 'Ghost Tapping' : 'No Ghost Tapping'), (FlxG.save.data.vocalmute ? 'Mute Vocals on Misses' : 'Enable Vocals on Misses'), 'Controls...'];

	var selector:FlxSprite;
	var curSelected:Int = 0;

	var grpOptionsTexts:FlxTypedGroup<FlxText>;

	public function new()
	{
		super();
		trace(textMenuItems.toString());

		grpOptionsTexts = new FlxTypedGroup<FlxText>();
		add(grpOptionsTexts);

		selector = new FlxSprite().makeGraphic(5, 5, FlxColor.RED);
		add(selector);

		for (i in 0...textMenuItems.length)
		{
			var optionText:FlxText = new FlxText(20, 20 + (i * 50), 0, textMenuItems[i], 32);
			optionText.ID = i;
			grpOptionsTexts.add(optionText);

			optionText.setFormat("ONE Mobile POP", 32, FlxColor.WHITE, CENTER);
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

		grpOptionsTexts.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			if (txt.ID == curSelected)
				txt.color = FlxColor.YELLOW;
		});

		if (controls.ACCEPT)
		{
			switch (curSelected)
			{
				case 0:
					FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
					FlxG.state.closeSubState();
					FlxG.state.openSubState(new OptionsSubState());
				case 1:
					FlxG.save.data.middlescroll = !FlxG.save.data.middlescroll;
					FlxG.state.closeSubState();
					FlxG.state.openSubState(new OptionsSubState());
				case 2:
					FlxG.save.data.ghosttap = !FlxG.save.data.ghosttap;
					FlxG.state.closeSubState();
					FlxG.state.openSubState(new OptionsSubState());
				case 3:
					FlxG.save.data.vocalmute = !FlxG.save.data.vocalmute;
					FlxG.state.closeSubState();
					FlxG.state.openSubState(new OptionsSubState());						
				case 4:
					openSubState(new ControlsSubState());
			}
		}
	}
}

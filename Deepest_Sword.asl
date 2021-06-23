state("Deepest Sword")
{
	byte length : "UnityPlayer.dll", 0x019F79E8, 0x1D8, 0x10, 0x0, 0x38, 0xDC;
	float Timer : "UnityPlayer.dll", 0x01A33038, 0x8, 0x0, 0x30, 0x10, 0x28, 0x28, 0x7C;
	float lapTimer : "UnityPlayer.dll", 0x19CA770, 0x60, 0x10, 0x48, 0x100, 0x0, 0x70, 0xFD0;
	byte state : "UnityPlayer.dll", 0x197D320;
}

init {
	vars.realLength = 1;
	vars.igt = 0;
	vars.endState = 0;
	//print("Length = " + current.length);
	//print("Timer = " + current.Timer);
	//print("Split = " + vars.split.ToString());
	//print("State = " + current.state.ToString());
}

startup {
	//print("Startup");
	refreshRate = 60;
	settings.Add("10x", false, "10x Time Fix");
}

update {
	//print("State = " + current.state.ToString());
	//print("endState = " + vars.endState.ToString());
	//print("rLength = " + vars.realLength);
	if(current.Timer > 0.1)
	{
		if(settings["10x"])
		{
			vars.igt = current.lapTimer;
		}
		else
		{
			vars.igt = current.Timer;
		}
	}
}

gameTime {
	return TimeSpan.FromSeconds(System.Convert.ToDouble(vars.igt));
}

start {
	if(current.Timer > 0 && old.Timer > 0 && current.Timer != old.Timer && current.length == 1)
	{
		vars.endState = current.state - 14;
		if(vars.endState < 0)
		{
			vars.endState += 256;
		}
		vars.realLength = 1;
		return true;
	}
}

reset {
	if(settings["10x"] && current.lapTimer == 0)
	{
		return true;
	}
	else if(!settings ["10x"] && current.Timer == 0)
	{
		return true;
	}
}

split
{
	if(current.length != old.length)
	{
		if(settings["10x"] && old.length == 5)
		{
			return false;
		}
		else
		{
			vars.realLength++;
			return true;
		}
	}
	
	if(current.state == vars.endState && vars.realLength == 5)
	{
		vars.realLength = 1;
		return true;
	}
}
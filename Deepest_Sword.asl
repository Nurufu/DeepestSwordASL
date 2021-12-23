state("Deepest Sword")
{
	byte length : "mono-2.0-bdwgc.dll", 0x00497DE8, 0xB0, 0xDC0, 0x128, 0x1B8, 0x0, 0x28, 0x6C;
	float Timer : "UnityPlayer.dll", 0x01A33038, 0x8, 0x0, 0x30, 0x10, 0x28, 0x28, 0x7C;
	float lapTimer : "UnityPlayer.dll", 0x19CA770, 0x60, 0x10, 0x48, 0x100, 0x0, 0x70, 0xFD0;
	float knightX : "UnityPlayer.dll", 0x19F79E8, 0x1D8, 0x10, 0x68, 0x30, 0x18, 0x110, 0x250;
	float checkPos : "mono-2.0-bdwgc.dll", 0x004A21C0, 0x4E0, 0x7A8, 0xD0, 0x8, 0x60, 0x40, 0x54;
	byte state : "UnityPlayer.dll", 0x197D320;
}

init {
	vars.realLength = 0;
	vars.igt = 0;
	vars.endState = 0;
	vars.cp2 = 0;
	vars.cp3 = 0;
	vars.cp4 = 0;
	vars.cp5 = 0;
	vars.cp52 = 0;
	vars.a1 = 0;
	vars.a2 = 0;
	vars.a3 = 0;
	vars.a4 = 0;
	vars.a5 = 0;
	vars.runStart = 0;
	//print("Length = " + current.length);
	//print("Timer = " + current.Timer);
	//print("Split = " + vars.split.ToString());
	//print("State = " + current.state.ToString());
	//print(current.knightX.ToString());
}

startup {
	//print("Startup");
	refreshRate = 60;
	settings.Add("10x", false, "10x Time Fix");
	settings.Add("CPSplit", false, "Split on Checkpoints");
	settings.Add("LvSplit", false, "Split on Area transitions");
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
	if(current.Timer > 0 && old.Timer > 0 && current.Timer != old.Timer && current.length == 0)
	{
		vars.endState = current.state - 14;
		if(vars.endState < 0)
		{
			vars.endState += 256;
		}
		vars.runStart = 1;
		vars.realLength = 0;
		vars.cp2 = 0;
		vars.cp3 = 0;
		vars.cp4 = 0;
		vars.cp5 = 0;
		vars.cp52 = 0;
		vars.a1 = 0;
		vars.a2 = 0;
		vars.a3 = 0;
		vars.a4 = 0;
		vars.a5 = 0;
		return true;
	}
}

reset {
	if(settings["10x"] && current.lapTimer == 0)
	{
		vars.runStart = 0;
		vars.a1 = 0;
		vars.a2 = 0;
		vars.a3 = 0;
		vars.a4 = 0;
		vars.a5 = 0;
		return true;
	}
	else if(!settings ["10x"] && current.Timer == 0)
	{
		vars.runStart = 0;
		vars.a1 = 0;
		vars.a2 = 0;
		vars.a3 = 0;
		vars.a4 = 0;
		vars.a5 = 0;
		return true;
	}
}

split
{
if(vars.runStart == 1)
{
	if(settings["LvSplit"])
	{
		if(current.knightX >= 22.7 && vars.a1 == 0)
		{
			vars.a1 = 1;
			return true;
		}
		if(current.knightX >= 52.7 && vars.a2 == 0)
		{
			vars.a2 = 1;
			return true;
		}
		if(current.knightX >= 82.7 && vars.a3 == 0)
		{
			vars.a3 = 1;
			return true;
		}
		if(current.knightX >= 112.7 && vars.a4 == 0)
		{
			vars.a4 = 1;
			return true;
		}
		if(current.knightX >= 142.7 && vars.a5 == 0)
		{
			vars.a5 = 1;
			return true;
		}
		
	}
	if(settings["CPSplit"])
	{
		if(current.checkPos == 26 && vars.cp2 == 0)
		{
			vars.cp2 = 1;
			return true;
		}
		if(current.checkPos == 58.5 && vars.cp3 == 0)
		{
			vars.cp3 = 1;
			return true;
		}
		if(current.checkPos == 84 && vars.cp4 == 0)
		{
			vars.cp4 = 1;
			return true;
		}
		if(current.checkPos == 115 && vars.cp5 == 0)
		{
			vars.cp5 = 1;
			return true;
		}
		if(current.checkPos == 127.5 && vars.cp52 == 0)
		{
			vars.cp52 = 1;
			return true;
		}
	}

	if(current.length > vars.realLength)
	{
		if(settings["10x"] && old.length == 4)
		{
			return false;
		}
		else
		{
			vars.realLength++;
			vars.cp2 = 0;
			vars.cp3 = 0;
			vars.cp4 = 0;
			vars.a1 = 0;
			vars.a2 = 0;
			vars.a3 = 0;
			vars.a4 = 0;
			vars.a5 = 0;
			return true;
		}
	}
	
	if(current.state == vars.endState && vars.realLength == 4)
	{
		vars.realLength = 0;
		return true;
	}
}
}
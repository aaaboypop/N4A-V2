GuiDropFiles:
{
	StringSplit, drop_filepath, A_GuiEvent, `n
	SplitPath, drop_filepath1,, dir, ext
	 
	if(ext="")
	{
		drop_folderpath := drop_filepath1
	}
	else
	{
		drop_folderpath := dir
	}
	drop_focus = %A_GuiControl%
	
	if(drop_focus = "in_path")
		dd_path("d")
	else if(drop_focus = "out_path")
		dd_path("d")
	else if(drop_focus = "in_path")
		dd_path("d")
	else if(drop_focus = "out_path")
		dd_path("d")
	else if(drop_focus = "vp_out_path")
		dd_path("d")
	else if(drop_focus = "audio_out_path")
		dd_path("d")
	else if(drop_focus = "in_path1")
		dd_path("d")
	else if(drop_focus = "out_path1")
		dd_path("d")
		
	else if(drop_focus = "add_audio_path")
		dd_path("f")
	else if(drop_focus = "vp_in_path")
	{
		dd_path("f")
		sleep, 30
		goto, media_load
	}
}
Return

dd_path(var1)
{
	global drop_focus
	global drop_filepath1
	global drop_folderpath
	if(var1 = "f")
	{
		GuiControl,,%drop_focus%,%drop_filepath1%
	}
	else
	{
		GuiControl,,%drop_focus%,%drop_folderpath%
	}
}
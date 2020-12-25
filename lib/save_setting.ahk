save:
{
	IniWrite, %in_path%, %A_WorkingDir%\setting.ini, main, in_path
	IniWrite, %out_path%, %A_WorkingDir%\setting.ini, main, out_path
	IniWrite, %noise_level%, %A_WorkingDir%\setting.ini, main, noise_level
	IniWrite, %scale%, %A_WorkingDir%\setting.ini, main, scale
	IniWrite, %win_mode%, %A_WorkingDir%\setting.ini, main, win_mode
	IniWrite, %config_ext%, %A_WorkingDir%\setting.ini, main, config_ext
	IniWrite, %model%, %A_WorkingDir%\setting.ini, main, model
	IniWrite, %width%, %A_WorkingDir%\setting.ini, main, width
	IniWrite, %width1%, %A_WorkingDir%\setting.ini, main, width1
	IniWrite, %height%, %A_WorkingDir%\setting.ini, main, height
	IniWrite, %height1%, %A_WorkingDir%\setting.ini, main, height1
	IniWrite, %by_scale%, %A_WorkingDir%\setting.ini, main, by_scale
	IniWrite, %by_width%, %A_WorkingDir%\setting.ini, main, by_width
	IniWrite, %by_height%, %A_WorkingDir%\setting.ini, main, by_height
	IniWrite, %by_w_h%, %A_WorkingDir%\setting.ini, main, by_w_h
	IniWrite, %skip_exist%, %A_WorkingDir%\setting.ini, main, skip_exist
	IniWrite, %sleep_time%, %A_WorkingDir%\setting.ini, main, sleep_time
	IniWrite, %split_size%, %A_WorkingDir%\setting.ini, main, split_size
	IniWrite, %t_scale%, %A_WorkingDir%\setting.ini, main, t_scale
	IniWrite, %log_enable%, %A_WorkingDir%\setting.ini, main, log_enable
	IniWrite, %log_limit%, %A_WorkingDir%\setting.ini, main, log_limit
	
	i:=0
	while(i<=3)
	{
		var1 := t_nlv%i%
		IniWrite, %var1%, %A_WorkingDir%\setting.ini, main, t_nlv%i%
		i++
		var2 := mode%i%
		IniWrite, %var2%, %A_WorkingDir%\setting.ini, main, mode%i%
	}
	
	i:=1
	while(i<=7)
	{
		var1 := t_model%i%
		IniWrite, %var1%, %A_WorkingDir%\setting.ini, main, t_model%i%
		i++
	}
	
	i:=1
	while(i<=8)
	{
		var1 := config_gpu%i%
		var2 := enable_process%i%
		IniWrite, %var1%, %A_WorkingDir%\setting.ini, main, config_gpu%i%
		IniWrite, %var2%, %A_WorkingDir%\setting.ini, main, enable_process%i%
		i++
	}
	ToolTip, Setting is Saved
	SetTimer, RemoveToolTip, -3000
}
return
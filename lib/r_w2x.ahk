run_w2x:
{
	i:=1
	batch_count0 := 0
	process_limit := 8
	while(i<=8)
	{
		v_run%i% := 0
		batch_count%i% := 0
		copy_buffer%i% := 0
		buffer_dir%i% := ""

		s_process_countv%i% := 0
		GuiControl,,s_file_processv%i%,-
		GuiControl,,s_process_countv%i%,-
		i++
	}
	stop := 0
	f_count := 0
	p_count := 0
	p_cycle := 0
	
	next_loop := 0
	gpu_select := 0
	test_count := 0
	last_files_svkiping := 0
	in_len := StrLen(in_path)
	GuiControl,,s_sv,Starting..
	GuiControl,,f_totalv,Scaning..
	GuiControl,,f_ppv,0
	GuiControl,,tspeed,-
	GuiControl,Disable,b_start
	GuiControl,Disable,b_startv
	GuiControl,Disable,b_start1
	GuiControl,Enabled,b_stop
	GuiControl,Enabled,b_stopv
	GuiControl,Enabled,b_stop1
	
	GuiControl,Disable,scale
	
	if (w2x_mode = 1)
	{
		process_path := "waifu2x-caffe-cui-p"
	}
	else
	{
		process_path := "waifu2x-ncnn-vulkan-p"
	}

	FileRemoveDir, %in_path%\temp, 1

	
	Loop, Files, %in_path%\*.*, F
	{
		if A_LoopFileExt in png,jpg,jpeg,tif,tiff,bmp,tga
		{
			f_count += 1
		}
	}

	
	GuiControl,,f_totalv,%f_count%
	
	IfNotExist, %in_path%\temp
	{
		FileCreateDir, %in_path%\temp
		i := 1
		while(i<=8)
		{
			FileCreateDir, %in_path%\temp\%i%
			i++
		}
	}
	
	IfNotExist, %out_path%
	{
		FileCreateDir, %out_path%
	}
	
	StartTime := A_TickCount
	
	Loop, Files, %in_path%\*.*, F
	{
		if A_LoopFileExt in png,jpg
		{
			if(stop = 1)
			{
				break
			}
			
			if A_LoopFileExt in webp
			{
				StringTrimRight, out_filename, A_LoopFileName, 5
			}
			else
			{
				StringTrimRight, out_filename, A_LoopFileName, 4
			}
			

			p_count += 1
			
			out_file_config := """" out_path "\" out_filename config_ext """"
			if skip_exist = 1
			{
				IfExist, %out_path%\%out_filename%%config_ext%.png
				{
					last_files_svkiping += 1
					if(last_files_svkiping = 1)
					{
						GuiControl,,f_ppv,Skipping..
					}
					Continue
				}
				else IfExist, %out_path%\%out_filename%%config_ext%
				{
					last_files_svkiping += 1
					if(last_files_svkiping = 1)
					{
						GuiControl,,f_ppv,Skipping..
					}
					Continue
				}
				else IfExist, %out_path%\%out_filename%.jpg.png
				{
					last_files_svkiping += 1
					if(last_files_svkiping = 1)
					{
						GuiControl,,f_ppv,Skipping..
					}
					Continue
				}
				else
				{
					last_files_svkiping := 0
					GuiControl,,f_ppv,%p_count%
				}
			}
			else
			{
				GuiControl,,f_ppv,%p_count%
			}
			
			
			buffer:

			fill_buuffer := 0
			while(fill_buuffer<=7)
			{
				fill_buuffer++

				if(enable_process%fill_buuffer% = 0)
				{
					continue
				}
				
				if(batch_count%fill_buuffer% = 0)
					FileCreateDir, %in_path%\temp\%fill_buuffer%_buffer
				
				if(batch_count%fill_buuffer% < batch_size)
				{
					FileCopy, %A_LoopFilePath%, %in_path%\temp\%fill_buuffer%_buffer
					batch_count%fill_buuffer%++
					test_count++
					if(p_count<f_count)
					{
						next_loop := 1
						break
					}
				}
				else
				{
					next_loop := 0
					continue
				}
			}
			
			if(A_index = f_count)
			{
				f_count := 0
				Loop, Files, %in_path%\*.*, F
				{
					if A_LoopFileExt in png,jpg,jpeg,tif,tiff,bmp,tga
					{
						f_count += 1
					}
				}
				

				fill_buuffer := 0
				while(fill_buuffer<8)
				{
					fill_buuffer++
					if(enable_process%fill_buuffer% = 0)
					{
						continue
					}
					FileCopy, %A_LoopFilePath%, %in_path%\temp\%fill_buuffer%_buffer
				}
				
				if(A_index = f_count)
				{
					break
				}
				else
				{
					GuiControl,,f_totalv,%f_count%
				}
			}
			
			if(next_loop<>1)
			{
				Loop
				{
					p_cycle += 1
					If p_cycle > %process_limit%
					{
						p_cycle := 1
					}
					if(stop = 1)
					{
						break
					}
					if(enable_process%p_cycle% = 0)
					{
						continue
					}
					process_name := process_path p_cycle ".exe"
					Process, Exist, %process_name%
					If (!ErrorLevel= 1)
					{
						FileRemoveDir, %in_path%\temp\%p_cycle%, 1
						FileMoveDir, %in_path%\temp\%p_cycle%_buffer, %in_path%\temp\%p_cycle%, R
						batch_count%p_cycle% := 0
						
						attribute2 := " --model_dir """ A_WorkingDir "\w2x_cuda\models\" modelv """"
						
						if (w2x_mode = 1)
						{
							If (by_size = 1)
							{
								run_command := """waifu2x-caffe-cui-p" p_cycle ".exe"" --gpu " config_gpu%p_cycle% " -p cudnn " "-w " sizew " -h " sizeh " " attribute2 " -n " noise_level " -m " "noise_scale -e " config_ext " -i """ in_path "\temp\" p_cycle """ -o """ out_path """"
							}
							else If (by_scale = 1)
							{
								run_command := """waifu2x-caffe-cui-p" p_cycle ".exe"" --gpu " config_gpu%p_cycle% " -p cudnn " "-s " scale " " attribute2 " -n " noise_level " -m " "noise_scale -e " config_ext " -i """ in_path "\temp\" p_cycle """ -o """ out_path """"
							}
							
							run, %comspec% /c cd "%A_WorkingDir%\w2x_cuda" & %run_command%,,%win_mode%
						}
						else
						{						
							run_command := """waifu2x-ncnn-vulkan-p" p_cycle ".exe"" -i """ in_path "\temp\" p_cycle """ -o """ out_path """ -n " noise_level " -s " scale " -t " config_t_size " -m """ A_WorkingDir "\w2x_vulkan\" modelv """ -g " config_gpu%p_cycle% " -j " J1 ":" J2 ":" J3 " -f " OutExtension
							run, %comspec% /c cd "%A_WorkingDir%\w2x_vulkan" & %run_command%,,%win_mode%
						}
						
						
						if(log_enable = 1)
						{
							gosub,log_console
						}
						
						;Msgbox,% A_WorkingDir "\w2x_cuda`r`r" run_command
						
						GuiControl,,s_file_processv%p_cycle%,%A_LoopFilePath%
						s_process_countv%p_cycle% += 1
						dv := s_process_countv%p_cycle%
						GuiControl,,s_process_countv%p_cycle%,%dv%
						per := (p_count/f_count)*100
						GuiControl,,p_pro,%per%
						per := Round(per,2)
						GuiControl,,s_percenv,%per% `%

						;wait_process
						Process, Wait, %process_name% , 10
						If (ErrorLevel=0)
						{
							Msgbox, Error Process Not Found.
							Return
						}
						
						goto,buffer
					}
					
					If (p_cycle > %process_limit%)
					{
						Sleep, %sleep_time%
					}
				}
			}
		}
	}
	
	Loop
	{
		p_cycle += 1
		If p_cycle > %process_limit%
		{
			p_cycle := 1
		}
		if(stop = 1)
		{
			break
		}
		if(enable_process%p_cycle% = 0)
		{
			continue
		}
		
		process_name := process_path p_cycle ".exe"
		Process, Exist, %process_name%
		If (!ErrorLevel= 1)
		{						
			FileRemoveDir, %in_path%\temp\%p_cycle%, 1
			FileMoveDir, %in_path%\temp\%p_cycle%_buffer, %in_path%\temp\%p_cycle%, R
			batch_count%p_cycle% := 0
			
			attribute2 := " --model_dir """ A_WorkingDir "\w2x_cuda\models\" modelv """"
			
			if (w2x_mode = 1)
			{
				If (by_size = 1)
				{
					run_command := """waifu2x-caffe-cui-p" p_cycle ".exe"" --gpu " config_gpu%p_cycle% " -p cudnn " "-w " sizew " -h " sizeh " " attribute2 " -n " noise_level " -m " "noise_scale -e " config_ext " -i """ in_path "\temp\" p_cycle """ -o """ out_path """"
				}
				else If (by_scale = 1)
				{
					run_command := """waifu2x-caffe-cui-p" p_cycle ".exe"" --gpu " config_gpu%p_cycle% " -p cudnn " "-s " scale " " attribute2 " -n " noise_level " -m " "noise_scale -e " config_ext " -i """ in_path "\temp\" p_cycle """ -o """ out_path """"
				}
				
				run, %comspec% /c cd "%A_WorkingDir%\w2x_cuda" & %run_command%,,%win_mode%
			}
			else
			{						
				run_command := """waifu2x-ncnn-vulkan-p" p_cycle ".exe"" -i """ in_path "\temp\" p_cycle """ -o """ out_path """ -n " noise_level " -s " scale " -t " config_t_size " -m """ A_WorkingDir "\w2x_vulkan\" modelv """ -g " config_gpu%p_cycle% " -j " J1 ":" J2 ":" J3 " -f " OutExtension
				run, %comspec% /c cd "%A_WorkingDir%\w2x_vulkan" & %run_command%,,%win_mode%
			}
		
			
			if(log_enable = 1)
			{
				gosub,log_console
			}


			sleep,200

			a:=0
			loop, Files, %in_path%\temp\*.*,F R
			{
				a++
			}
			
			if(a=0)
			{
				Break
			}
			else
			{
				continue
			}
		}
		
		If (p_cycle > %process_limit%)
		{
			Sleep, %sleep_time%
		}
	}


	
	t_sec := (A_TickCount-StartTime)/1000
	speed := Round(test_count/t_sec,3)
	GuiControl,,tspeed,%speed%
	GuiControl,,s_percenv,100 `%

	fix_name := 1
	If(fix_name=1)
	{
		Gui, 1:Show,hide
		Gui, 5:Add, Progress, y9 x7 w640 r6 +c777777, 100
		Gui, 5:Add, Text, y12 x10 w640 r6 vcurrent_fn +BackgroundTrans +ceeeeee, File Name : ...
		Gui, 5:Add, Progress, y92 x7 w640 r1 border +c00dd00 vtest_progress, 0
		Gui, 5:Add, Text, y92 x7 w640 +BackgroundTrans center r1 vtest_per,% 0.00 " %"
		Gui, 5:Color, bbbbbb
		Gui, 5:Default
		Gui, 5:Show, w654,Renaming..
		
		StartTime := A_TickCount

		
		Loop, Files, %out_path%\*.png.png , F
		{
			e_time := (A_TickCount-StartTime)
			If(e_time>500)
			{
				c_fn := A_LoopFileName
				StartTime := A_TickCount
				GuiControl,, current_fn,% "File Name : " A_LoopFileName
				progress_percent := (A_Index/f_count)*100
				progress_percent2 := Round(progress_percent,2)
				GuiControl,, test_progress, %progress_percent%
				GuiControl,, test_per, %progress_percent2% `%
			}
			loop_ext := SubStr(A_LoopFileName, -7)
			StringTrimLeft, loop_ext, loop_ext, 4
			StringTrimRight, loop_fpath, A_LoopFilePath, 8
			FileMove, %A_LoopFilePath%, %loop_fpath%%loop_ext%
		}
		
		Loop, Files, %out_path%\*.jpg.png , F
		{
			e_time := (A_TickCount-StartTime)
			If(e_time>500)
			{
				c_fn := A_LoopFileName
				StartTime := A_TickCount
				GuiControl,, current_fn,% "File Name : " A_LoopFileName
				progress_percent := (A_Index/f_count)*100
				progress_percent2 := Round(progress_percent,2)
				GuiControl,, test_progress, %progress_percent%
				GuiControl,, test_per, %progress_percent2% `%
			}
			loop_ext := SubStr(A_LoopFileName, -7)
			StringTrimLeft, loop_ext, loop_ext, 4
			StringTrimRight, loop_fpath, A_LoopFilePath, 8
			FileMove, %A_LoopFilePath%, %loop_fpath%%loop_ext%
		}

		GuiControl,, test_progress, 100
		GuiControl,, test_per, 100.00 `%
		
		Gui, 1:Default
		Gui, 5:Destroy
		Gui, 1:Show
	}
	
	FileRemoveDir, %in_path%\temp, 1
	GuiControl,,f_ppv,%p_count%
	GuiControl,Enabled,b_start
	GuiControl,Enabled,b_startv
	GuiControl,Enabled,b_startv1
	GuiControl,Enabled,scale
	GuiControl,Disable,b_stop
	GuiControl,Disable,b_stopv
	GuiControl,Disable,b_stopv1
	
	if(stop = 1)
	{
		GuiControl,,s_sv,Stopped
	}
	else
	{
		GuiControl,,s_sv,Finished
		per := (p_count/f_count)*100
		GuiControl,,p_pro,%per%
	}
	stop := 1
	goto, gui_update
}
return
check_file:
{
	GuiControl,Disable,b_start
	GuiControl,Disable,b_start1
	GuiControl,Enabled,b_stop
	GuiControl,Enabled,b_stop1
	f_count := 0
	l_count := 0
	stop := 0
	damage_count := 0
	
	Loop, Files, %in_path%\*.*, FR
	{
		if A_LoopFileExt in png,jpg,jpeg,tif,tiff,bmp,tga
		{
			f_count += 1
		}
	}
	

	
	StartTime := A_TickCount
	
	c_main_h := 0
	c_main_w := 0
	c_size_count := 0
	
	; SSIM Config
	ssim_cycle := 0
	ssim_limit_thread := 4
	ssim_file_count := 0
	
	Loop, Files, %in_path%\*.*, FR
	{
		if A_LoopFileExt in png,jpg,jpeg,tif,tiff,bmp,tga
		{
			l_count++
			if(stop = 1)
			{
				break
			}
				SplitPath, A_LoopFilePath,,,, name_no_ext
				loop_out_filepath := out_path "\" name_no_ext config_ext
			
				if !FileExist(loop_out_filepath)
				{
					LV_Add("","Output Not Found : " loop_out_filepath)
					continue
				}
				
				imagefile := loop_out_filepath
				GDIPToken := Gdip_Startup()                                     
				pBM := Gdip_CreateBitmapFromFile( imagefile )
				img_w1:= Gdip_GetImageWidth( pBM ) 
				img_h1:= Gdip_GetImageHeight( pBM ) 
				Gdip_DisposeImage( pBM )
				Gdip_Shutdown( GDIPToken ) 
			
			if(img_w1>0)
			{
				if(enable_check_res = 1)
				{
					if(c_size_count>0)
					{
						if(img_w1 <> c_main_w1) || (img_w1 <> c_main_w1)
						{
							while(LV_GetCount() >= log_limit)
							{
								LV_Delete(1)
							}
							LV_Add("","Not Match Output Size : " loop_out_filepath)
							
							if(check_action = "Delete")
							{
								FileDelete, %loop_out_filepath%
								LV_Add("","Deleted : " A_LoopFileName)
							}
							else if(check_action = "Move")
							{
								FileMove, %loop_out_filepath%, %check_action_move_path%\%A_LoopFileName%
								LV_Add("","Moved : " A_LoopFileName)
							}
							damage_count++
						}
						if(enable_check_ssim = 1)
						{
							loop
							{
								ssim_cycle++
								if(ssim_cycle=ssim_limit_thread)
								{
									sleep,50
								}
								process_name := "ffmpeg_p" ssim_cycle ".exe"
								Process, Exist, %process_name%
								If (!ErrorLevel= 1)
								{
									ssim_file_count++
									if (ssim_cycle>ssim_limit_thread)
									{
										ssim_cycle := 1
									}
									;SSIM Read Log
									if(ssim_file_count>ssim_limit_thread)
									{
										re_read:
										ssim_filename := ssim_filename_%ssim_cycle%
										ssim_filepath := ssim_filepath_%ssim_cycle%
										FileRead, ssim_log, ssim_%ssim_cycle%.log
										if(ssim_log="")
										{
											sleep,33
											goto,re_read
										}
										StringTrimLeft, ssim_log, ssim_log, 41
										StringTrimRight, ssim_log, ssim_log, 13
										ssim_log := ssim_log*100
										while(LV_GetCount() >= log_limit)
										{
											LV_Delete(1)
										}
										if(ssim_log<check_bad_ssim)
										{
											LV_Add("", "Bad SSIM : " ssim_log " : " ssim_filename)
											if(check_action = "Delete")
											{
												FileDelete, %out_path%\ssim_filename
												LV_Add("","Deleted : " ssim_filename)
											}
											else if(check_action = "Move")
											{
												FileMove, ssim_filepath, %check_action_move_path%\%ssim_filename%
												LV_Add("","Moved : " ssim_filename)
											}
										}
									}
									run_command := """" A_WorkingDir "\ffmpeg\ffmpeg_p" ssim_cycle ".exe"" -i """ A_LoopFilePath """ -i """ out_path "\" A_LoopFileName """ -lavfi ""[1:v]scale=" img_w ":" img_h "[vid1];[vid1][0:v]ssim=ssim_" ssim_cycle ".log"" -f null -"
									Run, %comspec% /c cd "%A_WorkingDir%" & %run_command%,,hide
									ssim_filename_%ssim_cycle% := A_LoopFileName
									ssim_filepath_%ssim_cycle% := A_LoopFilePath
									break
								}
							}
						}
					}
					else ;setup first file
					{
						if(check_res_mode = "First File")
						{
							c_main_w1 := img_w1
							c_main_h1 := img_h1
						}
						else
						{
							c_main_w1 := check_custom_w
							c_main_h1 := check_custom_h
						}
						while(LV_GetCount() >= log_limit)
						{
							LV_Delete(1)
						}
						LV_Add("","Output Size : " img_w1 "x" img_h1 )
					}
					c_size_count++
				}
			}
			else
			{
				while(LV_GetCount() >= log_limit)
				{
					LV_Delete(1)
				}
				LV_Add("","Bad File : " loop_out_filepath)
				if(check_action = "Delete")
				{
				FileDelete, %loop_out_filepath%
				LV_Add("","Deleted : " A_LoopFileName)
				}
				else if(check_action = "Move")
				{
					FileMove, %loop_out_filepath%, %check_action_move_path%\%A_LoopFileName%
					LV_Add("","Moved : " A_LoopFileName)
				}
				damage_count++
			}
			if(f_count<2000)
			{
				per := (l_count/f_count)*100
				GuiControl,,p_pro,%per%
				per := Round(per,2)
				GuiControl,,s_percen,%per% `%
				GuiControl,,s_file_process1,%A_LoopFilePath%
				GuiControl,,s_process_count1,% l_count
			}
			else
			{
				ElapsedTime := A_TickCount - StartTime
				if(ElapsedTime > 500)
				{
					per := (l_count/f_count)*100
					GuiControl,,p_pro,%per%
					per := Round(per,2)
					GuiControl,,s_percen,%per% `%
					StartTime := A_TickCount
					GuiControl,,s_file_process1,%A_LoopFilePath%
					GuiControl,,s_process_count1,% l_count
				}
			}
		}
	}
	
	per := (l_count/f_count)*100
	GuiControl,,p_pro,%per%
	per := Round(per,2)
	GuiControl,,s_percen,%per% `%
	GuiControl,,s_file_process1,%imagefile%
	GuiControl,,s_process_count1,% l_count
	
	GuiControl,Enabled,b_start
	GuiControl,Enabled,b_start1
	GuiControl,Disable,b_stop
	GuiControl,Disable,b_stop1
	LV_Add("", damage_count " File has Damaged.")
}
Return
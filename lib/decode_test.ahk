decode_test:
{
	If(vp_in_path = "")
	{
		MsgBox, No Input File
		Return
	}
	run_command := ""
	run_command1 := ""
	run_command2 := ""
	run_command3 := ""
	run_command4 := ""
	run_command5 := ""
	run_command6 := ""
	SplitPath, vp_in_path, in_name_ext, in_dir, in_ext, in_name
	
	run_command .= """" A_WorkingDir "\ffmpeg\ffmpeg_p1.exe""" " -hide_banner -loglevel info"
	
	if(image_input=1)
	{
		run_command2 .= " -i """ in_dir "\image%06d." in_ext """"
	}
	else if(image_input=2)
	{
		run_command2 .= " -i """ in_dir "\%06d." in_ext """"
	}
	else
	{
		run_command2 .= " -i """ vp_in_path """"
	}
	
	FileDelete, %A_WorkingDir%\output.txt
	
	run_command6 .= " -f null - 1> " A_WorkingDir "\output.txt 2>&1"

	run_command .= run_command1 run_command2 run_command3 run_command4 run_command5 run_command6
	gosub,log_console

	Run, %comspec% /c "%run_command%",,Hide
	
	pro_color := "00dd00"
	
	Gui, 3:destroy
	Gui, 1:show,hide
	Gui, 3:Add, Progress, y9 x7 w640 r6 +c777777, 100
	Gui, 3:Add, Text, y12 x10 w640 r6 vcom_display +BackgroundTrans +ceeeeee,
	Gui, 3:Add, Progress, y92 x7 w640 r1 border +c%pro_color% vtest_progress, 0
	Gui, 3:Add, Text, y92 x7 w640 +BackgroundTrans center r1 vtest_per,% 0.00 " %"
	Gui, 3:Show, w654,Decode Testing..
	Gui, 3:Default
	Gui, 3:Color, bbbbbb
	sleep,100
	
	StartTime := A_TickCount
	stop:=0
	i:=1
	last := 0
	err_count := 0
	loop
	{
		if(stop=1)
		{
			Break
		}
		
		FileReadLine, line, %A_WorkingDir%\output.txt, %i%
		if(line != last_line)
		{
			ElapsedTime := A_TickCount - StartTime
			last_line := line
			i++
			If InStr(line, "error") || InStr(line, "Invalid") || InStr(line, "not allocated")
			{
				if(last=0)
				{
					StartTime := A_TickCount
					GuiControl,, com_display,% i " : " line
				}
				else if(ElapsedTime>500)
				{
					last=-1
					StartTime := A_TickCount
				}
				last++
				err_count++
				if(err_count>0)
				{
					kill_ffmpeg:
					{
						Process, Close, ffmpeg_p1.exe
						Sleep, 50
						if Process, Exist , ffmpeg_p1.exe
						{
							Goto, kill_ffmpeg
						}
					}
					a := i-5
					l := 0
					error_re := ""
					while(l<5)
					{
						FileReadLine, line2, %A_WorkingDir%\output.txt,% a + l
						error_re .= a + l " : " line2 "`r"
						l++
					}
					GuiControl,, com_display,% error_re
					pro_color := "dd0000"
					GuiControl, Hide, test_progress
					Gui, 3:Add, Progress, y92 x7 w640 r1 border +c%pro_color%,% progress_percent
					break
				}
				Continue
			}
			If InStr(line, "overhead:")
			{
				Break
			}
		}
		If InStr(line, "frame=")
		{
			StringTrimLeft,progress_info,line,6
			progress_info := StrReplace(progress_info, A_Space)
			current_frame := StrSplit(progress_info,"fps=","fps=")
			progress_fps := StrSplit(current_frame[2],"q=","q=")
			GuiControl,, com_display,% "Current Frame : " current_frame[1] "`rSpeed : " progress_fps[1] " fps"
			progress_percent := (current_frame[1] / video_n_frame) * 100
			GuiControl,,test_progress,% progress_percent
			progress_percent2 := Round(progress_percent,2)
			GuiControl,,test_per,% progress_percent2 " %"
			sleep,250
		}
	}
	
	if(err_count>0)
	{
		msgbox,0x2030, Media Info, Decoding Test, Error Detected!
	}
	else
	{
		msgbox,0x2040, Media Info, Decoding Test, Decode Successful!
	}
	Gui, 1:Default
	Gui, 3:destroy
	Gui, 1:show
}
Return
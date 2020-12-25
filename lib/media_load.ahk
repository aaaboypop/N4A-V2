media_load:
{
	Gui, 1:+Disabled
	Gui, 3:Add,Text,w200 r3 cRed center vload_text, `nLoading..
	Gui, 3:Show,, Media Info
	Gui, 3:+Disabled
	Gui, 3:Default			
	media_load := 1
	image_input := 0
	load_image_count := 0
	SplitPath, vp_in_path, load_name, load_fullpath, load_ext, in_name_no_ext
	if(load_ext="png"||load_ext="jpg")
	{
		ifExist, %load_fullpath%\image000001.*
		{
			Loop, Files, %load_fullpath%\image*.* , F
			{
				load_image_count++
			}
			image_input := 1
			video_n_frame := load_image_count
			
			Gui, 4:Add, ListView,, General|Info
			Gui, 4:Default			
			LV_Add("", "Input Type", load_ext)
			LV_Add("", "Frame", load_image_count)

			LV_ModifyCol() 
			Gui, 4:-Resize -MaximizeBox -MinimizeBox +ToolWindow
			Gui, 4:Show,, Media Info
			
			
		}
		else If (FileExist(load_fullpath "\000001.*")) 
		{
			Loop, Files, %load_fullpath%\*.* , F
			{
				load_image_count++
			}
			image_input := 2
			video_n_frame := load_image_count
			
			Gui, 4:Add, ListView,, General|Info
			Gui, 4:Default			
			LV_Add("", "Input Type", load_ext)
			LV_Add("", "Frame", load_image_count)

			LV_ModifyCol() 
			Gui, 4:-Resize -MaximizeBox -MinimizeBox +ToolWindow
			Gui, 4:Show,, Media Info
			
			
		}
		else
		{
			msgbox,0x2000, Media Info,% "Not Found Image Format ""image%06d"""
			Gui, 4:destroy
			Gui, 1:-Disabled
		}
	}
	else if(load_ext="mkv"||load_ext="mp4"||load_ext="mov"||load_ext="wmv"||load_ext="ts"||load_ext="m4v")
	{
		GuiControl,,load_text, Loading..`nMedia Infomation
		Gui, 4:Add, ListView, r32 w600, General|Info
		Gui, 4:Default	
		
		var1 = mediainfo --Output=XML "%vp_in_path%"
		c4 := ""
		c4 := StdOutToVar(comspec . " /c " . A_WorkingDir . "\ffmpeg\" . var1)

		add_row := 0
		Loop, parse, c4, `r,
		{
			If RegExMatch(A_LoopField,"(<[^\/].*?>)",get_txt)
			{
				If RegExMatch(get_txt,"<Format>")
					add_row := 1

				If(add_row=0)
					continue
				
				If RegExMatch(get_txt,"<track type=""Video"">")
				{
					LV_Add("")
					LV_Add("", "<Video>")
				}
				else If RegExMatch(get_txt,"<track type=""Audio"">")
				{
					LV_Add("")
					LV_Add("", "<Audio>")
				}
				else If RegExMatch(get_txt,"<track type=""Menu"">")
				{
					LV_Add("")
					LV_Add("", "<Menu>")
				}
				else
				{
					get_title := RegExReplace(get_txt, "(<|>)")
					get_value := RegExReplace(A_LoopField, "(<.*?>)")
					LV_Add("", get_title, get_value)
				}
				
			}
		}
		LV_ModifyCol() 
		Gui, 4:+AlwaysOnTop +ToolWindow
		Gui, 4:Show,, Media Info
	}
	else
	{
		media_load := 0
		msgbox,0x2000, Media Info, Not Support FileFormat.
		GuiControl,,vp_in_path,
		Gui, 4:destroy
		Gui, 1:-Disabled
	}
	Gui, 3:Destroy
}
Return

4GuiClose:
{
	Gui, 1:Default
	Gui, 4:destroy
	Gui, 1:-Disabled
}
Return
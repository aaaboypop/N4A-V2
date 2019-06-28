vp_in_path := ""
vp_out_path := ""
pv_in_path := ""
pv_in_audio := ""
pv_out_path := ""
config_ext1 := ".mp4"
config_ext2 := ".jpg"
config_ext3 := ".mp4"
config_ext4 := ".jpg"
fps := "23.976"
crf := 18
ex_command := "-metadata description=""https://www.facebook.com/Net4Anime"""

Gui, Add, GroupBox, x12 y9 w310 h400 , Video to Image

Gui, Add, Text, x22 y29 w70 h20 , Input Folder :
Gui, Add, Edit, x102 y29 w180 h20 vvp_in_path ggui_update, %vp_in_path%

Gui, Add, Text, x22 y49 w70 h20 , Output Folder :
Gui, Add, Edit, x102 y49 w180 h20 vvp_out_path ggui_update, %vp_out_path%

Gui, Add, Button, x282 y29 w30 h20 gvid_to_pic_in_folder, ...
Gui, Add, Button, x282 y49 w30 h20 gvid_to_pic_out_folder, ...

Gui, Add, Text, x22 y309 w70 h20 right , Input Ext :
Gui, Add, DropDownList, x102 y309 w50 h20 vconfig_ext1 r8 ggui_update, .mp4||.mkv|.wma|.flv|.mov

Gui, Add, Text, x22 y329 w70 h20 right , Output Ext :
Gui, Add, DropDownList, x102 y329 w50 h20 vconfig_ext2 r8 ggui_update, .jpg|.png||.bmp


Gui, Add, GroupBox, x322 y9 w310 h400 , Image to Video
Gui, Add, Text, x332 y29 w70 h20 , Input Folder :
Gui, Add, Edit, x412 y29 w180 h20 vpv_in_path ggui_update, %pv_in_path%
Gui, Add, CheckBox, x332 y79 w90 h20 vadd_audio Checked ggui_update, Audio
Gui, Add, Text, x332 y99 w70 h20 , Input Audio :
Gui, Add, Edit, x412 y99 w180 h20 vpv_in_audio ggui_update, %pv_in_audio%

Gui, Add, CheckBox, x22 y79 w190 h20 vconvert_enable Checked ggui_update, Convert to Constant Frame Rate 
Gui, Add, DropDownList, x+10 y79 w60 h20 vconvert_fps r8 ggui_update, 15|23.976||24|25|29.97|30|50|59.94|60|100|120
Gui, Add, CheckBox, x22 y109 w160 h20 vaudio_extract Checked ggui_update, Extract Audio
Gui, Add, Text, x22 y129 w70 h20 , Output Audio :
Gui, Add, Edit, x102 y129 w180 h20 vaudio_out_path ggui_update, %vp_out_path%
Gui, Add, Text, x22 y169 w70 h20 , Image Quality :
Gui, Add, Edit, x102 y169 w180 h20 vvp_quality ggui_update, 1
Gui, Add, Button, x282 y129 w30 h20 gvid_to_pic_out_audio, ...

Gui, Add, Text, x332 y49 w70 h20 , Output Folder :
Gui, Add, Edit, x412 y49 w180 h20 vpv_out_path ggui_update, %pv_out_path%
Gui, Add, Text, x332 y149 w70 h20 , CRF :
Gui, Add, Edit, x412 y149 w180 h20 vcrf ggui_update, %crf%
Gui, Add, Text, x332 y169 w70 h20 , Frame Rate :
Gui, Add, Edit, x412 y169 w180 h20 vfps ggui_update, %fps%
Gui, Add, Text, x652 y29 w70 h20 , Extra :
Gui, Add, Edit, x702 y29 w180 h20 vex_command ggui_update, %ex_command%
Gui, Add, Text, x332 y309 w70 h20 right, Input Ext :
Gui, Add, DropDownList, x412 y309 w50 h20 vconfig_ext3 r8 ggui_update, .jpg||.png|.bmp
Gui, Add, Text, x332 y329 w70 h20 right, Output Ext :
Gui, Add, DropDownList, x412 y329 w50 h20 vconfig_ext4 r8 ggui_update, .mp4||.mkv|.wma|.flv|.mov
Gui, Add, Button, x592 y29 w30 h20 gpic_to_vid_in_folder, ...
Gui, Add, Button, x592 y99 w30 h20 gpic_to_vid_in_audio, ...
Gui, Add, Button, x592 y49 w30 h20 gpic_to_vid_out_folder, ...

Gui, Add, Edit, x12 y419 w620 h80 -VScroll vl_com,

Gui, Add, button, x332 y379 w150 h20 vb_start grun_pic_to_vid, Start
Gui, Add, button, x22 y379 w150 h20 vb_stop grun_vid_to_pic, Start

Gui, Add, Text, x652 y519 w240 h20, by pond_pop @ www.facebook.com/Net4Anime

Gui, Submit, NoHide
Gui, Show, x345 y137 h539 w895, N4A-V2

gui_update:
{
	Gui, Submit, NoHide
}
return

;picture to video
pic_to_vid_in_folder:
{
	Thread, NoTimers
	FileSelectFolder, pv_in_path,, 3
	Thread, NoTimers, false
	GuiControl,,pv_in_path,%pv_in_path%
}
Return

pic_to_vid_in_audio:
{
	Thread, NoTimers
	FileSelectFile, pv_in_audio,,,,(*.wav)
	Thread, NoTimers, false
	GuiControl,,pv_in_audio,%pv_in_audio%
}
Return

pic_to_vid_out_folder:
{
	Thread, NoTimers
	FileSelectFolder, pv_out_path,,, 3
	Thread, NoTimers, false
	GuiControl,,pv_out_path,%pv_out_path%
}
Return

;video to picture
vid_to_pic_in_folder:
{
	Thread, NoTimers
	FileSelectFolder, vp_in_path,, 3
	Thread, NoTimers, false
	GuiControl,,vp_in_path,%vp_in_path%
}
Return

vid_to_pic_out_folder:
{
	Thread, NoTimers
	FileSelectFolder, vp_out_path,, 3
	Thread, NoTimers, false
	GuiControl,,vp_out_path,%vp_out_path%
}
Return

vid_to_pic_out_audio:
{
	Thread, NoTimers
	FileSelectFile, audio_out_path, s,,, *.wav
	Thread, NoTimers, false
	StringReplace, audio_out_path, audio_out_path, .wav, , All
	audio_out_path := audio_out_path ".wav"
	GuiControl,,audio_out_path,%audio_out_path%
}
Return



run_pic_to_vid:
{
	loopc := pv_in_path "\*" config_ext3
	
	Loop, Files, %loopc%, F
	{
		StringTrimRight, out_filename, A_LoopFileName, 10
		
		IfExist, %pv_out_path%\%out_filename%%config_ext4%
		{
			MsgBox, 4,, File Exist Do you want to Delete?
			IfMsgBox Yes
				FileDelete, %pv_out_path%\%out_filename%%config_ext4%
			else
				break
		}
		
		IfNotExist, %pv_out_path%
		{
			FileCreateDir, %pv_out_path%
		}

		;video
			video_c1 := " -framerate " fps 
			video_c2 := " -i """ pv_in_path "\" out_filename "%06d." A_LoopFileExt """"
			video_c3 := " -c:v libx264 -vf fps=" fps " -pix_fmt yuv420p -crf " crf " " ex_command
			video_c4 := " """ pv_out_path "\" out_filename config_ext4 """"

		;audio
		if(add_audio = 1)
		{
			audio_c1 := " -i """ pv_in_audio """"
			audio_c2 := " -codec:a libmp3lame -b:a 320k" 
		}
		else
		{
			audio_c1 := ""
			audio_c2 := "" 
		}
		
		command := """" A_WorkingDir "\bin\ffmpeg.exe""" video_c1 video_c2 audio_c1 audio_c2 video_c3 video_c4
		GuiControl,,l_com,%command%
		RunWait,  %command%, ,
		break
	}
	msgbox, Finished
}
Return

run_vid_to_pic:
{
	loopc := vp_in_path "\*" config_ext1
	Loop, Files, %loopc%, F
	{
		StringTrimRight, filename, A_LoopFileName, 4
		IfNotExist, %vp_out_path%\%filename%
		{
			FileCreateDir, %vp_out_path%\%filename%
		}
		if(convert_enable = 1)
		{
			attribute3 := " -vsync 1 -vf fps=" convert_fps
		}
		else
		{
			attribute3 := ""
		}
		
		if(audio_extract = 1)
		{
			attribute5 := " """ audio_out_path "\" filename ".wav"""
		}
		else
		{
			attribute5 := ""
		}
		
		if(config_ext2 = ".jpg")
		{
			attribute4 := " -q:v " vp_quality
		}
		command := """" A_WorkingDir "\bin\ffmpeg.exe"" -i """ A_LoopFilePath """" attribute3 attribute4 " """ vp_out_path "\" filename "\image%06d" config_ext2 """" attribute5
		GuiControl,,l_com,%command%
		RunWait,  %command%, ,
	}
	MsgBox, Finished!
}
Return

guiclose:
exit:
{
	exitapp
}
return

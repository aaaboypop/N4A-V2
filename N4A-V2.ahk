#SingleInstance, OFF
#Include, lib\lib.ahk
SetWorkingDir %A_ScriptDir%
FileInstall, lib\lib.ahk, lib\lib.ahk, 1
FileInstall, lib\load_env.ahk, lib\load_env.ahk, 1

version := "0.12.0"
build := "20201224"

model_name1 := "anime_style_art"
model_name2 := "anime_style_art_rgb"
model_name3 := "cunet"
model_name4 := "photo"
model_name5 := "upconv_7_anime_style_art_rgb"
model_name6 := "upconv_7_photo"
model_name7 := "upresnet10"

config_ext2 := ".jpg"
config_ext3 := ".mp4"
config_ext4 := ".jpg"
fps := "23.976"
crf := 18

#Include, lib\load_env.ahk

Gui, Add, Tab3, x2 y0 w900 h570 vcurrent_tab ggui_update, Media|Test Mode|Waifu2X|Frame Interpolation|Console Log
Gui, Color, FFFFFF


#Include, lib\gtab_framei.ahk
#Include, lib\gtab_w2x.ahk
#Include, lib\gtab_media.ahk
#Include, lib\gtab_test.ahk
#Include, lib\gtab_log.ahk

Gui, Tab, 
Gui, Add, Text, x652 y539 w240 h20 , by pond_pop @ www.facebook.com/Net4Anime

#Include, lib\gsetting.ahk

;==== GUI Window ====
Gui, Show, x413 y187 h560 w900, N4A-V2 - %version% %build%
Menu, Tray, Tip, Version : %version% `nBuild : %build%
Gosub, gui_update
Gosub, alt_guiupdate
Return

console_log:
{
	LastEventInfo := LV_GetNext(0, "F")
	LV_GetText(var1, LastEventInfo, 1)
	
	clipboard := var1
}
Return

gui2:
{
	Gui, 2:destroy
	Gui, 2:Add,Button, x2 y2 h20 w60 ggui2_r,Launch
	Gui, 2:Add,Edit, x2 y22 h696 w596 Readonly vshow_script,DeinterlaceFilter(Experimental)`n
	Gui, 2:Show, h720 w600, Filter Script
}
Return

gui2_r:
{
	If(vp_in_path = "")
	{
		MsgBox, No Input File
		Return
	}

	If(vp_out_path = "")
	{
		vp_out_path := A_WorkingDir
	}
	else if !FileExist(vp_out_path)
	{
		FileCreateDir, %vp_out_path%
	}

	out_filename = %vp_out_path%\%in_name_no_ext%_Deinterlace.%load_ext%
	if FileExist(out_filename)
	{
		MsgBox, Output File Exist
		Run,"%vp_out_path%"
		Return
	}
	
	s_script := load_script0()
	;GuiControl,,show_script,% s_script
	FileDelete, %A_WorkingDir%\filter\temp\vs_script.vpy
	FileDelete, %A_WorkingDir%\filter\temp\run_script.bat
	Sleep, 1000
	FileAppend , %s_script%, %A_WorkingDir%\filter\temp\vs_script.vpy, UTF-8
	
	FileAppend,cd "%A_WorkingDir%\ffmpeg" `nvspipe --y4m "%A_WorkingDir%\filter\temp\vs_script.vpy" - | ffmpeg -i pipe: -i "%vp_in_path%" -c:v libx264 -qp 0 -preset ultrafast -map 0:v:0 -map 1:a:0 -codec:a copy "%out_filename%", %A_WorkingDir%\filter\temp\run_script.bat
	RunWait %ComSpec% /c ""%A_WorkingDir%\filter\temp\run_script.bat"
	Run,"%vp_out_path%"
	GuiControl,,show_script,Finished~!
}
Return

2GuiClose:
{
	Gui, 2:destroy
}
Return

3GuiClose:
{
	Process, Close, ffmpeg_p1.exe
	Sleep, 50
	while Process, Exist , ffmpeg_p1.exe
	{
		Process, Close, ffmpeg_p1.exe
	}
	stop := 1
	Gui, 3:destroy
}
Return


load_script1()
{
	Global filter_path
	Global vp_in_path
	filter_path := A_WorkingDir "/filter"
	filter_path := RegExReplace(filter_path, "\\", "/")
	source_path := StrReplace(vp_in_path, "\", "/")

	Global s_script
	s_script := ""
	s_script .= "import os" "`n"
	s_script .= "import sys" "`n"
	s_script .= "import ctypes" "`n"
	s_script .= "Dllref = ctypes.windll.LoadLibrary(""" filter_path "/vsfilters/Support/libfftw3f-3.dll"")" "`n"
	s_script .= "Dllref = ctypes.windll.LoadLibrary(""" filter_path "/vsfilters/ResizeFilter/Waifu2x/w2xc.dll"")" "`n"
	
	s_script .= "import vapoursynth as vs" "`n"
	s_script .= "core = vs.get_core()" "`n"

	s_script .= "scriptPath = '" filter_path "/vsscripts'" "`n"
	s_script .= "sys.path.append(os.path.abspath(scriptPath))" "`n"
	
	import_plugin("/vsfilters/DenoiseFilter/TTempSmooth/TTempSmooth.dll")
	import_plugin("/vsfilters/ResizeFilter/Waifu2x/Waifu2x-w2xc.dll")
	import_plugin("/vsfilters/GrainFilter/AddGrain/AddGrain.dll")
	import_plugin("/vsfilters/DenoiseFilter/FFT3DFilter/fft3dfilter.dll")
	import_plugin("/vsfilters/DeinterlaceFilter/TDeintMod/TDeintMod.dll")
	import_plugin("/vsfilters/DenoiseFilter/DFTTest/DFTTest.dll")
	import_plugin("/vsfilters/Support/libmvtools.dll")
	import_plugin("/vsfilters/Support/temporalsoften.dll")
	import_plugin("/vsfilters/Support/scenechange.dll")
	import_plugin("/vsfilters/Support/vs_sangnommod.dll")
	import_plugin("/vsfilters/Support/EEDI3.dll")
	import_plugin("/vsfilters/Support/EEDI2.dll")
	import_plugin("/vsfilters/ResizeFilter/nnedi3/NNEDI3CL.dll")
	import_plugin("/vsfilters/ResizeFilter/nnedi3/vsznedi3.dll")
	import_plugin("/vsfilters/DeinterlaceFilter/Yadifmod/Yadifmod.dll")
	import_plugin("/vsfilters/Support/fmtconv.dll")
	import_plugin("/vsfilters/SourceFilter/LSmashSource/vslsmashsource.dll")
	import_plugin("/vsfilters/SharpenFilter/AWarpSharp2/libawarpsharp2.dll")
	import_plugin("/vsfilters/DebandFilter/Flash3kDeband/flash3kyuu_deband.dll")
	import_plugin("/vsfilters/DenoiseFilter/KNLMeansCL/KNLMeansCL.dll")
	;import_plugin("/vsfilters/SourceFilter/Imagemagick/libimwri.dll")
	Import_scripts("havsfunc")
	Import_scripts("mvsfunc")
	Import_scripts("muvsfunc")
	Import_scripts("G41Fun")
	Import_scripts("edi_rpow2")
	Import_scripts("hysteria")
	Import_scripts("functools")
	Import_scripts("kagefunc as vsutil")
	
	
	Return s_script
}


import_plugin(plugin)
{
	global s_script, filter_path
	s_script .= "core.std.LoadPlugin(path=""" filter_path plugin """)" "`n"
}

Import_scripts(script)
{
	global s_script
	s_script .= "import " script "`n"
}

load_script0()
{
	global media_load
	global s_path
	global load_fullpath
	global image_input
	global load_image_count
	global load_ext
	global convert_fps_num
	global convert_fps_den
	global convert_enable
	
	Global vp_in_path

	s_path := StrReplace(vp_in_path, "\","/")

	if(media_load=1)
	{

		s_script := load_script1()
		
		s_script .= "clip = core.lsmas.LWLibavSource(source=""" s_path """, cache=0)" "`n"

		MsgBox, 4, , Interlace is NOT "Store" Type? (default: YES)
		IfMsgBox No
		{
			MsgBox, 4, , Top Field First? (default: YES)
				IfMsgBox Yes
				{
					s_script .= "clip = core.vivtc.VFM(clip=clip, order=0)" "`n"
				}
				else
				{
					s_script .= "clip = core.vivtc.VFM(clip=clip, order=1)" "`n"
				}
		}
		IfMsgBox Yes
		{
			s_script .= "clip = core.vivtc.VFM(clip=clip, order=0)" "`n"
			s_script .= "clip = havsfunc.QTGMC(Input=clip,Preset='Placebo', TFF=False, opencl=True, device=0)" "`n"
			s_script .= "clip = clip[::2]" "`n"
		}

		s_script .= "clip = core.resize.Bicubic(clip=clip, format=vs.YUV444P8, range_s=""limited"")" "`n"
		s_script .= "clip.set_output()"
		Return s_script
	}
	
}

#Include, lib\gupdate.ahk
#Include, lib\gdrop_file.ahk
#Include, lib\media_load.ahk
#Include, lib\decode_test.ahk
#Include, lib\test_check.ahk
#Include, lib\r_ffmpeg.ahk
#Include, lib\r_w2x.ahk
#Include, lib\save_setting.ahk

add_filter(var1)
{
	global filter_count
	if(filter_count=0)
	{
		var2 := " -filter_complex """ var1
		filter_count++
		return var2
	}
	else
	{
		var2 := "[vid" filter_count "];[vid" filter_count "]" var1
		filter_count++
		return var2
	}
}


in_folder:
{
	Thread, NoTimers
	FileSelectFolder, in_path,, 3
	Thread, NoTimers, false
	if(in_path<>"")
		GuiControl,,in_path,%in_path%
}
Return

out_folder:
{
	Thread, NoTimers
	FileSelectFolder, out_path,, 3
	Thread, NoTimers, false
	if(out_path<>"")
		GuiControl,,out_path,%out_path%
}
Return

in_folderv:
{
	Thread, NoTimers
	FileSelectFolder, in_path,, 3
	Thread, NoTimers, false
	if(in_path<>"")
		GuiControl,,in_path,%in_path%
}
Return

out_folderv:
{
	Thread, NoTimers
	FileSelectFolder, out_path,, 3
	Thread, NoTimers, false
	if(out_path<>"")
		GuiControl,,out_path,%out_path%
}
Return


in_folderi:
{
	Thread, NoTimers
	FileSelectFolder, in_path1,, 3
	Thread, NoTimers, false
	if(in_path1<>"")
		GuiControl,,in_path1,%in_path1%
}
Return

out_folderi:
{
	Thread, NoTimers
	FileSelectFolder, out_path1,, 3
	Thread, NoTimers, false
	if(out_path1<>"")
		GuiControl,,out_path1,%out_path1%
}
Return


RemoveToolTip:
ToolTip
return

log_console:
{
	while(LV_GetCount() >= log_limit)
	{
		LV_Delete(1)
	}
	LV_Add("", run_command)
}
Return


run_stop:
{
	stop := 1
	GuiControl,Enabled,b_startv
	GuiControl,Enabled,b_startv1
	GuiControl,Disable,b_stopv
	GuiControl,Disable,b_stopv1
}
return


vid_to_pic_in_folder:
{
	Thread, NoTimers
	FileSelectFile, vp_in_path
	Thread, NoTimers, false
	if(vp_in_path<>"")
	{
		GuiControl,,vp_in_path,%vp_in_path%
		goto,media_load
	}
}
Return

vid_to_pic_out_folder:
{
	Thread, NoTimers
	FileSelectFolder, vp_out_path,, 3
	Thread, NoTimers, false
	if(vp_out_path<>"")
		GuiControl,,vp_out_path,%vp_out_path%
}
Return

add_audio_file:
{
	Thread, NoTimers
	FileSelectFile, add_audio_path
	Thread, NoTimers, false
	if(add_audio_path<>"")
		GuiControl,,add_audio_path,%add_audio_path%
}
Return


run_starti:
Gosub, gui_update
If (model1 = "CAIN")
{
	command = -i "%in_path1%" -o "%out_path1%" -t %config_t_size1% -g %config_gpu_fi% -f %config_ext1%
	run_command = cain-ncnn-vulkan.exe %command%
	run, %comspec% /c cd "%A_WorkingDir%\frame_Interpolation\cain-ncnn" & %run_command%,,
}
else If (model1 = "DAIN")
{
	command = -i "%in_path1%" -o "%out_path1%" -t %config_t_size1% -g %config_gpu_fi% -f %config_ext1%
	run_command = dain-ncnn-vulkan.exe %command%
	run, %comspec% /c cd "%A_WorkingDir%\frame_Interpolation\dain-ncnn" & %run_command%,,
}
else
{
	command = -i "%in_path1%" -o "%out_path1%" -m "%config_model%" -g %config_gpu_fi% -f %config_ext1%
	run_command = rife-ncnn-vulkan.exe %command%
	run, %comspec% /c cd "%A_WorkingDir%\frame_Interpolation\rife-ncnn" & %run_command%,,
}
gosub,log_console
Return


guiclose:
exit:
{
	If (stop = 0)
	{
		msgbox, 0x13, Exit, WOW!! Do you want to "Close" now?
		IfMsgBox Yes
		{
			Process, Close, waifu2x-caffe-cui-p1.exe
			Process, Close, waifu2x-caffe-cui-p2.exe
			Process, Close, waifu2x-caffe-cui-p3.exe
			Process, Close, waifu2x-caffe-cui-p4.exe
			Process, Close, waifu2x-caffe-cui-p5.exe
			Process, Close, waifu2x-caffe-cui-p6.exe
			Process, Close, waifu2x-caffe-cui-p7.exe
			Process, Close, waifu2x-caffe-cui-p8.exe
			Process, Close, waifu2x-ncnn-vulkan-p1.exe
			Process, Close, waifu2x-ncnn-vulkan-p2.exe
			Process, Close, waifu2x-ncnn-vulkan-p3.exe
			Process, Close, waifu2x-ncnn-vulkan-p4.exe
			Process, Close, waifu2x-ncnn-vulkan-p5.exe
			Process, Close, waifu2x-ncnn-vulkan-p6.exe
			Process, Close, waifu2x-ncnn-vulkan-p7.exe
			Process, Close, waifu2x-ncnn-vulkan-p8.exe
			
			exitapp
		}
		else IfMsgBox No
		{
			
		}
	}
	else
	{
		ExitApp
	}
}
return




if !FileExist(A_WorkingDir "\w2x_cuda\waifu2x-caffe-cui.exe")
{
	MsgBox,16, Error!, waifu2x-caffe-cui.exe Not Found
	exitapp
}
if !FileExist(A_WorkingDir "\w2x_vulkan\waifu2x-ncnn-vulkan.exe")
{
	MsgBox,16, Error!, waifu2x-ncnn-vulkan.exe Not Found
	exitapp
}
if !FileExist(A_WorkingDir "\ffmpeg\ffmpeg.exe")
{
	MsgBox,16, Error!, ffmpeg.exe Not Found
	exitapp
}

load_gui(){
	global all_task
	global i_task
	if (i_task="")
	{
		i_task:=0
	}
	i_task++
	GuiControl,3:, p_load,% (i_task/all_task)*100
	Return
}

if (FileExist(A_WorkingDir "\update.ini")) || (!FileExist(A_WorkingDir "\w2x_cuda\waifu2x-caffe-cui-p*.exe")) || (!FileExist(A_WorkingDir "\w2x_vulkan\waifu2x-ncnn-vulkan-p*.exe") || !FileExist(A_WorkingDir "\ffmpeg\ffmpeg_p1.exe"))
{
	all_task := 24
	Gui, 3:Add, Progress, x2 y2 w300 h20 +cGreen Border vp_load -Theme BackgroundWhite, 0
	Gui, 3:Show, w304 h24, Loading..
	
	FileDelete, %A_WorkingDir%\w2x_cuda\waifu2x-caffe-cui-p*.exe
	load_gui()
	FileCopy, %A_WorkingDir%\w2x_cuda\waifu2x-caffe-cui.exe, %A_WorkingDir%\w2x_cuda\waifu2x-caffe-cui-p1.exe
	load_gui()
	FileCopy, %A_WorkingDir%\w2x_cuda\waifu2x-caffe-cui.exe, %A_WorkingDir%\w2x_cuda\waifu2x-caffe-cui-p2.exe
	load_gui()
	FileCopy, %A_WorkingDir%\w2x_cuda\waifu2x-caffe-cui.exe, %A_WorkingDir%\w2x_cuda\waifu2x-caffe-cui-p3.exe
	load_gui()
	FileCopy, %A_WorkingDir%\w2x_cuda\waifu2x-caffe-cui.exe, %A_WorkingDir%\w2x_cuda\waifu2x-caffe-cui-p4.exe
	load_gui()
	FileCopy, %A_WorkingDir%\w2x_cuda\waifu2x-caffe-cui.exe, %A_WorkingDir%\w2x_cuda\waifu2x-caffe-cui-p5.exe
	load_gui()
	FileCopy, %A_WorkingDir%\w2x_cuda\waifu2x-caffe-cui.exe, %A_WorkingDir%\w2x_cuda\waifu2x-caffe-cui-p6.exe
	load_gui()
	FileCopy, %A_WorkingDir%\w2x_cuda\waifu2x-caffe-cui.exe, %A_WorkingDir%\w2x_cuda\waifu2x-caffe-cui-p7.exe
	load_gui()
	FileCopy, %A_WorkingDir%\w2x_cuda\waifu2x-caffe-cui.exe, %A_WorkingDir%\w2x_cuda\waifu2x-caffe-cui-p8.exe
	load_gui()
	FileDelete, %A_WorkingDir%\w2x_vulkan\waifu2x-ncnn-vulkan-p*.exe
	load_gui()
	FileCopy, %A_WorkingDir%\w2x_vulkan\waifu2x-ncnn-vulkan.exe, %A_WorkingDir%\w2x_vulkan\waifu2x-ncnn-vulkan-p1.exe
	load_gui()
	FileCopy, %A_WorkingDir%\w2x_vulkan\waifu2x-ncnn-vulkan.exe, %A_WorkingDir%\w2x_vulkan\waifu2x-ncnn-vulkan-p2.exe
	load_gui()
	FileCopy, %A_WorkingDir%\w2x_vulkan\waifu2x-ncnn-vulkan.exe, %A_WorkingDir%\w2x_vulkan\waifu2x-ncnn-vulkan-p3.exe
	load_gui()
	FileCopy, %A_WorkingDir%\w2x_vulkan\waifu2x-ncnn-vulkan.exe, %A_WorkingDir%\w2x_vulkan\waifu2x-ncnn-vulkan-p4.exe
	load_gui()
	FileCopy, %A_WorkingDir%\w2x_vulkan\waifu2x-ncnn-vulkan.exe, %A_WorkingDir%\w2x_vulkan\waifu2x-ncnn-vulkan-p5.exe
	load_gui()
	FileCopy, %A_WorkingDir%\w2x_vulkan\waifu2x-ncnn-vulkan.exe, %A_WorkingDir%\w2x_vulkan\waifu2x-ncnn-vulkan-p6.exe
	load_gui()
	FileCopy, %A_WorkingDir%\w2x_vulkan\waifu2x-ncnn-vulkan.exe, %A_WorkingDir%\w2x_vulkan\waifu2x-ncnn-vulkan-p7.exe
	load_gui()
	FileCopy, %A_WorkingDir%\w2x_vulkan\waifu2x-ncnn-vulkan.exe, %A_WorkingDir%\w2x_vulkan\waifu2x-ncnn-vulkan-p8.exe
	load_gui()
	FileDelete, %A_WorkingDir%\ffmpeg\ffmpeg_p*.exe
	load_gui()
	FileCopy, %A_WorkingDir%\ffmpeg\ffmpeg.exe, %A_WorkingDir%\ffmpeg\ffmpeg_p1.exe
	load_gui()
	FileCopy, %A_WorkingDir%\ffmpeg\ffmpeg.exe, %A_WorkingDir%\ffmpeg\ffmpeg_p2.exe
	load_gui()
	FileCopy, %A_WorkingDir%\ffmpeg\ffmpeg.exe, %A_WorkingDir%\ffmpeg\ffmpeg_p3.exe
	load_gui()
	FileCopy, %A_WorkingDir%\ffmpeg\ffmpeg.exe, %A_WorkingDir%\ffmpeg\ffmpeg_p4.exe
	load_gui()
	FileDelete, %A_WorkingDir%\update.ini
	load_gui()
	sleep, 333
	Gui, 3:destroy
}



IniRead, in_path, %A_WorkingDir%\setting.ini, main, in_path, %A_Space%
IniRead, out_path, %A_WorkingDir%\setting.ini, main, out_path,  %A_Space%
IniRead, noise_level, %A_WorkingDir%\setting.ini, main, noise_level, 2
IniRead, scale, %A_WorkingDir%\setting.ini, main, scale, 2
IniRead, win_mode, %A_WorkingDir%\setting.ini, main, win_mode, Hide
IniRead, config_ext, %A_WorkingDir%\setting.ini, main, config_ext, png
IniRead, model, %A_WorkingDir%\setting.ini, main, model, %A_Space%
IniRead, width, %A_WorkingDir%\setting.ini, main, width, %A_Space%
IniRead, height, %A_WorkingDir%\setting.ini, main, height, %A_Space%
IniRead, width1, %A_WorkingDir%\setting.ini, main, width1, %A_Space%
IniRead, height1, %A_WorkingDir%\setting.ini, main, height1, %A_Space%
IniRead, by_scale, %A_WorkingDir%\setting.ini, main, by_scale, 1
IniRead, by_width, %A_WorkingDir%\setting.ini, main, by_width, 0
IniRead, by_height, %A_WorkingDir%\setting.ini, main, by_height, 0
IniRead, by_w_h, %A_WorkingDir%\setting.ini, main, by_w_h, 0
IniRead, skip_exist, %A_WorkingDir%\setting.ini, main, skip_exist, 1
IniRead, sleep_time, %A_WorkingDir%\setting.ini, main, sleep_time, 100
IniRead, mode1, %A_WorkingDir%\setting.ini, main, mode1, 1
IniRead, mode2, %A_WorkingDir%\setting.ini, main, mode2, 0
IniRead, mode3, %A_WorkingDir%\setting.ini, main, mode3, 0
IniRead, mode4, %A_WorkingDir%\setting.ini, main, mode4, 0
IniRead, t_scale, %A_WorkingDir%\setting.ini, main, t_scale, lanczos
IniRead, log_enable, %A_WorkingDir%\setting.ini, main, log_enable, 1
IniRead, log_limit, %A_WorkingDir%\setting.ini, main, log_limit, 26
IniRead, first_load, %A_WorkingDir%\setting.ini, main, first_load, 1

i:=0
while(i<=3)
{
	IniRead, t_nlv%i%, %A_WorkingDir%\setting.ini, main, t_nlv%i%, 0
	i++
}

i:=1
while(i<=7)
{
	IniRead, t_model%i%, %A_WorkingDir%\setting.ini, main, t_model%i%, 0
	i++
}

i:=1
while(i<=8)
{
	IniRead, config_gpu%i%, %A_WorkingDir%\setting.ini, main, config_gpu%i%, 0
	IniRead, enable_process%i%, %A_WorkingDir%\setting.ini, main, enable_process%i%, 0
	i++
}

Loop, Files, %A_WorkingDir%\w2x_cuda\models\*info.json, FR
{
	model_trim_l := StrLen(A_WorkingDir) + 17
	StringTrimLeft, add_list, A_LoopFilePath, %model_trim_l%
	StringTrimRight, add_list, add_list, 10
	if(!model_list)
	{
		model_list := add_list
		continue
	}
	model_list := model_list "|" add_list
}

StringReplace, model_list, model_list, |ukbench , , All
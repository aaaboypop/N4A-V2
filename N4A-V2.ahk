; load setting
process_limit := 8
thumbnail_max_size := 120

model_name1 := "anime_style_art"
model_name2 := "anime_style_art_rgb"
model_name3 := "cunet"
model_name4 := "photo"
model_name5 := "upconv_7_anime_style_art_rgb"
model_name6 := "upconv_7_photo"
model_name7 := "upresnet10"

vp_in_path := ""
vp_out_path := ""
pv_in_path := ""
pv_in_audio := ""
pv_out_path := ""
config_ext2 := ".jpg"
config_ext3 := ".mp4"
config_ext4 := ".jpg"
fps := "23.976"
crf := 18
ex_command := "-metadata description=""https://www.facebook.com/Net4Anime"""

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
IniRead, th_enable, %A_WorkingDir%\setting.ini, main, th_enable, 1
IniRead, sleep_time, %A_WorkingDir%\setting.ini, main, sleep_time, 100
IniRead, mode1, %A_WorkingDir%\setting.ini, main, mode1, 1
IniRead, mode2, %A_WorkingDir%\setting.ini, main, mode2, 0
IniRead, mode3, %A_WorkingDir%\setting.ini, main, mode3, 0
IniRead, mode4, %A_WorkingDir%\setting.ini, main, mode4, 0
IniRead, t_scale, %A_WorkingDir%\setting.ini, main, t_scale, lanczos
IniRead, log_enable, %A_WorkingDir%\setting.ini, main, log_enable, 1
IniRead, log_limit, %A_WorkingDir%\setting.ini, main, log_limit, 26

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

Loop, Files, %A_WorkingDir%\models\*info.json, FR
{
	model_trim_l := StrLen(A_WorkingDir) + 8
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

Gui, Add, Tab3, x2 y0 w900 h570 vcurrent_tab ggui_update, Media|Waifu2X CUDA|Test Mode|Waifu2X Vulkan|Console Log
Gui, Color, FFFFFF

Gui, Tab, Waifu2X Vulkan
Gui, Add, Text, x22 y29 w80 h20 , Input Folder :
Gui, Add, Edit, x112 y29 w180 h20 vin_pathv ggui_update, %in_path%
Gui, Add, Text, x22 y49 w80 h20 , Output Folder :
Gui, Add, Edit, x112 y49 w180 h20 vout_pathv ggui_update, %out_path%
Gui, Add, GroupBox, x22 y79 w310 h70 , Conversion Mode
Gui, Add, Radio, x32 y99 w140 h20 vmodev1 Group Checked ggui_update, Denoise+Magnify
Gui, Add, Radio, x182 y99 w140 h20 vmodev2 Hide ggui_update, Magnify
Gui, Add, Radio, x32 y119 w140 h20 vmodev3 Hide ggui_update, Denoise
Gui, Add, Radio, x182 y119 w140 h20 vmodev4 Hide ggui_update, Magnify+AutoDenoise

Gui, Add, Radio, x22 y159 w80 h20 Group vby_scalev Checked ggui_update, Scale

Gui, Add, Slider, x112 y159 w180 h20 vscalev Range1-2 ggui_update, 2
Gui, Add, Text, x292 y159 w40 h20 vscalev_show, 2

Gui, Add, Text, x172 y209 w80 h20 ,Batch/Process : 
Gui, Add, Edit, x262 y209 w50 h21 vbatch_size ggui_update, 200

Gui, Add, Text, x22 y249 w70 h20 , Noise Level :
Gui, Add, Slider, x112 y249 w180 h20 vnoise_levelv Range-1-3 ggui_update, 3
Gui, Add, Text, x292 y249 w40 h20 vnoise_levelv_show, %noise_levelv%
Gui, Add, Text, x22 y279 w40 h20 , Model :
Gui, Add, DropDownList, x112 y279 w180 h21 vmodelv r10 ggui_update, models-cunet|models-upconv_7_anime_style_art_rgb||

Gui, Add, Text, x22 y309 w90 h20 , File Extension :
Gui, Add, DropDownList, x112 y309 w50 h21 vconfig_extv r11 ggui_update, .png||
Gui, Add, Text, x202 y309 w90 h20 , Tile Size :
Gui, Add, Edit, x262 y309 w50 h21 vconfig_t_sizev ggui_update, 256
Gui, Add, Text, x22 y339 w40 h20 , Mode :
Gui, Add, DropDownList, x112 y339 w50 h21 vwin_modev r6 ggui_update, |Max|Min|Hide||
Gui, Add, Text, x202 y339 w40 h20 , Sleep :
Gui, Add, DropDownList, x262 y339 w50 h21 vsleep_timev r10 ggui_update, 10|20|50|100|200|333||500|1000|2000|3000|4000|5000|10000
Gui, Add, CheckBox, x22 y369 w90 h20 vskip_existv Checked ggui_update, Skip Exist File
Gui, Add, CheckBox, x182 y369 w70 h20 vth_enablev Disabled ggui_update, Thumbnail
Gui, Add, GroupBox, x22 y399 w310 h110 , GPU Setting
Gui, Add, CheckBox, x32 y419 w20 h20 venable_processv1 checked ggui_update, 
Gui, Add, Text, x52 y419 w60 h20 vtconfig_gpuvv1, Process 1 :
Gui, Add, DropDownList, x112 y419 w50 h21 vconfig_gpuv1 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x32 y439 w20 h20 venable_processv2 ggui_update, 
Gui, Add, Text, x52 y439 w60 h20 vtconfig_gpuvv2, Process 2 :
Gui, Add, DropDownList, x112 y439 w50 h21 vconfig_gpuv2 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x32 y459 w20 h20 venable_processv3 ggui_update, 
Gui, Add, Text, x52 y459 w60 h20 vtconfig_gpuvv3, Process 3 :
Gui, Add, DropDownList, x112 y459 w50 h21 vconfig_gpuv3 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x32 y479 w20 h20 venable_processv4 ggui_update, 
Gui, Add, Text, x52 y479 w60 h20 vtconfig_gpuvv4, Process 4 :
Gui, Add, DropDownList, x112 y479 w50 h21 vconfig_gpuv4 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x182 y419 w20 h20 venable_processv5 ggui_update, 
Gui, Add, Text, x202 y419 w60 h20 vtconfig_gpuvv5, Process 5 :
Gui, Add, DropDownList, x262 y419 w50 h21 vconfig_gpuv5 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x182 y439 w20 h20 venable_processv6 ggui_update, 
Gui, Add, Text, x202 y439 w60 h20 vtconfig_gpuvv6, Process 6 :
Gui, Add, DropDownList, x262 y439 w50 h21 vconfig_gpuv6 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x182 y459 w20 h20 venable_processv7 ggui_update, 
Gui, Add, Text, x202 y459 w60 h20 vtconfig_gpuvv7, Process 7 :
Gui, Add, DropDownList, x262 y459 w50 h21 vconfig_gpuv7 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x182 y479 w20 h20 venable_processv8 ggui_update, 
Gui, Add, Text, x202 y479 w60 h20 vtconfig_gpuvv8, Process 8 :
Gui, Add, DropDownList, x262 y479 w50 h21 vconfig_gpuv8 r8 ggui_update, 0||1|2|3|4|5|6|7

Gui, Add, GroupBox, x342 y29 w550 h510 , Status
Gui, Add, Text, x352 y49 w60 h20 , Total Files :
Gui, Add, Text, x442 y49 w70 h20 vf_totalv, -
Gui, Add, Text, x352 y69 w80 h20 , Processing Files :
Gui, Add, Text, x442 y69 w70 h20 vf_ppv, -
Gui, Add, Text, x562 y49 w40 h20 , Speed :
Gui, Add, Text, x612 y49 w60 h20 vtspeedv, -
Gui, Add, Text, x682 y49 w50 h20 , fps
Gui, Add, Text, x832 y69 w50 h20 right vs_percenv, 
Gui, Add, Progress, x352 y89 w530 h10 +cGreen Border vp_prov -Theme BackgroundWhite, 0
Gui, Add, Text, x352 y109 w80 h20 , Process 1 :
Gui, Add, Text, x442 y109 w380 h20 vs_file_processv1, -
Gui, Add, Text, x832 y109 w50 h20 vs_process_countv1, -
Gui, Add, Text, x352 y129 w80 h20 , Process 2 :
Gui, Add, Text, x442 y129 w380 h20 vs_file_processv2, -
Gui, Add, Text, x832 y129 w50 h20 vs_process_countv2, -
Gui, Add, Text, x352 y149 w80 h20 , Process 3 :
Gui, Add, Text, x442 y149 w380 h20 vs_file_processv3, -
Gui, Add, Text, x832 y149 w50 h20 vs_process_countv3, -
Gui, Add, Text, x352 y169 w80 h20 , Process 4 :
Gui, Add, Text, x442 y169 w380 h20 vs_file_processv4, -
Gui, Add, Text, x832 y169 w50 h20 vs_process_countv4, -
Gui, Add, Text, x352 y189 w80 h20 , Process 5 :
Gui, Add, Text, x442 y189 w380 h20 vs_file_processv5, -
Gui, Add, Text, x832 y189 w50 h20 vs_process_countv5, -
Gui, Add, Text, x352 y209 w80 h20 , Process 6 :
Gui, Add, Text, x442 y209 w380 h20 vs_file_processv6, -
Gui, Add, Text, x832 y209 w50 h20 vs_process_countv6, -
Gui, Add, Text, x352 y229 w80 h20 , Process 7 :
Gui, Add, Text, x442 y229 w380 h20 vs_file_processv7, -
Gui, Add, Text, x832 y229 w50 h20 vs_process_countv7, -
Gui, Add, Text, x352 y249 w80 h20 , Process 8 :
Gui, Add, Text, x442 y249 w380 h20 vs_file_processv8, -
Gui, Add, Text, x832 y249 w50 h20 vs_process_countv8, -
Gui, Add, Picture, x352 y279 w120 h120 vpicv1, 
Gui, Add, Picture, x482 y279 w120 h120 vpicv2, 
Gui, Add, Picture, x612 y279 w120 h120 vpicv3, 
Gui, Add, Picture, x742 y279 w120 h120 vpicv4, 
Gui, Add, Picture, x352 y409 w120 h120 vpicv5, 
Gui, Add, Picture, x482 y409 w120 h120 vpicv6, 
Gui, Add, Picture, x612 y409 w120 h120 vpicv7, 
Gui, Add, Picture, x742 y409 w120 h120 vpicv8, 
Gui, Add, Button, x292 y29 w30 h20 gin_folderv, ...
Gui, Add, Button, x292 y49 w30 h20 gout_folderv, ...
Gui, Add, button, x22 y529 w80 h20 vb_startv grun_startv, Start
Gui, Add, button, x102 y529 w80 h20 vb_stopv grun_stop Disabled, Stop
Gui, Add, button, x262 y529 w70 h20 Hide, Save Setting
Gui, Add, Text, x22 y509 w70 h20 vs_sv, Ready ..



Gui, Tab, Media
Gui, Add, Text, x12 y29 w70 h20 , Input File :
Gui, Add, Edit, x92 y29 w180 h20 Readonly vvp_in_path ggui_update, 
Gui, Add, Text, x12 y49 w70 h20 , Output Folder :
Gui, Add, Edit, x92 y49 w180 h20 Readonly vvp_out_path ggui_update, 
Gui, Add, GroupBox, x552 y29 w340 h50 , Output Type
Gui, Add, Radio, x562 y49 w60 h20 Checked voutput_pic galt_guiupdate, Picture
Gui, Add, Radio, x622 y49 w60 h20 voutput_vid galt_guiupdate, Video
Gui, Add, Radio, x682 y49 w60 h20 voutput_audio galt_guiupdate, Audio
Gui, Add, GroupBox, x2 y79 w890 h470 , Setting
Gui, Add, Button, x272 y29 w30 h20 gvid_to_pic_in_folder, ...
Gui, Add, Button, x272 y49 w30 h20 gvid_to_pic_out_folder, ...
Gui, Add, CheckBox, x12 y99 w190 h20 vconvert_enable ggui_update, Convert to Constant Frame Rate
Gui, Add, DropDownList, x212 y99 w60 h20 vconvert_fps r8 ggui_update, 15|23.976||24|25|29.97|30|50|59.94|60|100|120
Gui, Add, Text, x272 y159 w20 h20 vvp_quality_show, 1
Gui, Add, CheckBox, x12 y189 w80 h20 venable_th_mode ggui_update, Thumbnail :
Gui, Add, Edit, x92 y189 w150 h20 vt_fps ggui_update, 1
Gui, Add, DropDownList, x242 y189 w60 h20 vt_fps_mode r8 ggui_update, 1 sec|1 min||10 min|1 hours
Gui, Add, CheckBox, x12 y219 w80 h20 venable_resize ggui_update, Resize :
Gui, Add, Edit, x92 y219 w50 h20 vresize_w ggui_update, 
Gui, Add, Text, x142 y219 w10 h20 vresize_x, x
Gui, Add, Edit, x152 y219 w50 h20 vresize_h ggui_update, 
Gui, Add, DropDownList, x202 y219 w100 h20 r10 vt_scale1 ggui_update, bilinear|bicubic|experimental|neighbor|area|bicublin|gauss|sinc|lanczos|spline||
Gui, Add, Text, x752 y49 w60 h20 right, Output Ext :
Gui, Add, DropDownList, x812 y49 w50 h21 vconfig_ext2 r12 ggui_update, .jpg||.png|.bmp
Gui, Add, button, x12 y519 w150 h20 vb_start2 grun_vid_to_pic, Start
Gui, Add, button, x172 y519 w150 h20 ggui2 Disabled, Show Script
Gui, Add, GroupBox, x312 y99 w140 h90 , Deinterlace
Gui, Add, CheckBox, x322 y219 w60 h20 venable_ss ggui_update, Start :
Gui, Add, CheckBox, x322 y249 w60 h20 venable_to ggui_update, End :
Gui, Add, Edit, x382 y219 w110 h20 vtime_ss ggui_update, 00:00:00
Gui, Add, Edit, x382 y249 w110 h20 vtime_to ggui_update, 00:00:00
Gui, Add, Text, x322 y139 w60 h20 , Mode :
Gui, Add, Text, x322 y159 w60 h20 , Field :
Gui, Add, DropDownList, x382 y139 w60 h10 r4 vdeinter_mode ggui_update, Frame||Field
Gui, Add, DropDownList, x382 y159 w60 h10 r2 vdeinter_field ggui_update, Top||Bottom
Gui, Add, CheckBox, x12 y249 w290 h20 venable_decimate ggui_update, Remove Duplicate Frame [Anime Preset 29.970 > 23.976]
Gui, Add, Radio, x542 y119 w60 h20 vcqp_s1 Group Checked ggui_update, CQP :
Gui, Add, Radio, x542 y139 w60 h20 vcrf_s1 ggui_update, CRF :
Gui, Add, Edit, x602 y119 w40 h20 vcqp_value1 ggui_update, 18
Gui, Add, Edit, x602 y139 w40 h20 vcrf_value1 ggui_update, 18
Gui, Add, Text, x472 y159 w40 h20 , Preset :
Gui, Add, DropDownList, x532 y159 w110 h20 venc_preset r12 ggui_update, ultrafast|superfast|veryfast|faster|fast|medium||slow|slower|veryslow|placebo|
Gui, Add, CheckBox, x522 y219 w60 h20 venable_audio Checked ggui_update, Audio
Gui, Add, Radio, x592 y219 w50 h20 venable_a_aac ggui_update, AAC
Gui, Add, Radio, x642 y219 w50 h20 venable_a_ogg ggui_update, OGG
Gui, Add, Radio, x702 y219 w50 h20 venable_a_mp3 ggui_update, MP3
Gui, Add, Radio, x752 y219 w50 h20 venable_a_pcm Checked ggui_update, PCM
Gui, Add, Radio, x802 y219 w50 h20 venable_a_copy ggui_update, Copy
Gui, Add, CheckBox, x522 y249 w60 h20 venable_add_audio ggui_update, Add
Gui, Add, Edit, x592 y249 w250 h20 vadd_audio_path ggui_update, 
Gui, Add, Button, x842 y249 w30 h20 gadd_audio_file, ...

Gui, Add, GroupBox, x692 y99 w190 h90 , Color
Gui, Add, Radio, x702 y119 w70 h20 vc_420 Checked ggui_update, YUV420
Gui, Add, Radio, x702 y139 w70 h20 vc_422 ggui_update, YUV422
Gui, Add, Radio, x702 y159 w70 h20 vc_444 ggui_update, YUV444
Gui, Add, Radio, x802 y119 w70 h20 vc_8b Group Checked ggui_update, 8 Bit
Gui, Add, Radio, x802 y139 w70 h20 vc_10b ggui_update, 10 Bit
Gui, Add, Text, x12 y159 w70 h20 , JPG Quality :
Gui, Add, Slider, x92 y159 w180 h20 vvp_quality Range1-31 ggui_update, 1
Gui, Add, GroupBox, x312 y199 w190 h80 , Trim
Gui, Add, GroupBox, x512 y199 w370 h80 , Audio
Gui, Add, GroupBox, x462 y99 w220 h90 , Video Encoder
Gui, Add, Radio, x472 y119 w50 h20 venc_264 Checked ggui_update, x264
Gui, Add, Radio, x472 y139 w50 h20 venc_265 ggui_update, x265
Gui, Add, CheckBox, x12 y279 w110 h20 Disabled, Enable Filter
Gui, Add, GroupBox, x12 y299 w870 h210 , Filter
Gui, Add, DropDownList, x22 y319 w150 h20 Disabled r12, Sharpen|DeHalo|AntiAliasing|Resizer|Line Darker
Gui, Add, Button, x172 y319 w50 h20 , Add
Gui, Add, Button, x222 y319 w50 h20 , Modify
Gui, Add, Button, x272 y319 w50 h20 , Delete
Gui, Add, ListView, x322 y309 w550 h190 vedit_script, Filter|Data
Gui, Add, Button, x282 y459 w40 h20 , up
Gui, Add, Button, x282 y479 w40 h20 , down




Gui, Tab, Waifu2X CUDA
Gui, Add, Text, x22 y29 w80 h20 , Input Folder :
Gui, Add, Edit, x112 y29 w180 h20 vin_path ggui_update, %in_path%
Gui, Add, Text, x22 y49 w80 h20 , Output Folder :
Gui, Add, Edit, x112 y49 w180 h20 vout_path ggui_update, %out_path%
Gui, Add, GroupBox, x22 y79 w310 h70 , Conversion Mode
Gui, Add, Radio, x32 y99 w140 h20 vmode1 Group ggui_update, Denoise+Magnify
Gui, Add, Radio, x182 y99 w140 h20 vmode2 ggui_update, Magnify
Gui, Add, Radio, x32 y119 w140 h20 vmode3 ggui_update, Denoise
Gui, Add, Radio, x182 y119 w140 h20 vmode4 ggui_update, Magnify+AutoDenoise

Gui, Add, Radio, x22 y159 w80 h20 Group vby_scale Checked ggui_update, Scale
Gui, Add, Radio, x22 y179 w80 h20 vby_width ggui_update, Width
Gui, Add, Radio, x22 y199 w80 h20 vby_height ggui_update, Height
Gui, Add, Radio, x22 y219 w80 h20 vby_w_h ggui_update, Width*Height
Gui, Add, Edit, x112 y159 w150 h20 vscale ggui_update, %scale%
Gui, Add, Edit, x112 y179 w150 h20 vwidth ggui_update, %width%
Gui, Add, Edit, x112 y199 w150 h20 vheight ggui_update, %height%
Gui, Add, Edit, x112 y219 w80 h20 vwidth1 ggui_update, %width1%
Gui, Add, Text, x202 y219 w10 h20 , x
Gui, Add, Edit, x212 y219 w80 h20 vheight1 ggui_update, %height1%
Gui, Add, Text, x22 y249 w70 h20 , Noise Level :
Gui, Add, Radio, x112 y249 w30 h20 vnlv0 Group ggui_update, 0
Gui, Add, Radio, x152 y249 w30 h20 vnlv1 ggui_update, 1
Gui, Add, Radio, x192 y249 w30 h20 vnlv2 ggui_update, 2
Gui, Add, Radio, x232 y249 w30 h20 vnlv3 ggui_update, 3
Gui, Add, Text, x22 y279 w40 h20 , Model :
Gui, Add, DropDownList, x112 y279 w180 h21 vmodel r10 ggui_update, %model_list%
Gui, Add, Text, x22 y309 w90 h20 , File Extension :
Gui, Add, DropDownList, x112 y309 w50 h21 vconfig_ext r11 ggui_update, .png|.bmp|.jpg||.jp2|.sr|.tif|.hdr|.exr|.ppm|.webp|.tga
Gui, Add, Text, x22 y339 w40 h20 , Mode :
Gui, Add, DropDownList, x112 y339 w50 h21 vwin_mode r6 ggui_update, |Max|Min|Hide||
Gui, Add, Text, x202 y339 w40 h20 , Sleep :
Gui, Add, DropDownList, x262 y339 w50 h21 vsleep_time r10 ggui_update, 10|20|50|100||200|333|500|1000
Gui, Add, CheckBox, x22 y369 w90 h20 vskip_exist Checked ggui_update, Skip Exist File
Gui, Add, CheckBox, x182 y369 w70 h20 vth_enable Checked ggui_update, Thumbnail
Gui, Add, GroupBox, x22 y399 w310 h110 , GPU Setting
Gui, Add, CheckBox, x32 y419 w20 h20 venable_process1 checked ggui_update, 
Gui, Add, Text, x52 y419 w60 h20 vtconfig_gpu1, Process 1 :
Gui, Add, DropDownList, x112 y419 w50 h21 vconfig_gpu1 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x32 y439 w20 h20 venable_process2 ggui_update, 
Gui, Add, Text, x52 y439 w60 h20 vtconfig_gpu2, Process 2 :
Gui, Add, DropDownList, x112 y439 w50 h21 vconfig_gpu2 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x32 y459 w20 h20 venable_process3 ggui_update, 
Gui, Add, Text, x52 y459 w60 h20 vtconfig_gpu3, Process 3 :
Gui, Add, DropDownList, x112 y459 w50 h21 vconfig_gpu3 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x32 y479 w20 h20 venable_process4 ggui_update, 
Gui, Add, Text, x52 y479 w60 h20 vtconfig_gpu4, Process 4 :
Gui, Add, DropDownList, x112 y479 w50 h21 vconfig_gpu4 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x182 y419 w20 h20 venable_process5 ggui_update, 
Gui, Add, Text, x202 y419 w60 h20 vtconfig_gpu5, Process 5 :
Gui, Add, DropDownList, x262 y419 w50 h21 vconfig_gpu5 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x182 y439 w20 h20 venable_process6 ggui_update, 
Gui, Add, Text, x202 y439 w60 h20 vtconfig_gpu6, Process 6 :
Gui, Add, DropDownList, x262 y439 w50 h21 vconfig_gpu6 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x182 y459 w20 h20 venable_process7 ggui_update, 
Gui, Add, Text, x202 y459 w60 h20 vtconfig_gpu7, Process 7 :
Gui, Add, DropDownList, x262 y459 w50 h21 vconfig_gpu7 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x182 y479 w20 h20 venable_process8 ggui_update, 
Gui, Add, Text, x202 y479 w60 h20 vtconfig_gpu8, Process 8 :
Gui, Add, DropDownList, x262 y479 w50 h21 vconfig_gpu8 r8 ggui_update, 0||1|2|3|4|5|6|7

Gui, Add, GroupBox, x342 y29 w550 h510 , Status
Gui, Add, Text, x352 y49 w60 h20 , Total Files :
Gui, Add, Text, x442 y49 w70 h20 vf_total, -
Gui, Add, Text, x352 y69 w80 h20 , Processing Files :
Gui, Add, Text, x442 y69 w70 h20 vf_pp, -
Gui, Add, Text, x562 y49 w40 h20 , Speed :
Gui, Add, Text, x612 y49 w60 h20 vtspeed, -
Gui, Add, Text, x682 y49 w50 h20 , fps
Gui, Add, Text, x832 y69 w50 h20 right vs_percen, 
Gui, Add, Progress, x352 y89 w530 h10 +cGreen Border vp_pro -Theme BackgroundWhite, 0
Gui, Add, Text, x352 y109 w80 h20 , Process 1 :
Gui, Add, Text, x442 y109 w380 h20 vs_file_process1, -
Gui, Add, Text, x832 y109 w50 h20 vs_process_count1, -
Gui, Add, Text, x352 y129 w80 h20 , Process 2 :
Gui, Add, Text, x442 y129 w380 h20 vs_file_process2, -
Gui, Add, Text, x832 y129 w50 h20 vs_process_count2, -
Gui, Add, Text, x352 y149 w80 h20 , Process 3 :
Gui, Add, Text, x442 y149 w380 h20 vs_file_process3, -
Gui, Add, Text, x832 y149 w50 h20 vs_process_count3, -
Gui, Add, Text, x352 y169 w80 h20 , Process 4 :
Gui, Add, Text, x442 y169 w380 h20 vs_file_process4, -
Gui, Add, Text, x832 y169 w50 h20 vs_process_count4, -
Gui, Add, Text, x352 y189 w80 h20 , Process 5 :
Gui, Add, Text, x442 y189 w380 h20 vs_file_process5, -
Gui, Add, Text, x832 y189 w50 h20 vs_process_count5, -
Gui, Add, Text, x352 y209 w80 h20 , Process 6 :
Gui, Add, Text, x442 y209 w380 h20 vs_file_process6, -
Gui, Add, Text, x832 y209 w50 h20 vs_process_count6, -
Gui, Add, Text, x352 y229 w80 h20 , Process 7 :
Gui, Add, Text, x442 y229 w380 h20 vs_file_process7, -
Gui, Add, Text, x832 y229 w50 h20 vs_process_count7, -
Gui, Add, Text, x352 y249 w80 h20 , Process 8 :
Gui, Add, Text, x442 y249 w380 h20 vs_file_process8, -
Gui, Add, Text, x832 y249 w50 h20 vs_process_count8, -
Gui, Add, Picture, x352 y279 w120 h120 vpic1, 
Gui, Add, Picture, x482 y279 w120 h120 vpic2, 
Gui, Add, Picture, x612 y279 w120 h120 vpic3, 
Gui, Add, Picture, x742 y279 w120 h120 vpic4, 
Gui, Add, Picture, x352 y409 w120 h120 vpic5, 
Gui, Add, Picture, x482 y409 w120 h120 vpic6, 
Gui, Add, Picture, x612 y409 w120 h120 vpic7, 
Gui, Add, Picture, x742 y409 w120 h120 vpic8, 
Gui, Add, Button, x292 y29 w30 h20 gin_folder, ...
Gui, Add, Button, x292 y49 w30 h20 gout_folder, ...
Gui, Add, button, x22 y529 w80 h20 vb_start grun_start, Start
Gui, Add, button, x102 y529 w80 h20 vb_stop grun_stop Disabled, Stop
Gui, Add, button, x262 y529 w70 h20 gsave, Save Setting
Gui, Add, Text, x22 y509 w70 h20 vs_s, Ready ..


Gui, Tab, Test Mode
Gui, Add, GroupBox, x12 y29 w190 h200 , Model
Gui, Add, CheckBox, x22 y49 w170 h20 vt_model1 ggui_update, anime_style_art
Gui, Add, CheckBox, x22 y69 w170 h20 vt_model2 ggui_update, anime_style_art_rgb
Gui, Add, CheckBox, x22 y89 w170 h20 vt_model3 ggui_update, cunet
Gui, Add, CheckBox, x22 y109 w170 h20 vt_model4 ggui_update, photo
Gui, Add, CheckBox, x22 y129 w170 h20 vt_model5 ggui_update, upconv_7_anime_style_art_rgb
Gui, Add, CheckBox, x22 y149 w170 h20 vt_model6 ggui_update, upconv_7_photo
Gui, Add, CheckBox, x22 y169 w170 h20 vt_model7 ggui_update, upresnet10
Gui, Add, GroupBox, x202 y29 w190 h200 , Noise Level
Gui, Add, CheckBox, x222 y49 w130 h20 vt_nlv0 ggui_update, Level 0
Gui, Add, CheckBox, x222 y69 w130 h20 vt_nlv1 ggui_update, Level 1
Gui, Add, CheckBox, x222 y89 w130 h20 vt_nlv2 ggui_update, Level 2
Gui, Add, CheckBox, x222 y109 w130 h20 vt_nlv3 ggui_update, Level 3
Gui, Add, Text, x22 y239 w140 h20 , Original Scaling Algorithm :
Gui, Add, DropDownList, x162 y239 w220 h21 r10 vt_scale ggui_update, bilinear|bicubic|experimental|neighbor|area|bicublin|gauss|sinc|lanczos|spline|
Gui, Add, button, x282 y269 w100 h20 vb_start1 grun_test, Start
Gui, Add, button, x172 y269 w100 h20 vb_stop1 grun_stop Disabled, Stop

Gui, Add, GroupBox, x12 y309 w590 h200 , Check Files Setting
Gui, Add, CheckBox, x22 y329 w130 h20 Checked Disabled venable_check_bad ggui_update, Bad File

Gui, Add, CheckBox, x22 y349 w130 h20 venable_check_res Checked Disabled ggui_update, Mismatch Resolution
Gui, Add, DropDownList, x162 y349 w100 h20 r2 vcheck_res_mode ggui_update, First File||
Gui, Add, Edit, x382 y349 w80 h20 vcheck_custom_w ggui_update,
Gui, Add, Text, x362 y349 w10 h10 , X
Gui, Add, Edit, x272 y349 w80 h20 vcheck_custom_h ggui_update,

Gui, Add, CheckBox, x22 y369 w130 h20 venable_check_ssim ggui_update, SSIM (Slow)
Gui, Add, Edit, x162 y369 w100 h20 vcheck_bad_ssim ggui_update, 90
Gui, Add, Text, x272 y369 w20 h20 , `%

Gui, Add, Text, x42 y419 w100 h20 , Action :
Gui, Add, DropDownList, x162 y419 w100 h20 r3 vcheck_action ggui_update, Delete|Move|Nothing||

Gui, Add, Text, x42 y449 w100 h20 , Move to :
Gui, Add, Edit, x162 y449 w220 h20 vcheck_action_move_path ggui_update,

Gui, Add, Text, x22 y+30 w110 h20 , (Experiment Function)

Gui, Add, button, x182 y529 w80 h20 vb_check gcheck_file, Check File

Gui, Tab, Console Log
Gui, Add, ListView, x12 y29 w880 h500 gconsole_log, Command
Gui, Add, CheckBox, x12 y534 w100 h20 vlog_enable Checked ggui_update, Enable Log
Gui, Add, Text, x142 y537 w60 h20 , Log Limit :
Gui, Add, Edit, x202 y534 w60 h20 vlog_limit number ggui_update, 26

Gui, Tab, 
Gui, Add, Text, x652 y539 w240 h20 , by pond_pop @ www.facebook.com/Net4Anime

;==== Control ====
GuiControl,,nlv%noise_level%, 1
GuiControl,,log_enable,% log_enable
GuiControl, Hide,mgpu_text
GuiControl, ChooseString, config_ext, %config_ext%
GuiControl, ChooseString, model, %model%
GuiControl, ChooseString, sleep_time, %sleep_time%
GuiControl,,skip_exist, %skip_exist%
GuiControl,,th_enable, %th_enable%
GuiControl,,by_scale, %by_scale%
GuiControl,,by_width, %by_width%
GuiControl,,by_height, %by_height%
GuiControl,,by_w_h, %by_w_h%
GuiControl,,log_limit, %log_limit%
GuiControl, ChooseString, t_scale,% t_scale
i:=1
while(i<=8)
{
	GuiControl, ChooseString, config_gpu%i%,% config_gpu%i%
	GuiControl,,enable_process%i%,% enable_process%i%
	i++
}

i:=1
while(i<=7)
{
	if(t_model%i% = 1)
	{
		GuiControl,,t_model%i%, 1
	}
	else
	{
		GuiControl,,t_model%i%, 0
	}
	i++
}

i:=0
while(i<=3)
{
	if(t_nlv%i% = 1)
	{
		GuiControl,,t_nlv%i%, 1
	}
	else
	{
		GuiControl,,t_nlv%i%, 0
	}
	
	i++
	
	if(mode%i% = 1)
	{
		GuiControl,,mode%i%, 1
	}
	else
	{
		GuiControl,,mode%i%, 0
	}
}

;==== GUI Window ====
Gui, Show, x413 y187 h560 w900, N4A-V2
goto, gui_update
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
	Gui, 2:Add,Button, x2 y2 h20 w60 ggui2_r,Refresh
	Gui, 2:Add,Edit, x2 y22 h696 w596 Readonly vshow_script,
	Gui, 2:Show, h720 w600, Filter Script
}
Return

gui2_r:
{
	s_script := load_script0()
	GuiControl,,show_script,% s_script
}
Return

2GuiClose:
{
	Gui, 2:destroy
}
Return

load_script1()
{
	hybrid_path := "C:/Program Files/Hybrid/64bit"
	source_path := StrReplace(vp_in_path, "\", "/")
			
	s_script := ""
	s_script .= "import os" "`n"
	s_script .= "import sys" "`n"
	s_script .= "import vapoursynth as vs" "`n"
	s_script .= "core = vs.get_core()" "`n"
	s_script .= "scriptPath = '" hybrid_path "/vsscripts'" "`n"
	s_script .= "sys.path.append(os.path.abspath(scriptPath))" "`n"
	s_script .= "core.std.LoadPlugin(path=""" hybrid_path "/vsfilters/Support/vs_sangnommod.dll"")" "`n"
	s_script .= "core.std.LoadPlugin(path=""" hybrid_path "/vsfilters/Support/EEDI3.dll"")" "`n"
	s_script .= "core.std.LoadPlugin(path=""" hybrid_path "/vsfilters/Support/EEDI2.dll"")" "`n"
	s_script .= "core.std.LoadPlugin(path=""" hybrid_path "/vsfilters/ResizeFilter/nnedi3/NNEDI3CL.dll"")" "`n"
	s_script .= "core.std.LoadPlugin(path=""" hybrid_path "/vsfilters/Support/fmtconv.dll"")" "`n"
	s_script .= "core.std.LoadPlugin(path=""" hybrid_path "/vsfilters/SourceFilter/LSmashSource/vslsmashsource.dll"")" "`n"
	s_script .= "import havsfunc" "`n"
	s_script .= "import mvsfunc" "`n"
	s_script .= "import edi_rpow2" "`n"
	s_script .= "import hysteria" "`n"
	s_script .= "import G41Fun" "`n"
	
	Return s_script
}

load_script2()
{
	hybrid_path := "C:/Program Files/Hybrid/64bit"
	source_path := StrReplace(vp_in_path, "\", "/")
			
	s_script := ""
	s_script .= "import os" "`n"
	s_script .= "import sys" "`n"
	s_script .= "import vapoursynth as vs" "`n"
	s_script .= "core = vs.get_core()" "`n"
	s_script .= "scriptPath = '" hybrid_path "/vsscripts'" "`n"
	s_script .= "sys.path.append(os.path.abspath(scriptPath))" "`n"
	s_script .= "core.std.LoadPlugin(path=""" hybrid_path "/vsfilters/Support/vs_sangnommod.dll"")" "`n"
	s_script .= "core.std.LoadPlugin(path=""" hybrid_path "/vsfilters/Support/EEDI3.dll"")" "`n"
	s_script .= "core.std.LoadPlugin(path=""" hybrid_path "/vsfilters/Support/EEDI2.dll"")" "`n"
	s_script .= "core.std.LoadPlugin(path=""" hybrid_path "/vsfilters/ResizeFilter/nnedi3/NNEDI3CL.dll"")" "`n"
	s_script .= "core.std.LoadPlugin(path=""" hybrid_path "/vsfilters/Support/fmtconv.dll"")" "`n"
	s_script .= "core.std.LoadPlugin(path=""" hybrid_path "/vsfilters/SharpenFilter/AWarpSharp2/libawarpsharp2.dll"")" "`n"
	s_script .= "core.std.LoadPlugin(path=""" hybrid_path "/vsfilters/SourceFilter/Imagemagick/libimwri.dll"")" "`n"
	s_script .= "import havsfunc" "`n"
	s_script .= "import mvsfunc" "`n"
	s_script .= "import edi_rpow2" "`n"
	s_script .= "import hysteria" "`n"
	s_script .= "import G41Fun" "`n"
	
	Return s_script
}


load_script0()
{
	global media_load
	global s_path
	global load_fullpath
	global fpsc1
	global fpsc2
	global cfr
	global vfr
	global image_input
	global load_image_count
	global load_ext
	global convert_fps_num
	global convert_fps_den
	global convert_enable
	
	if(media_load=1)
	{
		if(image_input=1)
		{
			s_script := load_script2()
			s_path_dir := StrReplace(load_fullpath, "\","/")
			s_script .= "clip = core.imwri.Read(""" s_path_dir "/image%06d." load_ext """, firstnum=1)" "`n"
			s_script .= "clip = core.std.Trim(clip=clip, length=" load_image_count ")" "`n"
			s_script .= "clip = core.std.AssumeFPS(clip, fpsnum=" convert_fps_num ", fpsden=" convert_fps_den ")" "`n"
		}
		else
		{
			s_script := load_script1()
			
			if(cfr=1)
				s1_script := "clip = core.lsmas.LWLibavSource(source=""" s_path """, format=""YUV420P8"", cache=0)" "`n"
			if(vfr=1)
			{
				if(convert_enable=1)
				{
					s1_script := "clip = core.lsmas.LWLibavSource(source=""" s_path """, format=""YUV420P8"", cache=0, fpsnum=" convert_fps_num ", fpsden=" convert_fps_den ")" "`n"
				}
				else
				{
					s1_script := "clip = core.lsmas.LWLibavSource(source=""" s_path """, format=""YUV420P8"", cache=0, fpsnum=" fpsc1 ", fpsden=" fpsc2 ")" "`n"
				}
			}
			s_script .= s1_script
			s_script .= "clip = core.resize.Point(clip, matrix_in_s=""unspec"",range_s=""limited"")" "`n"
			
			if(convert_enable=1 and vfr=1)
			{
				s_script .= "clip = core.std.AssumeFPS(clip, fpsnum=" convert_fps_num ", fpsden=" convert_fps_den ")" "`n"
			}
			else
			{
				s_script .= "clip = core.std.AssumeFPS(clip, fpsnum=" fpsc1 ", fpsden=" fpsc2 ")" "`n"
			}
			
			s_script .= "clip = core.std.SetFrameProp(clip=clip, prop=""_ColorRange"", intval=1)" "`n"
		}
		
		s_script .= "clip.set_output()"
		Return s_script
	}
	
}

media_load:
{
	media_load := 1
	image_input := 0
	load_image_count := 0
	
	SplitPath, vp_in_path, load_name, load_fullpath, load_ext
	if(load_ext="png"||load_ext="jpg")
	{
		ifExist, %load_fullpath%\image000001.*
		{
			Loop, Files, %load_fullpath%\image*.* , F
			{
				load_image_count++
			}
			image_input := 1
			msgbox,% "Loaded " load_image_count " Image."
		}
		else
		{
			msgbox,% "Not Found Image Format ""image%06d"""
		}
	}
	else if(load_ext="mkv"||load_ext="mp4"||load_ext="mov"||load_ext="wmv")
	{
		var1=ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate,avg_frame_rate -of default=noprint_wrappers=1:nokey=1 "%vp_in_path%"
		c2 :=""
		c2 := StdOutToVar(comspec . " /c " . var1)
		
		StringSplit,probe_re, c2, "`n"
		StringTrimRight,probe_re1,probe_re1,1
		StringTrimRight,probe_re2,probe_re2,1
		
		StringSplit,fpsc, probe_re1, "/"
		StringSplit,fpsv, probe_re2, "/"
		
		s_path := StrReplace(vp_in_path,"\","/")
		
		if(probe_re1=probe_re2)
		{
			msgbox,% "Frame Rate Mode : Constance`n" fpsc1 / fpsc2 " FPS"
			cfr := 1
			vfr := 0
		}
		else
		{
			msgbox,% "Frame Rate Mode : Variable`n" fpsc1 / fpsc2 " FPS"
			;msgbox,% "Filter is Not support Variable Frame rate mode"
			cfr := 0
			vfr := 1
		}

	}
	else
	{
		media_load := 0
		msgbox, Not Support FileFormat.
		GuiControl,,vp_in_path,
	}
}
Return

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
	else if(drop_focus = "in_pathv")
		dd_path("d")
	else if(drop_focus = "out_pathv")
		dd_path("d")
	else if(drop_focus = "vp_out_path")
		dd_path("d")
	else if(drop_focus = "audio_out_path")
		dd_path("d")
		
	else if(drop_focus = "add_audio_path")
		dd_path("f")
	else if(drop_focus = "vp_in_path")
	{
		dd_path("f")
		sleep, 100
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

gui_update:
{
	Gui, Submit, NoHide
	if (nlv0 == 1) 
	noise_level := 0
	else if (nlv1 == 1) 
	noise_level := 1
	else if (nlv2 == 1) 
	noise_level := 2
	else if (nlv3 == 1) 
	noise_level := 3
	
	if(convert_fps=15)
	{
		convert_fps_num := 15000
		convert_fps_den := 1000
	}
	else
	if(convert_fps=23.976)
	{
		convert_fps_num := 24000
		convert_fps_den := 1001
	}
	else if(convert_fps=24)
	{
		convert_fps_num := 24000
		convert_fps_den := 1000
	}
	else if(convert_fps=25)
	{
		convert_fps_num := 25000
		convert_fps_den := 1000
	}
	else if(convert_fps=29.97)
	{
		convert_fps_num := 30000
		convert_fps_den := 1001
	}
	else if(convert_fps=30)
	{
		convert_fps_num := 30000
		convert_fps_den := 1000
	}
	else if(convert_fps=50)
	{
		convert_fps_num := 50000
		convert_fps_den := 1000
	}
	else if(convert_fps=59.94)
	{
		convert_fps_num := 60000
		convert_fps_den := 1001
	}
	else if(convert_fps=60)
	{
		convert_fps_num := 60000
		convert_fps_den := 1000
	}
	else if(convert_fps=100)
	{
		convert_fps_num := 100000
		convert_fps_den := 1000
	}
	else if(convert_fps=120)
	{
		convert_fps_num := 120000
		convert_fps_den := 1000
	}
	
	
	i:=1
	while(i<=8)
	{
		if (enable_process%i% = 0)
		{
			GuiControl,Hide,pic%i%
		}
		else
		{
			GuiControl,Show,pic%i%
		}
		i++
	}
	
	if(th_enable = 0)
	{
		i:=1
		while(i<=8)
		{
			GuiControl,Hide,pic%i%
			GuiControl,Hide,picv%i%
			i++
		}
	}

	if(by_scale = 1)
	{
		gui_d("width,height,width1,height1")
		gui_e("scale")
	}
	else if(by_width = 1)
	{
		gui_d("scale,height,width1,height1")
		gui_e("width")
	}
	else if(by_height = 1)
	{
		gui_d("scale,width,height,height1")
		gui_e("height")
	}
	else if(by_w_h = 1)
	{
		gui_d("scale,width,height")
		gui_e("width1,height1")
	}
	
	if(mode1 = 1)
	{
		mode_select := "noise_scale"
	}
	else if(mode2 = 1)
	{
		mode_select := "scale"
	}
	else if(mode3 = 1)
	{
		mode_select := "noise"
	}
	else
	{
		mode_select := "auto_scale"
	}
	
	GuiControl,,scalev_show,%scalev%
	GuiControl,,vp_quality_show,%vp_quality%
	GuiControl,,noise_levelv_show,%noise_levelv%
	
	if(t_fps_mode="1 sec")
	{
		t_fpsx := 1
	}
	else if(t_fps_mode="1 min")
	{
		t_fpsx := 60
	}
	else if(t_fps_mode="10 min")
	{
		t_fpsx := 600
	}
	else
	{
		t_fpsx := 3600
	}
	
	if(check_res_mode = "First File")
	{
		gui_d("check_custom_w,check_custom_h")
		
	}
	else
	{
		gui_e("check_custom_w,check_custom_h")
	}
	
	if(enable_check_res = "0")
	{
		GuiControl,Disable,enable_check_ssim
		enable_check_ssim := 0
	}
	else
	{
		GuiControl,Enable,enable_check_ssim
	}
	
	if(convert_enable = 1)
	{
		gui_d("enable_th_mode")
		enable_th_mode := 0
	}
	else
	{
		GuiControl,Enable,enable_th_mode
		gui_e("enable_th_mode")
	}
	
	if(enable_resize = 1)
	{
		gui_s("t_scale1,resize_w,resize_h,resize_x")
	}
	else
	{
		gui_h("t_scale1,resize_w,resize_h,resize_x")
	}
	
	if(deinter_mode="Frame")
	{
		deinter_m := 0
	}
	else
	{
		deinter_m := 1
	}
	
	if(deinter_field="Top")
	{
		deinter_f := 0
	}
	else
	{
		deinter_f := 1
	}
	
	if(enable_lossless=1)
	{
		gui_d("cqp_value1,crf_value1,c_420,c_422,c_444,c_8b,c_10b,enc_preset")
	}
	else
	{
		gui_e("cqp_value1,crf_value1,c_420,c_422,c_444,c_8b,c_10b,enc_preset")
	}
}
return

gui_d(var1)
{
	var2 := StrSplit(var1, ",")
	Loop % var2.MaxIndex()
	{
		GuiControl,Disable,% var2[A_Index]
	}
}


gui_e(var1)
{
	var2 := StrSplit(var1, ",")
	Loop % var2.MaxIndex()
	{
		GuiControl,Enable,% var2[A_Index]
	}
}

gui_h(var1)
{
	var2 := StrSplit(var1, ",")
	Loop % var2.MaxIndex()
	{
		GuiControl,Hide,% var2[A_Index]
	}
}

gui_s(var1)
{
	var2 := StrSplit(var1, ",")
	Loop % var2.MaxIndex()
	{
		GuiControl,Show,% var2[A_Index]
	}
}

alt_guiupdate:
{
	Gui, Submit, NoHide
	if(output_vid=1)
	{
		GuiControl,,config_ext2,|.avi|.mp4||.mkv
	}
	else if(output_pic=1)
	{
		GuiControl,,config_ext2,|.jpg||.png|.bmp
	}
	else
	{
		GuiControl,,config_ext2,|.aac||.ogg|.mp3|.wav
	}
	Gui, Submit, NoHide
}
Return


;------------------------------------------------------------------
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
	
	IfNotExist, %A_WorkingDir%\bin\ffmpeg_p1.exe
	{
		FileCopy, %A_WorkingDir%\bin\ffmpeg.exe, %A_WorkingDir%\bin\ffmpeg_p1.exe
		FileCopy, %A_WorkingDir%\bin\ffmpeg.exe, %A_WorkingDir%\bin\ffmpeg_p2.exe
		FileCopy, %A_WorkingDir%\bin\ffmpeg.exe, %A_WorkingDir%\bin\ffmpeg_p3.exe
		FileCopy, %A_WorkingDir%\bin\ffmpeg.exe, %A_WorkingDir%\bin\ffmpeg_p4.exe
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
				loop_out_filepath := out_path "\" A_LoopFileName
			
				if FileExist(loop_out_filepath)
				{
				}
				else
				{
					LV_Add("","Output Not Found : " loop_out_filepath)
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
									run_command := """" A_WorkingDir "\bin\ffmpeg_p" ssim_cycle ".exe"" -i """ A_LoopFilePath """ -i """ out_path "\" A_LoopFileName """ -lavfi ""[1:v]scale=" img_w ":" img_h "[vid1];[vid1][0:v]ssim=ssim_" ssim_cycle ".log"" -f null -"
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
	IniWrite, %th_enable%, %A_WorkingDir%\setting.ini, main, th_enable
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
	FileSelectFolder, in_pathv,, 3
	Thread, NoTimers, false
	if(in_pathv<>"")
		GuiControl,,in_pathv,%in_pathv%
}
Return

out_folderv:
{
	Thread, NoTimers
	FileSelectFolder, out_pathv,, 3
	Thread, NoTimers, false
	if(out_pathv<>"")
		GuiControl,,out_pathv,%out_pathv%
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

load_img:
{
	imagefile := A_LoopFilePath
	GDIPToken := Gdip_Startup()                                     
	pBM := Gdip_CreateBitmapFromFile( imagefile )
	img_w:= Gdip_GetImageWidth( pBM )
	img_h:= Gdip_GetImageHeight( pBM )   
	Gdip_DisposeImage( pBM )
	Gdip_Shutdown( GDIPToken ) 

	if(img_w>img_h)
	{
		p_ratio := Floor(thumbnail_max_size/(img_w/img_h))
		GuiControl,,pic%p_cycle%,%imagefile%
		GuiControl, MoveDraw, pic%p_cycle%, w%thumbnail_max_size% h%p_ratio%
	}
	else
	{
		p_ratio := Floor(thumbnail_max_size/(img_h/img_w))
		GuiControl,,pic%p_cycle%,%imagefile%
		GuiControl, MoveDraw, pic%p_cycle%, w%p_ratio% h%thumbnail_max_size%
	}
	GuiControl,Show,pic%p_cycle%
}
Return

load_imgv:
{
	imagefile := A_LoopFilePath
	GDIPToken := Gdip_Startup()                                     
	pBM := Gdip_CreateBitmapFromFile( imagefile )
	img_w:= Gdip_GetImageWidth( pBM )
	img_h:= Gdip_GetImageHeight( pBM )   
	Gdip_DisposeImage( pBM )
	Gdip_Shutdown( GDIPToken ) 

	if(img_w>img_h)
	{
		p_ratio := Floor(thumbnail_max_size/(img_w/img_h))
		GuiControl,,picv%p_cycle%,%imagefile%
		GuiControl, MoveDraw, picv%p_cycle%, w%thumbnail_max_size% h%p_ratio%
	}
	else
	{
		p_ratio := Floor(thumbnail_max_size/(img_h/img_w))
		GuiControl,,picv%p_cycle%,%imagefile%
		GuiControl, MoveDraw, picv%p_cycle%, w%p_ratio% h%thumbnail_max_size%
	}
	GuiControl,Show,picv%p_cycle%
}
Return

scale_select:
{
	if(mode3 = 1)
	{
		attribute1 := ""
		ff := ""
	}
	else if(by_scale = 1)
	{
		if scale is alpha
		{
			msgbox, Scale must not alphabetic characters
			stop := 1
		}
		attribute1 := "-s " scale
		ff := "-vf scale=iw*" scale ":ih*" scale
	}
	else if(by_width = 1)
	{
		if width is alpha
		{
			msgbox, Width must not alphabetic characters
			stop := 1
		}
		attribute1 := "-w " width
		ff := "-vf scale=" width ":-1"
	}
	else if(by_height = 1)
	{
		if height is alpha
		{
			msgbox, Height must not alphabetic characters
			stop := 1
		}
		attribute1 := "-h " height
		ff := "-vf scale=-1:"height
	}
	else if(by_w_h = 1)
	{
		if width1 is alpha
		{
			msgbox, Width1 must not alphabetic characters
			stop := 1
		}
		if height1 is alpha
		{
			msgbox, Height1 must not alphabetic characters
			stop := 1
		}
		attribute1 := "-w " width1 " -h " height1
		ff := "-vf scale=" width1 ":" height1
	}
}
Return

run_test:
{
	i:=1
	while(i<=8)
	{
		s_process_count%i% := 0
		GuiControl,,s_file_process%i%,-
		GuiControl,,s_process_count%i%,-
		GuiControl,Hide,pic%i%
		i++
	}
	stop := 0
	f_count := 0
	p_count := 0
	p_cycle := 0
	gpu_select := 0
	test_count := 0
	last_files_skiping := 0
	in_len := StrLen(in_path)
	GuiControl,,s_s,Starting..
	GuiControl,,f_total,Scaning..
	GuiControl,,f_pp,0
	GuiControl,,tspeed,-
	GuiControl,Disable,b_start
	GuiControl,Disable,b_start1
	GuiControl,Enabled,b_stop
	GuiControl,Enabled,b_stop1
	
	GuiControl,Disable,scale
	GuiControl,Disable,width
	GuiControl,Disable,height
	GuiControl,Disable,width1
	GuiControl,Disable,height1
	
	gosub,scale_select
	
	Loop, Files, %in_path%\*.*, FR
	{
		if A_LoopFileExt in png,jpg,jpeg,tif,tiff,bmp,tga
		{
			f_count += 1
		}
	}
	
	m1 := 0
	m2 := 0
	x := 1
	while (x<=7)
	{
		if(t_model%x% = 1)
		{
			m1 += 1
		}
		x++
	}
	
	x := 0
	while (x<=3)
	{
		if(t_nlv%x% = 1)
		{
			m2 += 1
		}
		x++
	}
	m3 := m1 * m2 * f_count
	GuiControl,,f_total,%m3%
	
	Loop, Files, %in_path%\*.*, FR
	{
		if A_LoopFileExt in png,bmp,jpg,jp2,sr,tif,hdr,exr,ppm,webp,tga
		{
			if(stop = 1)
			{
				break
			}
			
			StringTrimLeft, sub_dir, A_LoopFileDir, %in_len%
			
			if A_LoopFileExt in webp
			{
				StringTrimRight, out_filename, A_LoopFileName, 5
			}
			else
			{
				StringTrimRight, out_filename, A_LoopFileName, 4
			}
			
			if(out_path = "")
			{
				out_path := in_path
			}
			
			else IfNotExist, %out_path%%sub_dir%\%out_filename%
			{
				FileCreateDir, %out_path%%sub_dir%\%out_filename%
			}
			run_command := """" A_WorkingDir "\bin\ffmpeg.exe"" -i """ A_LoopFilePath """ " ff " -sws_flags " t_scale " """ out_path sub_dir "\" out_filename "\" out_filename "_" t_scale ".png"""
			Run, %run_command%, ,%win_mode%
			GuiControl,,l_com,%run_command%
			
			m1_cycle := 1
			while ( m1_cycle <= 7)
			{
				if(t_model%m1_cycle% = 0)
				{
					m1_cycle += 1
					continue
				}
				
				m2_cycle := 0
				while ( m2_cycle <= 3)
				{
					if(t_nlv%m2_cycle% = 0)
					{
						m2_cycle += 1
						continue
					}
				
					p_count += 1

					Loop
					{
						p_cycle += 1
						If p_cycle > %process_limit%
						{
							Sleep, %sleep_time%
							p_cycle := 1
						}
						
						if(enable_process%p_cycle% = 0)
						{
							continue
						}

						if(stop = 1)
						{
							goto, stop
						}
						process_name := "waifu2x-caffe-cui-p" p_cycle ".exe"
						Process, Exist, %process_name%
						If (!ErrorLevel= 1)
						{
							gpu_select := config_gpu%p_cycle%
							out_filename1 := out_filename "(" model_name%m1_cycle% ")_noise_level_" m2_cycle
							attribute2 := " --model_dir """ A_WorkingDir "\models\" model_name%m1_cycle% """"
							noise_level1 := m2_cycle
							run_command := """" A_WorkingDir "\waifu2x-caffe-cui-p" p_cycle ".exe"" --gpu " gpu_select " -p cudnn " attribute1 attribute2 " -n " noise_level1 " -m " mode_select " -i """ A_LoopFilePath """ -o """ out_path sub_dir "\" out_filename "\" out_filename1 config_ext """"
							Run, %run_command%, ,%win_mode%
							if(log_enable = 1)
							{
								gosub,log_console
							}
							GuiControl,,s_file_process%p_cycle%,%A_LoopFilePath%
							if(th_enable = 1)
							{
								gosub, load_img
							}
							s_process_count%p_cycle% += 1
							dv := s_process_count%p_cycle%
							GuiControl,,s_process_count%p_cycle%,%dv%
							per := (p_count/m3)*100
							GuiControl,,p_pro,%per%
							per := Round(per,2)
							GuiControl,,s_percen,%per% `%
							

							test_count += 1
							p_all := 0
							i := 1
							while(i<=8)
							{
								if(enable_process%i% = 1)
								{
									p_all++
								}
								i++
							}
							if (test_count = 1)
							{
								StartTime := A_TickCount
							}
							if test_count <= %p_all%
							{
								break
							}
							t_sec := (A_TickCount-StartTime)/1000
							speed := Round((test_count-p_all)/t_sec,3)
							GuiControl,,tspeed,%speed%
							Break
						}
					}
					m2_cycle += 1
				}
				m1_cycle += 1
			}
		}
	}
	stop:
	GuiControl,,f_pp,%p_count%
	GuiControl,Enabled,b_start
	GuiControl,Enabled,b_start1
	GuiControl,Disable,b_stop
	GuiControl,Disable,b_stop1
	
	if(stop = 1)
	{
		GuiControl,,s_s,Stopped
	}
	else
	{
		GuiControl,,s_s,Finished
		per := (p_count/f_count)*100
		GuiControl,,p_pro,%per%
	}
	goto, gui_update

}
Return

run_start:
{
	i:=1
	while(i<=8)
	{
		s_process_count%i% := 0
		GuiControl,,s_file_process%i%,-
		GuiControl,,s_process_count%i%,-
		GuiControl,Hide,pic%i%
		i++
	}
	stop := 0
	f_count := 0
	p_count := 0
	p_cycle := 0
	gpu_select := 0
	test_count := 0
	last_files_skiping := 0
	in_len := StrLen(in_path)
	GuiControl,,s_s,Starting..
	GuiControl,,f_total,Scaning..
	GuiControl,,f_pp,0
	GuiControl,,tspeed,-
	GuiControl,Disable,b_start
	GuiControl,Disable,b_start1
	GuiControl,Enabled,b_stop
	GuiControl,Enabled,b_stop1
	
	GuiControl,Disable,scale
	GuiControl,Disable,width
	GuiControl,Disable,height
	GuiControl,Disable,width1
	GuiControl,Disable,height1
	
	gosub,scale_select
	
	Loop, Files, %in_path%\*.*, FR
	{
		if A_LoopFileExt in png,jpg,jpeg,tif,tiff,bmp,tga
		{
			f_count += 1
		}
	}

	if(!model)
	{
		attribute2 := ""
	}
	else
	{
		attribute2 := " --model_dir """ A_WorkingDir "\models\" model """"
	}
	
	GuiControl,,f_total,%f_count%
	
	Loop, Files, %in_path%\*.*, FR
	{
		if A_LoopFileExt in png,bmp,jpg,jp2,sr,tif,hdr,exr,ppm,webp,tga
		{
			if(stop = 1)
			{
				break
			}
			
			StringTrimLeft, sub_dir, A_LoopFileDir, %in_len%
			
			if A_LoopFileExt in webp
			{
				StringTrimRight, out_filename, A_LoopFileName, 5
			}
			else
			{
				StringTrimRight, out_filename, A_LoopFileName, 4
			}
			

			
			p_count += 1
			
			if(out_path = "")
			{
				out_path := in_path
				out_file_config := ""
			}
			else
			{
				out_file_config := " -o """ out_path sub_dir "\" out_filename config_ext """"
				if skip_exist = 1
				{
					IfExist, %out_path%%sub_dir%\%out_filename%%config_ext%
					{
						last_files_skiping += 1
						if(last_files_skiping = 1)
						{
							GuiControl,,f_pp,Skipping..
						}
						Continue
					}
					else
					{
						last_files_skiping := 0
						GuiControl,,f_pp,%p_count%
					}
				}
				else
				{
					GuiControl,,f_pp,%p_count%
				}
			}


			Loop
			{	
				p_cycle += 1
				If p_cycle > %process_limit%
				{
					Sleep, %sleep_time%
					p_cycle := 1
				}
				
				if(enable_process%p_cycle% = 0)
				{
					continue
				}
				
				
				if(stop = 1)
				{
					break
				}
				process_name := "waifu2x-caffe-cui-p" p_cycle ".exe"
				Process, Exist, %process_name%
				If (!ErrorLevel= 1)
				{
					IfNotExist, %out_path%%sub_dir%
					{
						FileCreateDir, %out_path%%sub_dir%
					}
					gpu_select := config_gpu%p_cycle%

					run_command := """" A_WorkingDir "\waifu2x-caffe-cui-p" p_cycle ".exe"" --gpu " gpu_select " -p cudnn " attribute1 attribute2 " -n " noise_level " -m " mode_select " -i """ A_LoopFilePath """ " out_file_config
					Run, %run_command%, ,%win_mode%
					if(log_enable = 1)
					{
						gosub,log_console
					}
					GuiControl,,s_file_process%p_cycle%,%A_LoopFilePath%
					if(th_enable = 1)
					{
						gosub, load_img
					}
					s_process_count%p_cycle% += 1
					dv := s_process_count%p_cycle%
					GuiControl,,s_process_count%p_cycle%,%dv%
					per := (p_count/f_count)*100
					GuiControl,,p_pro,%per%
					per := Round(per,2)
					GuiControl,,s_percen,%per% `%

					test_count += 1
					
					p_all := 0
					i := 1
					while(i<=8)
					{
						if(enable_process%i% = 1)
						{
							p_all++
						}
						i++
					}
					if (test_count = 1)
					{
						StartTime := A_TickCount
					}
					if test_count <= %p_all%
					{
						break
					}
					t_sec := (A_TickCount-StartTime)/1000
					speed := Round((test_count-p_all)/t_sec,3)
					GuiControl,,tspeed,%speed%
					Break
				}
			}
		}
	}
	GuiControl,,f_pp,%p_count%
	GuiControl,Enabled,b_start
	GuiControl,Enabled,b_start1
	GuiControl,Disable,b_stop
	GuiControl,Disable,b_stop1
	
	if(stop = 1)
	{
		GuiControl,,s_s,Stopped
	}
	else
	{
		GuiControl,,s_s,Finished
		per := (p_count/f_count)*100
		GuiControl,,p_pro,%per%
	}
	goto, gui_update
}
return


run_stop:
{
	stop := 1
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


run_vid_to_pic:
{
	filter_count := 0
	run_command := ""
	run_command1 := ""
	run_command2 := ""
	run_command3 := ""
	run_command4 := ""
	run_command5 := ""
	run_command6 := ""
	
	if(vp_in_path="")
	{
		MsgBox, Error No Input
		Return
	}
	
	SplitPath, vp_in_path, in_name_ext, in_dir, in_ext, in_name
	
	if (SubStr(vp_out_path,-1)="\")
	{
		StringTrimRight, vp_out_path, vp_out_path, 1
	}
	
	if(vp_out_path="")
	{
		vp_out_path := in_dir
	}
	
	if(audio_out_path="")
	{
		audio_out_path := vp_out_path
	}
	
	


	if(output_pic=1)
	{
		IfNotExist, %audio_out_path%
		{
			FileCreateDir, %audio_out_path%
		}
		
		IfNotExist, %vp_out_path%\%in_name%
		{
			FileCreateDir, %vp_out_path%\%in_name%
		}
	}
	else
	{
		IfNotExist, %vp_out_path%
		{
			FileCreateDir, %vp_out_path%
		}
	}
	
	run_command .= """" A_WorkingDir "\bin\ffmpeg.exe"""
	if(image_input=1)
	{
		run_command2 .= " -i """ in_dir "\image%06d." in_ext """"
	}
	else
	{
		run_command2 .= " -i """ vp_in_path """"
	}
	
	if(enable_add_audio=1 and output_pic<>1)
	{
		if(add_audio_path<>"")
			run_command2 .= " -i """ add_audio_path """"
	}
	
	if(enable_deinterlace = 1)
	{
		attribute := "yadif=" deinter_m ":" deinter_f
		run_command4 .= add_filter(attribute)
	}
	
	if(enable_decimate = 1)
	{
		attribute := "decimate=cycle=5,setpts=N/23.976/TB"
		run_command4 .= add_filter(attribute)
	}
	
	
	if(image_input=1)
	{
		run_command1 .= " -framerate " convert_fps_num "/" convert_fps_den
		attribute := "fps=" convert_fps_num "/" convert_fps_den
		run_command4 .= add_filter(attribute)
	}
	else
	{
		if(convert_enable = 1)
		{
			run_command3 .= " -vsync 1"
			attribute := "fps=" convert_fps_num "/" convert_fps_den
			run_command4 .= add_filter(attribute)
		}
		
		if(enable_th_mode = 1)
		{
			attribute := "fps=" t_fps "/" t_fpsx
			run_command4 .= add_filter(attribute)
		}
	}
	if(enable_resize = 1)
	{
		attribute := "scale=" resize_w ":" resize_h
		run_command4 .= add_filter(attribute)
		run_command5 .= " -sws_flags " t_scale1
	}
	
	
	
	if(filter_count>0)
	{
		run_command4 .= """"
	}
	
	if(config_ext2 = ".jpg")
	{
		run_command5 .= " -q:v " vp_quality
	}
	
	if(output_vid=1)
	{
		if(enc_264=1)
			run_command5 .= " -c:v libx264"
		if(enc_265=1)
			run_command5 .= " -c:v libx265"			
		
		if(c_420=1)
		{
			run_command5 .= " -pix_fmt yuv420p"
		}
		else if(c_422=1)
		{
			run_command5 .= " -pix_fmt yuv422p"
		}
		else
		{
			run_command5 .= " -pix_fmt yuv444p"
		}
		
		if(c_10b=1)
		{
			run_command5 .= "10le"
		}
		
		if(cqp_s1=1)
		{
			run_command5 .= " -qp " cqp_value1
		}
		else if(crf_s1=1)
		{
			run_command5 .= " -crf " crf_value1
		}
		
		run_command5 .= " -preset " enc_preset
	}
	
	if(enable_audio=1 and output_pic<>1)
	{
		if(enable_add_audio=1 and image_input<>1)
		{
			run_command5 .= " -map 0:v:0 -map 1:a:0"
		}
		
		if(enable_a_aac=1)
			run_command5 .= " -codec:a aac -q:a 5 -cutoff 22000"
		else if(enable_a_ogg=1)
			run_command5 .= " -codec:a libvorbis -aq 10"
		else if(enable_a_mp3=1)
			run_command5 .= " -codec:a libmp3lame -b:a 320k"
		else if(enable_a_pcm=1)
			run_command5 .= " -codec:a pcm_s16le"
		else if(enable_a_copy=1)
			run_command5 .= " -codec:a copy"
	}
	else
	{
		run_command5 .= " -an"
	}
	
	
	if(enable_ss=1)
	{
		run_command5 .= " -ss " time_ss
	}
	if(enable_to=1)
	{
		run_command5 .= " -to " time_to
	}
	
	run_command6 .= " """ vp_out_path "\"
	
	if(output_pic=1)
	{
		run_command6 .= in_name "\image%06d" config_ext2 """"
	}
	else if(output_vid=1)
	{
		out_name := in_name
		ifExist, %vp_out_path%\%in_name%%config_ext2%
		{
			out_name .= "_1" 
		}
		run_command6 .= out_name config_ext2 """"
	}
	else
	{
		run_command6 .= in_name
		if(enable_a_aac=1)
			run_command6 .= ".aac"
		else if(enable_a_ogg=1)
			run_command6 .= ".ogg"
		else if(enable_a_mp3=1)
			run_command6 .= ".mp3"
		else if(enable_a_pcm=1)
			run_command6 .= ".wav"
		else if(enable_a_copy=1)
			run_command6 .= config_ext2
		
		run_command6 .= """"
	}
	
	run_command .= run_command1 run_command2 run_command3 run_command4 run_command5 run_command6
	gosub,log_console
	RunWait,  %run_command%, ,
	MsgBox, Finished!
}
Return



run_startv:
{
	i:=1
	batch_count0 := 0
	process_limitv := 8
	while(i<=8)
	{
		v_run%i% := 0
		batch_count%i% := 0
		copy_buffer%i% := 0
		buffer_dir%i% := ""

		s_process_countv%i% := 0
		GuiControl,,s_file_processv%i%,-
		GuiControl,,s_process_countv%i%,-
		GuiControl,Hide,pic%i%
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
	in_len := StrLen(in_pathv)
	GuiControl,,s_sv,Starting..
	GuiControl,,f_totalv,Scaning..
	GuiControl,,f_ppv,0
	GuiControl,,tspeedv,-
	GuiControl,Disable,b_start
	GuiControl,Disable,b_startv
	GuiControl,Disable,b_start1
	GuiControl,Enabled,b_stop
	GuiControl,Enabled,b_stopv
	GuiControl,Enabled,b_stop1
	
	GuiControl,Disable,scalev
	

	FileRemoveDir, %in_pathv%\temp, 1

	
	Loop, Files, %in_pathv%\*.*, F
	{
		if A_LoopFileExt in png,jpg,jpeg,tif,tiff,bmp,tga
		{
			f_count += 1
		}
	}

	
	GuiControl,,f_totalv,%f_count%
	
	IfNotExist, %in_pathv%\temp
	{
		FileCreateDir, %in_pathv%\temp
		i := 1
		while(i<=8)
		{
			FileCreateDir, %in_pathv%\temp\%i%
			i++
		}
	}
	
	IfNotExist, %out_pathv%
	{
		FileCreateDir, %out_pathv%
	}
	
	StartTime := A_TickCount
	
	Loop, Files, %in_pathv%\*.*, F
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
			
			out_file_config := """" out_pathv "\" out_filename config_extv """"
			if skip_exist = 1
			{
				IfExist, %out_pathv%\%out_filename%%config_extv%.png
				{
					last_files_svkiping += 1
					if(last_files_svkiping = 1)
					{
						GuiControl,,f_ppv,Skipping..
					}
					Continue
				}
				else IfExist, %out_pathv%\%out_filename%%config_extv%
				{
					last_files_svkiping += 1
					if(last_files_svkiping = 1)
					{
						GuiControl,,f_ppv,Skipping..
					}
					Continue
				}
				else IfExist, %out_pathv%\%out_filename%.jpg.png
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

				if(enable_processv%fill_buuffer% = 0)
				{
					continue
				}
				
				if(batch_count%fill_buuffer% = 0)
					FileCreateDir, %in_pathv%\temp\%fill_buuffer%_buffer
				
				if(batch_count%fill_buuffer% < batch_size)
				{
					FileCopy, %A_LoopFilePath%, %in_pathv%\temp\%fill_buuffer%_buffer
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
				fill_buuffer := 0
				while(fill_buuffer<8)
				{
					fill_buuffer++
					if(enable_processv%fill_buuffer% = 0)
					{
						continue
					}
					FileCopy, %A_LoopFilePath%, %in_pathv%\temp\%fill_buuffer%_buffer
				}
				break
			}
			
			if(next_loop<>1)
			{
				Loop
				{
					p_cycle += 1
					If p_cycle > %process_limitv%
					{
						p_cycle := 1
					}
					if(stop = 1)
					{
						break
					}
					if(enable_processv%p_cycle% = 0)
					{
						continue
					}

					process_name := "waifu2x-ncnn-vulkan-p" p_cycle ".exe"
					Process, Exist, %process_name%
					If (!ErrorLevel= 1)
					{
						FileRemoveDir, %in_pathv%\temp\%p_cycle%, 1
						FileMoveDir, %in_pathv%\temp\%p_cycle%_buffer, %in_pathv%\temp\%p_cycle%, R
						batch_count%p_cycle% := 0
						run_command := """waifu2x-ncnn-vulkan-p" p_cycle ".exe"" -i """ in_pathv "\temp\" p_cycle """ -o """ out_pathv """ -n " noise_levelv " -s " scalev " -t " config_t_sizev " -m """ A_WorkingDir "\" modelv """ -g " config_gpuv%p_cycle%
						run, %comspec% /c cd "%A_WorkingDir%" & %run_command%,,%win_modev%
						
						if(log_enable = 1)
						{
							gosub,log_console
						}
						GuiControl,,s_file_processv%p_cycle%,%A_LoopFilePath%
						if(th_enablev = 1)
						{
							gosub, load_imgv
						}
						s_process_countv%p_cycle% += 1
						dv := s_process_countv%p_cycle%
						GuiControl,,s_process_countv%p_cycle%,%dv%
						per := (p_count/f_count)*100
						GuiControl,,p_prov,%per%
						per := Round(per,2)
						GuiControl,,s_percenv,%per% `%

						wait_process:
						Process, Exist, %process_name%
						If (!ErrorLevel= 1)
						{
							sleep,100
							goto,wait_process
						}
						
						goto,buffer
					}
					
					If p_cycle > %process_limitv%
					{
						Sleep, %sleep_timev%
					}
				}
			}
		}
	}
	
	Loop
	{
		p_cycle += 1
		If p_cycle > %process_limitv%
		{
			p_cycle := 1
		}
		if(stop = 1)
		{
			break
		}
		if(enable_processv%p_cycle% = 0)
		{
			continue
		}
		
		process_name := "waifu2x-ncnn-vulkan-p" p_cycle ".exe"
		Process, Exist, %process_name%
		If (!ErrorLevel= 1)
		{
			FileRemoveDir, %in_pathv%\temp\%p_cycle%, 1
			FileMoveDir, %in_pathv%\temp\%p_cycle%_buffer, %in_pathv%\temp\%p_cycle%, R
			run_command := """waifu2x-ncnn-vulkan-p" p_cycle ".exe"" -i """ in_pathv "\temp\" p_cycle """ -o """ out_pathv """ -n " noise_levelv " -s " scalev " -t " config_t_sizev " -m """ A_WorkingDir "\" modelv """ -g " config_gpuv%p_cycle%
			run, %comspec% /c cd "%A_WorkingDir%" & %run_command%,,%win_modev%
			
			if(log_enable = 1)
			{
				gosub,log_console
			}
			
			if(th_enablev = 1)
			{
				gosub, load_imgv
			}


			sleep,200

			a:=0
			loop, Files, %in_pathv%\temp\*.*,F R
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
		
		If p_cycle > %process_limitv%
		{
			Sleep, %sleep_timev%
		}
	}


	
	t_sec := (A_TickCount-StartTime)/1000
	speed := Round(test_count/t_sec,3)
	GuiControl,,tspeedv,%speed%
	GuiControl,,s_percenv,100 `%

	MsgBox, 4,, Finished do you want to Rename?
	IfMsgBox Yes
	{
		Loop, Files, %out_pathv%\*.png.png , F
		{
			loop_ext := SubStr(A_LoopFileName, -7)
			StringTrimLeft, loop_ext, loop_ext, 4
			StringTrimRight, loop_fpath, A_LoopFilePath, 8
			FileMove, %A_LoopFilePath%, %loop_fpath%%loop_ext%
		}
		
		Loop, Files, %out_pathv%\*.jpg.png , F
		{
			loop_ext := SubStr(A_LoopFileName, -7)
			StringTrimLeft, loop_ext, loop_ext, 4
			StringTrimRight, loop_fpath, A_LoopFilePath, 8
			FileMove, %A_LoopFilePath%, %loop_fpath%%loop_ext%
		}
		MsgBox,Finished!
		
	}
	FileRemoveDir, %in_pathv%\temp, 1
	GuiControl,,f_ppv,%p_count%
	GuiControl,Enabled,b_start
	GuiControl,Enabled,b_startv
	GuiControl,Enabled,b_startv1
	GuiControl,Enabled,scalev
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
		GuiControl,,p_prov,%per%
	}
	goto, gui_update
}
return


guiclose:
exit:
{
	exitapp
}
return





; Gdip standard library v1.45 by tic (Tariq Porter) 07/09/11
; Modifed by Rseding91 using fincs 64 bit compatible Gdip library 5/1/2013
; Supports: Basic, _L ANSi, _L Unicode x86 and _L Unicode x64
;
; Updated 2/20/2014 - fixed Gdip_CreateRegion() and Gdip_GetClipRegion() on AHK Unicode x86
; Updated 5/13/2013 - fixed Gdip_SetBitmapToClipboard() on AHK Unicode x64
;
;#####################################################################################
;#####################################################################################
; STATUS ENUMERATION
; Return values for functions specified to have status enumerated return type
;#####################################################################################
;
; Ok =						= 0
; GenericError				= 1
; InvalidParameter			= 2
; OutOfMemory				= 3
; ObjectBusy				= 4
; InsufficientBuffer		= 5
; NotImplemented			= 6
; Win32Error				= 7
; WrongState				= 8
; Aborted					= 9
; FileNotFound				= 10
; ValueOverflow				= 11
; AccessDenied				= 12
; UnknownImageFormat		= 13
; FontFamilyNotFound		= 14
; FontStyleNotFound			= 15
; NotTrueTypeFont			= 16
; UnsupportedGdiplusVersion	= 17
; GdiplusNotInitialized		= 18
; PropertyNotFound			= 19
; PropertyNotSupported		= 20
; ProfileNotFound			= 21
;
;#####################################################################################
;#####################################################################################
; FUNCTIONS
;#####################################################################################
;
; UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255)
; BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster="")
; StretchBlt(dDC, dx, dy, dw, dh, sDC, sx, sy, sw, sh, Raster="")
; SetImage(hwnd, hBitmap)
; Gdip_BitmapFromScreen(Screen=0, Raster="")
; CreateRectF(ByRef RectF, x, y, w, h)
; CreateSizeF(ByRef SizeF, w, h)
; CreateDIBSection
;
;#####################################################################################

; Function:     			UpdateLayeredWindow
; Description:  			Updates a layered window with the handle to the DC of a gdi bitmap
; 
; hwnd        				Handle of the layered window to update
; hdc           			Handle to the DC of the GDI bitmap to update the window with
; Layeredx      			x position to place the window
; Layeredy      			y position to place the window
; Layeredw      			Width of the window
; Layeredh      			Height of the window
; Alpha         			Default = 255 : The transparency (0-255) to set the window transparency
;
; return      				If the function succeeds, the return value is nonzero
;
; notes						If x or y omitted, then layered window will use its current coordinates
;							If w or h omitted then current width and height will be used

UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if ((x != "") && (y != ""))
		VarSetCapacity(pt, 8), NumPut(x, pt, 0, "UInt"), NumPut(y, pt, 4, "UInt")

	if (w = "") ||(h = "")
		WinGetPos,,, w, h, ahk_id %hwnd%
   
	return DllCall("UpdateLayeredWindow"
					, Ptr, hwnd
					, Ptr, 0
					, Ptr, ((x = "") && (y = "")) ? 0 : &pt
					, "int64*", w|h<<32
					, Ptr, hdc
					, "int64*", 0
					, "uint", 0
					, "UInt*", Alpha<<16|1<<24
					, "uint", 2)
}

;#####################################################################################

; Function				BitBlt
; Description			The BitBlt function performs a bit-block transfer of the color data corresponding to a rectangle 
;						of pixels from the specified source device context into a destination device context.
;
; dDC					handle to destination DC
; dx					x-coord of destination upper-left corner
; dy					y-coord of destination upper-left corner
; dw					width of the area to copy
; dh					height of the area to copy
; sDC					handle to source DC
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; Raster				raster operation code
;
; return				If the function succeeds, the return value is nonzero
;
; notes					If no raster operation is specified, then SRCCOPY is used, which copies the source directly to the destination rectangle
;
; BLACKNESS				= 0x00000042
; NOTSRCERASE			= 0x001100A6
; NOTSRCCOPY			= 0x00330008
; SRCERASE				= 0x00440328
; DSTINVERT				= 0x00550009
; PATINVERT				= 0x005A0049
; SRCINVERT				= 0x00660046
; SRCAND				= 0x008800C6
; MERGEPAINT			= 0x00BB0226
; MERGECOPY				= 0x00C000CA
; SRCCOPY				= 0x00CC0020
; SRCPAINT				= 0x00EE0086
; PATCOPY				= 0x00F00021
; PATPAINT				= 0x00FB0A09
; WHITENESS				= 0x00FF0062
; CAPTUREBLT			= 0x40000000
; NOMIRRORBITMAP		= 0x80000000

BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster="")
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdi32\BitBlt"
					, Ptr, dDC
					, "int", dx
					, "int", dy
					, "int", dw
					, "int", dh
					, Ptr, sDC
					, "int", sx
					, "int", sy
					, "uint", Raster ? Raster : 0x00CC0020)
}

;#####################################################################################

; Function				StretchBlt
; Description			The StretchBlt function copies a bitmap from a source rectangle into a destination rectangle, 
;						stretching or compressing the bitmap to fit the dimensions of the destination rectangle, if necessary.
;						The system stretches or compresses the bitmap according to the stretching mode currently set in the destination device context.
;
; ddc					handle to destination DC
; dx					x-coord of destination upper-left corner
; dy					y-coord of destination upper-left corner
; dw					width of destination rectangle
; dh					height of destination rectangle
; sdc					handle to source DC
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; sw					width of source rectangle
; sh					height of source rectangle
; Raster				raster operation code
;
; return				If the function succeeds, the return value is nonzero
;
; notes					If no raster operation is specified, then SRCCOPY is used. It uses the same raster operations as BitBlt		

StretchBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, sw, sh, Raster="")
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdi32\StretchBlt"
					, Ptr, ddc
					, "int", dx
					, "int", dy
					, "int", dw
					, "int", dh
					, Ptr, sdc
					, "int", sx
					, "int", sy
					, "int", sw
					, "int", sh
					, "uint", Raster ? Raster : 0x00CC0020)
}

;#####################################################################################

; Function				SetStretchBltMode
; Description			The SetStretchBltMode function sets the bitmap stretching mode in the specified device context
;
; hdc					handle to the DC
; iStretchMode			The stretching mode, describing how the target will be stretched
;
; return				If the function succeeds, the return value is the previous stretching mode. If it fails it will return 0
;
; STRETCH_ANDSCANS 		= 0x01
; STRETCH_ORSCANS 		= 0x02
; STRETCH_DELETESCANS 	= 0x03
; STRETCH_HALFTONE 		= 0x04

SetStretchBltMode(hdc, iStretchMode=4)
{
	return DllCall("gdi32\SetStretchBltMode"
					, A_PtrSize ? "UPtr" : "UInt", hdc
					, "int", iStretchMode)
}

;#####################################################################################

; Function				SetImage
; Description			Associates a new image with a static control
;
; hwnd					handle of the control to update
; hBitmap				a gdi bitmap to associate the static control with
;
; return				If the function succeeds, the return value is nonzero

SetImage(hwnd, hBitmap)
{
	SendMessage, 0x172, 0x0, hBitmap,, ahk_id %hwnd%
	E := ErrorLevel
	DeleteObject(E)
	return E
}

;#####################################################################################

; Function				SetSysColorToControl
; Description			Sets a solid colour to a control
;
; hwnd					handle of the control to update
; SysColor				A system colour to set to the control
;
; return				If the function succeeds, the return value is zero
;
; notes					A control must have the 0xE style set to it so it is recognised as a bitmap
;						By default SysColor=15 is used which is COLOR_3DFACE. This is the standard background for a control
;
; COLOR_3DDKSHADOW				= 21
; COLOR_3DFACE					= 15
; COLOR_3DHIGHLIGHT				= 20
; COLOR_3DHILIGHT				= 20
; COLOR_3DLIGHT					= 22
; COLOR_3DSHADOW				= 16
; COLOR_ACTIVEBORDER			= 10
; COLOR_ACTIVECAPTION			= 2
; COLOR_APPWORKSPACE			= 12
; COLOR_BACKGROUND				= 1
; COLOR_BTNFACE					= 15
; COLOR_BTNHIGHLIGHT			= 20
; COLOR_BTNHILIGHT				= 20
; COLOR_BTNSHADOW				= 16
; COLOR_BTNTEXT					= 18
; COLOR_CAPTIONTEXT				= 9
; COLOR_DESKTOP					= 1
; COLOR_GRADIENTACTIVECAPTION	= 27
; COLOR_GRADIENTINACTIVECAPTION	= 28
; COLOR_GRAYTEXT				= 17
; COLOR_HIGHLIGHT				= 13
; COLOR_HIGHLIGHTTEXT			= 14
; COLOR_HOTLIGHT				= 26
; COLOR_INACTIVEBORDER			= 11
; COLOR_INACTIVECAPTION			= 3
; COLOR_INACTIVECAPTIONTEXT		= 19
; COLOR_INFOBK					= 24
; COLOR_INFOTEXT				= 23
; COLOR_MENU					= 4
; COLOR_MENUHILIGHT				= 29
; COLOR_MENUBAR					= 30
; COLOR_MENUTEXT				= 7
; COLOR_SCROLLBAR				= 0
; COLOR_WINDOW					= 5
; COLOR_WINDOWFRAME				= 6
; COLOR_WINDOWTEXT				= 8

SetSysColorToControl(hwnd, SysColor=15)
{
   WinGetPos,,, w, h, ahk_id %hwnd%
   bc := DllCall("GetSysColor", "Int", SysColor, "UInt")
   pBrushClear := Gdip_BrushCreateSolid(0xff000000 | (bc >> 16 | bc & 0xff00 | (bc & 0xff) << 16))
   pBitmap := Gdip_CreateBitmap(w, h), G := Gdip_GraphicsFromImage(pBitmap)
   Gdip_FillRectangle(G, pBrushClear, 0, 0, w, h)
   hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
   SetImage(hwnd, hBitmap)
   Gdip_DeleteBrush(pBrushClear)
   Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap)
   return 0
}

;#####################################################################################

; Function				Gdip_BitmapFromScreen
; Description			Gets a gdi+ bitmap from the screen
;
; Screen				0 = All screens
;						Any numerical value = Just that screen
;						x|y|w|h = Take specific coordinates with a width and height
; Raster				raster operation code
;
; return      			If the function succeeds, the return value is a pointer to a gdi+ bitmap
;						-1:		one or more of x,y,w,h not passed properly
;
; notes					If no raster operation is specified, then SRCCOPY is used to the returned bitmap

Gdip_BitmapFromScreen(Screen=0, Raster="")
{
	if (Screen = 0)
	{
		Sysget, x, 76
		Sysget, y, 77	
		Sysget, w, 78
		Sysget, h, 79
	}
	else if (SubStr(Screen, 1, 5) = "hwnd:")
	{
		Screen := SubStr(Screen, 6)
		if !WinExist( "ahk_id " Screen)
			return -2
		WinGetPos,,, w, h, ahk_id %Screen%
		x := y := 0
		hhdc := GetDCEx(Screen, 3)
	}
	else if (Screen&1 != "")
	{
		Sysget, M, Monitor, %Screen%
		x := MLeft, y := MTop, w := MRight-MLeft, h := MBottom-MTop
	}
	else
	{
		StringSplit, S, Screen, |
		x := S1, y := S2, w := S3, h := S4
	}

	if (x = "") || (y = "") || (w = "") || (h = "")
		return -1

	chdc := CreateCompatibleDC(), hbm := CreateDIBSection(w, h, chdc), obm := SelectObject(chdc, hbm), hhdc := hhdc ? hhdc : GetDC()
	BitBlt(chdc, 0, 0, w, h, hhdc, x, y, Raster)
	ReleaseDC(hhdc)
	
	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
	SelectObject(chdc, obm), DeleteObject(hbm), DeleteDC(hhdc), DeleteDC(chdc)
	return pBitmap
}

;#####################################################################################

; Function				Gdip_BitmapFromHWND
; Description			Uses PrintWindow to get a handle to the specified window and return a bitmap from it
;
; hwnd					handle to the window to get a bitmap from
;
; return				If the function succeeds, the return value is a pointer to a gdi+ bitmap
;
; notes					Window must not be not minimised in order to get a handle to it's client area

Gdip_BitmapFromHWND(hwnd)
{
	WinGetPos,,, Width, Height, ahk_id %hwnd%
	hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
	PrintWindow(hwnd, hdc)
	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
	SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
	return pBitmap
}

;#####################################################################################

; Function    			CreateRectF
; Description			Creates a RectF object, containing a the coordinates and dimensions of a rectangle
;
; RectF       			Name to call the RectF object
; x            			x-coordinate of the upper left corner of the rectangle
; y            			y-coordinate of the upper left corner of the rectangle
; w            			Width of the rectangle
; h            			Height of the rectangle
;
; return      			No return value

CreateRectF(ByRef RectF, x, y, w, h)
{
   VarSetCapacity(RectF, 16)
   NumPut(x, RectF, 0, "float"), NumPut(y, RectF, 4, "float"), NumPut(w, RectF, 8, "float"), NumPut(h, RectF, 12, "float")
}

;#####################################################################################

; Function    			CreateRect
; Description			Creates a Rect object, containing a the coordinates and dimensions of a rectangle
;
; RectF       			Name to call the RectF object
; x            			x-coordinate of the upper left corner of the rectangle
; y            			y-coordinate of the upper left corner of the rectangle
; w            			Width of the rectangle
; h            			Height of the rectangle
;
; return      			No return value

CreateRect(ByRef Rect, x, y, w, h)
{
	VarSetCapacity(Rect, 16)
	NumPut(x, Rect, 0, "uint"), NumPut(y, Rect, 4, "uint"), NumPut(w, Rect, 8, "uint"), NumPut(h, Rect, 12, "uint")
}
;#####################################################################################

; Function		    	CreateSizeF
; Description			Creates a SizeF object, containing an 2 values
;
; SizeF         		Name to call the SizeF object
; w            			w-value for the SizeF object
; h            			h-value for the SizeF object
;
; return      			No Return value

CreateSizeF(ByRef SizeF, w, h)
{
   VarSetCapacity(SizeF, 8)
   NumPut(w, SizeF, 0, "float"), NumPut(h, SizeF, 4, "float")     
}
;#####################################################################################

; Function		    	CreatePointF
; Description			Creates a SizeF object, containing an 2 values
;
; SizeF         		Name to call the SizeF object
; w            			w-value for the SizeF object
; h            			h-value for the SizeF object
;
; return      			No Return value

CreatePointF(ByRef PointF, x, y)
{
   VarSetCapacity(PointF, 8)
   NumPut(x, PointF, 0, "float"), NumPut(y, PointF, 4, "float")     
}
;#####################################################################################

; Function				CreateDIBSection
; Description			The CreateDIBSection function creates a DIB (Device Independent Bitmap) that applications can write to directly
;
; w						width of the bitmap to create
; h						height of the bitmap to create
; hdc					a handle to the device context to use the palette from
; bpp					bits per pixel (32 = ARGB)
; ppvBits				A pointer to a variable that receives a pointer to the location of the DIB bit values
;
; return				returns a DIB. A gdi bitmap
;
; notes					ppvBits will receive the location of the pixels in the DIB

CreateDIBSection(w, h, hdc="", bpp=32, ByRef ppvBits=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	hdc2 := hdc ? hdc : GetDC()
	VarSetCapacity(bi, 40, 0)
	
	NumPut(w, bi, 4, "uint")
	, NumPut(h, bi, 8, "uint")
	, NumPut(40, bi, 0, "uint")
	, NumPut(1, bi, 12, "ushort")
	, NumPut(0, bi, 16, "uInt")
	, NumPut(bpp, bi, 14, "ushort")
	
	hbm := DllCall("CreateDIBSection"
					, Ptr, hdc2
					, Ptr, &bi
					, "uint", 0
					, A_PtrSize ? "UPtr*" : "uint*", ppvBits
					, Ptr, 0
					, "uint", 0, Ptr)

	if !hdc
		ReleaseDC(hdc2)
	return hbm
}

;#####################################################################################

; Function				PrintWindow
; Description			The PrintWindow function copies a visual window into the specified device context (DC), typically a printer DC
;
; hwnd					A handle to the window that will be copied
; hdc					A handle to the device context
; Flags					Drawing options
;
; return				If the function succeeds, it returns a nonzero value
;
; PW_CLIENTONLY			= 1

PrintWindow(hwnd, hdc, Flags=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("PrintWindow", Ptr, hwnd, Ptr, hdc, "uint", Flags)
}

;#####################################################################################

; Function				DestroyIcon
; Description			Destroys an icon and frees any memory the icon occupied
;
; hIcon					Handle to the icon to be destroyed. The icon must not be in use
;
; return				If the function succeeds, the return value is nonzero

DestroyIcon(hIcon)
{
	return DllCall("DestroyIcon", A_PtrSize ? "UPtr" : "UInt", hIcon)
}

;#####################################################################################

PaintDesktop(hdc)
{
	return DllCall("PaintDesktop", A_PtrSize ? "UPtr" : "UInt", hdc)
}

;#####################################################################################

CreateCompatibleBitmap(hdc, w, h)
{
	return DllCall("gdi32\CreateCompatibleBitmap", A_PtrSize ? "UPtr" : "UInt", hdc, "int", w, "int", h)
}

;#####################################################################################

; Function				CreateCompatibleDC
; Description			This function creates a memory device context (DC) compatible with the specified device
;
; hdc					Handle to an existing device context					
;
; return				returns the handle to a device context or 0 on failure
;
; notes					If this handle is 0 (by default), the function creates a memory device context compatible with the application's current screen

CreateCompatibleDC(hdc=0)
{
   return DllCall("CreateCompatibleDC", A_PtrSize ? "UPtr" : "UInt", hdc)
}

;#####################################################################################

; Function				SelectObject
; Description			The SelectObject function selects an object into the specified device context (DC). The new object replaces the previous object of the same type
;
; hdc					Handle to a DC
; hgdiobj				A handle to the object to be selected into the DC
;
; return				If the selected object is not a region and the function succeeds, the return value is a handle to the object being replaced
;
; notes					The specified object must have been created by using one of the following functions
;						Bitmap - CreateBitmap, CreateBitmapIndirect, CreateCompatibleBitmap, CreateDIBitmap, CreateDIBSection (A single bitmap cannot be selected into more than one DC at the same time)
;						Brush - CreateBrushIndirect, CreateDIBPatternBrush, CreateDIBPatternBrushPt, CreateHatchBrush, CreatePatternBrush, CreateSolidBrush
;						Font - CreateFont, CreateFontIndirect
;						Pen - CreatePen, CreatePenIndirect
;						Region - CombineRgn, CreateEllipticRgn, CreateEllipticRgnIndirect, CreatePolygonRgn, CreateRectRgn, CreateRectRgnIndirect
;
; notes					If the selected object is a region and the function succeeds, the return value is one of the following value
;
; SIMPLEREGION			= 2 Region consists of a single rectangle
; COMPLEXREGION			= 3 Region consists of more than one rectangle
; NULLREGION			= 1 Region is empty

SelectObject(hdc, hgdiobj)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("SelectObject", Ptr, hdc, Ptr, hgdiobj)
}

;#####################################################################################

; Function				DeleteObject
; Description			This function deletes a logical pen, brush, font, bitmap, region, or palette, freeing all system resources associated with the object
;						After the object is deleted, the specified handle is no longer valid
;
; hObject				Handle to a logical pen, brush, font, bitmap, region, or palette to delete
;
; return				Nonzero indicates success. Zero indicates that the specified handle is not valid or that the handle is currently selected into a device context

DeleteObject(hObject)
{
   return DllCall("DeleteObject", A_PtrSize ? "UPtr" : "UInt", hObject)
}

;#####################################################################################

; Function				GetDC
; Description			This function retrieves a handle to a display device context (DC) for the client area of the specified window.
;						The display device context can be used in subsequent graphics display interface (GDI) functions to draw in the client area of the window. 
;
; hwnd					Handle to the window whose device context is to be retrieved. If this value is NULL, GetDC retrieves the device context for the entire screen					
;
; return				The handle the device context for the specified window's client area indicates success. NULL indicates failure

GetDC(hwnd=0)
{
	return DllCall("GetDC", A_PtrSize ? "UPtr" : "UInt", hwnd)
}

;#####################################################################################

; DCX_CACHE = 0x2
; DCX_CLIPCHILDREN = 0x8
; DCX_CLIPSIBLINGS = 0x10
; DCX_EXCLUDERGN = 0x40
; DCX_EXCLUDEUPDATE = 0x100
; DCX_INTERSECTRGN = 0x80
; DCX_INTERSECTUPDATE = 0x200
; DCX_LOCKWINDOWUPDATE = 0x400
; DCX_NORECOMPUTE = 0x100000
; DCX_NORESETATTRS = 0x4
; DCX_PARENTCLIP = 0x20
; DCX_VALIDATE = 0x200000
; DCX_WINDOW = 0x1

GetDCEx(hwnd, flags=0, hrgnClip=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
    return DllCall("GetDCEx", Ptr, hwnd, Ptr, hrgnClip, "int", flags)
}

;#####################################################################################

; Function				ReleaseDC
; Description			This function releases a device context (DC), freeing it for use by other applications. The effect of ReleaseDC depends on the type of device context
;
; hdc					Handle to the device context to be released
; hwnd					Handle to the window whose device context is to be released
;
; return				1 = released
;						0 = not released
;
; notes					The application must call the ReleaseDC function for each call to the GetWindowDC function and for each call to the GetDC function that retrieves a common device context
;						An application cannot use the ReleaseDC function to release a device context that was created by calling the CreateDC function; instead, it must use the DeleteDC function. 

ReleaseDC(hdc, hwnd=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("ReleaseDC", Ptr, hwnd, Ptr, hdc)
}

;#####################################################################################

; Function				DeleteDC
; Description			The DeleteDC function deletes the specified device context (DC)
;
; hdc					A handle to the device context
;
; return				If the function succeeds, the return value is nonzero
;
; notes					An application must not delete a DC whose handle was obtained by calling the GetDC function. Instead, it must call the ReleaseDC function to free the DC

DeleteDC(hdc)
{
   return DllCall("DeleteDC", A_PtrSize ? "UPtr" : "UInt", hdc)
}
;#####################################################################################

; Function				Gdip_LibraryVersion
; Description			Get the current library version
;
; return				the library version
;
; notes					This is useful for non compiled programs to ensure that a person doesn't run an old version when testing your scripts

Gdip_LibraryVersion()
{
	return 1.45
}

;#####################################################################################

; Function				Gdip_LibrarySubVersion
; Description			Get the current library sub version
;
; return				the library sub version
;
; notes					This is the sub-version currently maintained by Rseding91
Gdip_LibrarySubVersion()
{
	return 1.47
}

;#####################################################################################

; Function:    			Gdip_BitmapFromBRA
; Description: 			Gets a pointer to a gdi+ bitmap from a BRA file
;
; BRAFromMemIn			The variable for a BRA file read to memory
; File					The name of the file, or its number that you would like (This depends on alternate parameter)
; Alternate				Changes whether the File parameter is the file name or its number
;
; return      			If the function succeeds, the return value is a pointer to a gdi+ bitmap
;						-1 = The BRA variable is empty
;						-2 = The BRA has an incorrect header
;						-3 = The BRA has information missing
;						-4 = Could not find file inside the BRA

Gdip_BitmapFromBRA(ByRef BRAFromMemIn, File, Alternate=0)
{
	Static FName = "ObjRelease"
	
	if !BRAFromMemIn
		return -1
	Loop, Parse, BRAFromMemIn, `n
	{
		if (A_Index = 1)
		{
			StringSplit, Header, A_LoopField, |
			if (Header0 != 4 || Header2 != "BRA!")
				return -2
		}
		else if (A_Index = 2)
		{
			StringSplit, Info, A_LoopField, |
			if (Info0 != 3)
				return -3
		}
		else
			break
	}
	if !Alternate
		StringReplace, File, File, \, \\, All
	RegExMatch(BRAFromMemIn, "mi`n)^" (Alternate ? File "\|.+?\|(\d+)\|(\d+)" : "\d+\|" File "\|(\d+)\|(\d+)") "$", FileInfo)
	if !FileInfo
		return -4
	
	hData := DllCall("GlobalAlloc", "uint", 2, Ptr, FileInfo2, Ptr)
	pData := DllCall("GlobalLock", Ptr, hData, Ptr)
	DllCall("RtlMoveMemory", Ptr, pData, Ptr, &BRAFromMemIn+Info2+FileInfo1, Ptr, FileInfo2)
	DllCall("GlobalUnlock", Ptr, hData)
	DllCall("ole32\CreateStreamOnHGlobal", Ptr, hData, "int", 1, A_PtrSize ? "UPtr*" : "UInt*", pStream)
	DllCall("gdiplus\GdipCreateBitmapFromStream", Ptr, pStream, A_PtrSize ? "UPtr*" : "UInt*", pBitmap)
	If (A_PtrSize)
		%FName%(pStream)
	Else
		DllCall(NumGet(NumGet(1*pStream)+8), "uint", pStream)
	return pBitmap
}

;#####################################################################################

; Function				Gdip_DrawRectangle
; Description			This function uses a pen to draw the outline of a rectangle into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the top left of the rectangle
; y						y-coordinate of the top left of the rectangle
; w						width of the rectanlge
; h						height of the rectangle
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipDrawRectangle", Ptr, pGraphics, Ptr, pPen, "float", x, "float", y, "float", w, "float", h)
}

;#####################################################################################

; Function				Gdip_DrawRoundedRectangle
; Description			This function uses a pen to draw the outline of a rounded rectangle into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the top left of the rounded rectangle
; y						y-coordinate of the top left of the rounded rectangle
; w						width of the rectanlge
; h						height of the rectangle
; r						radius of the rounded corners
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawRoundedRectangle(pGraphics, pPen, x, y, w, h, r)
{
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	E := Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
	Gdip_ResetClip(pGraphics)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_DrawEllipse(pGraphics, pPen, x, y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x, y+h-(2*r), 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_ResetClip(pGraphics)
	return E
}

;#####################################################################################

; Function				Gdip_DrawEllipse
; Description			This function uses a pen to draw the outline of an ellipse into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the top left of the rectangle the ellipse will be drawn into
; y						y-coordinate of the top left of the rectangle the ellipse will be drawn into
; w						width of the ellipse
; h						height of the ellipse
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawEllipse(pGraphics, pPen, x, y, w, h)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipDrawEllipse", Ptr, pGraphics, Ptr, pPen, "float", x, "float", y, "float", w, "float", h)
}

;#####################################################################################

; Function				Gdip_DrawBezier
; Description			This function uses a pen to draw the outline of a bezier (a weighted curve) into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x1					x-coordinate of the start of the bezier
; y1					y-coordinate of the start of the bezier
; x2					x-coordinate of the first arc of the bezier
; y2					y-coordinate of the first arc of the bezier
; x3					x-coordinate of the second arc of the bezier
; y3					y-coordinate of the second arc of the bezier
; x4					x-coordinate of the end of the bezier
; y4					y-coordinate of the end of the bezier
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawBezier(pGraphics, pPen, x1, y1, x2, y2, x3, y3, x4, y4)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipDrawBezier"
					, Ptr, pgraphics
					, Ptr, pPen
					, "float", x1
					, "float", y1
					, "float", x2
					, "float", y2
					, "float", x3
					, "float", y3
					, "float", x4
					, "float", y4)
}

;#####################################################################################

; Function				Gdip_DrawArc
; Description			This function uses a pen to draw the outline of an arc into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the start of the arc
; y						y-coordinate of the start of the arc
; w						width of the arc
; h						height of the arc
; StartAngle			specifies the angle between the x-axis and the starting point of the arc
; SweepAngle			specifies the angle between the starting and ending points of the arc
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawArc(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipDrawArc"
					, Ptr, pGraphics
					, Ptr, pPen
					, "float", x
					, "float", y
					, "float", w
					, "float", h
					, "float", StartAngle
					, "float", SweepAngle)
}

;#####################################################################################

; Function				Gdip_DrawPie
; Description			This function uses a pen to draw the outline of a pie into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the start of the pie
; y						y-coordinate of the start of the pie
; w						width of the pie
; h						height of the pie
; StartAngle			specifies the angle between the x-axis and the starting point of the pie
; SweepAngle			specifies the angle between the starting and ending points of the pie
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawPie(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipDrawPie", Ptr, pGraphics, Ptr, pPen, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}

;#####################################################################################

; Function				Gdip_DrawLine
; Description			This function uses a pen to draw a line into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x1					x-coordinate of the start of the line
; y1					y-coordinate of the start of the line
; x2					x-coordinate of the end of the line
; y2					y-coordinate of the end of the line
;
; return				status enumeration. 0 = success		

Gdip_DrawLine(pGraphics, pPen, x1, y1, x2, y2)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipDrawLine"
					, Ptr, pGraphics
					, Ptr, pPen
					, "float", x1
					, "float", y1
					, "float", x2
					, "float", y2)
}

;#####################################################################################

; Function				Gdip_DrawLines
; Description			This function uses a pen to draw a series of joined lines into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; Points				the coordinates of all the points passed as x1,y1|x2,y2|x3,y3.....
;
; return				status enumeration. 0 = success				

Gdip_DrawLines(pGraphics, pPen, Points)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)   
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
	}
	return DllCall("gdiplus\GdipDrawLines", Ptr, pGraphics, Ptr, pPen, Ptr, &PointF, "int", Points0)
}

;#####################################################################################

; Function				Gdip_FillRectangle
; Description			This function uses a brush to fill a rectangle in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the rectangle
; y						y-coordinate of the top left of the rectangle
; w						width of the rectanlge
; h						height of the rectangle
;
; return				status enumeration. 0 = success

Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipFillRectangle"
					, Ptr, pGraphics
					, Ptr, pBrush
					, "float", x
					, "float", y
					, "float", w
					, "float", h)
}

;#####################################################################################

; Function				Gdip_FillRoundedRectangle
; Description			This function uses a brush to fill a rounded rectangle in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the rounded rectangle
; y						y-coordinate of the top left of the rounded rectangle
; w						width of the rectanlge
; h						height of the rectangle
; r						radius of the rounded corners
;
; return				status enumeration. 0 = success

Gdip_FillRoundedRectangle(pGraphics, pBrush, x, y, w, h, r)
{
	Region := Gdip_GetClipRegion(pGraphics)
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	E := Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_FillEllipse(pGraphics, pBrush, x, y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x, y+h-(2*r), 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_DeleteRegion(Region)
	return E
}

;#####################################################################################

; Function				Gdip_FillPolygon
; Description			This function uses a brush to fill a polygon in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; Points				the coordinates of all the points passed as x1,y1|x2,y2|x3,y3.....
;
; return				status enumeration. 0 = success
;
; notes					Alternate will fill the polygon as a whole, wheras winding will fill each new "segment"
; Alternate 			= 0
; Winding 				= 1

Gdip_FillPolygon(pGraphics, pBrush, Points, FillMode=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)   
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
	}   
	return DllCall("gdiplus\GdipFillPolygon", Ptr, pGraphics, Ptr, pBrush, Ptr, &PointF, "int", Points0, "int", FillMode)
}

;#####################################################################################

; Function				Gdip_FillPie
; Description			This function uses a brush to fill a pie in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the pie
; y						y-coordinate of the top left of the pie
; w						width of the pie
; h						height of the pie
; StartAngle			specifies the angle between the x-axis and the starting point of the pie
; SweepAngle			specifies the angle between the starting and ending points of the pie
;
; return				status enumeration. 0 = success

Gdip_FillPie(pGraphics, pBrush, x, y, w, h, StartAngle, SweepAngle)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipFillPie"
					, Ptr, pGraphics
					, Ptr, pBrush
					, "float", x
					, "float", y
					, "float", w
					, "float", h
					, "float", StartAngle
					, "float", SweepAngle)
}

;#####################################################################################

; Function				Gdip_FillEllipse
; Description			This function uses a brush to fill an ellipse in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the ellipse
; y						y-coordinate of the top left of the ellipse
; w						width of the ellipse
; h						height of the ellipse
;
; return				status enumeration. 0 = success

Gdip_FillEllipse(pGraphics, pBrush, x, y, w, h)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipFillEllipse", Ptr, pGraphics, Ptr, pBrush, "float", x, "float", y, "float", w, "float", h)
}

;#####################################################################################

; Function				Gdip_FillRegion
; Description			This function uses a brush to fill a region in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; Region				Pointer to a Region
;
; return				status enumeration. 0 = success
;
; notes					You can create a region Gdip_CreateRegion() and then add to this

Gdip_FillRegion(pGraphics, pBrush, Region)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipFillRegion", Ptr, pGraphics, Ptr, pBrush, Ptr, Region)
}

;#####################################################################################

; Function				Gdip_FillPath
; Description			This function uses a brush to fill a path in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; Region				Pointer to a Path
;
; return				status enumeration. 0 = success

Gdip_FillPath(pGraphics, pBrush, Path)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipFillPath", Ptr, pGraphics, Ptr, pBrush, Ptr, Path)
}

;#####################################################################################

; Function				Gdip_DrawImagePointsRect
; Description			This function draws a bitmap into the Graphics of another bitmap and skews it
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBitmap				Pointer to a bitmap to be drawn
; Points				Points passed as x1,y1|x2,y2|x3,y3 (3 points: top left, top right, bottom left) describing the drawing of the bitmap
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; sw					width of source rectangle
; sh					height of source rectangle
; Matrix				a matrix used to alter image attributes when drawing
;
; return				status enumeration. 0 = success
;
; notes					if sx,sy,sw,sh are missed then the entire source bitmap will be used
;						Matrix can be omitted to just draw with no alteration to ARGB
;						Matrix may be passed as a digit from 0 - 1 to change just transparency
;						Matrix can be passed as a matrix with any delimiter

Gdip_DrawImagePointsRect(pGraphics, pBitmap, Points, sx="", sy="", sw="", sh="", Matrix=1)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)   
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
	}

	if (Matrix&1 = "")
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
		
	if (sx = "" && sy = "" && sw = "" && sh = "")
	{
		sx := 0, sy := 0
		sw := Gdip_GetImageWidth(pBitmap)
		sh := Gdip_GetImageHeight(pBitmap)
	}

	E := DllCall("gdiplus\GdipDrawImagePointsRect"
				, Ptr, pGraphics
				, Ptr, pBitmap
				, Ptr, &PointF
				, "int", Points0
				, "float", sx
				, "float", sy
				, "float", sw
				, "float", sh
				, "int", 2
				, Ptr, ImageAttr
				, Ptr, 0
				, Ptr, 0)
	if ImageAttr
		Gdip_DisposeImageAttributes(ImageAttr)
	return E
}

;#####################################################################################

; Function				Gdip_DrawImage
; Description			This function draws a bitmap into the Graphics of another bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBitmap				Pointer to a bitmap to be drawn
; dx					x-coord of destination upper-left corner
; dy					y-coord of destination upper-left corner
; dw					width of destination image
; dh					height of destination image
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; sw					width of source image
; sh					height of source image
; Matrix				a matrix used to alter image attributes when drawing
;
; return				status enumeration. 0 = success
;
; notes					if sx,sy,sw,sh are missed then the entire source bitmap will be used
;						Gdip_DrawImage performs faster
;						Matrix can be omitted to just draw with no alteration to ARGB
;						Matrix may be passed as a digit from 0 - 1 to change just transparency
;						Matrix can be passed as a matrix with any delimiter. For example:
;						MatrixBright=
;						(
;						1.5		|0		|0		|0		|0
;						0		|1.5	|0		|0		|0
;						0		|0		|1.5	|0		|0
;						0		|0		|0		|1		|0
;						0.05	|0.05	|0.05	|0		|1
;						)
;
; notes					MatrixBright = 1.5|0|0|0|0|0|1.5|0|0|0|0|0|1.5|0|0|0|0|0|1|0|0.05|0.05|0.05|0|1
;						MatrixGreyScale = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1
;						MatrixNegative = -1|0|0|0|0|0|-1|0|0|0|0|0|-1|0|0|0|0|0|1|0|0|0|0|0|1

Gdip_DrawImage(pGraphics, pBitmap, dx="", dy="", dw="", dh="", sx="", sy="", sw="", sh="", Matrix=1)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if (Matrix&1 = "")
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")

	if (sx = "" && sy = "" && sw = "" && sh = "")
	{
		if (dx = "" && dy = "" && dw = "" && dh = "")
		{
			sx := dx := 0, sy := dy := 0
			sw := dw := Gdip_GetImageWidth(pBitmap)
			sh := dh := Gdip_GetImageHeight(pBitmap)
		}
		else
		{
			sx := sy := 0
			sw := Gdip_GetImageWidth(pBitmap)
			sh := Gdip_GetImageHeight(pBitmap)
		}
	}

	E := DllCall("gdiplus\GdipDrawImageRectRect"
				, Ptr, pGraphics
				, Ptr, pBitmap
				, "float", dx
				, "float", dy
				, "float", dw
				, "float", dh
				, "float", sx
				, "float", sy
				, "float", sw
				, "float", sh
				, "int", 2
				, Ptr, ImageAttr
				, Ptr, 0
				, Ptr, 0)
	if ImageAttr
		Gdip_DisposeImageAttributes(ImageAttr)
	return E
}

;#####################################################################################

; Function				Gdip_SetImageAttributesColorMatrix
; Description			This function creates an image matrix ready for drawing
;
; Matrix				a matrix used to alter image attributes when drawing
;						passed with any delimeter
;
; return				returns an image matrix on sucess or 0 if it fails
;
; notes					MatrixBright = 1.5|0|0|0|0|0|1.5|0|0|0|0|0|1.5|0|0|0|0|0|1|0|0.05|0.05|0.05|0|1
;						MatrixGreyScale = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1
;						MatrixNegative = -1|0|0|0|0|0|-1|0|0|0|0|0|-1|0|0|0|0|0|1|0|0|0|0|0|1

Gdip_SetImageAttributesColorMatrix(Matrix)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	VarSetCapacity(ColourMatrix, 100, 0)
	Matrix := RegExReplace(RegExReplace(Matrix, "^[^\d-\.]+([\d\.])", "$1", "", 1), "[^\d-\.]+", "|")
	StringSplit, Matrix, Matrix, |
	Loop, 25
	{
		Matrix := (Matrix%A_Index% != "") ? Matrix%A_Index% : Mod(A_Index-1, 6) ? 0 : 1
		NumPut(Matrix, ColourMatrix, (A_Index-1)*4, "float")
	}
	DllCall("gdiplus\GdipCreateImageAttributes", A_PtrSize ? "UPtr*" : "uint*", ImageAttr)
	DllCall("gdiplus\GdipSetImageAttributesColorMatrix", Ptr, ImageAttr, "int", 1, "int", 1, Ptr, &ColourMatrix, Ptr, 0, "int", 0)
	return ImageAttr
}

;#####################################################################################

; Function				Gdip_GraphicsFromImage
; Description			This function gets the graphics for a bitmap used for drawing functions
;
; pBitmap				Pointer to a bitmap to get the pointer to its graphics
;
; return				returns a pointer to the graphics of a bitmap
;
; notes					a bitmap can be drawn into the graphics of another bitmap

Gdip_GraphicsFromImage(pBitmap)
{
	DllCall("gdiplus\GdipGetImageGraphicsContext", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "UInt*", pGraphics)
	return pGraphics
}

;#####################################################################################

; Function				Gdip_GraphicsFromHDC
; Description			This function gets the graphics from the handle to a device context
;
; hdc					This is the handle to the device context
;
; return				returns a pointer to the graphics of a bitmap
;
; notes					You can draw a bitmap into the graphics of another bitmap

Gdip_GraphicsFromHDC(hdc)
{
    DllCall("gdiplus\GdipCreateFromHDC", A_PtrSize ? "UPtr" : "UInt", hdc, A_PtrSize ? "UPtr*" : "UInt*", pGraphics)
    return pGraphics
}

;#####################################################################################

; Function				Gdip_GetDC
; Description			This function gets the device context of the passed Graphics
;
; hdc					This is the handle to the device context
;
; return				returns the device context for the graphics of a bitmap

Gdip_GetDC(pGraphics)
{
	DllCall("gdiplus\GdipGetDC", A_PtrSize ? "UPtr" : "UInt", pGraphics, A_PtrSize ? "UPtr*" : "UInt*", hdc)
	return hdc
}

;#####################################################################################

; Function				Gdip_ReleaseDC
; Description			This function releases a device context from use for further use
;
; pGraphics				Pointer to the graphics of a bitmap
; hdc					This is the handle to the device context
;
; return				status enumeration. 0 = success

Gdip_ReleaseDC(pGraphics, hdc)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipReleaseDC", Ptr, pGraphics, Ptr, hdc)
}

;#####################################################################################

; Function				Gdip_GraphicsClear
; Description			Clears the graphics of a bitmap ready for further drawing
;
; pGraphics				Pointer to the graphics of a bitmap
; ARGB					The colour to clear the graphics to
;
; return				status enumeration. 0 = success
;
; notes					By default this will make the background invisible
;						Using clipping regions you can clear a particular area on the graphics rather than clearing the entire graphics

Gdip_GraphicsClear(pGraphics, ARGB=0x00ffffff)
{
    return DllCall("gdiplus\GdipGraphicsClear", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", ARGB)
}

;#####################################################################################

; Function				Gdip_BlurBitmap
; Description			Gives a pointer to a blurred bitmap from a pointer to a bitmap
;
; pBitmap				Pointer to a bitmap to be blurred
; Blur					The Amount to blur a bitmap by from 1 (least blur) to 100 (most blur)
;
; return				If the function succeeds, the return value is a pointer to the new blurred bitmap
;						-1 = The blur parameter is outside the range 1-100
;
; notes					This function will not dispose of the original bitmap

Gdip_BlurBitmap(pBitmap, Blur)
{
	if (Blur > 100) || (Blur < 1)
		return -1	
	
	sWidth := Gdip_GetImageWidth(pBitmap), sHeight := Gdip_GetImageHeight(pBitmap)
	dWidth := sWidth//Blur, dHeight := sHeight//Blur

	pBitmap1 := Gdip_CreateBitmap(dWidth, dHeight)
	G1 := Gdip_GraphicsFromImage(pBitmap1)
	Gdip_SetInterpolationMode(G1, 7)
	Gdip_DrawImage(G1, pBitmap, 0, 0, dWidth, dHeight, 0, 0, sWidth, sHeight)

	Gdip_DeleteGraphics(G1)

	pBitmap2 := Gdip_CreateBitmap(sWidth, sHeight)
	G2 := Gdip_GraphicsFromImage(pBitmap2)
	Gdip_SetInterpolationMode(G2, 7)
	Gdip_DrawImage(G2, pBitmap1, 0, 0, sWidth, sHeight, 0, 0, dWidth, dHeight)

	Gdip_DeleteGraphics(G2)
	Gdip_DisposeImage(pBitmap1)
	return pBitmap2
}

;#####################################################################################

; Function:     		Gdip_SaveBitmapToFile
; Description:  		Saves a bitmap to a file in any supported format onto disk
;   
; pBitmap				Pointer to a bitmap
; sOutput      			The name of the file that the bitmap will be saved to. Supported extensions are: .BMP,.DIB,.RLE,.JPG,.JPEG,.JPE,.JFIF,.GIF,.TIF,.TIFF,.PNG
; Quality      			If saving as jpg (.JPG,.JPEG,.JPE,.JFIF) then quality can be 1-100 with default at maximum quality
;
; return      			If the function succeeds, the return value is zero, otherwise:
;						-1 = Extension supplied is not a supported file format
;						-2 = Could not get a list of encoders on system
;						-3 = Could not find matching encoder for specified file format
;						-4 = Could not get WideChar name of output file
;						-5 = Could not save file to disk
;
; notes					This function will use the extension supplied from the sOutput parameter to determine the output format

Gdip_SaveBitmapToFile(pBitmap, sOutput, Quality=75)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	SplitPath, sOutput,,, Extension
	if Extension not in BMP,DIB,RLE,JPG,JPEG,JPE,JFIF,GIF,TIF,TIFF,PNG
		return -1
	Extension := "." Extension

	DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
	VarSetCapacity(ci, nSize)
	DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, Ptr, &ci)
	if !(nCount && nSize)
		return -2
	
	If (A_IsUnicode){
		StrGet_Name := "StrGet"
		Loop, %nCount%
		{
			sString := %StrGet_Name%(NumGet(ci, (idx := (48+7*A_PtrSize)*(A_Index-1))+32+3*A_PtrSize), "UTF-16")
			if !InStr(sString, "*" Extension)
				continue
			
			pCodec := &ci+idx
			break
		}
	} else {
		Loop, %nCount%
		{
			Location := NumGet(ci, 76*(A_Index-1)+44)
			nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
			VarSetCapacity(sString, nSize)
			DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "str", sString, "int", nSize, "uint", 0, "uint", 0)
			if !InStr(sString, "*" Extension)
				continue
			
			pCodec := &ci+76*(A_Index-1)
			break
		}
	}
	
	if !pCodec
		return -3

	if (Quality != 75)
	{
		Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
		if Extension in .JPG,.JPEG,.JPE,.JFIF
		{
			DllCall("gdiplus\GdipGetEncoderParameterListSize", Ptr, pBitmap, Ptr, pCodec, "uint*", nSize)
			VarSetCapacity(EncoderParameters, nSize, 0)
			DllCall("gdiplus\GdipGetEncoderParameterList", Ptr, pBitmap, Ptr, pCodec, "uint", nSize, Ptr, &EncoderParameters)
			Loop, % NumGet(EncoderParameters, "UInt")      ;%
			{
				elem := (24+(A_PtrSize ? A_PtrSize : 4))*(A_Index-1) + 4 + (pad := A_PtrSize = 8 ? 4 : 0)
				if (NumGet(EncoderParameters, elem+16, "UInt") = 1) && (NumGet(EncoderParameters, elem+20, "UInt") = 6)
				{
					p := elem+&EncoderParameters-pad-4
					NumPut(Quality, NumGet(NumPut(4, NumPut(1, p+0)+20, "UInt")), "UInt")
					break
				}
			}      
		}
	}

	if (!A_IsUnicode)
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sOutput, "int", -1, Ptr, 0, "int", 0)
		VarSetCapacity(wOutput, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sOutput, "int", -1, Ptr, &wOutput, "int", nSize)
		VarSetCapacity(wOutput, -1)
		if !VarSetCapacity(wOutput)
			return -4
		E := DllCall("gdiplus\GdipSaveImageToFile", Ptr, pBitmap, Ptr, &wOutput, Ptr, pCodec, "uint", p ? p : 0)
	}
	else
		E := DllCall("gdiplus\GdipSaveImageToFile", Ptr, pBitmap, Ptr, &sOutput, Ptr, pCodec, "uint", p ? p : 0)
	return E ? -5 : 0
}

;#####################################################################################

; Function				Gdip_GetPixel
; Description			Gets the ARGB of a pixel in a bitmap
;
; pBitmap				Pointer to a bitmap
; x						x-coordinate of the pixel
; y						y-coordinate of the pixel
;
; return				Returns the ARGB value of the pixel

Gdip_GetPixel(pBitmap, x, y)
{
	DllCall("gdiplus\GdipBitmapGetPixel", A_PtrSize ? "UPtr" : "UInt", pBitmap, "int", x, "int", y, "uint*", ARGB)
	return ARGB
}

;#####################################################################################

; Function				Gdip_SetPixel
; Description			Sets the ARGB of a pixel in a bitmap
;
; pBitmap				Pointer to a bitmap
; x						x-coordinate of the pixel
; y						y-coordinate of the pixel
;
; return				status enumeration. 0 = success

Gdip_SetPixel(pBitmap, x, y, ARGB)
{
   return DllCall("gdiplus\GdipBitmapSetPixel", A_PtrSize ? "UPtr" : "UInt", pBitmap, "int", x, "int", y, "int", ARGB)
}

;#####################################################################################

; Function				Gdip_GetImageWidth
; Description			Gives the width of a bitmap
;
; pBitmap				Pointer to a bitmap
;
; return				Returns the width in pixels of the supplied bitmap

Gdip_GetImageWidth(pBitmap)
{
   DllCall("gdiplus\GdipGetImageWidth", A_PtrSize ? "UPtr" : "UInt", pBitmap, "uint*", Width)
   return Width
}

;#####################################################################################

; Function				Gdip_GetImageHeight
; Description			Gives the height of a bitmap
;
; pBitmap				Pointer to a bitmap
;
; return				Returns the height in pixels of the supplied bitmap

Gdip_GetImageHeight(pBitmap)
{
   DllCall("gdiplus\GdipGetImageHeight", A_PtrSize ? "UPtr" : "UInt", pBitmap, "uint*", Height)
   return Height
}

;#####################################################################################

; Function				Gdip_GetDimensions
; Description			Gives the width and height of a bitmap
;
; pBitmap				Pointer to a bitmap
; Width					ByRef variable. This variable will be set to the width of the bitmap
; Height				ByRef variable. This variable will be set to the height of the bitmap
;
; return				No return value
;						Gdip_GetDimensions(pBitmap, ThisWidth, ThisHeight) will set ThisWidth to the width and ThisHeight to the height

Gdip_GetImageDimensions(pBitmap, ByRef Width, ByRef Height)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	DllCall("gdiplus\GdipGetImageWidth", Ptr, pBitmap, "uint*", Width)
	DllCall("gdiplus\GdipGetImageHeight", Ptr, pBitmap, "uint*", Height)
}

;#####################################################################################

Gdip_GetDimensions(pBitmap, ByRef Width, ByRef Height)
{
	Gdip_GetImageDimensions(pBitmap, Width, Height)
}

;#####################################################################################

Gdip_GetImagePixelFormat(pBitmap)
{
	DllCall("gdiplus\GdipGetImagePixelFormat", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "UInt*", Format)
	return Format
}

;#####################################################################################

; Function				Gdip_GetDpiX
; Description			Gives the horizontal dots per inch of the graphics of a bitmap
;
; pBitmap				Pointer to a bitmap
; Width					ByRef variable. This variable will be set to the width of the bitmap
; Height				ByRef variable. This variable will be set to the height of the bitmap
;
; return				No return value
;						Gdip_GetDimensions(pBitmap, ThisWidth, ThisHeight) will set ThisWidth to the width and ThisHeight to the height

Gdip_GetDpiX(pGraphics)
{
	DllCall("gdiplus\GdipGetDpiX", A_PtrSize ? "UPtr" : "uint", pGraphics, "float*", dpix)
	return Round(dpix)
}

;#####################################################################################

Gdip_GetDpiY(pGraphics)
{
	DllCall("gdiplus\GdipGetDpiY", A_PtrSize ? "UPtr" : "uint", pGraphics, "float*", dpiy)
	return Round(dpiy)
}

;#####################################################################################

Gdip_GetImageHorizontalResolution(pBitmap)
{
	DllCall("gdiplus\GdipGetImageHorizontalResolution", A_PtrSize ? "UPtr" : "uint", pBitmap, "float*", dpix)
	return Round(dpix)
}

;#####################################################################################

Gdip_GetImageVerticalResolution(pBitmap)
{
	DllCall("gdiplus\GdipGetImageVerticalResolution", A_PtrSize ? "UPtr" : "uint", pBitmap, "float*", dpiy)
	return Round(dpiy)
}

;#####################################################################################

Gdip_BitmapSetResolution(pBitmap, dpix, dpiy)
{
	return DllCall("gdiplus\GdipBitmapSetResolution", A_PtrSize ? "UPtr" : "uint", pBitmap, "float", dpix, "float", dpiy)
}

;#####################################################################################

Gdip_CreateBitmapFromFile(sFile, IconNumber=1, IconSize="")
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	, PtrA := A_PtrSize ? "UPtr*" : "UInt*"
	
	SplitPath, sFile,,, ext
	if ext in exe,dll
	{
		Sizes := IconSize ? IconSize : 256 "|" 128 "|" 64 "|" 48 "|" 32 "|" 16
		BufSize := 16 + (2*(A_PtrSize ? A_PtrSize : 4))
		
		VarSetCapacity(buf, BufSize, 0)
		Loop, Parse, Sizes, |
		{
			DllCall("PrivateExtractIcons", "str", sFile, "int", IconNumber-1, "int", A_LoopField, "int", A_LoopField, PtrA, hIcon, PtrA, 0, "uint", 1, "uint", 0)
			
			if !hIcon
				continue

			if !DllCall("GetIconInfo", Ptr, hIcon, Ptr, &buf)
			{
				DestroyIcon(hIcon)
				continue
			}
			
			hbmMask  := NumGet(buf, 12 + ((A_PtrSize ? A_PtrSize : 4) - 4))
			hbmColor := NumGet(buf, 12 + ((A_PtrSize ? A_PtrSize : 4) - 4) + (A_PtrSize ? A_PtrSize : 4))
			if !(hbmColor && DllCall("GetObject", Ptr, hbmColor, "int", BufSize, Ptr, &buf))
			{
				DestroyIcon(hIcon)
				continue
			}
			break
		}
		if !hIcon
			return -1

		Width := NumGet(buf, 4, "int"), Height := NumGet(buf, 8, "int")
		hbm := CreateDIBSection(Width, -Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
		if !DllCall("DrawIconEx", Ptr, hdc, "int", 0, "int", 0, Ptr, hIcon, "uint", Width, "uint", Height, "uint", 0, Ptr, 0, "uint", 3)
		{
			DestroyIcon(hIcon)
			return -2
		}
		
		VarSetCapacity(dib, 104)
		DllCall("GetObject", Ptr, hbm, "int", A_PtrSize = 8 ? 104 : 84, Ptr, &dib) ; sizeof(DIBSECTION) = 76+2*(A_PtrSize=8?4:0)+2*A_PtrSize
		Stride := NumGet(dib, 12, "Int"), Bits := NumGet(dib, 20 + (A_PtrSize = 8 ? 4 : 0)) ; padding
		DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", Stride, "int", 0x26200A, Ptr, Bits, PtrA, pBitmapOld)
		pBitmap := Gdip_CreateBitmap(Width, Height)
		G := Gdip_GraphicsFromImage(pBitmap)
		, Gdip_DrawImage(G, pBitmapOld, 0, 0, Width, Height, 0, 0, Width, Height)
		SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
		Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmapOld)
		DestroyIcon(hIcon)
	}
	else
	{
		if (!A_IsUnicode)
		{
			VarSetCapacity(wFile, 1024)
			DllCall("kernel32\MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sFile, "int", -1, Ptr, &wFile, "int", 512)
			DllCall("gdiplus\GdipCreateBitmapFromFile", Ptr, &wFile, PtrA, pBitmap)
		}
		else
			DllCall("gdiplus\GdipCreateBitmapFromFile", Ptr, &sFile, PtrA, pBitmap)
	}
	
	return pBitmap
}

;#####################################################################################

Gdip_CreateBitmapFromHBITMAP(hBitmap, Palette=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", Ptr, hBitmap, Ptr, Palette, A_PtrSize ? "UPtr*" : "uint*", pBitmap)
	return pBitmap
}

;#####################################################################################

Gdip_CreateHBITMAPFromBitmap(pBitmap, Background=0xffffffff)
{
	DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "uint*", hbm, "int", Background)
	return hbm
}

;#####################################################################################

Gdip_CreateBitmapFromHICON(hIcon)
{
	DllCall("gdiplus\GdipCreateBitmapFromHICON", A_PtrSize ? "UPtr" : "UInt", hIcon, A_PtrSize ? "UPtr*" : "uint*", pBitmap)
	return pBitmap
}

;#####################################################################################

Gdip_CreateHICONFromBitmap(pBitmap)
{
	DllCall("gdiplus\GdipCreateHICONFromBitmap", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "uint*", hIcon)
	return hIcon
}

;#####################################################################################

Gdip_CreateBitmap(Width, Height, Format=0x26200A)
{
    DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", 0, "int", Format, A_PtrSize ? "UPtr" : "UInt", 0, A_PtrSize ? "UPtr*" : "uint*", pBitmap)
    Return pBitmap
}

;#####################################################################################

Gdip_CreateBitmapFromClipboard()
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if !DllCall("OpenClipboard", Ptr, 0)
		return -1
	if !DllCall("IsClipboardFormatAvailable", "uint", 8)
		return -2
	if !hBitmap := DllCall("GetClipboardData", "uint", 2, Ptr)
		return -3
	if !pBitmap := Gdip_CreateBitmapFromHBITMAP(hBitmap)
		return -4
	if !DllCall("CloseClipboard")
		return -5
	DeleteObject(hBitmap)
	return pBitmap
}

;#####################################################################################

Gdip_SetBitmapToClipboard(pBitmap)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	off1 := A_PtrSize = 8 ? 52 : 44, off2 := A_PtrSize = 8 ? 32 : 24
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	DllCall("GetObject", Ptr, hBitmap, "int", VarSetCapacity(oi, A_PtrSize = 8 ? 104 : 84, 0), Ptr, &oi)
	hdib := DllCall("GlobalAlloc", "uint", 2, Ptr, 40+NumGet(oi, off1, "UInt"), Ptr)
	pdib := DllCall("GlobalLock", Ptr, hdib, Ptr)
	DllCall("RtlMoveMemory", Ptr, pdib, Ptr, &oi+off2, Ptr, 40)
	DllCall("RtlMoveMemory", Ptr, pdib+40, Ptr, NumGet(oi, off2 - (A_PtrSize ? A_PtrSize : 4), Ptr), Ptr, NumGet(oi, off1, "UInt"))
	DllCall("GlobalUnlock", Ptr, hdib)
	DllCall("DeleteObject", Ptr, hBitmap)
	DllCall("OpenClipboard", Ptr, 0)
	DllCall("EmptyClipboard")
	DllCall("SetClipboardData", "uint", 8, Ptr, hdib)
	DllCall("CloseClipboard")
}

;#####################################################################################

Gdip_CloneBitmapArea(pBitmap, x, y, w, h, Format=0x26200A)
{
	DllCall("gdiplus\GdipCloneBitmapArea"
					, "float", x
					, "float", y
					, "float", w
					, "float", h
					, "int", Format
					, A_PtrSize ? "UPtr" : "UInt", pBitmap
					, A_PtrSize ? "UPtr*" : "UInt*", pBitmapDest)
	return pBitmapDest
}

;#####################################################################################
; Create resources
;#####################################################################################

Gdip_CreatePen(ARGB, w)
{
   DllCall("gdiplus\GdipCreatePen1", "UInt", ARGB, "float", w, "int", 2, A_PtrSize ? "UPtr*" : "UInt*", pPen)
   return pPen
}

;#####################################################################################

Gdip_CreatePenFromBrush(pBrush, w)
{
	DllCall("gdiplus\GdipCreatePen2", A_PtrSize ? "UPtr" : "UInt", pBrush, "float", w, "int", 2, A_PtrSize ? "UPtr*" : "UInt*", pPen)
	return pPen
}

;#####################################################################################

Gdip_BrushCreateSolid(ARGB=0xff000000)
{
	DllCall("gdiplus\GdipCreateSolidFill", "UInt", ARGB, A_PtrSize ? "UPtr*" : "UInt*", pBrush)
	return pBrush
}

;#####################################################################################

; HatchStyleHorizontal = 0
; HatchStyleVertical = 1
; HatchStyleForwardDiagonal = 2
; HatchStyleBackwardDiagonal = 3
; HatchStyleCross = 4
; HatchStyleDiagonalCross = 5
; HatchStyle05Percent = 6
; HatchStyle10Percent = 7
; HatchStyle20Percent = 8
; HatchStyle25Percent = 9
; HatchStyle30Percent = 10
; HatchStyle40Percent = 11
; HatchStyle50Percent = 12
; HatchStyle60Percent = 13
; HatchStyle70Percent = 14
; HatchStyle75Percent = 15
; HatchStyle80Percent = 16
; HatchStyle90Percent = 17
; HatchStyleLightDownwardDiagonal = 18
; HatchStyleLightUpwardDiagonal = 19
; HatchStyleDarkDownwardDiagonal = 20
; HatchStyleDarkUpwardDiagonal = 21
; HatchStyleWideDownwardDiagonal = 22
; HatchStyleWideUpwardDiagonal = 23
; HatchStyleLightVertical = 24
; HatchStyleLightHorizontal = 25
; HatchStyleNarrowVertical = 26
; HatchStyleNarrowHorizontal = 27
; HatchStyleDarkVertical = 28
; HatchStyleDarkHorizontal = 29
; HatchStyleDashedDownwardDiagonal = 30
; HatchStyleDashedUpwardDiagonal = 31
; HatchStyleDashedHorizontal = 32
; HatchStyleDashedVertical = 33
; HatchStyleSmallConfetti = 34
; HatchStyleLargeConfetti = 35
; HatchStyleZigZag = 36
; HatchStyleWave = 37
; HatchStyleDiagonalBrick = 38
; HatchStyleHorizontalBrick = 39
; HatchStyleWeave = 40
; HatchStylePlaid = 41
; HatchStyleDivot = 42
; HatchStyleDottedGrid = 43
; HatchStyleDottedDiamond = 44
; HatchStyleShingle = 45
; HatchStyleTrellis = 46
; HatchStyleSphere = 47
; HatchStyleSmallGrid = 48
; HatchStyleSmallCheckerBoard = 49
; HatchStyleLargeCheckerBoard = 50
; HatchStyleOutlinedDiamond = 51
; HatchStyleSolidDiamond = 52
; HatchStyleTotal = 53
Gdip_BrushCreateHatch(ARGBfront, ARGBback, HatchStyle=0)
{
	DllCall("gdiplus\GdipCreateHatchBrush", "int", HatchStyle, "UInt", ARGBfront, "UInt", ARGBback, A_PtrSize ? "UPtr*" : "UInt*", pBrush)
	return pBrush
}

;#####################################################################################

Gdip_CreateTextureBrush(pBitmap, WrapMode=1, x=0, y=0, w="", h="")
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	, PtrA := A_PtrSize ? "UPtr*" : "UInt*"
	
	if !(w && h)
		DllCall("gdiplus\GdipCreateTexture", Ptr, pBitmap, "int", WrapMode, PtrA, pBrush)
	else
		DllCall("gdiplus\GdipCreateTexture2", Ptr, pBitmap, "int", WrapMode, "float", x, "float", y, "float", w, "float", h, PtrA, pBrush)
	return pBrush
}

;#####################################################################################

; WrapModeTile = 0
; WrapModeTileFlipX = 1
; WrapModeTileFlipY = 2
; WrapModeTileFlipXY = 3
; WrapModeClamp = 4
Gdip_CreateLineBrush(x1, y1, x2, y2, ARGB1, ARGB2, WrapMode=1)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	CreatePointF(PointF1, x1, y1), CreatePointF(PointF2, x2, y2)
	DllCall("gdiplus\GdipCreateLineBrush", Ptr, &PointF1, Ptr, &PointF2, "Uint", ARGB1, "Uint", ARGB2, "int", WrapMode, A_PtrSize ? "UPtr*" : "UInt*", LGpBrush)
	return LGpBrush
}

;#####################################################################################

; LinearGradientModeHorizontal = 0
; LinearGradientModeVertical = 1
; LinearGradientModeForwardDiagonal = 2
; LinearGradientModeBackwardDiagonal = 3
Gdip_CreateLineBrushFromRect(x, y, w, h, ARGB1, ARGB2, LinearGradientMode=1, WrapMode=1)
{
	CreateRectF(RectF, x, y, w, h)
	DllCall("gdiplus\GdipCreateLineBrushFromRect", A_PtrSize ? "UPtr" : "UInt", &RectF, "int", ARGB1, "int", ARGB2, "int", LinearGradientMode, "int", WrapMode, A_PtrSize ? "UPtr*" : "UInt*", LGpBrush)
	return LGpBrush
}

;#####################################################################################

Gdip_CloneBrush(pBrush)
{
	DllCall("gdiplus\GdipCloneBrush", A_PtrSize ? "UPtr" : "UInt", pBrush, A_PtrSize ? "UPtr*" : "UInt*", pBrushClone)
	return pBrushClone
}

;#####################################################################################
; Delete resources
;#####################################################################################

Gdip_DeletePen(pPen)
{
   return DllCall("gdiplus\GdipDeletePen", A_PtrSize ? "UPtr" : "UInt", pPen)
}

;#####################################################################################

Gdip_DeleteBrush(pBrush)
{
   return DllCall("gdiplus\GdipDeleteBrush", A_PtrSize ? "UPtr" : "UInt", pBrush)
}

;#####################################################################################

Gdip_DisposeImage(pBitmap)
{
   return DllCall("gdiplus\GdipDisposeImage", A_PtrSize ? "UPtr" : "UInt", pBitmap)
}

;#####################################################################################

Gdip_DeleteGraphics(pGraphics)
{
   return DllCall("gdiplus\GdipDeleteGraphics", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}

;#####################################################################################

Gdip_DisposeImageAttributes(ImageAttr)
{
	return DllCall("gdiplus\GdipDisposeImageAttributes", A_PtrSize ? "UPtr" : "UInt", ImageAttr)
}

;#####################################################################################

Gdip_DeleteFont(hFont)
{
   return DllCall("gdiplus\GdipDeleteFont", A_PtrSize ? "UPtr" : "UInt", hFont)
}

;#####################################################################################

Gdip_DeleteStringFormat(hFormat)
{
   return DllCall("gdiplus\GdipDeleteStringFormat", A_PtrSize ? "UPtr" : "UInt", hFormat)
}

;#####################################################################################

Gdip_DeleteFontFamily(hFamily)
{
   return DllCall("gdiplus\GdipDeleteFontFamily", A_PtrSize ? "UPtr" : "UInt", hFamily)
}

;#####################################################################################

Gdip_DeleteMatrix(Matrix)
{
   return DllCall("gdiplus\GdipDeleteMatrix", A_PtrSize ? "UPtr" : "UInt", Matrix)
}

;#####################################################################################
; Text functions
;#####################################################################################

Gdip_TextToGraphics(pGraphics, Text, Options, Font="Arial", Width="", Height="", Measure=0)
{
	IWidth := Width, IHeight:= Height
	
	RegExMatch(Options, "i)X([\-\d\.]+)(p*)", xpos)
	RegExMatch(Options, "i)Y([\-\d\.]+)(p*)", ypos)
	RegExMatch(Options, "i)W([\-\d\.]+)(p*)", Width)
	RegExMatch(Options, "i)H([\-\d\.]+)(p*)", Height)
	RegExMatch(Options, "i)C(?!(entre|enter))([a-f\d]+)", Colour)
	RegExMatch(Options, "i)Top|Up|Bottom|Down|vCentre|vCenter", vPos)
	RegExMatch(Options, "i)NoWrap", NoWrap)
	RegExMatch(Options, "i)R(\d)", Rendering)
	RegExMatch(Options, "i)S(\d+)(p*)", Size)

	if !Gdip_DeleteBrush(Gdip_CloneBrush(Colour2))
		PassBrush := 1, pBrush := Colour2
	
	if !(IWidth && IHeight) && (xpos2 || ypos2 || Width2 || Height2 || Size2)
		return -1

	Style := 0, Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
	Loop, Parse, Styles, |
	{
		if RegExMatch(Options, "\b" A_loopField)
		Style |= (A_LoopField != "StrikeOut") ? (A_Index-1) : 8
	}
  
	Align := 0, Alignments := "Near|Left|Centre|Center|Far|Right"
	Loop, Parse, Alignments, |
	{
		if RegExMatch(Options, "\b" A_loopField)
			Align |= A_Index//2.1      ; 0|0|1|1|2|2
	}

	xpos := (xpos1 != "") ? xpos2 ? IWidth*(xpos1/100) : xpos1 : 0
	ypos := (ypos1 != "") ? ypos2 ? IHeight*(ypos1/100) : ypos1 : 0
	Width := Width1 ? Width2 ? IWidth*(Width1/100) : Width1 : IWidth
	Height := Height1 ? Height2 ? IHeight*(Height1/100) : Height1 : IHeight
	if !PassBrush
		Colour := "0x" (Colour2 ? Colour2 : "ff000000")
	Rendering := ((Rendering1 >= 0) && (Rendering1 <= 5)) ? Rendering1 : 4
	Size := (Size1 > 0) ? Size2 ? IHeight*(Size1/100) : Size1 : 12

	hFamily := Gdip_FontFamilyCreate(Font)
	hFont := Gdip_FontCreate(hFamily, Size, Style)
	FormatStyle := NoWrap ? 0x4000 | 0x1000 : 0x4000
	hFormat := Gdip_StringFormatCreate(FormatStyle)
	pBrush := PassBrush ? pBrush : Gdip_BrushCreateSolid(Colour)
	if !(hFamily && hFont && hFormat && pBrush && pGraphics)
		return !pGraphics ? -2 : !hFamily ? -3 : !hFont ? -4 : !hFormat ? -5 : !pBrush ? -6 : 0
   
	CreateRectF(RC, xpos, ypos, Width, Height)
	Gdip_SetStringFormatAlign(hFormat, Align)
	Gdip_SetTextRenderingHint(pGraphics, Rendering)
	ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)

	if vPos
	{
		StringSplit, ReturnRC, ReturnRC, |
		
		if (vPos = "vCentre") || (vPos = "vCenter")
			ypos += (Height-ReturnRC4)//2
		else if (vPos = "Top") || (vPos = "Up")
			ypos := 0
		else if (vPos = "Bottom") || (vPos = "Down")
			ypos := Height-ReturnRC4
		
		CreateRectF(RC, xpos, ypos, Width, ReturnRC4)
		ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
	}

	if !Measure
		E := Gdip_DrawString(pGraphics, Text, hFont, hFormat, pBrush, RC)

	if !PassBrush
		Gdip_DeleteBrush(pBrush)
	Gdip_DeleteStringFormat(hFormat)   
	Gdip_DeleteFont(hFont)
	Gdip_DeleteFontFamily(hFamily)
	return E ? E : ReturnRC
}

;#####################################################################################

Gdip_DrawString(pGraphics, sString, hFont, hFormat, pBrush, ByRef RectF)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if (!A_IsUnicode)
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, Ptr, 0, "int", 0)
		VarSetCapacity(wString, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, Ptr, &wString, "int", nSize)
	}
	
	return DllCall("gdiplus\GdipDrawString"
					, Ptr, pGraphics
					, Ptr, A_IsUnicode ? &sString : &wString
					, "int", -1
					, Ptr, hFont
					, Ptr, &RectF
					, Ptr, hFormat
					, Ptr, pBrush)
}

;#####################################################################################

Gdip_MeasureString(pGraphics, sString, hFont, hFormat, ByRef RectF)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	VarSetCapacity(RC, 16)
	if !A_IsUnicode
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wString, nSize*2)   
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &sString, "int", -1, Ptr, &wString, "int", nSize)
	}
	
	DllCall("gdiplus\GdipMeasureString"
					, Ptr, pGraphics
					, Ptr, A_IsUnicode ? &sString : &wString
					, "int", -1
					, Ptr, hFont
					, Ptr, &RectF
					, Ptr, hFormat
					, Ptr, &RC
					, "uint*", Chars
					, "uint*", Lines)
	
	return &RC ? NumGet(RC, 0, "float") "|" NumGet(RC, 4, "float") "|" NumGet(RC, 8, "float") "|" NumGet(RC, 12, "float") "|" Chars "|" Lines : 0
}

; Near = 0
; Center = 1
; Far = 2
Gdip_SetStringFormatAlign(hFormat, Align)
{
   return DllCall("gdiplus\GdipSetStringFormatAlign", A_PtrSize ? "UPtr" : "UInt", hFormat, "int", Align)
}

; StringFormatFlagsDirectionRightToLeft    = 0x00000001
; StringFormatFlagsDirectionVertical       = 0x00000002
; StringFormatFlagsNoFitBlackBox           = 0x00000004
; StringFormatFlagsDisplayFormatControl    = 0x00000020
; StringFormatFlagsNoFontFallback          = 0x00000400
; StringFormatFlagsMeasureTrailingSpaces   = 0x00000800
; StringFormatFlagsNoWrap                  = 0x00001000
; StringFormatFlagsLineLimit               = 0x00002000
; StringFormatFlagsNoClip                  = 0x00004000 
Gdip_StringFormatCreate(Format=0, Lang=0)
{
   DllCall("gdiplus\GdipCreateStringFormat", "int", Format, "int", Lang, A_PtrSize ? "UPtr*" : "UInt*", hFormat)
   return hFormat
}

; Regular = 0
; Bold = 1
; Italic = 2
; BoldItalic = 3
; Underline = 4
; Strikeout = 8
Gdip_FontCreate(hFamily, Size, Style=0)
{
   DllCall("gdiplus\GdipCreateFont", A_PtrSize ? "UPtr" : "UInt", hFamily, "float", Size, "int", Style, "int", 0, A_PtrSize ? "UPtr*" : "UInt*", hFont)
   return hFont
}

Gdip_FontFamilyCreate(Font)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if (!A_IsUnicode)
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &Font, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wFont, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, Ptr, &Font, "int", -1, Ptr, &wFont, "int", nSize)
	}
	
	DllCall("gdiplus\GdipCreateFontFamilyFromName"
					, Ptr, A_IsUnicode ? &Font : &wFont
					, "uint", 0
					, A_PtrSize ? "UPtr*" : "UInt*", hFamily)
	
	return hFamily
}

;#####################################################################################
; Matrix functions
;#####################################################################################

Gdip_CreateAffineMatrix(m11, m12, m21, m22, x, y)
{
   DllCall("gdiplus\GdipCreateMatrix2", "float", m11, "float", m12, "float", m21, "float", m22, "float", x, "float", y, A_PtrSize ? "UPtr*" : "UInt*", Matrix)
   return Matrix
}

Gdip_CreateMatrix()
{
   DllCall("gdiplus\GdipCreateMatrix", A_PtrSize ? "UPtr*" : "UInt*", Matrix)
   return Matrix
}

;#####################################################################################
; GraphicsPath functions
;#####################################################################################

; Alternate = 0
; Winding = 1
Gdip_CreatePath(BrushMode=0)
{
	DllCall("gdiplus\GdipCreatePath", "int", BrushMode, A_PtrSize ? "UPtr*" : "UInt*", Path)
	return Path
}

Gdip_AddPathEllipse(Path, x, y, w, h)
{
	return DllCall("gdiplus\GdipAddPathEllipse", A_PtrSize ? "UPtr" : "UInt", Path, "float", x, "float", y, "float", w, "float", h)
}

Gdip_AddPathPolygon(Path, Points)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)   
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
	}   

	return DllCall("gdiplus\GdipAddPathPolygon", Ptr, Path, Ptr, &PointF, "int", Points0)
}

Gdip_DeletePath(Path)
{
	return DllCall("gdiplus\GdipDeletePath", A_PtrSize ? "UPtr" : "UInt", Path)
}

;#####################################################################################
; Quality functions
;#####################################################################################

; SystemDefault = 0
; SingleBitPerPixelGridFit = 1
; SingleBitPerPixel = 2
; AntiAliasGridFit = 3
; AntiAlias = 4
Gdip_SetTextRenderingHint(pGraphics, RenderingHint)
{
	return DllCall("gdiplus\GdipSetTextRenderingHint", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", RenderingHint)
}

; Default = 0
; LowQuality = 1
; HighQuality = 2
; Bilinear = 3
; Bicubic = 4
; NearestNeighbor = 5
; HighQualityBilinear = 6
; HighQualityBicubic = 7
Gdip_SetInterpolationMode(pGraphics, InterpolationMode)
{
   return DllCall("gdiplus\GdipSetInterpolationMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", InterpolationMode)
}

; Default = 0
; HighSpeed = 1
; HighQuality = 2
; None = 3
; AntiAlias = 4
Gdip_SetSmoothingMode(pGraphics, SmoothingMode)
{
   return DllCall("gdiplus\GdipSetSmoothingMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", SmoothingMode)
}

; CompositingModeSourceOver = 0 (blended)
; CompositingModeSourceCopy = 1 (overwrite)
Gdip_SetCompositingMode(pGraphics, CompositingMode=0)
{
   return DllCall("gdiplus\GdipSetCompositingMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", CompositingMode)
}

;#####################################################################################
; Extra functions
;#####################################################################################

Gdip_Startup()
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if !DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("LoadLibrary", "str", "gdiplus")
	VarSetCapacity(si, A_PtrSize = 8 ? 24 : 16, 0), si := Chr(1)
	DllCall("gdiplus\GdiplusStartup", A_PtrSize ? "UPtr*" : "uint*", pToken, Ptr, &si, Ptr, 0)
	return pToken
}

Gdip_Shutdown(pToken)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	DllCall("gdiplus\GdiplusShutdown", Ptr, pToken)
	if hModule := DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("FreeLibrary", Ptr, hModule)
	return 0
}

; Prepend = 0; The new operation is applied before the old operation.
; Append = 1; The new operation is applied after the old operation.
Gdip_RotateWorldTransform(pGraphics, Angle, MatrixOrder=0)
{
	return DllCall("gdiplus\GdipRotateWorldTransform", A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", Angle, "int", MatrixOrder)
}

Gdip_ScaleWorldTransform(pGraphics, x, y, MatrixOrder=0)
{
	return DllCall("gdiplus\GdipScaleWorldTransform", A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}

Gdip_TranslateWorldTransform(pGraphics, x, y, MatrixOrder=0)
{
	return DllCall("gdiplus\GdipTranslateWorldTransform", A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}

Gdip_ResetWorldTransform(pGraphics)
{
	return DllCall("gdiplus\GdipResetWorldTransform", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}

Gdip_GetRotatedTranslation(Width, Height, Angle, ByRef xTranslation, ByRef yTranslation)
{
	pi := 3.14159, TAngle := Angle*(pi/180)	

	Bound := (Angle >= 0) ? Mod(Angle, 360) : 360-Mod(-Angle, -360)
	if ((Bound >= 0) && (Bound <= 90))
		xTranslation := Height*Sin(TAngle), yTranslation := 0
	else if ((Bound > 90) && (Bound <= 180))
		xTranslation := (Height*Sin(TAngle))-(Width*Cos(TAngle)), yTranslation := -Height*Cos(TAngle)
	else if ((Bound > 180) && (Bound <= 270))
		xTranslation := -(Width*Cos(TAngle)), yTranslation := -(Height*Cos(TAngle))-(Width*Sin(TAngle))
	else if ((Bound > 270) && (Bound <= 360))
		xTranslation := 0, yTranslation := -Width*Sin(TAngle)
}

Gdip_GetRotatedDimensions(Width, Height, Angle, ByRef RWidth, ByRef RHeight)
{
	pi := 3.14159, TAngle := Angle*(pi/180)
	if !(Width && Height)
		return -1
	RWidth := Ceil(Abs(Width*Cos(TAngle))+Abs(Height*Sin(TAngle)))
	RHeight := Ceil(Abs(Width*Sin(TAngle))+Abs(Height*Cos(Tangle)))
}

; RotateNoneFlipNone   = 0
; Rotate90FlipNone     = 1
; Rotate180FlipNone    = 2
; Rotate270FlipNone    = 3
; RotateNoneFlipX      = 4
; Rotate90FlipX        = 5
; Rotate180FlipX       = 6
; Rotate270FlipX       = 7
; RotateNoneFlipY      = Rotate180FlipX
; Rotate90FlipY        = Rotate270FlipX
; Rotate180FlipY       = RotateNoneFlipX
; Rotate270FlipY       = Rotate90FlipX
; RotateNoneFlipXY     = Rotate180FlipNone
; Rotate90FlipXY       = Rotate270FlipNone
; Rotate180FlipXY      = RotateNoneFlipNone
; Rotate270FlipXY      = Rotate90FlipNone 

Gdip_ImageRotateFlip(pBitmap, RotateFlipType=1)
{
	return DllCall("gdiplus\GdipImageRotateFlip", A_PtrSize ? "UPtr" : "UInt", pBitmap, "int", RotateFlipType)
}

; Replace = 0
; Intersect = 1
; Union = 2
; Xor = 3
; Exclude = 4
; Complement = 5
Gdip_SetClipRect(pGraphics, x, y, w, h, CombineMode=0)
{
   return DllCall("gdiplus\GdipSetClipRect",  A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", x, "float", y, "float", w, "float", h, "int", CombineMode)
}

Gdip_SetClipPath(pGraphics, Path, CombineMode=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	return DllCall("gdiplus\GdipSetClipPath", Ptr, pGraphics, Ptr, Path, "int", CombineMode)
}

Gdip_ResetClip(pGraphics)
{
   return DllCall("gdiplus\GdipResetClip", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}

Gdip_GetClipRegion(pGraphics)
{
	Region := Gdip_CreateRegion()
	DllCall("gdiplus\GdipGetClip", A_PtrSize ? "UPtr" : "UInt", pGraphics, "UInt*", Region)
	return Region
}

Gdip_SetClipRegion(pGraphics, Region, CombineMode=0)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("gdiplus\GdipSetClipRegion", Ptr, pGraphics, Ptr, Region, "int", CombineMode)
}

Gdip_CreateRegion()
{
	DllCall("gdiplus\GdipCreateRegion", "UInt*", Region)
	return Region
}

Gdip_DeleteRegion(Region)
{
	return DllCall("gdiplus\GdipDeleteRegion", A_PtrSize ? "UPtr" : "UInt", Region)
}

;#####################################################################################
; BitmapLockBits
;#####################################################################################

Gdip_LockBits(pBitmap, x, y, w, h, ByRef Stride, ByRef Scan0, ByRef BitmapData, LockMode = 3, PixelFormat = 0x26200a)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	CreateRect(Rect, x, y, w, h)
	VarSetCapacity(BitmapData, 16+2*(A_PtrSize ? A_PtrSize : 4), 0)
	E := DllCall("Gdiplus\GdipBitmapLockBits", Ptr, pBitmap, Ptr, &Rect, "uint", LockMode, "int", PixelFormat, Ptr, &BitmapData)
	Stride := NumGet(BitmapData, 8, "Int")
	Scan0 := NumGet(BitmapData, 16, Ptr)
	return E
}

;#####################################################################################

Gdip_UnlockBits(pBitmap, ByRef BitmapData)
{
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	return DllCall("Gdiplus\GdipBitmapUnlockBits", Ptr, pBitmap, Ptr, &BitmapData)
}

;#####################################################################################

Gdip_SetLockBitPixel(ARGB, Scan0, x, y, Stride)
{
	Numput(ARGB, Scan0+0, (x*4)+(y*Stride), "UInt")
}

;#####################################################################################

Gdip_GetLockBitPixel(Scan0, x, y, Stride)
{
	return NumGet(Scan0+0, (x*4)+(y*Stride), "UInt")
}

;#####################################################################################

Gdip_PixelateBitmap(pBitmap, ByRef pBitmapOut, BlockSize)
{
	static PixelateBitmap
	
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if (!PixelateBitmap)
	{
		if A_PtrSize != 8 ; x86 machine code
		MCode_PixelateBitmap =
		(LTrim Join
		558BEC83EC3C8B4514538B5D1C99F7FB56578BC88955EC894DD885C90F8E830200008B451099F7FB8365DC008365E000894DC88955F08945E833FF897DD4
		397DE80F8E160100008BCB0FAFCB894DCC33C08945F88945FC89451C8945143BD87E608B45088D50028BC82BCA8BF02BF2418945F48B45E02955F4894DC4
		8D0CB80FAFCB03CA895DD08BD1895DE40FB64416030145140FB60201451C8B45C40FB604100145FC8B45F40FB604020145F883C204FF4DE475D6034D18FF
		4DD075C98B4DCC8B451499F7F98945148B451C99F7F989451C8B45FC99F7F98945FC8B45F899F7F98945F885DB7E648B450C8D50028BC82BCA83C103894D
		C48BC82BCA41894DF48B4DD48945E48B45E02955E48D0C880FAFCB03CA895DD08BD18BF38A45148B7DC48804178A451C8B7DF488028A45FC8804178A45F8
		8B7DE488043A83C2044E75DA034D18FF4DD075CE8B4DCC8B7DD447897DD43B7DE80F8CF2FEFFFF837DF0000F842C01000033C08945F88945FC89451C8945
		148945E43BD87E65837DF0007E578B4DDC034DE48B75E80FAF4D180FAFF38B45088D500203CA8D0CB18BF08BF88945F48B45F02BF22BFA2955F48945CC0F
		B6440E030145140FB60101451C0FB6440F010145FC8B45F40FB604010145F883C104FF4DCC75D8FF45E4395DE47C9B8B4DF00FAFCB85C9740B8B451499F7
		F9894514EB048365140033F63BCE740B8B451C99F7F989451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB
		038975F88975E43BDE7E5A837DF0007E4C8B4DDC034DE48B75E80FAF4D180FAFF38B450C8D500203CA8D0CB18BF08BF82BF22BFA2BC28B55F08955CC8A55
		1488540E038A551C88118A55FC88540F018A55F888140183C104FF4DCC75DFFF45E4395DE47CA68B45180145E0015DDCFF4DC80F8594FDFFFF8B451099F7
		FB8955F08945E885C00F8E450100008B45EC0FAFC38365DC008945D48B45E88945CC33C08945F88945FC89451C8945148945103945EC7E6085DB7E518B4D
		D88B45080FAFCB034D108D50020FAF4D18034DDC8BF08BF88945F403CA2BF22BFA2955F4895DC80FB6440E030145140FB60101451C0FB6440F010145FC8B
		45F40FB604080145F883C104FF4DC875D8FF45108B45103B45EC7CA08B4DD485C9740B8B451499F7F9894514EB048365140033F63BCE740B8B451C99F7F9
		89451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB038975F88975103975EC7E5585DB7E468B4DD88B450C
		0FAFCB034D108D50020FAF4D18034DDC8BF08BF803CA2BF22BFA2BC2895DC88A551488540E038A551C88118A55FC88540F018A55F888140183C104FF4DC8
		75DFFF45108B45103B45EC7CAB8BC3C1E0020145DCFF4DCC0F85CEFEFFFF8B4DEC33C08945F88945FC89451C8945148945103BC87E6C3945F07E5C8B4DD8
		8B75E80FAFCB034D100FAFF30FAF4D188B45088D500203CA8D0CB18BF08BF88945F48B45F02BF22BFA2955F48945C80FB6440E030145140FB60101451C0F
		B6440F010145FC8B45F40FB604010145F883C104FF4DC875D833C0FF45108B4DEC394D107C940FAF4DF03BC874068B451499F7F933F68945143BCE740B8B
		451C99F7F989451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB038975F88975083975EC7E63EB0233F639
		75F07E4F8B4DD88B75E80FAFCB034D080FAFF30FAF4D188B450C8D500203CA8D0CB18BF08BF82BF22BFA2BC28B55F08955108A551488540E038A551C8811
		8A55FC88540F018A55F888140883C104FF4D1075DFFF45088B45083B45EC7C9F5F5E33C05BC9C21800
		)
		else ; x64 machine code
		MCode_PixelateBitmap =
		(LTrim Join
		4489442418488954241048894C24085355565741544155415641574883EC28418BC1448B8C24980000004C8BDA99488BD941F7F9448BD0448BFA8954240C
		448994248800000085C00F8E9D020000418BC04533E4458BF299448924244C8954241041F7F933C9898C24980000008BEA89542404448BE889442408EB05
		4C8B5C24784585ED0F8E1A010000458BF1418BFD48897C2418450FAFF14533D233F633ED4533E44533ED4585C97E5B4C63BC2490000000418D040A410FAF
		C148984C8D441802498BD9498BD04D8BD90FB642010FB64AFF4403E80FB60203E90FB64AFE4883C2044403E003F149FFCB75DE4D03C748FFCB75D0488B7C
		24188B8C24980000004C8B5C2478418BC59941F7FE448BE8418BC49941F7FE448BE08BC59941F7FE8BE88BC69941F7FE8BF04585C97E4048639C24900000
		004103CA4D8BC1410FAFC94863C94A8D541902488BCA498BC144886901448821408869FF408871FE4883C10448FFC875E84803D349FFC875DA8B8C249800
		0000488B5C24704C8B5C24784183C20448FFCF48897C24180F850AFFFFFF8B6C2404448B2424448B6C24084C8B74241085ED0F840A01000033FF33DB4533
		DB4533D24533C04585C97E53488B74247085ED7E42438D0C04418BC50FAF8C2490000000410FAFC18D04814863C8488D5431028BCD0FB642014403D00FB6
		024883C2044403D80FB642FB03D80FB642FA03F848FFC975DE41FFC0453BC17CB28BCD410FAFC985C9740A418BC299F7F98BF0EB0233F685C9740B418BC3
		99F7F9448BD8EB034533DB85C9740A8BC399F7F9448BD0EB034533D285C9740A8BC799F7F9448BC0EB034533C033D24585C97E4D4C8B74247885ED7E3841
		8D0C14418BC50FAF8C2490000000410FAFC18D04814863C84A8D4431028BCD40887001448818448850FF448840FE4883C00448FFC975E8FFC2413BD17CBD
		4C8B7424108B8C2498000000038C2490000000488B5C24704503E149FFCE44892424898C24980000004C897424100F859EFDFFFF448B7C240C448B842480
		000000418BC09941F7F98BE8448BEA89942498000000896C240C85C00F8E3B010000448BAC2488000000418BCF448BF5410FAFC9898C248000000033FF33
		ED33F64533DB4533D24533C04585FF7E524585C97E40418BC5410FAFC14103C00FAF84249000000003C74898488D541802498BD90FB642014403D00FB602
		4883C2044403D80FB642FB03F00FB642FA03E848FFCB75DE488B5C247041FFC0453BC77CAE85C9740B418BC299F7F9448BE0EB034533E485C9740A418BC3
		99F7F98BD8EB0233DB85C9740A8BC699F7F9448BD8EB034533DB85C9740A8BC599F7F9448BD0EB034533D24533C04585FF7E4E488B4C24784585C97E3541
		8BC5410FAFC14103C00FAF84249000000003C74898488D540802498BC144886201881A44885AFF448852FE4883C20448FFC875E941FFC0453BC77CBE8B8C
		2480000000488B5C2470418BC1C1E00203F849FFCE0F85ECFEFFFF448BAC24980000008B6C240C448BA4248800000033FF33DB4533DB4533D24533C04585
		FF7E5A488B7424704585ED7E48418BCC8BC5410FAFC94103C80FAF8C2490000000410FAFC18D04814863C8488D543102418BCD0FB642014403D00FB60248
		83C2044403D80FB642FB03D80FB642FA03F848FFC975DE41FFC0453BC77CAB418BCF410FAFCD85C9740A418BC299F7F98BF0EB0233F685C9740B418BC399
		F7F9448BD8EB034533DB85C9740A8BC399F7F9448BD0EB034533D285C9740A8BC799F7F9448BC0EB034533C033D24585FF7E4E4585ED7E42418BCC8BC541
		0FAFC903CA0FAF8C2490000000410FAFC18D04814863C8488B442478488D440102418BCD40887001448818448850FF448840FE4883C00448FFC975E8FFC2
		413BD77CB233C04883C428415F415E415D415C5F5E5D5BC3
		)
		
		VarSetCapacity(PixelateBitmap, StrLen(MCode_PixelateBitmap)//2)
		Loop % StrLen(MCode_PixelateBitmap)//2		;%
			NumPut("0x" SubStr(MCode_PixelateBitmap, (2*A_Index)-1, 2), PixelateBitmap, A_Index-1, "UChar")
		DllCall("VirtualProtect", Ptr, &PixelateBitmap, Ptr, VarSetCapacity(PixelateBitmap), "uint", 0x40, A_PtrSize ? "UPtr*" : "UInt*", 0)
	}

	Gdip_GetImageDimensions(pBitmap, Width, Height)
	
	if (Width != Gdip_GetImageWidth(pBitmapOut) || Height != Gdip_GetImageHeight(pBitmapOut))
		return -1
	if (BlockSize > Width || BlockSize > Height)
		return -2

	E1 := Gdip_LockBits(pBitmap, 0, 0, Width, Height, Stride1, Scan01, BitmapData1)
	E2 := Gdip_LockBits(pBitmapOut, 0, 0, Width, Height, Stride2, Scan02, BitmapData2)
	if (E1 || E2)
		return -3

	E := DllCall(&PixelateBitmap, Ptr, Scan01, Ptr, Scan02, "int", Width, "int", Height, "int", Stride1, "int", BlockSize)
	
	Gdip_UnlockBits(pBitmap, BitmapData1), Gdip_UnlockBits(pBitmapOut, BitmapData2)
	return 0
}

;#####################################################################################

Gdip_ToARGB(A, R, G, B)
{
	return (A << 24) | (R << 16) | (G << 8) | B
}

;#####################################################################################

Gdip_FromARGB(ARGB, ByRef A, ByRef R, ByRef G, ByRef B)
{
	A := (0xff000000 & ARGB) >> 24
	R := (0x00ff0000 & ARGB) >> 16
	G := (0x0000ff00 & ARGB) >> 8
	B := 0x000000ff & ARGB
}

;#####################################################################################

Gdip_AFromARGB(ARGB)
{
	return (0xff000000 & ARGB) >> 24
}

;#####################################################################################

Gdip_RFromARGB(ARGB)
{
	return (0x00ff0000 & ARGB) >> 16
}

;#####################################################################################

Gdip_GFromARGB(ARGB)
{
	return (0x0000ff00 & ARGB) >> 8
}

;#####################################################################################

Gdip_BFromARGB(ARGB)
{
	return 0x000000ff & ARGB
}

;#####################################################################################

StrGetB(Address, Length=-1, Encoding=0)
{
	; Flexible parameter handling:
	if Length is not integer
	Encoding := Length,  Length := -1

	; Check for obvious errors.
	if (Address+0 < 1024)
		return

	; Ensure 'Encoding' contains a numeric identifier.
	if Encoding = UTF-16
		Encoding = 1200
	else if Encoding = UTF-8
		Encoding = 65001
	else if SubStr(Encoding,1,2)="CP"
		Encoding := SubStr(Encoding,3)

	if !Encoding ; "" or 0
	{
		; No conversion necessary, but we might not want the whole string.
		if (Length == -1)
			Length := DllCall("lstrlen", "uint", Address)
		VarSetCapacity(String, Length)
		DllCall("lstrcpyn", "str", String, "uint", Address, "int", Length + 1)
	}
	else if Encoding = 1200 ; UTF-16
	{
		char_count := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0x400, "uint", Address, "int", Length, "uint", 0, "uint", 0, "uint", 0, "uint", 0)
		VarSetCapacity(String, char_count)
		DllCall("WideCharToMultiByte", "uint", 0, "uint", 0x400, "uint", Address, "int", Length, "str", String, "int", char_count, "uint", 0, "uint", 0)
	}
	else if Encoding is integer
	{
		; Convert from target encoding to UTF-16 then to the active code page.
		char_count := DllCall("MultiByteToWideChar", "uint", Encoding, "uint", 0, "uint", Address, "int", Length, "uint", 0, "int", 0)
		VarSetCapacity(String, char_count * 2)
		char_count := DllCall("MultiByteToWideChar", "uint", Encoding, "uint", 0, "uint", Address, "int", Length, "uint", &String, "int", char_count * 2)
		String := StrGetB(&String, char_count, 1200)
	}
	
	return String
}

;- https://autohotkey.com/boards/viewtopic.php?f=6&t=791&hilit=stdouttovar
; ----------------------------------------------------------------------------------------------------------------------
; Function .....: StdoutToVar_CreateProcess
; Description ..: Runs a command line program and returns its output.
; Parameters ...: sCmd      - Commandline to execute.
; ..............: sEncoding - Encoding used by the target process. Look at StrGet() for possible values.
; ..............: sDir      - Working directory.
; ..............: nExitCode - Process exit code, receive it as a byref parameter.
; Return .......: Command output as a string on success, empty string on error.
; AHK Version ..: AHK_L x32/64 Unicode/ANSI
; Author .......: Sean (http://goo.gl/o3VCO8), modified by nfl and by Cyruz
; License ......: WTFPL - http://www.wtfpl.net/txt/copying/
; Changelog ....: Feb. 20, 2007 - Sean version.
; ..............: Sep. 21, 2011 - nfl version.
; ..............: Nov. 27, 2013 - Cyruz version (code refactored and exit code).
; ..............: Mar. 09, 2014 - Removed input, doesn't seem reliable. Some code improvements.
; ..............: Mar. 16, 2014 - Added encoding parameter as pointed out by lexikos.
; ..............: Jun. 02, 2014 - Corrected exit code error.
; ..............: Nov. 02, 2016 - Fixed blocking behavior due to ReadFile thanks to PeekNamedPipe.
; ----------------------------------------------------------------------------------------------------------------------
StdoutToVar(sCmd, sEncoding:="CP0", sDir:="", ByRef nExitCode:=0) {
    hstdoutrd:=""
	hstdoutwr:=""
	nTot:=""
	nSize:=""
	sOutput:=""
    DllCall( "CreatePipe",           PtrP,hStdOutRd, PtrP,hStdOutWr, Ptr,0, UInt,0 )
    DllCall( "SetHandleInformation", Ptr,hStdOutWr, UInt,1, UInt,1                 )
	

            VarSetCapacity( pi, (A_PtrSize == 4) ? 16 : 24,  0 )
    siSz := VarSetCapacity( si, (A_PtrSize == 4) ? 68 : 104, 0 )
    NumPut( siSz,      si,  0,                          "UInt" )
    NumPut( 0x100,     si,  (A_PtrSize == 4) ? 44 : 60, "UInt" )
    NumPut( hStdOutWr, si,  (A_PtrSize == 4) ? 60 : 88, "Ptr"  )
    NumPut( hStdOutWr, si,  (A_PtrSize == 4) ? 64 : 96, "Ptr"  )

    If ( !DllCall( "CreateProcess", Ptr,0, Ptr,&sCmd, Ptr,0, Ptr,0, Int,True, UInt,0x08000000
                                  , Ptr,0, Ptr,sDir?&sDir:0, Ptr,&si, Ptr,&pi ) )
        Return ""
      , DllCall( "CloseHandle", Ptr,hStdOutWr )
      , DllCall( "CloseHandle", Ptr,hStdOutRd )

    DllCall( "CloseHandle", Ptr,hStdOutWr ) ; The write pipe must be closed before reading the stdout.
    While ( 1 )
    { ; Before reading, we check if the pipe has been written to, so we avoid freezings.
        If ( !DllCall( "PeekNamedPipe", Ptr,hStdOutRd, Ptr,0, UInt,0, Ptr,0, UIntP,nTot, Ptr,0 ) )
            Break
        If ( !nTot )
        { ; If the pipe buffer is empty, sleep and continue checking.
            Sleep, 100
            Continue
        } ; Pipe buffer is not empty, so we can read it.
        VarSetCapacity(sTemp, nTot+1)
        DllCall( "ReadFile", Ptr,hStdOutRd, Ptr,&sTemp, UInt,nTot, PtrP,nSize, Ptr,0 )
        sOutput .= StrGet(&sTemp, nSize, sEncoding)
    }
    
    ; * SKAN has managed the exit code through SetLastError.
    DllCall( "GetExitCodeProcess", Ptr,NumGet(pi,0), UIntP,nExitCode )
    DllCall( "CloseHandle",        Ptr,NumGet(pi,0)                  )
    DllCall( "CloseHandle",        Ptr,NumGet(pi,A_PtrSize)          )
    DllCall( "CloseHandle",        Ptr,hStdOutRd                     )
    Return sOutput
}
;============================================================



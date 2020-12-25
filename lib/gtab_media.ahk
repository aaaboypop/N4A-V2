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
Gui, Add, Button, x312 y29 w80 h20 gdecode_test, Decode Test
Gui, Add, Button, x272 y49 w30 h20 gvid_to_pic_out_folder, ...
Gui, Add, CheckBox, x12 y99 w190 h20 vconvert_enable ggui_update, Convert to Constant Frame Rate
Gui, Add, DropDownList, x212 y99 w60 h20 vconvert_fps r8 ggui_update, 15|23.976||24|25|29.97|30|50|59.94|60|100|120|Custom|Advanced|
Gui, Add, Text, x29 y124 w100 h20 vconvert_custom ggui_update, Custom Frame Rate
Gui, Add, Edit, x212 y124 w60 h20 Number Limit3 vcustom_fps ggui_update, 30
Gui, Add, Edit, x142 y124 w60 h20 Number vcustom_fps_num ggui_update, 30000
Gui, Add, Edit, x212 y124 w60 h20 Number vcustom_fps_den ggui_update, 1001
Gui, Add, Text, x272 y159 w20 h20 vvp_quality_show, 1
Gui, Add, CheckBox, x12 y189 w80 h20 venable_th_mode ggui_update, Thumbnail :
Gui, Add, Edit, x92 y189 w150 h20 vt_fps ggui_update, 1
Gui, Add, DropDownList, x242 y189 w60 h20 vt_fps_mode r8 ggui_update, 1 sec|1 min||10 min|1 hours
Gui, Add, CheckBox, x12 y219 w80 h20 venable_resize ggui_update, Resize :
Gui, Add, Edit, x92 y219 w50 h20 vresize_w ggui_update, 
Gui, Add, Text, x142 y219 w10 h20 vresize_x, x
Gui, Add, Edit, x152 y219 w50 h20 vresize_h ggui_update, 
Gui, Add, DropDownList, x202 y219 w100 h20 r10 vt_scale1 ggui_update, bilinear|bicubic|experimental|neighbor|area|bicublin|gauss|sinc|lanczos|spline||
Gui, Add, Text, x749 y52 w60 h20 right, Output Ext :
Gui, Add, DropDownList, x812 y49 w50 h21 vconfig_ext2 r12 ggui_update, .jpg||.png|.bmp
Gui, Add, button, x12 y519 w150 h20 vb_start2 grun_ffmpeg, Start
Gui, Add, GroupBox, x312 y99 w140 h90 , Deinterlace
Gui, Add, CheckBox, x322 y219 w60 h20 venable_ss ggui_update, Start :
Gui, Add, CheckBox, x322 y249 w60 h20 venable_to ggui_update, End :
Gui, Add, Edit, x382 y219 w110 h20 vtime_ss ggui_update, 00:00:00
Gui, Add, Edit, x382 y249 w110 h20 vtime_to ggui_update, 00:00:00
Gui, Add, CheckBox, x12 y249 w290 h20 venable_decimate ggui_update, Remove Duplicate Frame [Anime Preset 29.970 > 23.976]
Gui, Add, GroupBox, x462 y99 w220 h90 , Video Encoder
Gui, Add, DropDownList, x472 y119 w50 h20 vencoder r12 ggui_update, x264||x265|Raw
Gui, Add, DropDownList, x472 y149 w50 h20 venc_profile r12 ggui_update, Auto||baseline|main|high|high10|high422|high444
Gui, Add, Radio, x542 y119 w60 h20 vcqp_s1 Group Checked ggui_update, CQP :
Gui, Add, Radio, x542 y139 w60 h20 vcrf_s1 ggui_update, CRF :
Gui, Add, Edit, x602 y119 w40 h20 vcqp_value1 ggui_update, 18
Gui, Add, Edit, x602 y139 w40 h20 vcrf_value1 ggui_update, 18
Gui, Add, Text, x542 y162 w40 h20 , Preset:
Gui, Add, DropDownList, x602 y159 w70 h20 venc_preset r12 ggui_update, ultrafast|superfast|veryfast|faster|fast|medium||slow|slower|veryslow|placebo|
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
Gui, Add, Text, x702 y129 w70 h20 , Color Space :
Gui, Add, DropDownList, x802 y129 w70 h20 vc_space r10 Checked ggui_update, Auto||YUV420|YUV422|YUV444
Gui, Add, Text, x702 y149 w70 h20 , Bit depth :
Gui, Add, DropDownList, x802 y149 w70 h20 vc_bit r10 Checked ggui_update, 8 Bit||10 Bit
Gui, Add, Text, x12 y159 w70 h20 , JPG Quality :
Gui, Add, Slider, x92 y159 w180 h20 vvp_quality Range1-31 ggui_update, 1
Gui, Add, GroupBox, x312 y199 w190 h80 , Trim
Gui, Add, GroupBox, x512 y199 w370 h80 , Audio
Gui, Add, button, x322 y129 w120 h40 ggui2 , Anime Deinterlace Filter
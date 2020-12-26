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

	
	if(convert_fps="Custom")
	{
		convert_fps_num := custom_fps*1000
		convert_fps_den := 1000
		GuiControl, Show,convert_custom
		GuiControl, Hide,custom_fps_num
		GuiControl, Hide,custom_fps_den	
		GuiControl, Show,custom_fps
	}
	else if(convert_fps="Advanced")
	{
		convert_fps_num := custom_fps_num
		convert_fps_den := custom_fps_den
		GuiControl, Show,convert_custom
		GuiControl, Show,custom_fps_num
		GuiControl, Show,custom_fps_den	
		GuiControl, Hide,custom_fps
	}
	else
	{
		GuiControl, Hide,convert_custom
		GuiControl, Hide,custom_fps_num
		GuiControl, Hide,custom_fps_den	
		GuiControl, Hide,custom_fps
	}
	
	if(convert_fps=15)
	{
		convert_fps_num := 15000
		convert_fps_den := 1000
	}
	else if(convert_fps=23.976)
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
	
	GuiControl,,vp_quality_show,%vp_quality%
	GuiControl,,noise_level_show,%noise_level%
	
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
	if(model1<>"RIFE")
	{
		gui_d("Modelfi")
	}
	Else
	{
		gui_e("Modelfi")
	}
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
		GuiControl,,config_ext2,|.aac||.ac3|.ogg|.mp3|.wav
	}
	
	if(w2x_mode=1)
	{
		GuiControl,,modelv,% "|" model_list
		GuiControl,Choose,modelv, 5
		GuiControl,Enable,by_size
		GuiControl,Enable,config_ext
		gui_d("J1,J2,J3")
	}
	else
	{
		GuiControl,,modelv, |models-cunet|models-upconv_7_anime_style_art_rgb|models-upconv_7_photo|
		GuiControl,Choose,config_ext, 1
		GuiControl,Choose,modelv, 2
		GuiControl,Disable,by_size
		GuiControl,,by_scale, 1
		gui_e("J1,J2,J3")
	}
	
	SplitPath, config_ext,,, OutExtension
	Gui, Submit, NoHide
}
Return
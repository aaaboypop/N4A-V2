;==== Control ====
GuiControl,,nlv%noise_level%, 1
GuiControl,,log_enable,% log_enable
GuiControl, Hide,mgpu_text
GuiControl, Hide,convert_custom
GuiControl, Hide,custom_fps
GuiControl, Hide,custom_fps_num
GuiControl, Hide,custom_fps_den
GuiControl, ChooseString, config_ext, %config_ext%
GuiControl, ChooseString, model, %model%
GuiControl, ChooseString, sleep_time, %sleep_time%
GuiControl,,skip_exist, %skip_exist%
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
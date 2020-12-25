run_ffmpeg:
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
		msgbox,0x2000, Error, Error No Input
		Return
	}
	
	SplitPath, vp_in_path, in_name_ext, in_dir, in_ext, in_name
	
	while (SubStr(vp_out_path,-1)="\")
	{
		StringTrimRight, vp_out_path, vp_out_path, 1
	}
	
	if(vp_out_path="")
	{
		msgbox,0x2003, Warning, Output Path is Empty`rDo you want to Set Output Path to Input Path `nPress No, If you Don't want output file
		
		IfMsgBox Yes
		{
			vp_out_path := in_dir
			GuiControl,,vp_out_path,%in_dir%
			no_output := 0
		}
		else IfMsgBox No
			no_output := 1
		else
			Return
		
		
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
	
	run_command .= """" A_WorkingDir "\ffmpeg\ffmpeg.exe"""
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
		attribute := "scale=" resize_w ":" resize_h ":flags=" t_scale1
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
		if(encoder="x264")
			run_command5 .= " -c:v libx264"
		if(encoder="x265")
			run_command5 .= " -c:v libx265"	
		If(encoder="Raw")
			run_command5 .= " -c:v rawvideo"	

		if(c_space="YUV420")
		{
			run_command5 .= " -pix_fmt yuv420p"
		}
		else if(c_space="YUV422")
		{
			run_command5 .= " -pix_fmt yuv422p"
		}
		else if(c_space="YUV444")
		{
			run_command5 .= " -pix_fmt yuv444p"
		}
		
		if(enc_profile<>"Auto")
		{
			run_command5 .= " -profile:v " enc_profile
		}
		
		if(c_bit="10 Bit") && (c_space<>"Auto")
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
			run_command5 .= " -codec:a aac -b:a 192k -cutoff 22050 -async 1"
		else if(enable_a_ogg=1)
			run_command5 .= " -codec:a libvorbis -aq 10 -async 1"
		else if(enable_a_mp3=1)
			run_command5 .= " -codec:a libmp3lame -b:a 320k -async 1"
		else if(enable_a_pcm=1)
			run_command5 .= " -codec:a pcm_s16le -async 1"
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
	

	if(no_output<>1)
	{
		run_command6 .= " """ vp_out_path "\"
		
		if(output_pic=1)
		{
			run_command6 .= in_name "\`%06d" config_ext2 """"

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
	}
	else
	{
		run_command6 .= " -f null - & pause"
	}
	run_command .= run_command1 run_command2 run_command3 run_command4 run_command5 run_command6
	gosub,log_console

	RunWait, %comspec% /c "%run_command%",,
	msgbox,0x2000, Media Convert, Finished!
}
Return
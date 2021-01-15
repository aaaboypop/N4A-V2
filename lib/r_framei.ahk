run_starti:
Gosub, gui_update
If (model1 = "CAIN")
{
    if(Use_CPU|UHD_Mode|TTA_Mode)
    {
        MsgBox, 0x10, Error, "CPU Only" , "UHD" , "TTA" now support only RIFE 
        Return
    }
	command = -i "%in_path1%" -o "%out_path1%" -t %config_t_size1% -g %config_gpu_fi% -f %config_ext1%
	run_command = cain-ncnn-vulkan.exe %command%
	run, %comspec% /c cd "%A_WorkingDir%\frame_Interpolation\cain-ncnn" & %run_command%,,
}
else If (model1 = "DAIN")
{
    if(Use_CPU|UHD_Mode|TTA_Mode)
    {
        MsgBox, 0x10, Error, "CPU Only" , "UHD" , "TTA" now support only RIFE 
        Return
    }
	command = -i "%in_path1%" -o "%out_path1%" -t %config_t_size1% -g %config_gpu_fi% -f %config_ext1%
	run_command = dain-ncnn-vulkan.exe %command%
	run, %comspec% /c cd "%A_WorkingDir%\frame_Interpolation\dain-ncnn" & %run_command%,,
}
else
{
    UHD := ""
    TTA := ""
    if(Use_CPU)
        config_gpu_fi := -1
    if(UHD_Mode)
        UHD := "-u "
    if(TTA_Mode)
        TTA := "-x "
	command = -i "%in_path1%" -o "%out_path1%" -m "%config_model%" -g %config_gpu_fi% %UHD% %TTA% -f %config_ext1%
	run_command = rife-ncnn-vulkan.exe %command%
	run, %comspec% /c cd "%A_WorkingDir%\frame_Interpolation\rife-ncnn" & %run_command%,,
}
gosub,log_console
Return
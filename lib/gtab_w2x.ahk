Gui, Tab, Waifu2X
Gui, Add, Text, x22 y29 w80 h20 , Input Folder :
Gui, Add, Edit, x112 y29 w180 h20 vin_path ggui_update, %in_path%
Gui, Add, Text, x22 y49 w80 h20 , Output Folder :
Gui, Add, Edit, x112 y49 w180 h20 vout_path ggui_update, %out_path%
Gui, Add, Radio, x22 y89 w80 h20 Group vby_scale Checked ggui_update, Scale
Gui, Add, Radio, x22 y119 w80 h20 vby_size ggui_update, Specific Size
Gui, Add, Edit, x112 y89 w60 h20 vscale ggui_update, 2
Gui, Add, Edit, x112 y119 w60 h20 vsizew number ggui_update, 1920
Gui, Add, Edit, x182 y119 w60 h20 vsizeh number ggui_update, 1080
Gui, Add, Text, x22 y149 w80 h20 , Batch/Process :
Gui, Add, Edit, x112 y149 w50 h20 vbatch_size ggui_update, 200
Gui, Add, Text, x22 y179 w70 h20 , Noise Level :
Gui, Add, Slider, x112 y179 w180 h20 vnoise_level Range0-3 ggui_update, 3
Gui, Add, Text, x292 y179 w40 h20 vnoise_level_show, %noise_level%
Gui, Add, Text, x22 y209 w40 h20 , Model :
Gui, Add, DropDownList, x112 y209 w180 h21 vmodelv r10 ggui_update, models-cunet||models-upconv_7_anime_style_art_rgb|models-upconv_7_photo|
Gui, Add, Text, x22 y239 w90 h20 , File Extension :
Gui, Add, DropDownList, x112 y239 w50 h21 vconfig_ext r11 ggui_update, .png||.jpg
Gui, Add, Text, x202 y239 w90 h20 , Tile Size :
Gui, Add, Edit, x262 y239 w50 h21 vconfig_t_size ggui_update, 240
Gui, Add, Text, x22 y269 w40 h20 , Mode :
Gui, Add, DropDownList, x112 y269 w50 h21 vwin_mode r6 ggui_update, |Max|Min|Hide||
Gui, Add, Text, x202 y269 w40 h20 , Sleep :
Gui, Add, DropDownList, x262 y269 w50 h21 vsleep_time r10 ggui_update, 10|20|50|100|200|333||500|1000|2000|3000|4000|5000|10000
Gui, Add, CheckBox, x22 y299 w90 h20 vskip_existv Checked ggui_update, Skip Exist File
Gui, Add, GroupBox, x22 y399 w310 h110 , GPU Setting
Gui, Add, CheckBox, x32 y419 w20 h20 venable_process1 checked ggui_update, 
Gui, Add, Text, x52 y419 w60 h20 , Process 1 :
Gui, Add, DropDownList, x112 y419 w50 h21 vconfig_gpu1 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x32 y439 w20 h20 venable_process2 ggui_update, 
Gui, Add, Text, x52 y439 w60 h20 , Process 2 :
Gui, Add, DropDownList, x112 y439 w50 h21 vconfig_gpu2 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x32 y459 w20 h20 venable_process3 ggui_update, 
Gui, Add, Text, x52 y459 w60 h20 , Process 3 :
Gui, Add, DropDownList, x112 y459 w50 h21 vconfig_gpu3 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x32 y479 w20 h20 venable_process4 ggui_update, 
Gui, Add, Text, x52 y479 w60 h20 , Process 4 :
Gui, Add, DropDownList, x112 y479 w50 h21 vconfig_gpu4 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x182 y419 w20 h20 venable_process5 ggui_update, 
Gui, Add, Text, x202 y419 w60 h20 , Process 5 :
Gui, Add, DropDownList, x262 y419 w50 h21 vconfig_gpu5 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x182 y439 w20 h20 venable_process6 ggui_update, 
Gui, Add, Text, x202 y439 w60 h20 , Process 6 :
Gui, Add, DropDownList, x262 y439 w50 h21 vconfig_gpu6 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x182 y459 w20 h20 venable_process7 ggui_update, 
Gui, Add, Text, x202 y459 w60 h20 , Process 7 :
Gui, Add, DropDownList, x262 y459 w50 h21 vconfig_gpu7 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, CheckBox, x182 y479 w20 h20 venable_process8 ggui_update, 
Gui, Add, Text, x202 y479 w60 h20 , Process 8 :
Gui, Add, DropDownList, x262 y479 w50 h21 vconfig_gpu8 r8 ggui_update, 0||1|2|3|4|5|6|7
Gui, Add, GroupBox, x352 y29 w200 h40 , Mode :
Gui, Add, Radio, x382 y42 w50 h20 vw2x_mode galt_guiupdate, Cuda
Gui, Add, Radio, x452 y42 w70 h20 vw2xv_mode Checked galt_guiupdate, Vulkan
Gui, Add, GroupBox, x342 y259 w550 h260 , Status
Gui, Add, Text, x352 y289 w60 h20 , Total Files :
Gui, Add, Text, x442 y289 w70 h20 vf_totalv, -
Gui, Add, Text, x352 y309 w80 h20 , Processing Files :
Gui, Add, Text, x442 y309 w70 h20 vf_ppv, -
Gui, Add, Text, x562 y289 w40 h20 , Speed :
Gui, Add, Text, x612 y289 w60 h20 vtspeed, -
Gui, Add, Text, x682 y289 w50 h20 , fps
Gui, Add, Text, x832 y309 w50 h20 right vs_percenv, 
Gui, Add, Progress, x352 y329 w530 h10 +cGreen Border vp_pro -Theme BackgroundWhite, 0
Gui, Add, Text, x352 y349 w80 h20 , Process 1 :
Gui, Add, Text, x442 y349 w380 h20 vs_file_processv1, -
Gui, Add, Text, x832 y349 w50 h20 vs_process_countv1, -
Gui, Add, Text, x352 y369 w80 h20 , Process 2 :
Gui, Add, Text, x442 y369 w380 h20 vs_file_processv2, -
Gui, Add, Text, x832 y369 w50 h20 vs_process_countv2, -
Gui, Add, Text, x352 y389 w80 h20 , Process 3 :
Gui, Add, Text, x442 y389 w380 h20 vs_file_processv3, -
Gui, Add, Text, x832 y389 w50 h20 vs_process_countv3, -
Gui, Add, Text, x352 y409 w80 h20 , Process 4 :
Gui, Add, Text, x442 y409 w380 h20 vs_file_processv4, -
Gui, Add, Text, x832 y409 w50 h20 vs_process_countv4, -
Gui, Add, Text, x352 y429 w80 h20 , Process 5 :
Gui, Add, Text, x442 y429 w380 h20 vs_file_processv5, -
Gui, Add, Text, x832 y429 w50 h20 vs_process_countv5, -
Gui, Add, Text, x352 y449 w80 h20 , Process 6 :
Gui, Add, Text, x442 y449 w380 h20 vs_file_processv6, -
Gui, Add, Text, x832 y449 w50 h20 vs_process_countv6, -
Gui, Add, Text, x352 y469 w80 h20 , Process 7 :
Gui, Add, Text, x442 y469 w380 h20 vs_file_processv7, -
Gui, Add, Text, x832 y469 w50 h20 vs_process_countv7, -
Gui, Add, Text, x352 y489 w80 h20 , Process 8 :
Gui, Add, Text, x442 y489 w380 h20 vs_file_processv8, -
Gui, Add, Text, x832 y489 w50 h20 vs_process_countv8, -
Gui, Add, Button, x292 y29 w30 h20 gin_folderv, ...
Gui, Add, Button, x292 y49 w30 h20 gout_folderv, ...
Gui, Add, button, x22 y529 w80 h20 vb_startv grun_w2x, Start
Gui, Add, button, x102 y529 w80 h20 vb_stopv grun_stop Disabled, Stop
Gui, Add, button, x262 y529 w70 h20 gsave, Save Setting
Gui, Add, Text, x22 y509 w70 h20 vs_sv, Ready ..
Gui, Add, Text, x22 y329 w70 h20 , Thread :
Gui, Add, Edit, x112 y329 w60 h20 vJ1 ggui_update, 1
Gui, Add, Edit, x182 y329 w60 h20 vJ2 ggui_update, 2
Gui, Add, Edit, x252 y329 w60 h20 vJ3 ggui_update, 2
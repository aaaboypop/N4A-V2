Gui, Tab, Frame Interpolation
Gui, Add, Text, x22 y29 w80 h20 , Input Folder :
Gui, Add, Edit, x112 y29 w180 h20 vin_path1 ggui_update, %in_path1%
Gui, Add, Text, x22 y49 w80 h20 , Output Folder :
Gui, Add, Edit, x112 y49 w180 h20 vout_path1 ggui_update, %out_path1%
Gui, Add, Button, x292 y29 w30 h20 gin_folderi, ...
Gui, Add, Button, x292 y49 w30 h20 gout_folderi, ...
Gui, Add, Text, x22 y209 w80 h20 , Interpolation :
Gui, Add, DropDownList, x112 y209 w180 h21 vmodel1 r10 ggui_update, CAIN|DAIN|RIFE||
Gui, Add, Text, x22 y239 w90 h20 , File Extension :
Gui, Add, DropDownList, x112 y239 w50 h21 vconfig_ext1 r11 ggui_update, png||jpg

Gui, Add, Text, x22 y269 w90 h20 , GPU :
Gui, Add, DropDownList, x112 y269 w50 h21 vconfig_gpu_fi r11 ggui_update, 0||1|2|3|4|5|6|7|8

Gui, Add, Text, x202 y239 w90 h20 , Tile Size :
Gui, Add, Edit, x262 y239 w50 h21 vconfig_t_size1 ggui_update, 512
Gui, Add, button, x22 y329 w80 h20 vb_starti grun_starti, Run
;Gui, Add, button, x102 y329 w80 h20 vb_stopi grun_stop Disabled, Stop
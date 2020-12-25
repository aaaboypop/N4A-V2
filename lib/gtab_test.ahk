Gui, Tab, Test Mode
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
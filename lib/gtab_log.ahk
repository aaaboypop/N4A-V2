Gui, Tab, Console Log
Gui, Add, ListView, x12 y29 w880 h500 gconsole_log, Command
Gui, Add, CheckBox, x12 y534 w100 h20 vlog_enable Checked ggui_update, Enable Log
Gui, Add, Text, x142 y537 w60 h20 , Log Limit :
Gui, Add, Edit, x202 y534 w60 h20 vlog_limit number ggui_update, 26
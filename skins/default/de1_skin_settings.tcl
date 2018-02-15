##############################################################################################################################################################################################################################################################################
# DE1 SETTINGS pages

##############################################################################################################################################################################################################################################################################
# the graphics for each of the main espresso machine modes

add_de1_page "settings_1" "settings_1.png" "default"

if {[de1plus]} {

	add_de1_page "settings_1" "settings_1.png" "default"
	
	if {$::settings(skale_bluetooth_address) == ""} {
		add_de1_page "settings_2a" "settings_2a.png" "default"
		add_de1_page "settings_2b" "settings_2b.png" "default"
	} else {
		add_de1_page "settings_2a" "settings_2a2.png" "default"
		add_de1_page "settings_2b" "settings_2b2.png" "default"
	}
	add_de1_page "settings_2c" "settings_2c.png" "default"

	if {$::settings(settings_profile_type) == "settings_2"} {
		# this happens if you switch to the de1 gui, which then saves the de1 settings default, so we need to reset it to this de1+ default
		set ::settings(settings_profile_type) "settings_2a"
	}
} else {
	set ::settings(settings_profile_type) "settings_2"
	add_de1_page "settings_1" "settings_1.png" "default"
	add_de1_page "settings_2" "settings_2.png" "default"
}

add_de1_page "settings_3" "settings_3.png" "default"
add_de1_page "settings_4" "settings_4.png" "default"

set ::active_settings_tab settings_1

# this is the message page
set ::message_label [add_de1_text "message" 1280 750 -text "" -font Helv_15_bold -fill "#2d3046" -justify "center" -anchor "center" -width 900]
set ::message_button_label [add_de1_text "message" 1280 1090 -text [translate "Quit"] -font Helv_10_bold -fill "#fAfBff" -anchor "center"]
set ::message_button [add_de1_button "message" {say [translate {Quit}] $::settings(sound_button_in);exit} 980 990 1580 1190 ""]

set slider_trough_color #EAEAEA
set chart_background_color #F8F8F8
##############################################################################################################################################################################################################################################################################

if {[de1plus]} { 

	############################
	# puressure controlled shots

	# preinfusing
	add_de1_text "settings_2a settings_2b" 45 755 -text [translate "1: preinfuse"] -font Helv_10_bold -fill "#7f879a" -anchor "nw" -width 600 -justify "left" 
		# pressure profile preinfusion
		add_de1_widget "settings_2a" scale 47 850 {} -from 0 -to 60 -background $::settings(color_stage_1) -borderwidth 1 -showvalue 0  -bigincrement 1 -resolution 1 -length [rescale_x_skin 600] -width [rescale_y_skin 150] -variable ::settings(preinfusion_time) -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -orient horizontal -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 
		add_de1_variable "settings_2a" 47 1000 -text "" -font Helv_8 -fill "#4e85f4" -anchor "nw" -width 600 -justify "left" -textvariable {[canvas_hide_if_zero $::settings(preinfusion_time) [list $::preinfusion_pressure_widget $::preinfusion_pressure_widget_label $::preinfusion_pressure_flow_widget $::preinfusion_pressure_flow_widget_label];  preinfusion_seconds_text $::settings(preinfusion_time)]}

		set ::preinfusion_pressure_widget [add_de1_widget "settings_2a" scale 670 850 {} -from [expr {$::de1(maxpressure) - 1}] -to 0.1 -background $::settings(color_stage_1) -borderwidth 1 -showvalue 0  -bigincrement 1 -resolution .1 -length [rescale_x_skin 475] -width [rescale_y_skin 150] -variable ::settings(preinfusion_stop_pressure) -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 ]
		set ::preinfusion_pressure_widget_label [add_de1_variable "settings_2a" 820 1325 -text "" -font Helv_8 -fill "#4e85f4" -anchor "ne" -width 600 -justify "left" -textvariable {< $::settings(preinfusion_stop_pressure) [translate bar]}]


		set ::preinfusion_pressure_flow_widget [add_de1_widget "settings_2a" scale 47 1115 {} -to $::de1(max_flowrate) -from 0.1 -tickinterval 0  -showvalue 0 -background $::settings(color_stage_1)  -bigincrement 1 -resolution 0.1 -length [rescale_x_skin 600] -width [rescale_y_skin 150] -variable ::settings(preinfusion_flow_rate) -font Helv_15_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -foreground #000000 -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 -orient horizontal ]
		set ::preinfusion_pressure_flow_widget_label [add_de1_variable "settings_2a" 47 1265 -text "" -font Helv_8 -fill "#4e85f4" -anchor "nw" -width 600 -justify "left" -textvariable {[return_flow_measurement $::settings(preinfusion_flow_rate)]}]

		# flow profile preinfusion
		add_de1_widget "settings_2b" scale 47 850 {} -from 0 -to 60 -background $::settings(color_stage_1) -borderwidth 1 -showvalue 0  -bigincrement 1 -resolution 1 -length [rescale_x_skin 600] -width [rescale_y_skin 150] -variable ::settings(preinfusion_time) -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -orient horizontal -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 
		add_de1_variable "settings_2b" 47 1000 -text "" -font Helv_8 -fill "#4e85f4" -anchor "nw" -width 600 -justify "left" -textvariable {[canvas_hide_if_zero $::settings(preinfusion_time) [list $::preinfusion_flow_pressure_guarantee_checkbox  $::preinfusion_flow_widget $::preinfusion_flow_widget_label $::preinfusion_flow_pressure_widget $::preinfusion_flow_pressure_widget_label];  preinfusion_seconds_text $::settings(preinfusion_time)]}
		
	set ::preinfusion_flow_widget [add_de1_widget "settings_2b" scale 670 850 {} -to 0.1 -from $::de1(max_flowrate) -tickinterval 0  -showvalue 0 -background $::settings(color_stage_1)  -bigincrement 1 -resolution 0.1 -length [rescale_x_skin 470] -width [rescale_y_skin 150] -variable ::settings(preinfusion_flow_rate) -font Helv_15_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -foreground #000000 -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 ]
		set ::preinfusion_flow_widget_label [add_de1_variable "settings_2b" 820 1325 -text "" -font Helv_8 -fill "#4e85f4" -anchor "ne" -width 600 -justify "left" -textvariable {[return_flow_measurement $::settings(preinfusion_flow_rate)]}]
		
		set ::preinfusion_flow_pressure_widget [add_de1_widget "settings_2b" scale 47 1115 {} -from 0.1 -to [expr {$::de1(maxpressure) - 1}]  -background $::settings(color_stage_1) -borderwidth 1 -showvalue 0  -bigincrement 1 -resolution .1 -length [rescale_x_skin 600] -width [rescale_y_skin 150] -variable ::settings(preinfusion_stop_pressure) -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 -orient horizontal ]
		set ::preinfusion_flow_pressure_widget_label [add_de1_variable "settings_2b" 47 1265 -text "" -font Helv_8 -fill "#4e85f4" -anchor "nw" -width 600 -justify "left" -textvariable {< $::settings(preinfusion_stop_pressure) [translate bar]}]
	
		set ::preinfusion_flow_pressure_guarantee_checkbox [add_de1_widget "settings_2b" checkbutton 47 1320 { } -command update_de1_explanation_chart_soon -padx 0 -pady 0 -bg #FFFFFF -text [translate "rise"] -indicatoron true -font Helv_10  -anchor nw -foreground #4e85f4 -activeforeground #4e85f4 -variable ::settings(preinfusion_guarantee)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF]

	add_de1_text "settings_2a" 890 755 -text [translate "2: rise and hold"] -font Helv_10_bold -fill "#7f879a" -anchor "nw" -width 600 -justify "left" 
		add_de1_widget "settings_2a" scale 892 850 {} -from 0 -to 60 -background $::settings(color_stage_2) -borderwidth 1 -showvalue 0  -bigincrement 1 -resolution 1 -length [rescale_x_skin 600] -width [rescale_y_skin 150] -variable ::settings(espresso_hold_time) -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -orient horizontal -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 
		add_de1_variable "settings_2 settings_2a" 892 1000 -text "" -font Helv_8 -fill "#4e85f4" -anchor "nw" -width 600 -justify "left" -textvariable {[canvas_hide_if_zero $::settings(espresso_hold_time) [list $::espresso_pressure_widget $::espresso_pressure_widget_label]; seconds_text $::settings(espresso_hold_time)]}

		set ::espresso_pressure_widget [add_de1_widget "settings_2a" scale 1516 850 {} -to 0 -from $::de1(maxpressure) -tickinterval 0  -showvalue 0 -background $::settings(color_stage_2)  -bigincrement 1 -resolution 0.1 -length [rescale_x_skin 470] -width [rescale_y_skin 150] -variable ::settings(espresso_pressure) -font Helv_15_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -foreground #000000 -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0]
		set ::espresso_pressure_widget_label [add_de1_variable "settings_2 settings_2a" 1667 1325 -text "" -font Helv_8 -fill "#4e85f4" -anchor "ne" -width 600 -justify "left" -textvariable {[return_pressure_measurement $::settings(espresso_pressure)]}]
	

	add_de1_text "settings_2 settings_2a" 1730 755 -text [translate "3: decline"] -font Helv_10_bold -fill "#7f879a" -anchor "nw" -width 600 -justify "left" 
		add_de1_widget "settings_2 settings_2a" scale 1730 850 {} -from 0 -to 60 -background $::settings(color_stage_3) -borderwidth 1 -showvalue 0 -bigincrement 1 -resolution 1 -length [rescale_x_skin 605] -width [rescale_y_skin 150] -variable ::settings(espresso_decline_time) -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -orient horizontal -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 
		add_de1_variable "settings_2 settings_2a" 1735 1000 -text "" -font Helv_8 -fill "#4e85f4" -anchor "nw" -width 600 -justify "left" -textvariable {[canvas_hide_if_zero $::settings(espresso_decline_time) [list $::espresso_pressure_decline_widget $::espresso_pressure_decline_widget_label]; seconds_text $::settings(espresso_decline_time)]}
		
		set ::espresso_pressure_decline_widget [add_de1_widget "settings_2a" scale 2360 850 {} -to 0 -from 10 -background $::settings(color_stage_3) -showvalue 0 -borderwidth 1 -bigincrement 1 -resolution 0.1 -length [rescale_x_skin 470]  -width [rescale_y_skin 150] -variable ::settings(pressure_end) -font Helv_15_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 ]
		set ::espresso_pressure_decline_widget_label [add_de1_variable "settings_2 settings_2a" 2510 1325 -text "" -font Helv_8 -fill "#4e85f4" -anchor "ne" -width 600 -justify "left" -textvariable {[return_pressure_measurement $::settings(pressure_end)]}]

	if {$::settings(enable_fahrenheit) == 1} {
		add_de1_button "settings_2a settings_2b" {say [translate {temperature}] $::settings(sound_button_in);vertical_clicker 0.55 0.055 ::settings(espresso_temperature) $::settings(minimum_water_temperature) 100 %x %y %x0 %y0 %x1 %y1} 2404 192 2590 750 ""
	} else {
		add_de1_button "settings_2a settings_2b" {say [translate {temperature}] $::settings(sound_button_in);vertical_clicker .5 .5 ::settings(espresso_temperature) $::settings(minimum_water_temperature) 100 %x %y %x0 %y0 %x1 %y1} 2404 192 2590 750 ""
	}
	add_de1_variable "settings_2a settings_2b" 2470 600 -text "" -font Helv_7 -fill "#4e85f4" -anchor "center" -textvariable {[return_temperature_setting $::settings(espresso_temperature)]}

	############################
	# flow controlled shots

	add_de1_text "settings_2b" 890 755 -text [translate "2: hold"] -font Helv_10_bold -fill "#7f879a" -anchor "nw" -width 600 -justify "left" 
		add_de1_widget "settings_2b" scale 892 850 {} -from 0 -to 60 -background $::settings(color_stage_2) -borderwidth 1 -showvalue 0  -bigincrement 1 -resolution 1 -length [rescale_x_skin 600] -width [rescale_y_skin 150] -variable ::settings(espresso_hold_time) -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -orient horizontal -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 
		add_de1_variable "settings_2b" 892 1000 -text "" -font Helv_8 -fill "#4e85f4" -anchor "nw" -width 600 -justify "left" -textvariable {[canvas_hide_if_zero $::settings(espresso_hold_time) [list $::flow_hold_widget $::flow_hold_widget_label]; seconds_text $::settings(espresso_hold_time)]}

		set ::flow_hold_widget [add_de1_widget "settings_2b" scale 1516 850 {} -to 0 -from 6 -tickinterval 0  -showvalue 0 -background $::settings(color_stage_2)  -bigincrement 1 -resolution 0.1 -length [rescale_x_skin 470] -width [rescale_y_skin 150] -variable ::settings(flow_profile_hold) -font Helv_15_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -foreground #000000 -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 ]
		set ::flow_hold_widget_label [add_de1_variable "settings_2b" 1667 1325 -text "" -font Helv_8 -fill "#4e85f4" -anchor "ne" -width 600 -justify "left" -textvariable {[return_flow_measurement $::settings(flow_profile_hold)]}]

	add_de1_text "settings_2b" 1730 755 -text [translate "3: decline"] -font Helv_10_bold -fill "#7f879a" -anchor "nw" -width 600 -justify "left" 
		add_de1_widget "settings_2b" scale 1730 850 {} -from 0 -to 60 -background $::settings(color_stage_3) -borderwidth 1 -showvalue 0 -bigincrement 1 -resolution 1 -length [rescale_x_skin 600] -width [rescale_y_skin 150] -variable ::settings(espresso_decline_time) -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -orient horizontal -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 
		add_de1_variable "settings_2b" 1735 1000 -text "" -font Helv_8 -fill "#4e85f4" -anchor "nw" -width 600 -justify "left" -textvariable {[canvas_hide_if_zero $::settings(espresso_decline_time) [list $::flow_decline_widget $::flow_decline_widget_label]; seconds_text $::settings(espresso_decline_time)]}
		
		set ::flow_decline_widget [add_de1_widget "settings_2b" scale 2360 850 {} -to 0 -from 6 -background $::settings(color_stage_3) -showvalue 0 -borderwidth 1 -bigincrement 1 -resolution 0.1 -length [rescale_x_skin 470]  -width [rescale_y_skin 150] -variable ::settings(flow_profile_decline) -font Helv_15_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 ]
		set ::flow_decline_widget_label [add_de1_variable "settings_2b" 2510 1325 -text "" -font Helv_8 -fill "#4e85f4" -anchor "ne" -width 600 -justify "left" -textvariable {[return_flow_measurement $::settings(flow_profile_decline)]}]

	add_de1_widget "settings_2b" graph 24 220 { 
		update_de1_explanation_chart;
		$widget element create line_espresso_de1_explanation_chart_flow -xdata espresso_de1_explanation_chart_elapsed_flow -ydata espresso_de1_explanation_chart_flow -symbol circle -label "" -linewidth [rescale_x_skin 5] -color #888888  -smooth quadratic -pixels [rescale_x_skin 30]; 
		$widget axis configure x -color #5a5d75 -tickfont Helv_6 -command graph_seconds_axis_format; 
		$widget axis configure y -color #5a5d75 -tickfont Helv_6 -min 0.0 -max 6.5 -majorticks {0 1 2 3 4 5 6} -title [translate "Flow rate"] -titlefont Helv_10 -titlecolor #5a5d75;
		$widget element create line_espresso_de1_explanation_chart_flow_part1 -xdata espresso_de1_explanation_chart_elapsed_flow_1 -ydata espresso_de1_explanation_chart_flow_1 -symbol circle -label "" -linewidth [rescale_x_skin 50] -color $::settings(color_stage_1)  -smooth quadratic -pixels [rescale_x_skin 30]; 
		$widget element create line_espresso_de1_explanation_chart_flow_part2 -xdata espresso_de1_explanation_chart_elapsed_flow_2 -ydata espresso_de1_explanation_chart_flow_2 -symbol circle -label "" -linewidth [rescale_x_skin 50] -color $::settings(color_stage_2)  -smooth quadratic -pixels [rescale_x_skin 30]; 
		$widget element create line_espresso_de1_explanation_chart_flow_part3 -xdata espresso_de1_explanation_chart_elapsed_flow_3 -ydata espresso_de1_explanation_chart_flow_3 -symbol circle -label "" -linewidth [rescale_x_skin 50] -color $::settings(color_stage_3)  -smooth quadratic -pixels [rescale_x_skin 30]; 

		bind $widget [platform_button_press] { 
			say [translate {refresh chart}] $::settings(sound_button_in); 
			update_de1_explanation_chart
		} 
	} -plotbackground $chart_background_color -width [rescale_x_skin 2375] -height [rescale_y_skin 500] -borderwidth 1 -background #FFFFFF -plotrelief raised

	############################

	# (beta) weight based shot ending, only displayed if a skale is connected
	if {$::settings(skale_bluetooth_address) != ""} {
		add_de1_text "settings_2a settings_2b" 1730 1100 -text [translate "4: stop at weight:"] -font Helv_10_bold -fill "#7f879a" -anchor "nw" -width 800 -justify "center"
		add_de1_widget "settings_2a settings_2b" scale 1730 1175 {} -to 100 -from 0 -background #e4d1c1 -showvalue 0 -borderwidth 1 -bigincrement 1 -resolution 1 -length [rescale_x_skin 546]  -width [rescale_y_skin 150] -variable ::settings(final_desired_shot_weight) -font Helv_15_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 -orient horizontal 
		add_de1_variable "settings_2a settings_2b" 1730 1325 -text "" -font Helv_8 -fill "#4e85f4" -anchor "nw" -width 600 -justify "left" -textvariable {[return_stop_at_weight_measurement $::settings(final_desired_shot_weight)]}
	}

} else {

	add_de1_text "settings_2" 45 755 -text [translate "1: preinfuse"] -font Helv_10_bold -fill "#7f879a" -anchor "nw" -width 600 -justify "left" 
		add_de1_widget "settings_2" scale 47 850 {} -from 0 -to 10 -tickinterval 0  -showvalue 0 -background $::settings(color_stage_1)  -bigincrement 1 -resolution 1 -length [rescale_x_skin 500] -width [rescale_y_skin 150] -variable ::settings(preinfusion_time) -font Helv_15_bold -sliderlength [rescale_x_skin 125] -relief flat -command {update_de1_explanation_chart_soon} -foreground #000000 -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 -orient horizontal 
		add_de1_variable "settings_2" 50 1000 -text "" -font Helv_8 -fill "#4e85f4" -anchor "nw" -width 600 -justify "left" -textvariable {[seconds_text $::settings(preinfusion_time)]}

	add_de1_text "settings_2" 610 755 -text [translate "2: rise and hold"] -font Helv_10_bold -fill "#7f879a" -anchor "nw" -width 600 -justify "left" 
		add_de1_widget "settings_2" scale 790 850 {} -from 5 -to 60 -background $::settings(color_stage_2) -borderwidth 1 -showvalue 0  -bigincrement 1 -resolution 1 -length [rescale_x_skin 740] -width [rescale_y_skin 150] -variable ::settings(espresso_hold_time) -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -orient horizontal -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 
		add_de1_variable "settings_2" 790 1000 -text "" -font Helv_8 -fill "#4e85f4" -anchor "nw" -width 600 -justify "left" -textvariable {[seconds_text $::settings(espresso_hold_time)]}
		add_de1_widget "settings_2" scale 610 850 {} -to 1 -from $::de1(maxpressure) -tickinterval 0  -showvalue 0 -background $::settings(color_stage_2)  -bigincrement 1 -resolution 1 -length [rescale_x_skin 470] -width [rescale_y_skin 150] -variable ::settings(espresso_pressure) -font Helv_15_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -foreground #000000 -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 
		add_de1_variable "settings_2" 610 1325 -text "" -font Helv_8 -fill "#4e85f4" -anchor "nw" -width 600 -justify "left" -textvariable {[return_pressure_measurement $::settings(espresso_pressure)]}

	add_de1_text "settings_2" 1605 755 -text [translate "3: decline"] -font Helv_10_bold -fill "#7f879a" -anchor "nw" -width 600 -justify "left" 
		add_de1_widget "settings_2" scale 1600 850 {} -from 0 -to 60 -background $::settings(color_stage_3) -borderwidth 1 -showvalue 0 -bigincrement 1 -resolution 1 -length [rescale_x_skin 735] -width [rescale_y_skin 150] -variable ::settings(espresso_decline_time) -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -orient horizontal -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 
		add_de1_variable "settings_2" 1605 1000 -text "" -font Helv_8 -fill "#4e85f4" -anchor "nw" -width 600 -justify "left" -textvariable {[canvas_hide_if_zero $::settings(espresso_decline_time) [list $::espresso_pressure_decline_widget $::espresso_pressure_decline_widget_label]; seconds_text $::settings(espresso_decline_time)]}
		
		set ::espresso_pressure_decline_widget [add_de1_widget "settings_2" scale 2360 850 {} -to 0 -from 10 -background $::settings(color_stage_3) -showvalue 0 -borderwidth 1 -bigincrement 1 -resolution 1 -length [rescale_x_skin 470]  -width [rescale_y_skin 150] -variable ::settings(pressure_end) -font Helv_15_bold -sliderlength [rescale_x_skin 125] -relief flat -command update_de1_explanation_chart_soon -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 ]
		set ::espresso_pressure_decline_widget_label [add_de1_variable "settings_2" 2510 1325 -text "" -font Helv_8 -fill "#4e85f4" -anchor "ne" -width 600 -justify "left" -textvariable {[return_pressure_measurement $::settings(pressure_end)]}]
		
	if {$::settings(enable_fahrenheit) == 1} {
		add_de1_button "settings_2" {say [translate {temperature}] $::settings(sound_button_in);vertical_clicker 0.555556 0.555556 ::settings(espresso_temperature) $::settings(minimum_water_temperature) 100 %x %y %x0 %y0 %x1 %y1} 2404 192 2590 750 ""
	} else {
		add_de1_button "settings_2" {say [translate {temperature}] $::settings(sound_button_in);vertical_clicker 1 1 ::settings(espresso_temperature) $::settings(minimum_water_temperature) 100 %x %y %x0 %y0 %x1 %y1} 2404 192 2590 750 ""
	}
	add_de1_variable "settings_2" 2470 600 -text "" -font Helv_7 -fill "#4e85f4" -anchor "center" -textvariable {[return_temperature_setting $::settings(espresso_temperature)]}

}

add_de1_widget "settings_2 settings_2a" graph 24 220 { 
	update_de1_explanation_chart;
	$widget element create line_espresso_de1_explanation_chart_pressure -xdata espresso_de1_explanation_chart_elapsed -ydata espresso_de1_explanation_chart_pressure -symbol circle -label "" -linewidth [rescale_x_skin 5] -color #888888  -smooth quadratic -pixels [rescale_x_skin 30]; 
	$widget axis configure x -color #5a5d75 -tickfont Helv_6 -command graph_seconds_axis_format; 
	$widget axis configure y -color #5a5d75 -tickfont Helv_6 -min 0.0 -max [expr {0.1 + $::de1(maxpressure)}] -stepsize 2 -majorticks {1 3 5 7 9 11} -title [translate "pressure (bar)"] -titlefont Helv_10 -titlecolor #5a5d75;

	$widget element create line_espresso_de1_explanation_chart_pressure_part1 -xdata espresso_de1_explanation_chart_elapsed_1 -ydata espresso_de1_explanation_chart_pressure_1 -symbol circle -label "" -linewidth [rescale_x_skin 50] -color $::settings(color_stage_1)  -smooth quadratic -pixels [rescale_x_skin 30]; 
	$widget element create line_espresso_de1_explanation_chart_pressure_part2 -xdata espresso_de1_explanation_chart_elapsed_2 -ydata espresso_de1_explanation_chart_pressure_2 -symbol circle -label "" -linewidth [rescale_x_skin 50] -color $::settings(color_stage_2)  -smooth quadratic -pixels [rescale_x_skin 30]; 
	$widget element create line_espresso_de1_explanation_chart_pressure_part3 -xdata espresso_de1_explanation_chart_elapsed_3 -ydata espresso_de1_explanation_chart_pressure_3 -symbol circle -label "" -linewidth [rescale_x_skin 50] -color $::settings(color_stage_3)  -smooth quadratic -pixels [rescale_x_skin 30]; 

	bind $widget [platform_button_press] { 
		say [translate {refresh chart}] $::settings(sound_button_in); 
		update_de1_explanation_chart
	} 
} -plotbackground $chart_background_color -width [rescale_x_skin 2375] -height [rescale_y_skin 500] -borderwidth 1 -background #FFFFFF -plotrelief raised


############################


############################
# advanced flow profiling
add_de1_text "settings_2c" 70 230 -text [translate "Steps"] -font Helv_10_bold -fill "#7f879a" -anchor "nw" 
add_de1_text "settings_2c" 984 240 -text [translate "1: Temperature"] -font Helv_9_bold -fill "#7f879a" -anchor "nw" 
add_de1_text "settings_2c" 1600 240 -text [translate "2: Pump"] -font Helv_9_bold -fill "#7f879a" -anchor "nw" 

add_de1_text "settings_2c" 984 830 -text [translate "3: Duration"] -font Helv_9_bold -fill "#7f879a" -anchor "nw" 

#add_de1_variable "settings_2c" 2238 830 -text "" -font Helv_7_bold -fill "#4e85f4" -anchor "center" -textvariable {$::settings(settings_profile_type)}


add_de1_widget "settings_2c" checkbutton 1538 830 {} -text [translate "4: Move on if..."] -padx 0 -pady 0 -indicatoron true  -font Helv_9_bold -anchor nw -foreground #7f879a -activeforeground #7f879a -variable ::current_adv_step(exit_if)  -borderwidth 0  -highlightthickness 0  -command save_current_adv_shot_step -selectcolor #f9f9f9 -activebackground #f9f9f9 -bg #f9f9f9 -relief flat 

add_de1_widget "settings_2c" listbox 70 310 { 
	set ::advanced_shot_steps_widget $widget
	bind $widget <<ListboxSelect>> ::load_advanced_profile_step
	fill_advanced_profile_steps_listbox

} -background #fbfaff -font Helv_9 -bd 0 -height 11 -width 24 -foreground #d3dbf3 -borderwidth 0 -selectborderwidth 0  -relief flat -highlightthickness 0 -selectmode single  -selectbackground #c0c4e1



add_de1_text "settings_2c" 70 1222 -text [translate "Insert a step"] -font Helv_9_bold -fill "#7f879a" -justify "left" -anchor "nw" 
add_de1_widget "settings_2c" entry 70 1282  {
	set ::globals(widget_profile_step_save) $widget
	bind $widget <Return> { say [translate {save}] $::settings(sound_button_in); change_current_adv_shot_step_name; }
	} -width 27 -font Helv_8  -borderwidth 1 -bg #FFFFFF  -foreground #4e85f4 -textvariable ::profile_step_name_to_add


add_de1_button "settings_2c" {say [translate {delete}] $::settings(sound_button_in); delete_current_adv_step} 740 250 920 500
add_de1_button "settings_2c" {say [translate {add}] $::settings(sound_button_in); add_to_current_adv_step} 740 1200 920 1400

add_de1_text "settings_2c" 1070 680 -text [translate "goal"] -font Helv_6 -fill "#7f879a" -anchor "center" -width 400 -justify "center" 
	add_de1_variable "settings_2c" 1070 744 -text "" -font Helv_7_bold -fill "#4e85f4" -anchor "center" -textvariable {[return_temperature_setting [ifexists ::current_adv_step(temperature)]]}
	add_de1_button "settings_2c" {say [translate {temperature}] $::settings(sound_button_in);vertical_clicker .5 .5 ::current_adv_step(temperature) $::settings(minimum_water_temperature) 100 %x %y %x0 %y0 %x1 %y1; save_current_adv_shot_step } 980 310 1150 640 ""

add_de1_text "settings_2c" 1380 680 -text [translate "sensor"] -font Helv_6 -fill "#7f879a" -anchor "center" -width 400 -justify "center" 
	add_de1_button "settings_2c" { say [translate {sensor}] $::settings(sound_button_in); if {[ifexists ::current_adv_step(sensor)] == "water"} {  set ::current_adv_step(sensor) "coffee" } else { set ::current_adv_step(sensor) "water" }; save_current_adv_shot_step } 1200 310 1550 680 ""
	add_de1_variable "settings_2c" 1380 744 -text "" -font Helv_7_bold -fill "#4e85f4" -anchor "center" -textvariable {[translate [ifexists ::current_adv_step(sensor)]]}

add_de1_text "settings_2c" 1710 680 -text [translate "flow"] -font Helv_6 -fill "#7f879a" -anchor "center" -width 400 -justify "center" 
add_de1_text "settings_2c" 2010 680 -text [translate "pressure"] -font Helv_6 -fill "#7f879a" -anchor "center" -width 400 -justify "center" 
	add_de1_button "settings_2c" { say [translate {flow}] $::settings(sound_button_in); set ::current_adv_step(pump) "flow";  vertical_clicker .1 .1 ::current_adv_step(flow) 0 6 %x %y %x0 %y0 %x1 %y1;  save_current_adv_shot_step; } 1580 310 1820 640 ""
	add_de1_button "settings_2c" { say [translate {pressure}] $::settings(sound_button_in);set ::current_adv_step(pump) "pressure"; vertical_clicker .1 .1 ::current_adv_step(pressure) 0 12 %x %y %x0 %y0 %x1 %y1; update_onscreen_variables; save_current_adv_shot_step} 1890 310 2120 640 ""
	
	add_de1_variable "settings_2c" 1710 744 -text "" -font Helv_7_bold -fill "#4e85f4" -anchor "center" -justify "center" -textvariable { [ if {[ifexists ::current_adv_step(pump)] == "flow"} { return [return_flow_measurement $::current_adv_step(flow)] } else { return "-" } ]  }

	add_de1_variable "settings_2c" 2010 744 -text "" -font Helv_7_bold -fill "#4e85f4" -anchor "center" -justify "center" -textvariable {[if {[ifexists ::current_adv_step(pump)] == "pressure"} {return_pressure_measurement $::current_adv_step(pressure)} else { return "-" }] }



add_de1_text "settings_2c" 2345 680 -text [translate "transition"] -font Helv_6 -fill "#7f879a" -anchor "center" -width 400 -justify "center" 
	add_de1_button "settings_2c" {say [translate {boiler}] $::settings(sound_button_in); if {[ifexists ::current_adv_step(transition)] == "fast"} {  set ::current_adv_step(transition) "smooth" } else { set ::current_adv_step(transition) "fast" }; save_current_adv_shot_step } 2200 310 2500 680 ""
	add_de1_variable "settings_2c" 2345 744 -text "" -font Helv_7_bold -fill "#4e85f4" -anchor "center" -textvariable {[translate [ifexists ::current_adv_step(transition)]]}


add_de1_text "settings_2c" 1090 1270 -text [translate "time"] -font Helv_6 -fill "#7f879a" -anchor "center" -width 400 -justify "center" 
	add_de1_button "settings_2c" {say [translate {time}] $::settings(sound_button_in);vertical_clicker 1 1 ::current_adv_step(seconds) 0 250 %x %y %x0 %y0 %x1 %y1; save_current_adv_shot_step } 980 900 1210 1240 ""
	add_de1_variable "settings_2c" 1090 1340 -text "" -font Helv_7_bold -fill "#4e85f4" -anchor "center" -textvariable {[seconds_text [round_to_integer [ifexists ::current_adv_step(seconds)]]]}

add_de1_text "settings_2c" 1360 1270 -text [translate "volume"] -font Helv_6 -fill "#7f879a" -anchor "center" -width 400 -justify "center" 
	add_de1_button "settings_2c" {say [translate {time}] $::settings(sound_button_in);vertical_clicker 1 1 ::current_adv_step(volume) 0 250 %x %y %x0 %y0 %x1 %y1; save_current_adv_shot_step } 1260 900 1500 1240 ""
	add_de1_variable "settings_2c" 1360 1340 -text "" -font Helv_7_bold -fill "#4e85f4" -anchor "center" -textvariable {[return_liquid_measurement [ifexists ::current_adv_step(volume)]]}


add_de1_text "settings_2c" 1654 1240 -text [translate "pressure"] -font Helv_6 -fill "#7f879a" -anchor "center" -width 400 -justify "center" 
add_de1_text "settings_2c" 1654 1270 -text [translate "goes over"] -font Helv_6 -fill "#7f879a" -anchor "center" -width 400 -justify "center" 
	add_de1_variable "settings_2c" 1654 1340 -text "" -font Helv_7_bold -fill "#4e85f4" -anchor "center" -textvariable { [ if {[ifexists ::current_adv_step(exit_if)] == 1 && [ifexists ::current_adv_step(exit_type)] == "pressure_over"} { return_pressure_measurement [ifexists ::current_adv_step(exit_pressure_over) 11] } else  { return "-" } ] }
	add_de1_button "settings_2c" { say [translate {over pressure}] $::settings(sound_button_in); set ::current_adv_step(exit_if) 1; if { [ifexists ::current_adv_step(exit_type)] != "pressure_over" } { set ::current_adv_step(exit_type) "pressure_over" } else { vertical_clicker .1 .1 ::current_adv_step(exit_pressure_over) 0 6 %x %y %x0 %y0 %x1 %y1 }; save_current_adv_shot_step; } 1540 900 1750 1240 ""

add_de1_text "settings_2c" 1890 1240 -text [translate "pressure"] -font Helv_6 -fill "#7f879a" -anchor "center" -width 400 -justify "center" 
add_de1_text "settings_2c" 1890 1270 -text [translate "goes under"] -font Helv_6 -fill "#7f879a" -anchor "center" -width 400 -justify "center" 
	add_de1_variable "settings_2c" 1890 1340 -text "" -font Helv_7_bold -fill "#4e85f4" -anchor "center" -textvariable { [ if {[ifexists ::current_adv_step(exit_if)] == 1 && [ifexists ::current_adv_step(exit_type)] == "pressure_under"} { return_pressure_measurement [ifexists ::current_adv_step(exit_pressure_under) 0] } else  { return "-" } ] }
	add_de1_button "settings_2c" { say [translate {over pressure}] $::settings(sound_button_in); set ::current_adv_step(exit_if) 1; if { [ifexists ::current_adv_step(exit_type)] != "pressure_under" } { set ::current_adv_step(exit_type) "pressure_under" } else { vertical_clicker .1 .1 ::current_adv_step(exit_pressure_under) 0 6 %x %y %x0 %y0 %x1 %y1}; save_current_adv_shot_step; } 1790 900 1990 1240 ""


add_de1_text "settings_2c" 2144 1240 -text [translate "flow"] -font Helv_6 -fill "#7f879a" -anchor "center" -width 400 -justify "center" 
add_de1_text "settings_2c" 2144 1270 -text [translate "goes over"] -font Helv_6 -fill "#7f879a" -anchor "center" -width 400 -justify "center" 
	add_de1_variable "settings_2c" 2144 1340 -text "" -font Helv_7_bold -fill "#4e85f4" -anchor "center" -textvariable { [ if {[ifexists ::current_adv_step(exit_if)] == 1 && [ifexists ::current_adv_step(exit_type)] == "flow_over"} { return_flow_measurement [ifexists ::current_adv_step(exit_flow_over) 6]} else  { return "-" } ] }
	add_de1_button "settings_2c" { say [translate {over pressure}] $::settings(sound_button_in); set ::current_adv_step(exit_if) 1; if {[ifexists ::current_adv_step(exit_type)] != "flow_over" } { set ::current_adv_step(exit_type) "flow_over" } else { vertical_clicker .1 .1 ::current_adv_step(exit_flow_over) 0 6 %x %y %x0 %y0 %x1 %y1}; save_current_adv_shot_step; } 2020 900 2230 1240 ""

add_de1_text "settings_2c" 2394 1240 -text [translate "flow"] -font Helv_6 -fill "#7f879a" -anchor "center" -width 400 -justify "center" 
add_de1_text "settings_2c" 2394 1270 -text [translate "goes under"] -font Helv_6 -fill "#7f879a" -anchor "center" -width 400 -justify "center" 
	add_de1_variable "settings_2c" 2394 1340 -text "" -font Helv_7_bold -fill "#4e85f4" -anchor "center" -textvariable { [ if {[ifexists ::current_adv_step(exit_if)] == 1 && [ifexists ::current_adv_step(exit_type)] == "flow_under"} { return_flow_measurement [ifexists ::current_adv_step(exit_flow_under) 0] } else  { return "-" } ] }
	add_de1_button "settings_2c" { say [translate {over pressure}] $::settings(sound_button_in); set ::current_adv_step(exit_if) 1; if { [ifexists ::current_adv_step(exit_type)] != "flow_under" } { set ::current_adv_step(exit_type) "flow_under" } else { vertical_clicker .1 .1 ::current_adv_step(exit_flow_under) 0 6 %x %y %x0 %y0 %x1 %y1}; save_current_adv_shot_step; } 2270 900 2500 1240 ""



############################

#set ::table_style_preview_image [add_de1_image "settings_3" 1860 310 "[skin_directory_graphics]/icon.jpg"]
set ::table_style_preview_image [add_de1_image "settings_3" 1860 310 ""]



add_de1_widget "settings_3" listbox 1310 305 { 
		set ::globals(tablet_styles_listbox) $widget
		fill_skin_listbox
		bind $::globals(tablet_styles_listbox) <<ListboxSelect>> ::preview_tablet_skin
	} -background #fbfaff -font Helv_10 -bd 0 -height 15 -width 18 -foreground #d3dbf3 -borderwidth 0 -selectborderwidth 0  -relief flat -highlightthickness 0 -selectmode single -selectbackground #c0c4e1


add_de1_widget "settings_1" listbox 50 305 { 
	 	set ::globals(profiles_listbox) $widget
		fill_profiles_listbox
		bind $::globals(profiles_listbox) <<ListboxSelect>> ::preview_profile
	} -background #fbfaff -yscrollcommand {scale_scroll ::profiles_slider} -font Helv_11 -bd 0 -height 15 -width 32 -foreground #d3dbf3 -borderwidth 0 -selectborderwidth 0  -relief flat -highlightthickness 0 -selectmode single  -selectbackground #c0c4e1 

set ::profiles_slider 0

# draw the scrollbar off screen so that it gets resized and moved to the right place on the first draw
set ::profiles_scrollbar [add_de1_widget "settings_1" scale 10000 1 {} -from 0 -to .50 -bigincrement 0.2 -background "#d3dbf3" -borderwidth 1 -showvalue 0 -resolution .01 -length [rescale_x_skin 400] -width [rescale_y_skin 150] -variable ::profiles_slider -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -command {listbox_moveto $::globals(profiles_listbox) $::profiles_slider}  -foreground #FFFFFF -troughcolor "#f7f6fa" -borderwidth 0  -highlightthickness 0]

proc set_profiles_scrollbar_dimensions {} {
	# set the height of the scrollbar to be the same as the listbox
	$::profiles_scrollbar configure -length [winfo height $::globals(profiles_listbox)]
	set coords [.can coords $::globals(profiles_listbox) ]
	set newx [expr {[winfo width $::globals(profiles_listbox)] + [lindex $coords 0]}]
	.can coords $::profiles_scrollbar "$newx [lindex $coords 1]"
}



add_de1_widget "settings_1" graph 1330 300 { 
		set ::preview_graph_pressure $widget
		update_de1_explanation_chart;
		$::preview_graph_pressure element create line_espresso_de1_explanation_chart_pressure -xdata espresso_de1_explanation_chart_elapsed -ydata espresso_de1_explanation_chart_pressure -symbol circle -label "" -linewidth [rescale_x_skin 10] -color #4e85f4  -smooth quadratic -pixels [rescale_x_skin 20]; 
		$::preview_graph_pressure axis configure x -color #5a5d75 -tickfont Helv_6 ; 
		$::preview_graph_pressure axis configure y -color #5a5d75 -tickfont Helv_6 -min 0.0 -max 11.5 -stepsize 2 -majorticks {1 3 5 7 9 11} -title [translate "pressure (bar)"] -titlefont Helv_8 -titlecolor #5a5d75;
		bind $::preview_graph_pressure [platform_button_press] { after 500 update_de1_explanation_chart; say [translate {settings}] $::settings(sound_button_in); set_next_page off $::settings(settings_profile_type); page_show off 	} 
	} -plotbackground $chart_background_color -width [rescale_x_skin 1050] -height [rescale_y_skin 450] -borderwidth 1 -background #FFFFFF -plotrelief raised

add_de1_widget "settings_1b" graph 1330 300 { 
		set ::preview_graph_flow $widget
		update_de1_explanation_chart;
		$::preview_graph_flow element create line_espresso_de1_explanation_chart_flow -xdata espresso_de1_explanation_chart_elapsed_flow -ydata espresso_de1_explanation_chart_flow -symbol circle -label "" -linewidth [rescale_x_skin 10] -color #4e85f4  -smooth quadratic -pixels [rescale_x_skin 30]; 
		$::preview_graph_flow axis configure x -color #5a5d75 -tickfont Helv_6; 
		$::preview_graph_flow axis configure y -color #5a5d75 -tickfont Helv_6 -min 0.0 -max 6.5 -majorticks {1 2 3 4 5 6} -title [translate "Flow rate"] -titlefont Helv_8 -titlecolor #5a5d75;
		bind $::preview_graph_flow [platform_button_press] { after 500 update_de1_explanation_chart; say [translate {settings}] $::settings(sound_button_in); set_next_page off $::settings(settings_profile_type); page_show off 	} 
	} -plotbackground $chart_background_color -width [rescale_x_skin 1050] -height [rescale_y_skin 450] -borderwidth 1 -background #FFFFFF -plotrelief raised 


add_de1_variable "settings_1" 2466 660 -text "" -font Helv_7 -fill "#7f879a" -anchor "center" -textvariable {[return_temperature_setting $::settings(espresso_temperature)]}

add_de1_text "settings_4" 380 1300 -text [translate "Clean"] -font Helv_10_bold -fill "#FFFFFF" -anchor "center"
add_de1_text "settings_4" 1000 1300 -text [translate "Descale"] -font Helv_10_bold -fill "#FFFFFF" -anchor "center"
 
add_de1_variable "settings_4" 2270 534 -text "" -width [rescale_y_skin 400] -font Helv_8_bold -fill "#FFFFFF" -justify "center" -anchor "center" -textvariable {[translate $::de1(firmware_update_button_label)]} 
add_de1_variable "settings_4" 2500 410 -font Helv_8 -fill "#7f879a" -anchor "ne" -width 500 -justify "right" -textvariable {[firmware_uploaded_label]} 

add_de1_variable "settings_4" 1650 1300 -text [translate "Update"] -font Helv_10_bold -fill "#FFFFFF" -anchor "center" -textvariable {[translate $::de1(app_update_button_label)]} 


# exit app feature
add_de1_text "settings_4" 2280 1300 -text [translate "Exit"] -font Helv_10_bold -fill "#FFFFFF" -anchor "center" 
add_de1_button "settings_4" {say [translate {exit}] $::settings(sound_button_in); app_exit} 1925 1206 2550 1406

#add_de1_text "settings_4" 1020 980 -text [translate "Reset"] -font Helv_10_bold -fill "#FFFFFF" -anchor "center"
#add_de1_text "settings_4" 2280 980 -text [translate "Pair"] -font Helv_10_bold -fill "#FFFFFF" -anchor "center" -width 200 -justify "center"

# clean feature
add_de1_button "settings_4" {say [translate {Clean}] $::settings(sound_button_in); start_cleaning}  30 1206 638 1406

# descale button
add_de1_button "settings_4" {say [translate {Descale}] $::settings(sound_button_in); start_decaling} 645 1206 1260 1406

# firmware update
add_de1_button "settings_4" {start_firmware_update} 1930 460 2550 600

# app update
add_de1_button "settings_4" {set ::de1(app_update_button_label) [translate "Updating"]; start_app_update} 1300 1206 1900 1406

# firmware reset
#add_de1_button "settings_4" {} 640 890 1260 1080

# firmware reset
#add_de1_button "settings_4" {} 1900 890 2520 1080

add_de1_text "settings_4" 1310 220 -text [translate "Information"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"
	add_de1_text "settings_4" 1310 300 -text [translate {Version}] -font Helv_7_bold -fill "#7f879a" -anchor "nw" -width [rescale_y_skin 1220] -justify "left" 
		add_de1_variable "settings_4" 1600 300 -text "" -font Helv_7 -fill "#7f879a" -anchor "nw" -width [rescale_y_skin 920] -justify "left" -textvariable {[de1_version_string]} 

	add_de1_text "settings_4" 1310 360 -text [translate "Water level"] -font Helv_7_bold -fill "#7f879a" -anchor "nw" -width [rescale_y_skin 1000] -justify "left" 
		add_de1_variable "settings_4" 1600 360 -text "" -font Helv_7 -fill "#7f879a" -anchor "nw" -width [rescale_y_skin 1000] -justify "left" -textvariable {[round_to_integer $::de1(water_level)][translate mm]}

	add_de1_text "settings_4" 1310 420 -text [translate "Counter"] -font Helv_7_bold -fill "#7f879a" -anchor "nw" -width [rescale_y_skin 1000] -justify "left"
		add_de1_text "settings_4" 1450 460 -text [translate "Espresso"] -font Helv_7 -fill "#7f879a" -anchor "nw" -width [rescale_y_skin 1000] -justify "left" 
		add_de1_text "settings_4" 1450 500 -text [translate "Steam"] -font Helv_7 -fill "#7f879a" -anchor "nw" -width [rescale_y_skin 1000] -justify "left"
		add_de1_text "settings_4" 1450 540 -text [translate "Hot water"] -font Helv_7 -fill "#7f879a" -anchor "nw" -width [rescale_y_skin 1000] -justify "left"
		add_de1_variable "settings_4" 1430 460 -text "" -font Helv_7 -fill "#7f879a" -anchor "ne" -width [rescale_y_skin 1000] -justify "right" -textvariable {[round_to_integer $::settings(espresso_count)]}
		add_de1_variable "settings_4" 1430 500 -text "" -font Helv_7 -fill "#7f879a" -anchor "ne" -width [rescale_y_skin 1000] -justify "right" -textvariable {[round_to_integer $::settings(steaming_count)]}
		add_de1_variable "settings_4" 1430 540 -text "" -font Helv_7 -fill "#7f879a" -anchor "ne" -width [rescale_y_skin 1000] -justify "right" -textvariable {[round_to_integer $::settings(water_count)]}

proc scheduler_feature_hide_show_refresh {} {
	if {$::de1(current_context) == "settings_3"} {
		show_hide_from_variable $::scheduler_widgetids ::settings scheduler_enable write
	}
}

#add_de1_widget "settings_2c" checkbutton 1538 830 {} -text [translate "4: Move on if..."] -padx 0 -pady 0 -indicatoron true  -font Helv_9_bold -anchor nw -foreground #7f879a -activeforeground #7f879a -variable ::current_adv_step(exit_if)  -borderwidth 0  -highlightthickness 0  -command save_current_adv_shot_step -selectcolor #f9f9f9 -activebackground #f9f9f9 -bg #f9f9f9 -relief flat 
# scheduled power up/down
add_de1_widget "settings_3" checkbutton 40 1120 {} -text [translate "Scheduler"] -padx 0 -pady 0 -indicatoron true  -font Helv_10_bold -bg #FFFFFF -anchor nw -foreground #7f879a -activeforeground #7f879a -variable ::settings(scheduler_enable)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF -command scheduler_feature_hide_show_refresh -relief flat 
	set scheduler_widget_id1 [add_de1_widget "settings_3_manual" scale 50 1200 {} -from 0 -to 85800 -background #e4d1c1 -borderwidth 1 -bigincrement 3600 -showvalue 0 -resolution 600 -length [rescale_x_skin 570] -width [rescale_y_skin 135] -variable ::settings(scheduler_wake) -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -orient horizontal -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 ]
	set scheduler_widget_id2 [add_de1_variable "settings_3" 50 1340 -text "" -font Helv_7 -fill "#4e85f4" -anchor "nw" -textvariable {[translate "Heat up:"] [format_alarm_time $::settings(scheduler_wake)]}]
	set scheduler_widget_id3 [add_de1_widget "settings_3_manual" scale 670 1200 {} -from 0 -to 85800 -background #e4d1c1 -borderwidth 1 -bigincrement 3600 -showvalue 0 -resolution 600 -length [rescale_x_skin 570] -width [rescale_y_skin 135] -variable ::settings(scheduler_sleep) -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -orient horizontal -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 ]
	set scheduler_widget_id4 [add_de1_variable "settings_3" 670 1340 -text "" -font Helv_7 -fill "#4e85f4" -anchor "nw" -textvariable {[translate "Cool down:"] [format_alarm_time $::settings(scheduler_sleep)]}]
	set ::scheduler_widgetids [list $scheduler_widget_id1 $scheduler_widget_id2 $scheduler_widget_id3 $scheduler_widget_id4]
	#trace add variable ::settings(scheduler_enable) write "show_hide_from_variable {$::scheduler_widgetids}"	
	set_alarms_for_de1_wake_sleep

#add_de1_text "settings_3" 2310 880 -text [translate "Temperature"] -font Helv_9 -fill "#7f879a" -anchor "center" -width 800 -justify "center"


#add_de1_text "settings_3" 50 1120 -text [translate "Hot water"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"
add_de1_text "settings_3" 50 220 -text [translate "Screen brightness"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"
add_de1_text "settings_3" 50 540 -text [translate "Energy saver"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"
add_de1_text "settings_3" 680 540 -text [translate "Screen saver"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"
add_de1_text "settings_3" 50 860 -text [translate "Measurements"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"
add_de1_text "settings_4" 50 1140 -text [translate "Maintenance"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"
add_de1_text "settings_4" 1320 1140 -text [translate "App"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"
#add_de1_text "settings_4" 1960 1140 -text [translate "App"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"

add_de1_text "settings_4" 1310 650 -text [translate "Connect"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"
	add_de1_text "settings_4" 1310 750 -text [translate "Espresso machine"] -font Helv_7_bold -fill "#7f879a" -justify "left" -anchor "nw"

	add_de1_variable "settings_4" 2230 696 -text {} -font Helv_8_bold -fill "#FFFFFF" -anchor "center"  -textvariable {[scanning_state_text]} 
	add_de1_button "settings_4" {say [translate {Scan}] $::settings(sound_button_in); scanning_restart} 2050 640 2550 750

	if {[de1plus]} {
		add_de1_text "settings_4" 1920 750 -text [translate "Scale"] -font Helv_7_bold -fill "#7f879a" -justify "left" -anchor "nw"

		add_de1_widget "settings_4" listbox 1920 800 { 
				set ::ble_skale_listbox_widget $widget
				bind $widget <<ListboxSelect>> ::change_skale_bluetooth_device
				fill_ble_skale_listbox
			} -background #fbfaff -font Helv_15 -bd 0 -height 3 -width 16 -foreground #d3dbf3 -borderwidth 0 -selectborderwidth 0  -relief flat -highlightthickness 0 -selectmode single -selectbackground #c0c4e1

	}

#set_next_page off settings_4

if {[de1plus]} {

	# advanced features that are normally disabled
	add_de1_text "settings_4" 50 220 -text [translate "Optional features"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"
	set pos_top 320
	set spacer 90
	set optionfont "Helv_9"
	add_de1_widget "settings_4" checkbutton 70 [expr {$pos_top + (0 * $spacer)}] {} -text [translate "Show water level"] -indicatoron true  -font $optionfont -bg #FFFFFF -anchor nw -foreground #4e85f4 -variable ::settings(waterlevel_indicator_on)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF -bd 0 -activeforeground #4e85f4  -relief flat 
	add_de1_widget "settings_4" checkbutton 70 [expr {$pos_top + (1 * $spacer)}] {} -text [translate "Blinking low water warning"] -indicatoron true  -font $optionfont -bg #FFFFFF -anchor nw -foreground #4e85f4 -variable ::settings(waterlevel_indicator_blink)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF -bd 0 -activeforeground #4e85f4  -relief flat 
	add_de1_widget "settings_4" checkbutton 70 [expr {$pos_top + (2 * $spacer)}] {} -text [translate "Show adaptive water temperature"] -indicatoron true  -font $optionfont -bg #FFFFFF -anchor nw -foreground #4e85f4 -variable ::settings(display_espresso_water_delta_number)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF -bd 0 -activeforeground #4e85f4  -relief flat 
	#add_de1_widget "settings_4" checkbutton 70 [expr {$pos_top + (3 * $spacer)}] {} -text [translate "Rate your espresso shots"] -indicatoron true  -font $optionfont -bg #FFFFFF -anchor nw -foreground #4e85f4 -variable ::settings(display_rate_espresso)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF -bd 0 -activeforeground #4e85f4  -relief flat 
	add_de1_widget "settings_4" checkbutton 70 [expr {$pos_top + (3 * $spacer)}] {} -text [translate "One-tap mode"] -indicatoron true  -font $optionfont -bg #FFFFFF -anchor nw -foreground #4e85f4 -variable ::settings(one_tap_mode)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF -bd 0 -activeforeground #4e85f4  -relief flat 
	add_de1_widget "settings_4" checkbutton 70 [expr {$pos_top + (4 * $spacer)}] {} -text [translate "Stress test"] -indicatoron true  -font $optionfont -bg #FFFFFF -anchor nw -foreground #4e85f4 -variable ::settings(stress_test)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF -bd 0 -activeforeground #4e85f4  -relief flat 

	add_de1_widget "settings_4" checkbutton 70 [expr {$pos_top + (5 * $spacer)}] {} -text [translate "Chart pressure changes"] -indicatoron true  -font $optionfont -bg #FFFFFF -anchor nw -foreground #4e85f4 -variable ::settings(display_pressure_delta_line)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF -bd 0 -activeforeground #4e85f4  -relief flat 
	add_de1_widget "settings_4" checkbutton 70 [expr {$pos_top + (6 * $spacer)}] {} -text [translate "Chart flow rate changes"] -indicatoron true  -font $optionfont -bg #FFFFFF -anchor nw -foreground #4e85f4 -variable ::settings(display_flow_delta_line)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF -bd 0 -activeforeground #4e85f4  -relief flat 

	# this feature is now automatically enabled if you have a bluetooth scale connected
	#if {$::settings(skale_bluetooth_address) != ""} {
		#add_de1_widget "settings_4" checkbutton 70 [expr {$pos_top + (7 * $spacer)}] {} -text [translate "Chart weight changes"] -indicatoron true  -font $optionfont -bg #FFFFFF -anchor nw -foreground #4e85f4 -variable ::settings(display_weight_delta_line)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF -bd 0 -activeforeground #4e85f4  -relief flat 
	#}
}




add_de1_widget "settings_4" listbox 1310 800 { 
		set ::ble_listbox_widget $widget
		bind $::ble_listbox_widget <<ListboxSelect>> ::change_bluetooth_device
		fill_ble_listbox
	} -background #fbfaff -font Helv_15 -bd 0 -height 3 -width 16 -foreground #d3dbf3 -borderwidth 0 -selectborderwidth 0  -relief flat -highlightthickness 0 -selectmode single -selectbackground #c0c4e1

# bluetooth scan
#add_de1_text "settings_4" 2230 980 -text [translate "Search"] -font Helv_10_bold -fill "#FFFFFF" -anchor "center"
#add_de1_button "settings_4" {set ::de1_bluetooth_list ""; say [translate {search}] $::settings(sound_button_in); ble_find_de1s} 1910 890 2550 1080

set enable_spoken_buttons 0
if {$enable_spoken_buttons == 1} {
	add_de1_widget "settings_3" scale 1350 580 {} -from 0 -to 4 -background #FFFFFF -borderwidth 1 -bigincrement .1 -resolution .1 -length [rescale_x_skin 1100] -width [rescale_y_skin 135] -variable ::settings(speaking_rate) -font Helv_10_bold -sliderlength [rescale_x_skin 75] -relief flat -orient horizontal -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 
	add_de1_text "settings_3" 1350 785 -text [translate "Speaking speed"] -font Helv_8 -fill "#2d3046" -anchor "nw" -width 800 -justify "left"

	add_de1_widget "settings_3" scale 1350 840 {} -from 0 -to 3 -background #FFFFFF -borderwidth 1 -bigincrement .1 -resolution .1 -length [rescale_x_skin 1100] -width [rescale_y_skin 135] -variable ::settings(speaking_pitch) -font Helv_10_bold -sliderlength [rescale_x_skin 75] -relief flat -orient horizontal -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 
	add_de1_text "settings_3" 1350 1045 -text [translate "Speaking pitch"] -font Helv_8 -fill "#2d3046" -anchor "nw" -width 800 -justify "left"
	add_de1_text "settings_3" 1350 250 -text [translate "Speaking"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"
	add_de1_widget "settings_3" checkbutton 1350 400 {} -text [translate "Enable spoken prompts"] -indicatoron true  -font Helv_10 -bg #FFFFFF -anchor nw -foreground #2d3046 -variable ::settings(enable_spoken_prompts)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF
}

add_de1_widget "settings_3" scale 50 300 {} -from 0 -to 100 -background #e4d1c1 -borderwidth 1 -bigincrement 1 -showvalue 0 -resolution 1 -length [rescale_x_skin 550] -width [rescale_y_skin 135] -variable ::settings(app_brightness) -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -orient horizontal -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 
add_de1_variable "settings_3" 50 440 -text "" -font Helv_7 -fill "#4e85f4" -anchor "nw" -width 800 -justify "left" -textvariable {[translate "App:"] $::settings(app_brightness)%}

add_de1_widget "settings_3" scale 670 300 {} -from 0 -to 100 -background #e4d1c1 -borderwidth 1 -bigincrement 1 -showvalue 0 -resolution 1 -length [rescale_x_skin 550] -width [rescale_y_skin 135] -variable ::settings(saver_brightness) -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -orient horizontal -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 
add_de1_variable "settings_3" 670 440 -text "" -font Helv_7 -fill "#4e85f4" -anchor "nw" -width 800 -justify "left" -textvariable {[translate "Screen saver"] $::settings(saver_brightness)%}

add_de1_widget "settings_3" scale 50 620 {} -from 0 -to 120 -background #e4d1c1 -borderwidth 1 -bigincrement 1 -showvalue 0 -resolution 1 -length [rescale_x_skin 550] -width [rescale_y_skin 135] -variable ::settings(screen_saver_delay) -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -orient horizontal -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 
add_de1_variable "settings_3" 50 760 -text "" -font Helv_7 -fill "#4e85f4" -anchor "nw" -width 800 -justify "left" -textvariable {[translate "Cool down after:"] [minutes_text $::settings(screen_saver_delay)]}

add_de1_widget "settings_3" scale 690 620 {} -from 1 -to 120 -background #e4d1c1 -borderwidth 1 -bigincrement 1 -showvalue 0 -resolution 1 -length [rescale_x_skin 530] -width [rescale_y_skin 135] -variable ::settings(screen_saver_change_interval) -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -orient horizontal -foreground #FFFFFF -troughcolor $slider_trough_color -borderwidth 0  -highlightthickness 0 
add_de1_variable "settings_3" 690 760 -text "" -font Helv_7 -fill "#4e85f4" -anchor "nw" -width 800 -justify "left" -textvariable {[translate "Change every:"] [minutes_text $::settings(screen_saver_change_interval)]}



add_de1_widget "settings_3" checkbutton 70 940 {} -text [translate "Fahrenheit"] -indicatoron true  -font Helv_10 -bg #FFFFFF -anchor nw -foreground #4e85f4 -variable ::settings(enable_fahrenheit)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF  -bd 0 -activeforeground #4e85f4 -relief flat -bd 0
add_de1_widget "settings_3" checkbutton 70 1000 {} -text [translate "AM/PM"] -indicatoron true  -font Helv_10 -bg #FFFFFF -anchor nw -foreground #4e85f4 -variable ::settings(enable_ampm)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF -bd 0 -activeforeground #4e85f4  -relief flat 
add_de1_widget "settings_3" checkbutton 690 940 {} -text [translate "1.234,56"] -indicatoron true  -font Helv_10 -bg #FFFFFF -anchor nw -foreground #4e85f4 -variable ::settings(enable_commanumbers)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF -bd 0 -activeforeground #4e85f4  -relief flat 

if {$::settings(display_fluid_ounces_option) == 1} {
	add_de1_widget "settings_3" checkbutton 690 1000 {} -text [translate "Fluid ounces"] -indicatoron true  -font Helv_10 -bg #FFFFFF -anchor nw -foreground #4e85f4 -variable ::settings(enable_fluid_ounces)  -borderwidth 0 -selectcolor #FFFFFF -highlightthickness 0 -activebackground #FFFFFF -bd 0 -activeforeground #4e85f4 -relief flat  
}

add_de1_text "settings_1 settings_2 settings_2a settings_2b settings_2c settings_3 settings_4" 2275 1520 -text [translate "Ok"] -font Helv_10_bold -fill "#FFFFFF" -anchor "center"
add_de1_text "settings_1 settings_2 settings_2a settings_2b settings_2c settings_3 settings_4" 1760 1520 -text [translate "Cancel"] -font Helv_10_bold -fill "#FFFFFF" -anchor "center"

add_de1_button "settings_1" {say [translate {save}] $::settings(sound_button_in); save_profile} 2300 1220 2550 1410
add_de1_button "settings_1" {say [translate {cancel}] $::settings(sound_button_in); delete_selected_profile} 1100 280 1300 500

set settings_label1 [translate "PRESSURE"]
set settings_label2 [translate "Pressure profiles"]

#add_de1_text "settings_1" 50 220 -text $settings_label2 -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw" 
add_de1_text "settings_1" 50 230 -text [translate "Load a preset"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw" 
add_de1_text "settings_1" 1360 230 -text [translate "Preview"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw" 
add_de1_text "settings_1" 1360 830 -text [translate "Description"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw" 

add_de1_text "settings_1" 1360 1240 -text [translate "Name and save"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw" 
	add_de1_widget "settings_1" multiline_entry 1360 900 {} -width 47 -height 4 -font Helv_8  -borderwidth 2 -bg #fbfaff  -foreground #4e85f4 -textvariable ::settings(profile_notes) -relief flat -highlightthickness 1 -highlightcolor #000000 

add_de1_text "settings_3" 1310 220 -text [translate "Tablet styles"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"
	add_de1_widget "settings_1" entry 1360 1310  {
			set ::globals(widget_profile_name_to_save) $widget
			bind $widget <Return> { say [translate {save}] $::settings(sound_button_in); save_profile; }
		} -width 38 -font Helv_8  -borderwidth 1 -bg #fbfaff  -foreground #4e85f4 -textvariable ::settings(profile_to_save) -relief flat  -highlightthickness 1 -highlightcolor #000000 




# labels for PREHEAT tab on

if {[de1plus]} {
	set settings_label1 [translate "PROFILE"]
	set settings_label2 [translate "Profiles"]

	# types of profiles available on DE1+
	add_de1_text "settings_2a" 240 1485 -text [translate "Pressure"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
	add_de1_text "settings_2a" 735 1485 -text [translate "Flow"] -font Helv_10_bold -fill "#7f879a" -anchor "center" 
	add_de1_text "settings_2a" 1220 1485 -text [translate "Advanced"] -font Helv_10_bold -fill "#7f879a" -anchor "center" 

	add_de1_text "settings_2b" 240 1485 -text [translate "Pressure"] -font Helv_10_bold -fill "#7f879a" -anchor "center" 
	add_de1_text "settings_2b" 735 1485 -text [translate "Flow"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 
	add_de1_text "settings_2b" 1220 1485 -text [translate "Advanced"] -font Helv_10_bold -fill "#7f879a" -anchor "center" 

	add_de1_text "settings_2c" 240 1485 -text [translate "Pressure"] -font Helv_10_bold -fill "#7f879a" -anchor "center" 
	add_de1_text "settings_2c" 735 1485 -text [translate "Flow"] -font Helv_10_bold -fill "#7f879a" -anchor "center" 
	add_de1_text "settings_2c" 1220 1485 -text [translate "Advanced"] -font Helv_10_bold -fill "#5a5d75" -anchor "center" 

	add_de1_button "settings_2b settings_2c" {say [translate {PRESSURE}] $::settings(sound_button_in); set ::settings(settings_profile_type) "settings_2a"; set_next_page off $::settings(settings_profile_type); page_show off; update_de1_explanation_chart; set ::active_settings_tab $::settings(settings_profile_type) } 1 1410 495 1600
	add_de1_button "settings_2a settings_2c" {say [translate {FLOW}] $::settings(sound_button_in); set ::settings(settings_profile_type) "settings_2b"; set_next_page off $::settings(settings_profile_type); page_show off; update_de1_explanation_chart; set ::active_settings_tab $::settings(settings_profile_type) } 496 1410 972 1600
	add_de1_button "settings_2a" {say [translate {ADVANCED}] $::settings(sound_button_in); set ::settings(settings_profile_type) "settings_2c"; set_next_page off $::settings(settings_profile_type); page_show off; set ::active_settings_tab $::settings(settings_profile_type); copy_pressure_profile_to_advanced_profile; fill_advanced_profile_steps_listbox;  } 974 1410 1500 1600
	add_de1_button "settings_2b" {say [translate {ADVANCED}] $::settings(sound_button_in); set ::settings(settings_profile_type) "settings_2c"; set_next_page off $::settings(settings_profile_type); page_show off; set ::active_settings_tab $::settings(settings_profile_type); copy_flow_profile_to_advanced_profile; fill_advanced_profile_steps_listbox;  } 974 1410 1500 1600
}



########################################
# labels for tab1
add_de1_text "settings_1" 330 100 -text [translate "PRESETS"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_variable "settings_1" 960 100 -text "" -font Helv_10_bold -fill "#7f879a" -anchor "center" -textvariable {[setting_profile_type_to_text]}
add_de1_text "settings_1" 1590 100 -text [translate "OTHER"] -font Helv_10_bold -fill "#7f879a" -anchor "center" 
add_de1_text "settings_1" 2215 100 -text [translate "MACHINE"] -font Helv_10_bold -fill "#7f879a" -anchor "center" 

########################################
# labels for tab2
add_de1_text "settings_2 settings_2a settings_2b settings_2c" 330 100 -text [translate "PRESETS"] -font Helv_10_bold -fill "#7f879a" -anchor "center" 
add_de1_variable "settings_2 settings_2a settings_2b settings_2c" 960 100 -text "" -font Helv_10_bold -fill "#2d3046" -anchor "center" -textvariable {[setting_profile_type_to_text]}
add_de1_text "settings_2 settings_2a settings_2b settings_2c" 1590 100 -text [translate "OTHER"] -font Helv_10_bold -fill "#7f879a" -anchor "center" 
add_de1_text "settings_2 settings_2a settings_2b settings_2c" 2215 100 -text [translate "MACHINE"] -font Helv_10_bold -fill "#7f879a" -anchor "center" 

########################################
# top labels for tab3 
add_de1_text "settings_3" 330 100 -text [translate "PRESETS"] -font Helv_10_bold -fill "#7f879a" -anchor "center" 
add_de1_variable "settings_3" 960 100 -text "" -font Helv_10_bold -fill "#7f879a" -anchor "center" -textvariable {[setting_profile_type_to_text]}
add_de1_text "settings_3" 1590 100 -text [translate "OTHER"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 
add_de1_text "settings_3" 2215 100 -text [translate "MACHINE"] -font Helv_10_bold -fill "#7f879a" -anchor "center" 

# top labels for tab4
add_de1_text "settings_4" 330 100 -text [translate "PRESETS"] -font Helv_10_bold -fill "#7f879a" -anchor "center" 
add_de1_variable "settings_4" 960 100 -text "" -font Helv_10_bold -fill "#7f879a" -anchor "center" -textvariable {[setting_profile_type_to_text]}
add_de1_text "settings_4" 1590 100 -text [translate "OTHER"] -font Helv_10_bold -fill "#7f879a" -anchor "center" 
add_de1_text "settings_4" 2215 100 -text [translate "MACHINE"] -font Helv_10_bold -fill "#2d3046" -anchor "center" 


add_de1_text "settings_3" 1890 790 -text [translate "Language"] -font Helv_10_bold -fill "#7f879a" -justify "left" -anchor "nw"
add_de1_widget "settings_3" listbox 1890 868 { 
	set ::languages_widget $widget
	bind $widget <<ListboxSelect>> ::load_language
	fill_languages_listbox

} -background #fbfaff -yscrollcommand {scale_scroll ::language_slider} -font global_font -bd 0 -height 7 -width 17 -foreground #d3dbf3 -borderwidth 0 -selectborderwidth 0  -relief flat -highlightthickness 0 -selectmode single  -selectbackground #c0c4e1


set ::language_slider 0
set ::languages_scrollbar [add_de1_widget "settings_3" scale 2300 868 {} -from 0 -to .90 -bigincrement 0.2 -background "#d3dbf3" -borderwidth 1 -showvalue 0 -resolution .01 -length [rescale_x_skin 400] -width [rescale_y_skin 150] -variable ::language_slider -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -command {listbox_moveto $::languages_widget $::language_slider}  -foreground #FFFFFF -troughcolor "#f7f6fa" -borderwidth 0  -highlightthickness 0]


# this moves the scrollbar to the right of the languages listbox, and sets its height correctly
# this can't be done until the page is rendered, because the windowing system doesn't know ahead of time the true dimensions of the listbox, not until it is rendered
proc set_languages_scrollbar_dimensions {} {

	# set the height of the scrollbar to be the same as the listbox
	$::languages_scrollbar configure -length [winfo height $::languages_widget]
	set coords [.can coords $::languages_widget ]
	set newx [expr {[winfo width $::languages_widget] + [lindex $coords 0]}]
	.can coords $::languages_scrollbar "$newx [lindex $coords 1]"
	#puts "coo:= [.can coords $::languages_scrollbar ] + [winfo height $::languages_widget]"
}


# buttons for moving between tabs, available at all times that the espresso machine is not doing something hot
add_de1_button "settings_1 settings_2 settings_2a settings_2b settings_2c settings_3 settings_4" {after 500 update_de1_explanation_chart; say [translate {settings}] $::settings(sound_button_in); set_next_page off "settings_1"; page_show off; set ::active_settings_tab "settings_1"; set_profiles_scrollbar_dimensions} 0 0 641 188
add_de1_button "settings_1 settings_2 settings_2a settings_2b settings_2c settings_3 settings_4" {after 500 update_de1_explanation_chart; say [translate {settings}] $::settings(sound_button_in); set_next_page off $::settings(settings_profile_type); page_show off; set ::active_settings_tab $::settings(settings_profile_type)} 642 0 1277 188 
add_de1_button "settings_1 settings_2 settings_2a settings_2b settings_2c settings_3 settings_4" {say [translate {settings}] $::settings(sound_button_in); set_next_page off settings_3; page_show settings_3; scheduler_feature_hide_show_refresh; set ::active_settings_tab "settings_3"; preview_tablet_skin; set_languages_scrollbar_dimensions} 1278 0 1904 188
add_de1_button "settings_1 settings_2 settings_2a settings_2b settings_2c settings_3 settings_4" {say [translate {settings}] $::settings(sound_button_in); set_next_page off settings_4; page_show settings_4; set ::active_settings_tab "settings_4"} 1905 0 2560 188

add_de1_button "settings_1 settings_2 settings_2a settings_2b settings_2c settings_3 settings_4" {save_settings_to_de1; set_alarms_for_de1_wake_sleep; say [translate {save}] $::settings(sound_button_in); save_settings; 
		if {[array_item_difference ::settings ::settings_backup "language skin waterlevel_indicator_on waterlevel_indicator_blink display_rate_espresso display_espresso_water_delta_number display_group_head_delta_number display_pressure_delta_line display_flow_delta_line display_weight_delta_line allow_unheated_water"] == 1 } {
			.can itemconfigure $::message_label -text [translate "Please quit and restart this app to apply your changes."]
			set_next_page off message; page_show message
		} else {
			set_next_page off off; page_show off
		}
	} 2016 1430 2560 1600
add_de1_button "settings_1 settings_2 settings_2a settings_2b settings_2c settings_3 settings_4" {unset -nocomplain ::settings; array set ::settings [array get ::settings_backup]; update_de1_explanation_chart; fill_profiles_listbox; fill_skin_listbox; say [translate {Cancel}] $::settings(sound_button_in); set_next_page off off; page_show off} 1505 1430 2015 1600


# END OF SETTINGS page
##############################################################################################################################################################################################################################################################################

proc setting_profile_type_to_text { } {
	set in $::settings(settings_profile_type)
	if {$in == "settings_2a"} {
		if {$::de1(current_context) == "settings_1"} {
			.can itemconfigure $::preview_graph_flow -state hidden
			.can itemconfigure $::preview_graph_pressure -state normal
		}
		#return [translate "Pressure profile"]
		return [translate "PRESSURE"]
	} elseif {$in == "settings_2b"} {
		if {$::de1(current_context) == "settings_1"} {
			.can itemconfigure $::preview_graph_pressure -state hidden
			.can itemconfigure $::preview_graph_flow -state normal
		}
		#return [translate "Flow profile"]
		return [translate "FLOW"]
	} elseif {$in == "settings_2c"} {
		if {$::de1(current_context) == "settings_1"} {
			.can itemconfigure $::preview_graph_pressure -state hidden
			.can itemconfigure $::preview_graph_flow -state hidden
		}
		return [translate "ADVANCED"]
		#return [translate "Advanced profile"]
	} else {
		return [translate "PROFILE"]
	}
}

#set_next_page off settings_1

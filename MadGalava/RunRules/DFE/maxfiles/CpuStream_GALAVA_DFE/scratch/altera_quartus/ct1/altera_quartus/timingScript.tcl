load_package report

proc fatal_error {msg} {
	post_message -type error $msg
	exit 1
}

# Retrieve the total TNS from the timing analyzer panel
proc read_tns_from_timequest_panel {panel_name} {
	load_report

	# Find panel
	set panel_id [get_report_panel_id "TimeQuest Timing Analyzer GUI||$panel_name"]
	if { $panel_id == -1 } {
		fatal_error "Could not find a panel named $panel_name"
	}

	# If a panel has no rows (i.e. no paths to report) 
	if { [catch {set num_rows [get_number_of_rows -id $panel_id]} err]} {
		return 0
	}

	# Find TNS column
	set tns_column [get_report_panel_column_index -id $panel_id "End Point TNS"]
	if { $tns_column == -1 } {
		fatal_error "Could not find 'End Point TNS' column"
	}

	# Sum TNS
	# Row 0 = headers, so start from 1
	set sum 0
	for { set i 1 } { $i < $num_rows } { incr i } {
		set curr [get_report_panel_data -id $panel_id -col $tns_column -row $i]
		set sum [expr $sum + $curr]
	}

	return $sum
}

if { $argc != 3 } {
	fatal_error "Usage: <ProjectName> <OutputFile> <NWorstPaths>"
}

set project  [lindex $argv 0]
set outFile  [lindex $argv 1]
set summary  "$outFile.timing"
set outTns   "$outFile.tns"
set outSetupSlow "$outFile.setup_slow"
set outSetupFast "$outFile.setup_fast"
set outHoldSlow  "$outFile.hold_slow"
set outHoldFast  "$outFile.hold_fast"
set outRecoverySlow "$outFile.recovery_slow"
set outRecoveryFast "$outFile.recovery_fast"

set outClock "$outFile.clocks"
set maxelercount    [lindex $argv 2]

# clean up
file delete -- $summary

# project setup
project_open $project
create_timing_netlist
read_sdc

# Total Negative Slack (TNS)
set tns 0 

# loop over all four timing corners and put the panels into a file
foreach_in_collection corner [get_available_operating_conditions] {
	set summary_file [open $summary a]
	puts $summary_file "=== Analysis for Corner: $corner ==="
	close $summary_file

	set_operating_conditions $corner

	update_timing_netlist
	create_timing_summary -setup    -panel_name "Summary (Setup)"               -file $summary -append
	set tns [expr $tns + [read_tns_from_timequest_panel "Summary (Setup)"]]

	create_timing_summary -hold     -panel_name "Summary (Hold)"                -file $summary -append
	set tns [expr $tns + [read_tns_from_timequest_panel "Summary (Hold)"]]

	create_timing_summary -recovery -panel_name "Summary (Recovery)"            -file $summary -append
	set tns [expr $tns + [read_tns_from_timequest_panel "Summary (Recovery)"]]

	create_timing_summary -removal  -panel_name "Summary (Removal)"             -file $summary -append
	set tns [expr $tns + [read_tns_from_timequest_panel "Summary (Removal)"]]

	create_timing_summary -mpw      -panel_name "Summary (Minimum Pulse Width)" -file $summary -append
	set tns [expr $tns + [read_tns_from_timequest_panel "Summary (Minimum Pulse Width)"]]
}

# write tns to file
set file_id [open $outTns "w"]
puts $file_id $tns
close $file_id

# report setup and hold for all four corner cases (exclusive to slow/fast model option)
foreach_in_collection corner [get_available_operating_conditions] {
   
    set outSetupCorner "$outFile.setup_$corner"

    set_operating_conditions $corner
    update_timing_netlist
    report_timing -setup -less_than_slack 0 -file $outSetupCorner -detail full_path -nworst $maxelercount -pairs_only


    set outHoldCorner "$outFile.hold_$corner"

    set_operating_conditions $corner
    update_timing_netlist
    report_timing -hold -less_than_slack 0 -file $outHoldCorner -detail full_path -nworst $maxelercount -pairs_only

    set outRecoveryCorner "$outFile.recovery_$corner"

    set_operating_conditions $corner
    update_timing_netlist
    report_timing -recovery -less_than_slack 0 -file $outRecoveryCorner -detail full_path -nworst $maxelercount -pairs_only


}



# report slow corner failing setup paths
set_operating_conditions -model slow
update_timing_netlist
report_timing -setup -less_than_slack 0 -file $outSetupSlow -detail full_path -nworst $maxelercount -pairs_only

# report slow corner failing hold paths
set_operating_conditions -model slow
update_timing_netlist
report_timing -hold -less_than_slack 0 -file $outHoldSlow -detail full_path -nworst $maxelercount -pairs_only

# report slow corner failing recovery paths
set_operating_conditions -model slow
update_timing_netlist
report_timing -recovery -less_than_slack 0 -file $outRecoverySlow -detail full_path -nworst $maxelercount -pairs_only

# report fast corner failing hold paths
set_operating_conditions -model fast
update_timing_netlist
report_timing -hold  -less_than_slack 0 -file $outHoldFast  -detail full_path -nworst $maxelercount -pairs_only

# report fast corner failing setup paths
set_operating_conditions -model fast
update_timing_netlist
report_timing -setup  -less_than_slack 0 -file $outSetupFast  -detail full_path -nworst $maxelercount -pairs_only

# report fast corner failing recovery paths
set_operating_conditions -model fast
update_timing_netlist
report_timing -recovery  -less_than_slack 0 -file $outRecoveryFast  -detail full_path -nworst $maxelercount -pairs_only

# report clock timing summary - used for mapping constraints
create_timing_summary -hold  -file $outClock
create_timing_summary -setup -file $outClock -append
report_clock_fmax_summary    -file $outClock -append

# report detailed clock data - required for finding target frequencies/periods
report_clocks -file $outClock -append

project_close

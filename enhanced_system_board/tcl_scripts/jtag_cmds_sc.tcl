# =================================================================
# Master access
# =================================================================
#
# -----------------------------------------------------------------
# Open the JTAG master service
# -----------------------------------------------------------------

# Open the first Avalon-MM master service
proc jtag_open {} {
    global jtag

    # Close any open service
    if {[info exists jtag(master)]} {
        jtag_close
    }

    set master_paths [get_service_paths master]
    if {[llength $master_paths] == 0} {
        puts "Sorry, no master nodes found"
        return
    }
#        puts "\[tip\]\nAll Jtag Masters shows bellow:"    
#        puts " $master_paths"

    # List out all master names and the master connected to them
    set master_index 0
    foreach master_name $master_paths {

        if {[lsearch $master_name "*EP3C120*"] == 0} {

#            puts "\n\[tip\]\nindex $master_index) master is used to as the access master"
#            puts "$master_index) $master_name"
#            puts "if keyword EP3C120 is not suit for jtag chain of this Board,Please verify the keyword\n"
                    break
                }
        incr master_index
    }

    # Select the first master service
    set jtag(master) [lindex $master_paths $master_index]

    open_service master $jtag(master)
    return
}

# -----------------------------------------------------------------
# Close the JTAG master service
# -----------------------------------------------------------------
#
proc jtag_close {} {
    global jtag

    if {[info exists jtag(master)]} {
        close_service master $jtag(master)
        unset jtag(master)
    }
    return
}

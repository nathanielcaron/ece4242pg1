source ./jtag_cmds_sc.tcl

namespace eval BMS {

    variable    jtag
    variable    dashboardActive 0
    variable    dash_path       ""
    variable    value_ledg      0
    variable    value_ledr      0
    variable    value_hex0      0
    variable    value_hex1      0
    variable    value_hex2      0
    variable    value_hex3      0
    variable    value_hex4      0
    variable    value_hex5      0
    variable    value_hex6      0
    variable    value_hex7      0
    variable    initialized     0
    
    variable    base_addr_ledg    0x00
    variable    base_addr_ledr    0x10
    variable    base_addr_hex0    0x20
    variable    base_addr_hex1    0x30
    variable    base_addr_hex2    0x40
    variable    base_addr_hex3    0x50
    variable    base_addr_hex4    0x60
    variable    base_addr_hex5    0x70
    variable    base_addr_hex6    0x80
    variable    base_addr_hex7    0x90
    variable    base_addr_key     0xa0
    variable    base_addr_sw      0xb0
    
    variable    size_read_32            1
    
    
    set         width_ledg_group    720
    set         width_ledg          60
    set         height_ledg         10
    set         width_ledr_group    720
    set         width_ledr          60
    set         height_ledr         20
    set         width_hex_label     20
    set         height_hex_label    20
    set         width_hex_text      40
    set         height_hex_text     20
    set         width_key           60
    set         height_key          20
    set         width_sw            60
    set         height_sw           20



#=======================================================================================================
# create dashboard
#=======================================================================================================

    proc dashBoard {} {
        
        if { ${::BMS::dashboardActive}  ==  1} {
            return  -code ok "dashboard already active"
        }
        
        set ::BMS::dashboardActive  1
        
        
        # create dashboard
        set ::BMS::dash_path    [add_service dashboard Terasic_BMS "DE2-115 Virtual GUI" "Tools/DE2-115 Virtual GUI"]
        # Set dashboard properties
        dashboard_set_property ${::BMS::dash_path} self developmentMode true
        dashboard_set_property ${::BMS::dash_path} self itemsPerRow 1
        dashboard_set_property ${::BMS::dash_path} self visible true
    

        # top group widget
        dashboard_add ${::BMS::dash_path} topGroup group self
        dashboard_set_property ${::BMS::dash_path} topGroup expandableX false
        dashboard_set_property ${::BMS::dash_path} topGroup expandableY false
        dashboard_set_property ${::BMS::dash_path} topGroup itemsPerRow 1
        dashboard_set_property ${::BMS::dash_path} topGroup title ""






####### 1. ledg_vir

        # ledg group widget
        dashboard_add ${::BMS::dash_path} ledgGroup group topGroup
        dashboard_set_property ${::BMS::dash_path} ledgGroup expandableX false
        dashboard_set_property ${::BMS::dash_path} ledgGroup expandableY false
        dashboard_set_property ${::BMS::dash_path} ledgGroup itemsPerRow 9
        dashboard_set_property ${::BMS::dash_path} ledgGroup title "ledg_vir state"
        dashboard_set_property ${::BMS::dash_path} ledgGroup preferredWidth $::BMS::width_ledg_group


        # ledg8 widgets
        dashboard_add ${::BMS::dash_path} ledg8LED led ledgGroup
        dashboard_set_property ${::BMS::dash_path} ledg8LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledg8LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledg8LED text "ledg8"
        dashboard_set_property ${::BMS::dash_path} ledg8LED color "green_off"
        dashboard_set_property ${::BMS::dash_path} ledg8LED preferredWidth $::BMS::width_ledg
        dashboard_set_property ${::BMS::dash_path} ledg8LED preferredHeight $::BMS::height_ledg
        # ledg7 widgets
        dashboard_add ${::BMS::dash_path} ledg7LED led ledgGroup
        dashboard_set_property ${::BMS::dash_path} ledg7LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledg7LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledg7LED text "ledg7"
        dashboard_set_property ${::BMS::dash_path} ledg7LED color "green_off"
        dashboard_set_property ${::BMS::dash_path} ledg7LED preferredWidth $::BMS::width_ledg
        dashboard_set_property ${::BMS::dash_path} ledg7LED preferredHeight $::BMS::height_ledg
        # ledg6 widgets
        dashboard_add ${::BMS::dash_path} ledg6LED led ledgGroup
        dashboard_set_property ${::BMS::dash_path} ledg6LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledg6LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledg6LED text "ledg6"
        dashboard_set_property ${::BMS::dash_path} ledg6LED color "green_off"
        dashboard_set_property ${::BMS::dash_path} ledg6LED preferredWidth $::BMS::width_ledg
        dashboard_set_property ${::BMS::dash_path} ledg6LED preferredHeight $::BMS::height_ledg
        # ledg5 widgets
        dashboard_add ${::BMS::dash_path} ledg5LED led ledgGroup
        dashboard_set_property ${::BMS::dash_path} ledg5LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledg5LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledg5LED text "ledg5"
        dashboard_set_property ${::BMS::dash_path} ledg5LED color "green_off"
        dashboard_set_property ${::BMS::dash_path} ledg5LED preferredWidth $::BMS::width_ledg
        dashboard_set_property ${::BMS::dash_path} ledg5LED preferredHeight $::BMS::height_ledg
        # ledg4 widgets
        dashboard_add ${::BMS::dash_path} ledg4LED led ledgGroup
        dashboard_set_property ${::BMS::dash_path} ledg4LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledg4LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledg4LED text "ledg4"
        dashboard_set_property ${::BMS::dash_path} ledg4LED color "green_off"
        dashboard_set_property ${::BMS::dash_path} ledg4LED preferredWidth $::BMS::width_ledg
        dashboard_set_property ${::BMS::dash_path} ledg4LED preferredHeight $::BMS::height_ledg
        # ledg3 widgets
        dashboard_add ${::BMS::dash_path} ledg3LED led ledgGroup
        dashboard_set_property ${::BMS::dash_path} ledg3LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledg3LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledg3LED text "ledg3"
        dashboard_set_property ${::BMS::dash_path} ledg3LED color "green_off"
        dashboard_set_property ${::BMS::dash_path} ledg3LED preferredWidth $::BMS::width_ledg
        dashboard_set_property ${::BMS::dash_path} ledg3LED preferredHeight $::BMS::height_ledg
        # ledg2 widgets
        dashboard_add ${::BMS::dash_path} ledg2LED led ledgGroup
        dashboard_set_property ${::BMS::dash_path} ledg2LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledg2LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledg2LED text "ledg2"
        dashboard_set_property ${::BMS::dash_path} ledg2LED color "green_off"
        dashboard_set_property ${::BMS::dash_path} ledg2LED preferredWidth $::BMS::width_ledg
        dashboard_set_property ${::BMS::dash_path} ledg2LED preferredHeight $::BMS::height_ledg
        # ledg1 widgets
        dashboard_add ${::BMS::dash_path} ledg1LED led ledgGroup
        dashboard_set_property ${::BMS::dash_path} ledg1LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledg1LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledg1LED text "ledg1"
        dashboard_set_property ${::BMS::dash_path} ledg1LED color "green_off"
        dashboard_set_property ${::BMS::dash_path} ledg1LED preferredWidth $::BMS::width_ledg
        dashboard_set_property ${::BMS::dash_path} ledg1LED preferredHeight $::BMS::height_ledg
        # ledg0 widgets
        dashboard_add ${::BMS::dash_path} ledg0LED led ledgGroup
        dashboard_set_property ${::BMS::dash_path} ledg0LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledg0LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledg0LED text "ledg0"
        dashboard_set_property ${::BMS::dash_path} ledg0LED color "green_off"
        dashboard_set_property ${::BMS::dash_path} ledg0LED preferredWidth $::BMS::width_ledg
        dashboard_set_property ${::BMS::dash_path} ledg0LED preferredHeight $::BMS::height_ledg




####### 2. ledr_vir

        # ledr group widget
        dashboard_add ${::BMS::dash_path} ledrGroup group topGroup
        dashboard_set_property ${::BMS::dash_path} ledrGroup expandableX false
        dashboard_set_property ${::BMS::dash_path} ledrGroup expandableY false
        dashboard_set_property ${::BMS::dash_path} ledrGroup itemsPerRow 9
        dashboard_set_property ${::BMS::dash_path} ledrGroup title "ledr_vir state"
        dashboard_set_property ${::BMS::dash_path} ledrGroup preferredWidth $::BMS::width_ledr_group
        
        # ledr17 widgets
        dashboard_add ${::BMS::dash_path} ledr17LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr17LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr17LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr17LED text "ledr17"
        dashboard_set_property ${::BMS::dash_path} ledr17LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr17LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr17LED preferredHeight $::BMS::height_ledr
        # ledr16 widgets
        dashboard_add ${::BMS::dash_path} ledr16LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr16LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr16LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr16LED text "ledr16"
        dashboard_set_property ${::BMS::dash_path} ledr16LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr16LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr16LED preferredHeight $::BMS::height_ledr
        # ledr15 widgets
        dashboard_add ${::BMS::dash_path} ledr15LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr15LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr15LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr15LED text "ledr15"
        dashboard_set_property ${::BMS::dash_path} ledr15LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr15LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr15LED preferredHeight $::BMS::height_ledr
        # ledr14 widgets
        dashboard_add ${::BMS::dash_path} ledr14LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr14LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr14LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr14LED text "ledr14"
        dashboard_set_property ${::BMS::dash_path} ledr14LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr14LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr14LED preferredHeight $::BMS::height_ledr
        # ledr13 widgets
        dashboard_add ${::BMS::dash_path} ledr13LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr13LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr13LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr13LED text "ledr13"
        dashboard_set_property ${::BMS::dash_path} ledr13LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr13LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr13LED preferredHeight $::BMS::height_ledr
        # ledr12 widgets
        dashboard_add ${::BMS::dash_path} ledr12LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr12LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr12LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr12LED text "ledr12"
        dashboard_set_property ${::BMS::dash_path} ledr12LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr12LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr12LED preferredHeight $::BMS::height_ledr
        # ledr11 widgets
        dashboard_add ${::BMS::dash_path} ledr11LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr11LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr11LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr11LED text "ledr11"
        dashboard_set_property ${::BMS::dash_path} ledr11LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr11LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr11LED preferredHeight $::BMS::height_ledr
        # ledr10 widgets
        dashboard_add ${::BMS::dash_path} ledr10LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr10LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr10LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr10LED text "ledr10"
        dashboard_set_property ${::BMS::dash_path} ledr10LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr10LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr10LED preferredHeight $::BMS::height_ledr
        # ledr9 widgets
        dashboard_add ${::BMS::dash_path} ledr9LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr9LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr9LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr9LED text "ledr9"
        dashboard_set_property ${::BMS::dash_path} ledr9LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr9LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr9LED preferredHeight $::BMS::height_ledr
        # ledr8 widgets
        dashboard_add ${::BMS::dash_path} ledr8LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr8LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr8LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr8LED text "ledr8"
        dashboard_set_property ${::BMS::dash_path} ledr8LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr8LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr8LED preferredHeight $::BMS::height_ledr
        # ledr7 widgets
        dashboard_add ${::BMS::dash_path} ledr7LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr7LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr7LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr7LED text "ledr7"
        dashboard_set_property ${::BMS::dash_path} ledr7LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr7LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr7LED preferredHeight $::BMS::height_ledr
        # ledr6 widgets
        dashboard_add ${::BMS::dash_path} ledr6LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr6LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr6LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr6LED text "ledr6"
        dashboard_set_property ${::BMS::dash_path} ledr6LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr6LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr6LED preferredHeight $::BMS::height_ledr
        # ledr5 widgets
        dashboard_add ${::BMS::dash_path} ledr5LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr5LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr5LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr5LED text "ledr5"
        dashboard_set_property ${::BMS::dash_path} ledr5LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr5LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr5LED preferredHeight $::BMS::height_ledr
        # ledr4 widgets
        dashboard_add ${::BMS::dash_path} ledr4LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr4LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr4LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr4LED text "ledr4"
        dashboard_set_property ${::BMS::dash_path} ledr4LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr4LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr4LED preferredHeight $::BMS::height_ledr
        # ledr3 widgets
        dashboard_add ${::BMS::dash_path} ledr3LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr3LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr3LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr3LED text "ledr3"
        dashboard_set_property ${::BMS::dash_path} ledr3LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr3LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr3LED preferredHeight $::BMS::height_ledr
        # ledr2 widgets
        dashboard_add ${::BMS::dash_path} ledr2LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr2LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr2LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr2LED text "ledr2"
        dashboard_set_property ${::BMS::dash_path} ledr2LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr2LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr2LED preferredHeight $::BMS::height_ledr
        # ledr1 widgets
        dashboard_add ${::BMS::dash_path} ledr1LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr1LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr1LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr1LED text "ledr1"
        dashboard_set_property ${::BMS::dash_path} ledr1LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr1LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr10LED preferredHeight $::BMS::height_ledr
        # ledr0 widgets
        dashboard_add ${::BMS::dash_path} ledr0LED led ledrGroup
        dashboard_set_property ${::BMS::dash_path} ledr0LED expandableX false
        dashboard_set_property ${::BMS::dash_path} ledr0LED expandableY false
        dashboard_set_property ${::BMS::dash_path} ledr0LED text "ledr0"
        dashboard_set_property ${::BMS::dash_path} ledr0LED color "red_off"
        dashboard_set_property ${::BMS::dash_path} ledr0LED preferredWidth $::BMS::width_ledr
        dashboard_set_property ${::BMS::dash_path} ledr0LED preferredHeight $::BMS::height_ledr
        





####### 3. hex_vir

        # hex group widget
        dashboard_add ${::BMS::dash_path} hexGroup group topGroup
        dashboard_set_property ${::BMS::dash_path} hexGroup expandableX false
        dashboard_set_property ${::BMS::dash_path} hexGroup expandableY false
        dashboard_set_property ${::BMS::dash_path} hexGroup itemsPerRow 8
        dashboard_set_property ${::BMS::dash_path} hexGroup title "hex_vir state"
        
        # hex7 label
        dashboard_add ${::BMS::dash_path} label_hex7 label hexGroup
        dashboard_set_property ${::BMS::dash_path} label_hex7 text "hex7"
        dashboard_set_property ${::BMS::dash_path} label_hex7 preferredWidth $::BMS::width_hex_label
        dashboard_set_property ${::BMS::dash_path} label_hex7 preferredHeight $::BMS::height_hex_label
        # hex7 text
        dashboard_add ${::BMS::dash_path} text_hex7 text hexGroup
        dashboard_set_property ${::BMS::dash_path} text_hex7 text        0x00
        dashboard_set_property ${::BMS::dash_path} text_hex7 editable    0
        dashboard_set_property ${::BMS::dash_path} text_hex7 preferredWidth $::BMS::width_hex_text
        dashboard_set_property ${::BMS::dash_path} text_hex7 preferredHeight $::BMS::height_hex_text
        # hex6 label
        dashboard_add ${::BMS::dash_path} label_hex6 label hexGroup
        dashboard_set_property ${::BMS::dash_path} label_hex6 text "hex6"
        dashboard_set_property ${::BMS::dash_path} label_hex6 preferredWidth $::BMS::width_hex_label
        dashboard_set_property ${::BMS::dash_path} label_hex6 preferredHeight $::BMS::height_hex_label
        # hex6 text
        dashboard_add ${::BMS::dash_path} text_hex6 text hexGroup
        dashboard_set_property ${::BMS::dash_path} text_hex6 text        0x00
        dashboard_set_property ${::BMS::dash_path} text_hex6 editable    0
        dashboard_set_property ${::BMS::dash_path} text_hex6 preferredWidth $::BMS::width_hex_text
        dashboard_set_property ${::BMS::dash_path} text_hex6 preferredHeight $::BMS::height_hex_text
        # hex5 label
        dashboard_add ${::BMS::dash_path} label_hex5 label hexGroup
        dashboard_set_property ${::BMS::dash_path} label_hex5 text "hex5"
        dashboard_set_property ${::BMS::dash_path} label_hex5 preferredWidth $::BMS::width_hex_label
        dashboard_set_property ${::BMS::dash_path} label_hex5 preferredHeight $::BMS::height_hex_label
        # hex5 text
        dashboard_add ${::BMS::dash_path} text_hex5 text hexGroup
        dashboard_set_property ${::BMS::dash_path} text_hex5 text        0x00
        dashboard_set_property ${::BMS::dash_path} text_hex5 editable    0
        dashboard_set_property ${::BMS::dash_path} text_hex5 preferredWidth $::BMS::width_hex_text
        dashboard_set_property ${::BMS::dash_path} text_hex5 preferredHeight $::BMS::height_hex_text
        # hex4 label
        dashboard_add ${::BMS::dash_path} label_hex4 label hexGroup
        dashboard_set_property ${::BMS::dash_path} label_hex4 text "hex4"
        dashboard_set_property ${::BMS::dash_path} label_hex4 preferredWidth $::BMS::width_hex_label
        dashboard_set_property ${::BMS::dash_path} label_hex4 preferredHeight $::BMS::height_hex_label
        # hex4 text
        dashboard_add ${::BMS::dash_path} text_hex4 text hexGroup
        dashboard_set_property ${::BMS::dash_path} text_hex4 text        0x00
        dashboard_set_property ${::BMS::dash_path} text_hex4 editable    0
        dashboard_set_property ${::BMS::dash_path} text_hex4 preferredWidth $::BMS::width_hex_text
        dashboard_set_property ${::BMS::dash_path} text_hex4 preferredHeight $::BMS::height_hex_text
        # hex3 label
        dashboard_add ${::BMS::dash_path} label_hex3 label hexGroup
        dashboard_set_property ${::BMS::dash_path} label_hex3 text "hex3"
        dashboard_set_property ${::BMS::dash_path} label_hex3 preferredWidth $::BMS::width_hex_label
        dashboard_set_property ${::BMS::dash_path} label_hex3 preferredHeight $::BMS::height_hex_label
        # hex3 text
        dashboard_add ${::BMS::dash_path} text_hex3 text hexGroup
        dashboard_set_property ${::BMS::dash_path} text_hex3 text        0x00
        dashboard_set_property ${::BMS::dash_path} text_hex3 editable    0
        dashboard_set_property ${::BMS::dash_path} text_hex3 preferredWidth $::BMS::width_hex_text
        dashboard_set_property ${::BMS::dash_path} text_hex3 preferredHeight $::BMS::height_hex_text
        # hex2 label
        dashboard_add ${::BMS::dash_path} label_hex2 label hexGroup
        dashboard_set_property ${::BMS::dash_path} label_hex2 text "hex2"
        dashboard_set_property ${::BMS::dash_path} label_hex2 preferredWidth $::BMS::width_hex_label
        dashboard_set_property ${::BMS::dash_path} label_hex2 preferredHeight $::BMS::height_hex_label
        # hex2 text
        dashboard_add ${::BMS::dash_path} text_hex2 text hexGroup
        dashboard_set_property ${::BMS::dash_path} text_hex2 text        0x00
        dashboard_set_property ${::BMS::dash_path} text_hex2 editable    0
        dashboard_set_property ${::BMS::dash_path} text_hex2 preferredWidth $::BMS::width_hex_text
        dashboard_set_property ${::BMS::dash_path} text_hex2 preferredHeight $::BMS::height_hex_text
        # hex1 label
        dashboard_add ${::BMS::dash_path} label_hex1 label hexGroup
        dashboard_set_property ${::BMS::dash_path} label_hex1 text "hex1"
        dashboard_set_property ${::BMS::dash_path} label_hex1 preferredWidth $::BMS::width_hex_label
        dashboard_set_property ${::BMS::dash_path} label_hex1 preferredHeight $::BMS::height_hex_label
        # hex1 text
        dashboard_add ${::BMS::dash_path} text_hex1 text hexGroup
        dashboard_set_property ${::BMS::dash_path} text_hex1 text        0x00
        dashboard_set_property ${::BMS::dash_path} text_hex1 editable    0
        dashboard_set_property ${::BMS::dash_path} text_hex1 preferredWidth $::BMS::width_hex_text
        dashboard_set_property ${::BMS::dash_path} text_hex1 preferredHeight $::BMS::height_hex_text
        # hex0 label
        dashboard_add ${::BMS::dash_path} label_hex0 label hexGroup
        dashboard_set_property ${::BMS::dash_path} label_hex0 text "hex0"
        dashboard_set_property ${::BMS::dash_path} label_hex0 preferredWidth $::BMS::width_hex_label
        dashboard_set_property ${::BMS::dash_path} label_hex0 preferredHeight $::BMS::height_hex_label
        # hex0 text
        dashboard_add ${::BMS::dash_path} text_hex0 text hexGroup
        dashboard_set_property ${::BMS::dash_path} text_hex0 text        0x00
        dashboard_set_property ${::BMS::dash_path} text_hex0 editable    0
        dashboard_set_property ${::BMS::dash_path} text_hex0 preferredWidth $::BMS::width_hex_text
        dashboard_set_property ${::BMS::dash_path} text_hex0 preferredHeight $::BMS::height_hex_text




####### 4. key_vir

        # key group widget
        dashboard_add ${::BMS::dash_path} keyGroup group topGroup
        dashboard_set_property ${::BMS::dash_path} keyGroup expandableX false
        dashboard_set_property ${::BMS::dash_path} keyGroup expandableY false
        dashboard_set_property ${::BMS::dash_path} keyGroup itemsPerRow 4
        dashboard_set_property ${::BMS::dash_path} keyGroup title "key_vir state"


        # key3 widgets
        dashboard_add ${::BMS::dash_path} key3checkbox checkBox keyGroup 
        dashboard_set_property ${::BMS::dash_path} key3checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} key3checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} key3checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} key3checkbox text "key3"
        dashboard_set_property ${::BMS::dash_path} key3checkbox checked true
        dashboard_set_property ${::BMS::dash_path} key3checkbox preferredWidth $::BMS::width_key
        dashboard_set_property ${::BMS::dash_path} key3checkbox preferredHeight $::BMS::height_key
        # key2 widgets
        dashboard_add ${::BMS::dash_path} key2checkbox checkBox keyGroup 
        dashboard_set_property ${::BMS::dash_path} key2checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} key2checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} key2checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} key2checkbox text "key2"
        dashboard_set_property ${::BMS::dash_path} key2checkbox checked true
        dashboard_set_property ${::BMS::dash_path} key2checkbox preferredWidth $::BMS::width_key
        dashboard_set_property ${::BMS::dash_path} key2checkbox preferredHeight $::BMS::height_key
        # key1 widgets
        dashboard_add ${::BMS::dash_path} key1checkbox checkBox keyGroup 
        dashboard_set_property ${::BMS::dash_path} key1checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} key1checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} key1checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} key1checkbox text "key1"
        dashboard_set_property ${::BMS::dash_path} key1checkbox checked true
        dashboard_set_property ${::BMS::dash_path} key1checkbox preferredWidth $::BMS::width_key
        dashboard_set_property ${::BMS::dash_path} key1checkbox preferredHeight $::BMS::height_key
        # key0 widgets
        dashboard_add ${::BMS::dash_path} key0checkbox checkBox keyGroup 
        dashboard_set_property ${::BMS::dash_path} key0checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} key0checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} key0checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} key0checkbox text "key0"
        dashboard_set_property ${::BMS::dash_path} key0checkbox checked true
        dashboard_set_property ${::BMS::dash_path} key0checkbox preferredWidth $::BMS::width_key
        dashboard_set_property ${::BMS::dash_path} key0checkbox preferredHeight $::BMS::height_key




####### 5. sw_vir

        # sw group widget
        dashboard_add ${::BMS::dash_path} swGroup group topGroup
        dashboard_set_property ${::BMS::dash_path} swGroup expandableX false
        dashboard_set_property ${::BMS::dash_path} swGroup expandableY false
        dashboard_set_property ${::BMS::dash_path} swGroup itemsPerRow 9
        dashboard_set_property ${::BMS::dash_path} swGroup title "sw_vir state"

        # sw17 widgets
        dashboard_add ${::BMS::dash_path} sw17checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw17checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw17checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw17checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw17checkbox text "sw17"
        dashboard_set_property ${::BMS::dash_path} sw17checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw17checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw17checkbox preferredHeight $::BMS::height_sw
        # sw16 widgets
        dashboard_add ${::BMS::dash_path} sw16checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw16checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw16checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw16checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw16checkbox text "sw16"
        dashboard_set_property ${::BMS::dash_path} sw16checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw16checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw16checkbox preferredHeight $::BMS::height_sw
        # sw15 widgets
        dashboard_add ${::BMS::dash_path} sw15checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw15checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw15checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw15checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw15checkbox text "sw15"
        dashboard_set_property ${::BMS::dash_path} sw15checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw15checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw15checkbox preferredHeight $::BMS::height_sw
        # sw14 widgets
        dashboard_add ${::BMS::dash_path} sw14checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw14checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw14checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw14checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw14checkbox text "sw14"
        dashboard_set_property ${::BMS::dash_path} sw14checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw14checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw14checkbox preferredHeight $::BMS::height_sw
        # sw13 widgets
        dashboard_add ${::BMS::dash_path} sw13checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw13checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw13checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw13checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw13checkbox text "sw13"
        dashboard_set_property ${::BMS::dash_path} sw13checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw13checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw13checkbox preferredHeight $::BMS::height_sw
        # sw12 widgets
        dashboard_add ${::BMS::dash_path} sw12checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw12checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw12checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw12checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw12checkbox text "sw12"
        dashboard_set_property ${::BMS::dash_path} sw12checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw12checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw12checkbox preferredHeight $::BMS::height_sw
        # sw11 widgets
        dashboard_add ${::BMS::dash_path} sw11checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw11checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw11checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw11checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw11checkbox text "sw11"
        dashboard_set_property ${::BMS::dash_path} sw11checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw11checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw11checkbox preferredHeight $::BMS::height_sw
        # sw10 widgets
        dashboard_add ${::BMS::dash_path} sw10checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw10checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw10checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw10checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw10checkbox text "sw10"
        dashboard_set_property ${::BMS::dash_path} sw10checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw10checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw10checkbox preferredHeight $::BMS::height_sw
        # sw9 widgets
        dashboard_add ${::BMS::dash_path} sw9checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw9checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw9checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw9checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw9checkbox text "sw9"
        dashboard_set_property ${::BMS::dash_path} sw9checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw9checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw9checkbox preferredHeight $::BMS::height_sw
        # sw8 widgets
        dashboard_add ${::BMS::dash_path} sw8checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw8checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw8checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw8checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw8checkbox text "sw8"
        dashboard_set_property ${::BMS::dash_path} sw8checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw8checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw8checkbox preferredHeight $::BMS::height_sw
        # sw7 widgets
        dashboard_add ${::BMS::dash_path} sw7checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw7checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw7checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw7checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw7checkbox text "sw7"
        dashboard_set_property ${::BMS::dash_path} sw7checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw7checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw7checkbox preferredHeight $::BMS::height_sw
        # sw6 widgets
        dashboard_add ${::BMS::dash_path} sw6checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw6checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw6checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw6checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw6checkbox text "sw6"
        dashboard_set_property ${::BMS::dash_path} sw6checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw6checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw6checkbox preferredHeight $::BMS::height_sw
        # sw5 widgets
        dashboard_add ${::BMS::dash_path} sw5checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw5checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw5checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw5checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw5checkbox text "sw5"
        dashboard_set_property ${::BMS::dash_path} sw5checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw5checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw5checkbox preferredHeight $::BMS::height_sw
        # sw4 widgets
        dashboard_add ${::BMS::dash_path} sw4checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw4checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw4checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw4checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw4checkbox text "sw4"
        dashboard_set_property ${::BMS::dash_path} sw4checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw4checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw4checkbox preferredHeight $::BMS::height_sw
        # sw3 widgets
        dashboard_add ${::BMS::dash_path} sw3checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw3checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw3checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw3checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw3checkbox text "sw3"
        dashboard_set_property ${::BMS::dash_path} sw3checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw3checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw3checkbox preferredHeight $::BMS::height_sw
        # sw2 widgets
        dashboard_add ${::BMS::dash_path} sw2checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw2checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw2checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw2checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw2checkbox text "sw2"
        dashboard_set_property ${::BMS::dash_path} sw2checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw2checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw2checkbox preferredHeight $::BMS::height_sw
        # sw1 widgets
        dashboard_add ${::BMS::dash_path} sw1checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw1checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw1checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw1checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw1checkbox text "sw1"
        dashboard_set_property ${::BMS::dash_path} sw1checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw1checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw1checkbox preferredHeight $::BMS::height_sw
        # sw0 widgets
        dashboard_add ${::BMS::dash_path} sw0checkbox checkBox swGroup 
        dashboard_set_property ${::BMS::dash_path} sw0checkbox enabled true
        dashboard_set_property ${::BMS::dash_path} sw0checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw0checkbox expandableY false
        dashboard_set_property ${::BMS::dash_path} sw0checkbox text "sw0"
        dashboard_set_property ${::BMS::dash_path} sw0checkbox checked false
        dashboard_set_property ${::BMS::dash_path} sw0checkbox preferredWidth $::BMS::width_sw
        dashboard_set_property ${::BMS::dash_path} sw0checkbox preferredHeight $::BMS::height_sw




        after idle ::BMS::update_dashboard

        return -code ok

    }
    # end of proc dashBoard





#=======================================================================================================
# process: for updating pheriperal's state
#=======================================================================================================

    # read ledg, ledr, hex0 ~ hex7
    proc init {} {

        global jtag
        if {![info exists jtag(master)]} {
            jtag_open
        }
        
        
        set ::BMS::value_ledg   [expr [master_read_32  $jtag(master)  [ expr ${::BMS::base_addr_ledg} + 0]  [expr ${::BMS::size_read_32} + 0]]  &  0x1FF]
        set ::BMS::value_ledr   [expr [master_read_32  $jtag(master)  [ expr ${::BMS::base_addr_ledr} + 0]  [expr ${::BMS::size_read_32} + 0]]  &  0x3FFFF]
        set ::BMS::value_hex0   [expr [master_read_32  $jtag(master)  [ expr ${::BMS::base_addr_hex0} + 0]  [expr ${::BMS::size_read_32} + 0]]  &  0x7F]
        set ::BMS::value_hex1   [expr [master_read_32  $jtag(master)  [ expr ${::BMS::base_addr_hex1} + 0]  [expr ${::BMS::size_read_32} + 0]]  &  0x7F]
        set ::BMS::value_hex2   [expr [master_read_32  $jtag(master)  [ expr ${::BMS::base_addr_hex2} + 0]  [expr ${::BMS::size_read_32} + 0]]  &  0x7F]
        set ::BMS::value_hex3   [expr [master_read_32  $jtag(master)  [ expr ${::BMS::base_addr_hex3} + 0]  [expr ${::BMS::size_read_32} + 0]]  &  0x7F]
        set ::BMS::value_hex4   [expr [master_read_32  $jtag(master)  [ expr ${::BMS::base_addr_hex4} + 0]  [expr ${::BMS::size_read_32} + 0]]  &  0x7F]
        set ::BMS::value_hex5   [expr [master_read_32  $jtag(master)  [ expr ${::BMS::base_addr_hex5} + 0]  [expr ${::BMS::size_read_32} + 0]]  &  0x7F]
        set ::BMS::value_hex6   [expr [master_read_32  $jtag(master)  [ expr ${::BMS::base_addr_hex6} + 0]  [expr ${::BMS::size_read_32} + 0]]  &  0x7F]
        set ::BMS::value_hex7   [expr [master_read_32  $jtag(master)  [ expr ${::BMS::base_addr_hex7} + 0]  [expr ${::BMS::size_read_32} + 0]]  &  0x7F]
        
        
        
        
        
        
        
        
        set ::BMS::initialized  1
    
    
        if {[info exists jtag(master)]} {
            jtag_close
        }
    
    }





    # process for LEDG update state
    proc update_ledg {} {
        
        set  value_ledg8  [expr ( ${::BMS::value_ledg} >> 8) & {0x001}]
        set  value_ledg7  [expr ( ${::BMS::value_ledg} >> 7) & {0x001}]
        set  value_ledg6  [expr ( ${::BMS::value_ledg} >> 6) & {0x001}]
        set  value_ledg5  [expr ( ${::BMS::value_ledg} >> 5) & {0x001}]
        set  value_ledg4  [expr ( ${::BMS::value_ledg} >> 4) & {0x001}]
        set  value_ledg3  [expr ( ${::BMS::value_ledg} >> 3) & {0x001}]
        set  value_ledg2  [expr ( ${::BMS::value_ledg} >> 2) & {0x001}]
        set  value_ledg1  [expr ( ${::BMS::value_ledg} >> 1) & {0x001}]
        set  value_ledg0  [expr ( ${::BMS::value_ledg} >> 0) & {0x001}]
                
        # ledg8
        if {$value_ledg8} {
            dashboard_set_property  ${::BMS::dash_path}   ledg8LED     color green
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledg8LED     color green_off
        }
        # ledg7
        if {$value_ledg7} {
            dashboard_set_property  ${::BMS::dash_path}   ledg7LED     color green
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledg7LED     color green_off
        }
        # ledg6
        if {$value_ledg6} {
            dashboard_set_property  ${::BMS::dash_path}   ledg6LED     color green
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledg6LED     color green_off
        }
        # ledg5
        if {$value_ledg5} {
            dashboard_set_property  ${::BMS::dash_path}   ledg5LED     color green
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledg5LED     color green_off
        }
        # ledg4
        if {$value_ledg4} {
            dashboard_set_property  ${::BMS::dash_path}   ledg4LED     color green
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledg4LED     color green_off
        }
        # ledg3
        if {$value_ledg3} {
            dashboard_set_property  ${::BMS::dash_path}   ledg3LED     color green
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledg3LED     color green_off
        }
        # ledg2
        if {$value_ledg2} {
            dashboard_set_property  ${::BMS::dash_path}   ledg2LED     color green
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledg2LED     color green_off
        }
        # ledg1
        if {$value_ledg1} {
            dashboard_set_property  ${::BMS::dash_path}   ledg1LED     color green
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledg1LED     color green_off
        }
        # ledg0
        if {$value_ledg0} {
            dashboard_set_property  ${::BMS::dash_path}   ledg0LED     color green
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledg0LED     color green_off
        }

    
    }
    # end of process update_ledg






    # process for LEDR update state
    proc update_ledr {} {
    
        # 
        set value_ledr17    [expr ( ${::BMS::value_ledr} >> 17) & {0x001}]
        set value_ledr16    [expr ( ${::BMS::value_ledr} >> 16) & {0x001}]
        set value_ledr15    [expr ( ${::BMS::value_ledr} >> 15) & {0x001}]
        set value_ledr14    [expr ( ${::BMS::value_ledr} >> 14) & {0x001}]
        set value_ledr13    [expr ( ${::BMS::value_ledr} >> 13) & {0x001}]
        set value_ledr12    [expr ( ${::BMS::value_ledr} >> 12) & {0x001}]
        set value_ledr11    [expr ( ${::BMS::value_ledr} >> 11) & {0x001}]
        set value_ledr10    [expr ( ${::BMS::value_ledr} >> 10) & {0x001}]
        set value_ledr9     [expr ( ${::BMS::value_ledr} >> 9)  & {0x001}]
        set value_ledr8     [expr ( ${::BMS::value_ledr} >> 8)  & {0x001}]
        set value_ledr7     [expr ( ${::BMS::value_ledr} >> 7)  & {0x001}]
        set value_ledr6     [expr ( ${::BMS::value_ledr} >> 6)  & {0x001}]
        set value_ledr5     [expr ( ${::BMS::value_ledr} >> 5)  & {0x001}]
        set value_ledr4     [expr ( ${::BMS::value_ledr} >> 4)  & {0x001}]
        set value_ledr3     [expr ( ${::BMS::value_ledr} >> 3)  & {0x001}]
        set value_ledr2     [expr ( ${::BMS::value_ledr} >> 2)  & {0x001}]
        set value_ledr1     [expr ( ${::BMS::value_ledr} >> 1)  & {0x001}]
        set value_ledr0     [expr ( ${::BMS::value_ledr} >> 0)  & {0x001}]

        # ledr17
        if {$value_ledr17}  {
            dashboard_set_property  ${::BMS::dash_path}   ledr17LED   color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr17LED   color red_off
        }
        # ledr16
        if {$value_ledr16}  {
            dashboard_set_property  ${::BMS::dash_path}   ledr16LED   color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr16LED   color red_off
        }
        # ledr15
        if {$value_ledr15}  {
            dashboard_set_property  ${::BMS::dash_path}   ledr15LED   color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr15LED   color red_off
        }
        # ledr14
        if {$value_ledr14}  {
            dashboard_set_property  ${::BMS::dash_path}   ledr14LED   color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr14LED   color red_off
        }
        # ledr13
        if {$value_ledr13}  {
            dashboard_set_property  ${::BMS::dash_path}   ledr13LED   color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr13LED   color red_off
        }
        # ledr12
        if {$value_ledr12}  {
            dashboard_set_property  ${::BMS::dash_path}   ledr12LED   color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr12LED   color red_off
        }
        # ledr11
        if {$value_ledr11}  {
            dashboard_set_property  ${::BMS::dash_path}   ledr11LED   color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr11LED   color red_off
        }
        # ledr10
        if {$value_ledr10}  {
            dashboard_set_property  ${::BMS::dash_path}   ledr10LED   color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr10LED   color red_off
        }
        # ledr9
        if {$value_ledr9} {
            dashboard_set_property  ${::BMS::dash_path}   ledr9LED    color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr9LED    color red_off
        }
        # ledr8
        if {$value_ledr8} {
            dashboard_set_property  ${::BMS::dash_path}   ledr8LED    color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr8LED    color red_off
        }
        # ledr7
        if {$value_ledr7} {
            dashboard_set_property  ${::BMS::dash_path}   ledr7LED    color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr7LED    color red_off
        }
        # ledr6
        if {$value_ledr6} {
            dashboard_set_property  ${::BMS::dash_path}   ledr6LED    color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr6LED    color red_off
        }
        # ledr5
        if {$value_ledr5} {
            dashboard_set_property  ${::BMS::dash_path}   ledr5LED    color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr5LED    color red_off
        }
        # ledr4
        if {$value_ledr4} {
            dashboard_set_property  ${::BMS::dash_path}   ledr4LED    color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr4LED    color red_off
        }
        # ledr3
        if {$value_ledr3} {
            dashboard_set_property  ${::BMS::dash_path}   ledr3LED    color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr3LED    color red_off
        }
        # ledr2
        if {$value_ledr2} {
            dashboard_set_property  ${::BMS::dash_path}   ledr2LED    color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr2LED    color red_off
        }
        # ledr1
        if {$value_ledr1} {
            dashboard_set_property  ${::BMS::dash_path}   ledr1LED    color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr1LED    color red_off
        }
        # ledr0
        if {$value_ledr0} {
            dashboard_set_property  ${::BMS::dash_path}   ledr0LED    color red
        } else {
            dashboard_set_property  ${::BMS::dash_path}   ledr0LED    color red_off
        }
        
    }
    # end of process update_ledr







    # may be invoked by process update_hex
    proc hex_transition {hex_binary_value} {
        puts $hex_binary_value
        if {$hex_binary_value == 0x40} {
            return 4'h0
        } elseif {$hex_binary_value == 0x79} {
            return 4'h1
        } elseif {$hex_binary_value == 0x24} {
            return 4'h2
        } elseif {$hex_binary_value == 0x30} {
            return 4'h3
        } elseif {$hex_binary_value == 0x19} {
            return 4'h4
        } elseif {$hex_binary_value == 0x12} {
            return 4'h5
        } elseif {$hex_binary_value == 0x2} {
            return 4'h6
        } elseif {$hex_binary_value == 0x78} {
            return 4'h7
        } elseif {$hex_binary_value == 0x0} {
            return 4'h8
        } elseif {$hex_binary_value == 0x18} {
            return 4'h9
        } elseif {$hex_binary_value == 0x8} {
            return 4'hA
        } elseif {$hex_binary_value == 0x3} {
            return 4'hB
        } elseif {$hex_binary_value == 0x46} {
            return 4'hC
        } elseif {$hex_binary_value == 0x21} {
            return 4'hD
        } elseif {$hex_binary_value == 0x6} {
            return 4'hE
        } elseif {$hex_binary_value == 0xe} {
            return 4'hF
        } else {
            return invalid
        }

    }
    # end of process hex_transition


    # process for HEX update state
    proc update_hex {} {
    
        # hex
        set value_hex7_hex  [hex_transition ${::BMS::value_hex7}]
        set value_hex6_hex  [hex_transition ${::BMS::value_hex6}]
        set value_hex5_hex  [hex_transition ${::BMS::value_hex5}]
        set value_hex4_hex  [hex_transition ${::BMS::value_hex4}]
        set value_hex3_hex  [hex_transition ${::BMS::value_hex3}]
        set value_hex2_hex  [hex_transition ${::BMS::value_hex2}]
        set value_hex1_hex  [hex_transition ${::BMS::value_hex1}]
        set value_hex0_hex  [hex_transition ${::BMS::value_hex0}]
        
        dashboard_set_property ${::BMS::dash_path} text_hex7 text $value_hex7_hex
        dashboard_set_property ${::BMS::dash_path} text_hex6 text $value_hex6_hex
        dashboard_set_property ${::BMS::dash_path} text_hex5 text $value_hex5_hex
        dashboard_set_property ${::BMS::dash_path} text_hex4 text $value_hex4_hex
        dashboard_set_property ${::BMS::dash_path} text_hex3 text $value_hex3_hex
        dashboard_set_property ${::BMS::dash_path} text_hex2 text $value_hex2_hex
        dashboard_set_property ${::BMS::dash_path} text_hex1 text $value_hex1_hex
        dashboard_set_property ${::BMS::dash_path} text_hex0 text $value_hex0_hex

    }
    # end of process update_hex



    
    
    # process for updating key and sw
    proc update_keysw_checkbox [] {
        
        
        # key mask and inverted_mask
        variable mask_key3 [expr {0x01 << 3} & 0xF]
        variable mask_key2 [expr {0x01 << 2} & 0xF]
        variable mask_key1 [expr {0x01 << 1} & 0xF]
        variable mask_key0 [expr {0x01 << 0} & 0xF]
        variable inverted_mask_key3 [ expr ( 0xF ^ ${mask_key3} ) & 0xF ]
        variable inverted_mask_key2 [ expr ( 0xF ^ ${mask_key2} ) & 0xF ]
        variable inverted_mask_key1 [ expr ( 0xF ^ ${mask_key1} ) & 0xF ]
        variable inverted_mask_key0 [ expr ( 0xF ^ ${mask_key0} ) & 0xF ]
        
        # sw mask and inverted mask
        variable mask_sw17 [expr {0x00001 << 17} & 0x3FFFF]
        variable mask_sw16 [expr {0x00001 << 16} & 0x3FFFF]
        variable mask_sw15 [expr {0x00001 << 15} & 0x3FFFF]
        variable mask_sw14 [expr {0x00001 << 14} & 0x3FFFF]
        variable mask_sw13 [expr {0x00001 << 13} & 0x3FFFF]
        variable mask_sw12 [expr {0x00001 << 12} & 0x3FFFF]
        variable mask_sw11 [expr {0x00001 << 11} & 0x3FFFF]
        variable mask_sw10 [expr {0x00001 << 10} & 0x3FFFF]
        variable mask_sw9  [expr {0x00001 << 9}  & 0x3FFFF]
        variable mask_sw8  [expr {0x00001 << 8}  & 0x3FFFF]
        variable mask_sw7  [expr {0x00001 << 7}  & 0x3FFFF]
        variable mask_sw6  [expr {0x00001 << 6}  & 0x3FFFF]
        variable mask_sw5  [expr {0x00001 << 5}  & 0x3FFFF]
        variable mask_sw4  [expr {0x00001 << 4}  & 0x3FFFF]
        variable mask_sw3  [expr {0x00001 << 3}  & 0x3FFFF]
        variable mask_sw2  [expr {0x00001 << 2}  & 0x3FFFF]
        variable mask_sw1  [expr {0x00001 << 1}  & 0x3FFFF]
        variable mask_sw0  [expr {0x00001 << 0}  & 0x3FFFF]
        variable inverted_mask_sw17 [ expr ( 0x3FFFF ^ ${mask_sw17} ) & 0x3FFFF ]
        variable inverted_mask_sw16 [ expr ( 0x3FFFF ^ ${mask_sw16} ) & 0x3FFFF ]
        variable inverted_mask_sw15 [ expr ( 0x3FFFF ^ ${mask_sw15} ) & 0x3FFFF ]
        variable inverted_mask_sw14 [ expr ( 0x3FFFF ^ ${mask_sw14} ) & 0x3FFFF ]
        variable inverted_mask_sw13 [ expr ( 0x3FFFF ^ ${mask_sw13} ) & 0x3FFFF ]
        variable inverted_mask_sw12 [ expr ( 0x3FFFF ^ ${mask_sw12} ) & 0x3FFFF ]
        variable inverted_mask_sw11 [ expr ( 0x3FFFF ^ ${mask_sw11} ) & 0x3FFFF ]
        variable inverted_mask_sw10 [ expr ( 0x3FFFF ^ ${mask_sw10} ) & 0x3FFFF ]
        variable inverted_mask_sw9  [ expr ( 0x3FFFF ^ ${mask_sw9} )  & 0x3FFFF ]
        variable inverted_mask_sw8  [ expr ( 0x3FFFF ^ ${mask_sw8} )  & 0x3FFFF ]
        variable inverted_mask_sw7  [ expr ( 0x3FFFF ^ ${mask_sw7} )  & 0x3FFFF ]
        variable inverted_mask_sw6  [ expr ( 0x3FFFF ^ ${mask_sw6} )  & 0x3FFFF ]
        variable inverted_mask_sw5  [ expr ( 0x3FFFF ^ ${mask_sw5} )  & 0x3FFFF ]
        variable inverted_mask_sw4  [ expr ( 0x3FFFF ^ ${mask_sw4} )  & 0x3FFFF ]
        variable inverted_mask_sw3  [ expr ( 0x3FFFF ^ ${mask_sw3} )  & 0x3FFFF ]
        variable inverted_mask_sw2  [ expr ( 0x3FFFF ^ ${mask_sw2} )  & 0x3FFFF ]
        variable inverted_mask_sw1  [ expr ( 0x3FFFF ^ ${mask_sw1} )  & 0x3FFFF ]
        variable inverted_mask_sw0  [ expr ( 0x3FFFF ^ ${mask_sw0} )  & 0x3FFFF ]
        
        



        global jtag
        if {![info exists jtag(master)]} {
            jtag_open
        }




        # read key value
        set value_key   [expr [master_read_32  $jtag(master)  [ expr ${::BMS::base_addr_key} + 0]  [expr ${::BMS::size_read_32} + 0]] & 0xF]
        # read key's checkbox value
        set value_key3checkbox  [expr [dashboard_get_property ${::BMS::dash_path} key3checkbox checked]]
        set value_key2checkbox  [expr [dashboard_get_property ${::BMS::dash_path} key2checkbox checked]]
        set value_key1checkbox  [expr [dashboard_get_property ${::BMS::dash_path} key1checkbox checked]]
        set value_key0checkbox  [expr [dashboard_get_property ${::BMS::dash_path} key0checkbox checked]]
        
        
        if {$value_key3checkbox} {
            set value_key [ expr $value_key | $mask_key3]
        } else {
            set value_key [ expr $value_key & $inverted_mask_key3]
        }
        if {$value_key2checkbox} {
            set value_key [ expr $value_key | $mask_key2]
        } else {
            set value_key [ expr $value_key & $inverted_mask_key2]
        }
        if {$value_key1checkbox} {
            set value_key [ expr $value_key | $mask_key1]
        } else {
            set value_key [ expr $value_key & $inverted_mask_key1]
        }
        if {$value_key0checkbox} {
            set value_key [ expr $value_key | $mask_key0]
        } else {
            set value_key [ expr $value_key & $inverted_mask_key0]
        }
        
        # update key_vir value
        master_write_32  $jtag(master)  [ expr ${::BMS::base_addr_key} + 0]  ${value_key}
        
        





        # read sw value
        set value_sw   [expr [master_read_32  $jtag(master)  [ expr ${::BMS::base_addr_sw} + 0]  [expr ${::BMS::size_read_32} + 0]] & 0x3FFFF]
        # read sw's checkbox value
        set value_sw17checkbox  [expr [dashboard_get_property ${::BMS::dash_path} sw17checkbox checked]]
        set value_sw16checkbox  [expr [dashboard_get_property ${::BMS::dash_path} sw16checkbox checked]]
        set value_sw15checkbox  [expr [dashboard_get_property ${::BMS::dash_path} sw15checkbox checked]]
        set value_sw14checkbox  [expr [dashboard_get_property ${::BMS::dash_path} sw14checkbox checked]]
        set value_sw13checkbox  [expr [dashboard_get_property ${::BMS::dash_path} sw13checkbox checked]]
        set value_sw12checkbox  [expr [dashboard_get_property ${::BMS::dash_path} sw12checkbox checked]]
        set value_sw11checkbox  [expr [dashboard_get_property ${::BMS::dash_path} sw11checkbox checked]]
        set value_sw10checkbox  [expr [dashboard_get_property ${::BMS::dash_path} sw10checkbox checked]]
        set value_sw9checkbox   [expr [dashboard_get_property ${::BMS::dash_path} sw9checkbox checked]]
        set value_sw8checkbox   [expr [dashboard_get_property ${::BMS::dash_path} sw8checkbox checked]]
        set value_sw7checkbox   [expr [dashboard_get_property ${::BMS::dash_path} sw7checkbox checked]]
        set value_sw6checkbox   [expr [dashboard_get_property ${::BMS::dash_path} sw6checkbox checked]]
        set value_sw5checkbox   [expr [dashboard_get_property ${::BMS::dash_path} sw5checkbox checked]]
        set value_sw4checkbox   [expr [dashboard_get_property ${::BMS::dash_path} sw4checkbox checked]]
        set value_sw3checkbox   [expr [dashboard_get_property ${::BMS::dash_path} sw3checkbox checked]]
        set value_sw2checkbox   [expr [dashboard_get_property ${::BMS::dash_path} sw2checkbox checked]]
        set value_sw1checkbox   [expr [dashboard_get_property ${::BMS::dash_path} sw1checkbox checked]]
        set value_sw0checkbox   [expr [dashboard_get_property ${::BMS::dash_path} sw0checkbox checked]]

        if {$value_sw17checkbox} {
            set value_sw [ expr $value_sw | $mask_sw17]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw17]
        }
        if {$value_sw16checkbox} {
            set value_sw [ expr $value_sw | $mask_sw16]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw16]
        }
        if {$value_sw15checkbox} {
            set value_sw [ expr $value_sw | $mask_sw15]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw15]
        }
        if {$value_sw14checkbox} {
            set value_sw [ expr $value_sw | $mask_sw14]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw14]
        }
        if {$value_sw13checkbox} {
            set value_sw [ expr $value_sw | $mask_sw13]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw13]
        }
        if {$value_sw12checkbox} {
            set value_sw [ expr $value_sw | $mask_sw12]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw12]
        }
        if {$value_sw11checkbox} {
            set value_sw [ expr $value_sw | $mask_sw11]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw11]
        }
        if {$value_sw10checkbox} {
            set value_sw [ expr $value_sw | $mask_sw10]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw10]
        }
        if {$value_sw9checkbox} {
            set value_sw [ expr $value_sw | $mask_sw9]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw9]
        }
        if {$value_sw8checkbox} {
            set value_sw [ expr $value_sw | $mask_sw8]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw8]
        }
        if {$value_sw7checkbox} {
            set value_sw [ expr $value_sw | $mask_sw7]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw7]
        }
        if {$value_sw6checkbox} {
            set value_sw [ expr $value_sw | $mask_sw6]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw6]
        }
        if {$value_sw5checkbox} {
            set value_sw [ expr $value_sw | $mask_sw5]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw5]
        }
        if {$value_sw4checkbox} {
            set value_sw [ expr $value_sw | $mask_sw4]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw4]
        }
        if {$value_sw3checkbox} {
            set value_sw [ expr $value_sw | $mask_sw3]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw3]
        }
        if {$value_sw2checkbox} {
            set value_sw [ expr $value_sw | $mask_sw2]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw2]
        }
        if {$value_sw1checkbox} {
            set value_sw [ expr $value_sw | $mask_sw1]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw1]
        }
        if {$value_sw0checkbox} {
            set value_sw [ expr $value_sw | $mask_sw0]
        } else {
            set value_sw [ expr $value_sw & $inverted_mask_sw0]
        }


        # update key_vir value
        master_write_32  $jtag(master)  [ expr ${::BMS::base_addr_sw} + 0]  ${value_sw}


    
        if {[info exists jtag(master)]} {
            jtag_close
        }
        
        return -code ok
    
    }






#=======================================================================================================
# update dashboard
#=======================================================================================================

    proc update_dashboard {} {
        
        
        ::BMS::init
        
        if { ${::BMS::dashboardActive} > 0 } {
            if { ${::BMS::initialized} > 0 } {
                
                dashboard_set_property ${::BMS::dash_path} ledgGroup title "ledg_vir state"
                dashboard_set_property ${::BMS::dash_path} ledrGroup title "ledr_vir state"
                dashboard_set_property ${::BMS::dash_path} hexGroup title "hex_vir state"
                
                update_ledg
                update_ledr
                update_hex
                
                # update key state
                update_keysw_checkbox


                after 50 ::BMS::update_dashboard
            } else {
                dashboard_set_property ${::BMS::dash_path} ledgGroup title "Uninitialized"
                dashboard_set_property ${::BMS::dash_path} ledrGroup title "Uninitialized"
                dashboard_set_property ${::BMS::dash_path} hexGroup title "Uninitialized"
                after 500 ::BMS::update_dashboard
            }
        }
    
    
    
    }
    # end of proc update_dashboard






#=======================================================================================================
# main
#=======================================================================================================
    dashBoard



}
# end of namespace

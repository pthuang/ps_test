############################################
# Write Vivado BlockDesign to .tcl file  
############################################
# update_compile_order -fileset sources_1

# save bd to .tcl
# open_bd_design {D:/ZWT/temp/ps_test/src/bd/mb_sys/mb_sys.bd}
# write_bd_tcl -force D:/ZWT/temp/ps_test/src/bd/mb_sys.tcl
# close_bd_design [get_bd_designs mb_sys]

# open_bd_design {D:/ZWT/temp/ps_test/src/bd/zynq/zynq.bd}
# write_bd_tcl -force D:/ZWT/temp/ps_test/src/bd/zynq.tcl
# close_bd_design [get_bd_designs zynq]


############################################
# Delete Temporary Files 
############################################
# cd $tclDir
# file delete -force listBd.txt
# file delete -force listConstr.txt
# file delete -force listConstr.txt
# file delete -force listIp.txt
# file delete -force listSim.txt
# file delete -force listSrc.txt
# cd .. 
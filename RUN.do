vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -cover
add wave /top/fifoif/*
coverage save FIFO_UVM.ucdb -onexit -du work.FIFO
vcover report FIFO_UVM.ucdb -details -annotate -all -output FIFO_UVM_cvr_rpt.txt
run -all
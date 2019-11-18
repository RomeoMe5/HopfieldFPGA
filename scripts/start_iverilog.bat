iverilog -o tmpres -g2005 -I ../data -I ../verilog_src -I ../tb -s test_net ../tb/test_net.v ../tb/s_reg.v ../tb/w_reg.v ../verilog_src/net.v ../verilog_src/neuron.v 

vvp tmpres
gtkwave out.vcd
pause
del tmpres
del out.vcd
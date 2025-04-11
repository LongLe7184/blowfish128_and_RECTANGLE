onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /IBR128_tb_top/vif/trans_type_debug
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/Clk
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/RstN
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/CS
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/Write
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/Read
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/Addr
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/WData
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/RData
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/Enable
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/SA
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/Encrypt
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/FB
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/cipherReady
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/SOM
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/key0
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/key1
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/plainText
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/IV
add wave -noupdate -expand -group dut_wrapper /IBR128_tb_top/dut/cipherText
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_IV0
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_IV1
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_IV2
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_IV3
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_KEY0
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_KEY1
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_KEY2
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_KEY3
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_PT0
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_PT1
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_PT2
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_PT3
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_CT0
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_CT1
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_CT2
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_CT3
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_CTRL
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IBR128_STA
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/Clk
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/RstN
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/CS
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/Write
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/Read
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/Addr
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/WData
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/RData
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/Enable
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/SA
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/Encrypt
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/SOM
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/plainText
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/IV
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/FB
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/key0
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/key1
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/cipherText
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/cipherReady
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/data_reg
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/data_ro_reg
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/ctrl_reg
add wave -noupdate -expand -group csr /IBR128_tb_top/dut/IBR128_csr/status_reg
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/Clk
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/RstN
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/Enable
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/SA
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/Encrypt
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/SOM
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/plainText
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/IV
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/FB
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/key0
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/key1
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/cipherText
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/cipherReady
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/encrypt
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/block_start
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/sa
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/block_ready
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/pData
add wave -noupdate -expand -group core /IBR128_tb_top/dut/IBR128_core/eData
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/Clk
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/RstN
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/Enable
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/Encrypt
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/SOM
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/FB
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/plainText
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/key0
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/key1
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/SA
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/IV
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/cipherText
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/cipherReady
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/encrypt
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/block_start
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/pData
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/sa
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/block_ready
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/eData
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/modeSel
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/nextBlock_input
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/ctr
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/cipherText_reg
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/cipherReady_reg
add wave -noupdate -group core/opmode /IBR128_tb_top/dut/IBR128_core/IBR128_opmode/adder_en
add wave -noupdate -group core/encrypt /IBR128_tb_top/dut/IBR128_core/IBR128_encrypt/Clk
add wave -noupdate -group core/encrypt /IBR128_tb_top/dut/IBR128_core/IBR128_encrypt/RstN
add wave -noupdate -group core/encrypt /IBR128_tb_top/dut/IBR128_core/IBR128_encrypt/key0
add wave -noupdate -group core/encrypt /IBR128_tb_top/dut/IBR128_core/IBR128_encrypt/key1
add wave -noupdate -group core/encrypt /IBR128_tb_top/dut/IBR128_core/IBR128_encrypt/encrypt
add wave -noupdate -group core/encrypt /IBR128_tb_top/dut/IBR128_core/IBR128_encrypt/block_start
add wave -noupdate -group core/encrypt /IBR128_tb_top/dut/IBR128_core/IBR128_encrypt/pData
add wave -noupdate -group core/encrypt /IBR128_tb_top/dut/IBR128_core/IBR128_encrypt/sa
add wave -noupdate -group core/encrypt /IBR128_tb_top/dut/IBR128_core/IBR128_encrypt/block_ready
add wave -noupdate -group core/encrypt /IBR128_tb_top/dut/IBR128_core/IBR128_encrypt/eData
add wave -noupdate -group core/encrypt /IBR128_tb_top/dut/IBR128_core/IBR128_encrypt/blowfish_en
add wave -noupdate -group core/encrypt /IBR128_tb_top/dut/IBR128_core/IBR128_encrypt/rectangle_en
add wave -noupdate -group core/encrypt /IBR128_tb_top/dut/IBR128_core/IBR128_encrypt/blowfish_eText
add wave -noupdate -group core/encrypt /IBR128_tb_top/dut/IBR128_core/IBR128_encrypt/blowfish_eReady
add wave -noupdate -group core/encrypt /IBR128_tb_top/dut/IBR128_core/IBR128_encrypt/rectangle_eText1
add wave -noupdate -group core/encrypt /IBR128_tb_top/dut/IBR128_core/IBR128_encrypt/rectangle_eText2
add wave -noupdate -group core/encrypt /IBR128_tb_top/dut/IBR128_core/IBR128_encrypt/rectangle_eReady1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {497 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1869 ns}

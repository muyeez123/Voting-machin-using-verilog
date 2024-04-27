//`include "Voting_machine
`timescale 1ns/1ns                             // 1 time unit = 1 ns

module tb_voting_machine ();
reg t_clk;
reg t_rst;
reg t_BJP;
reg t_INC;
reg t_JDS;
reg t_vote_over;

  wire [5:0] t_result_BJP;
  wire [5:0] t_result_INC;
  wire [5:0] t_result_JDS;

voting_machine uut ( 
.clk(t_clk), 
.rst(t_rst), 
  .i_BJP(t_BJP), 
  .i_INC(t_INC), 
  .i_JDS(t_JDS), 
.i_voting_over(t_vote_over),
  .o_BJP(t_result_BJP),
  .o_INC(t_result_INC),
  .o_JDS(t_result_JDS)
);


initial t_clk = 1'b1;

always
begin
    #5 t_clk = ~ t_clk;     
end

initial
begin
  $monitor ("time = %d, rst = %b, BJP = %b, INC = %b, JDS = %b, vote_over = %b, result_1 = %3d, result_2 = %3d, result_3 = %3d,\n",
    $time, t_rst, t_BJP, t_INC, t_JDS, t_vote_over, t_result_BJP, t_result_INC, t_result_JDS,);

    
    t_rst = 1'b1;
    t_BJP = 1'b0;
    t_INC = 1'b0;
    t_JDS = 1'b0;
    t_vote_over = 1'b0;

    #20 t_rst = 1'b0;
    #10 t_BJP = 1'b1;              //when button for candidate 1 is pressed
    #10 t_INC = 1'b0;              //button  for candidate 1 is released

    #20 t_INC = 1'b1;              //when button for candidate 2 is pressed
    #10 t_INC = 1'b0;              //button  for candidate 2 is released

    #20 t_BJP = 1'b1;              //when button for candidate 1 is pressed
    #10 t_BJP = 1'b0;              //button  for candidate 1 is released

    #20 t_JDS = 1'b1;               //when button for candidate 3 is pressed
    #10 t_JDS = 1'b0;               //button  for candidate 3 is released
  
    #20 t_INC = 1'b1;
    #10 t_INC = 1'b0;

    #20 t_INC = 1'b1;
    #10 t_INC = 1'b0;
    
    #20 t_BJP = 1'b1;
    #10 t_BJP = 1'b0;
    
    #20 t_JDS = 1'b1;               //when button for candidate 3 is pressed
    #10 t_JDS = 1'b0;               //button  for candidate 3 is released


    #30 t_vote_over = 1'b1;

    #50 t_rst = 1'b1;                               
    #60 $stop;   //INSTEAD OFSTOP WE CAN USE FINISH TOO                            
end

//.vcd file for gtk wave plot
initial
begin
    $dumpfile ("voting_dumpfile.vcd");
    $dumpvars (0, tb_voting_machine);
end


endmodule

//voting machine of 3 candidates 
module voting_machine #(
parameter idle =  2'b00,					
parameter vote =  2'b01,
parameter hold =  2'b10,
parameter finish = 2'b11
)(
    input clk,							
    input rst,							 
    input i_BJP,				// input to vote for candidate 1
    input i_INC,				// input to vote for candidate 2
    input i_JDS,				// input to vote for candidate 3
    input i_voting_over,				// input high to get total votes after voting is over

  output reg [31:0] o_BJP,			// output for total number of votes of candidate 1
  output reg [31:0] o_INC,			// output for total number of votes of candidate 2
  output reg [31:0] o_JDS			// output for total number of votes of candidate 3
);	  

  reg [31:0] r_BJP_prev;					// store previous value of input for candidate 1
  reg [31:0] r_INC_prev;					// store previous value of input for candidate 2
  reg [31:0] r_JDS_prev;					// store previous value of input for candidate 3

reg [31:0] r_counter_1;						// counting register for candidate 1
reg [31:0] r_counter_2;						// counting register for candidate 2
reg [31:0] r_counter_3;						// counting register for candidate 3

reg [1:0] r_present_state, r_next_state;		// present state and next 
reg [3:0] r_hold_count;                        //counter for hold state

always @(posedge clk or negedge rst)
	begin
		case (r_present_state)												

			idle: if (!rst)												
						begin
							r_next_state <= vote;							
						end	

					else
						begin
						
							r_counter_1 <= 32'b0;							
							r_counter_2 <= 32'b0;
							r_counter_3 <= 32'b0;
							r_hold_count <= 4'b0000;
							r_next_state <= idle;							
						end
			vote: if (i_voting_over == 1'b1)									
						begin
							r_next_state <= finish;							
						end
									
          else if (i_BJP == 1'b0 && r_BJP_prev == 1'b1)       
						begin
							r_counter_1 <= r_counter_1 + 1'b1;				
							r_next_state <= hold;
                        end

          else if (i_INC == 1'b0 && r_INC_prev == 1'b1) 		
						begin
							r_counter_2 <= r_counter_2 + 1'b1;	
                          r_next_state <= hold;								
						end

          else if (i_JDS == 1'b0 && r_JDS_prev == 1'b1) 	
						begin
							
							r_counter_3 <= r_counter_3 + 1'b1;							
							r_next_state <= hold;									
						end
					else															
						begin
							r_counter_1 <= r_counter_1;						
							r_counter_2 <= r_counter_2;						
							r_counter_3 <= r_counter_3;
							r_next_state <= vote;
							
						end

			hold: if (i_voting_over == 1'b1)									
						begin
							r_next_state <= finish;									
						end

					else 
						begin
							if (r_hold_count != 4'b1111) begin
								r_hold_count = r_hold_count + 1'b1;
							end
							else begin
							    r_next_state <= vote;						
							end
						end

			finish: if (i_voting_over == 1'b0)										
						begin
							r_next_state <= idle;							
						end

					else
						begin
							r_next_state <= finish;							
						end
			default: 
				begin 
					r_counter_1 <= 32'b0;									
					r_counter_2 <= 32'b0;
					r_counter_3 <= 32'b0;
					r_hold_count <= 4'b0000;

					r_next_state <= idle;
				end
		endcase
	end	  
always @(posedge clk or negedge rst)													
	begin				

      if (rst == 1'b1)
			begin
				 r_present_state <= idle;									
													
				 o_BJP <= 32'b0; 											 
				 o_INC <= 32'b0;
				 o_JDS <= 32'b0;
				 r_hold_count <= 4'b0000;
			end 
			
		else if (rst == 1'b0 && i_voting_over == 1'b1)						
			begin
				 o_BJP <= r_counter_1; 										
				 o_INC <= r_counter_2;
				 o_JDS <= r_counter_3;
			end
		
		else
			begin
				r_present_state <= r_next_state;							
				r_BJP_prev <= i_BJP;									
				r_INC_prev <= i_INC;
				r_JDS_prev <= i_JDS;
			end
	
	end	

endmodule

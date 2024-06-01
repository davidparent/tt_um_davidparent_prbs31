/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none
module tt_um_davidparent_hdl (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    reg [30:0] lfsr;
    reg [30:0] lfsr_test;
    reg [60:0] lfsr_big;
    reg [8:0] InputA;
    reg [7:0] InputB;
    reg [2:0] out;
    always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
        lfsr <= 31'd1; 
        lfsr_test <= 31'd1;  
        lfsr_big <=61'd1;
        InputA<=9'b000000000;  
        InputB<=8'b00000000;  
        out<=3'b000;    
    end else begin
        lfsr[0] <= lfsr[27] ^ lfsr[30] ;
        lfsr[30:1] <=lfsr[29:0] ;  
        lfsr_big[0] <= lfsr_big[29] ^ lfsr_big[60] ;
        lfsr_big[60:1] <=lfsr_big[59:0] ; 
        InputA[8]<=ui_in[0];
        lfsr_test[0] <= InputA[8];
        lfsr_test[30:1] <=lfsr_test[29:0] ;
        InputA[7:1]<=ui_in[7:1];
        InputB[7:1]<=uio_in[7:1];
        out[0]<=InputA[0] & InputB[0];
        out[1]<=InputA[0];
        out[2]<=InputA[0] & out[1];
        if (InputA[7:1]<lfsr[30:24]) begin
            InputA[0]<=1'b0;
        end else begin
            InputA[0]<=1'b1;
        end 
        if (InputB[7:1]<lfsr[30:24]) begin
            InputB[0]<=1'b0;
        end else begin
            InputB[0]<=1'b1;
        end 
    end
end  
  // All output pins must be assigned. If not used, assign to 0. 
  assign uo_out[0] =lfsr[30] ;
  assign uo_out[1] =InputA[8]^(lfsr_test[27] ^ lfsr_test[30] );   
  assign uo_out[2] =   InputA[0];
  assign uo_out[3] =   InputB[0]; 
  assign uo_out[4] = out[0];
  assign uo_out[5] = out[2];    
  assign uo_out[7:6] = lfsr_big[60:59];    
  assign uio_out = 0;
  assign uio_oe  = 0;
 // assign uo_out[7:6]= 2'b00;
  // List all unused inputs to prevent 
    wire _unused = &{ena, uio_in[0], 1'b0}; 
endmodule


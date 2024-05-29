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


reg [15:0] counter;    // Counter for generating frequency

always @(posedge clk or posedge rst_n) begin
    if (rst_n) begin
        counter <= 16'd0; // Reset counter
        uio_out[0] <= 1'b0;       // Ensure output is low on reset
    end else begin
        // Increment counter on each clock cycle
        counter <= counter + 1;
        // Toggle output when counter reaches half of its maximum value
        if (counter == 16'd32768) begin
            uio_out[0] <= ~uio_out[0];
        end
    end
end

endmodule
  // All output pins must be assigned. If not used, assign to 0.
  // assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out[7:1] = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, 1'b0};

endmodule

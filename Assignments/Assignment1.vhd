// Half Adder
module half_adder (output sum,output carry,input a,input b);
    xor(sum,a,b);
    and(carry,a,b);
endmodule




// Full Adder
module full_adder (output sum,output carry,input a,input b,input c);
    wire s1, c1, c2;
    half_adder ha1(s1,c1,a,b);
    half_adder ha2(sum,c2,s1,c);
    or(carry,c1,c2);
endmodule




// 4X1 Multiplexer
module mux_4to1 (output y,input i0,input i1,input i2,input i3,input [1:0] sel);
    wire a0,a1,a2,a3;
    and(a0,i0,~sel[0],~sel[1]);
    and(a1,i1,sel[0],~sel[1]);
    and(a2,i2,~sel[0],sel[1]);
    and(a3,i3,sel[0],sel[1]);
    or(y,a0,a1,a2,a3);
endmodule




// Final Module
module final (
    output [2:0] y,
    output [2:0] c_out,
    input [2:0] a,
    input [2:0] b,
    input [1:0] sel
);
    wire [5:0]m;

    mux_4to1 mux0(m[0] , a[0] , a[0] , a[0] , b[0] , sel);
    mux_4to1 mux1(m[1] , 1'b1 , b[0] , b[0] , 1'b1 , sel);
    mux_4to1 mux2(m[2] , a[1] , a[1] , a[1] , b[1] , sel);
    mux_4to1 mux3(m[3] , 1'b0 , b[1] , b[1] , 1'b0 , sel);
    mux_4to1 mux4(m[4] , a[2] , a[2] , a[2] , b[2] , sel);
    mux_4to1 mux5(m[5] , 1'b0 , b[2] , b[2] , 1'b0 , sel);
    
    full_adder f0(y[0] , c_out[0] , m[0]^sel[1] , m[1] , sel[1]);
    full_adder f1(y[1] , c_out[1] , m[2]^sel[1] , m[3] , c_out[0]);
    full_adder f2(y[2] , c_out[2] , m[4]^sel[1] , m[5] , c_out[1]);
    
endmodule;







// Testbench Module
`timescale 1ns / 1ps

module tb_final;

  // Inputs
  reg [2:0] a;
  reg [2:0] b;
  reg [1:0] sel;

  // Outputs
  wire [2:0] y;
  wire [2:0]carry_out;
  wire [5:0]m;
  // Instantiate the module
  final uut (y,carry_out,a,b,sel);
  
  // Testbench stimulus
  initial begin
  $monitor($time, " a=%b, b=%b, ,sel=%b, y=%b, carry_out=%b", a, b, sel,y, carry_out);
  
    // Test case
    for(integer i = 0;i<8;i++)begin 
        for(integer j = 0;j<8;j++)begin 
            for(integer s = 0;s<4;s++)begin 
                a <= i;
                b <=j;
                sel <= s;
                #10;
            end
        end
    end
  end
endmodule;
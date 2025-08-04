`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zuofu Cheng
// 
// Create Date: 12/11/2022 10:48:49 AM
// Design Name: 
// Module Name: mb_usb_hdmi_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Top level for mb_lwusb test project, copy mb wrapper here from Verilog and modify
// to SV
// Dependencies: microblaze block design
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mb_usb_hdmi_top(
    input logic Clk,
    input logic reset_rtl_0,
    
    //USB signals
    input logic [0:0] gpio_usb_int_tri_i,
    output logic gpio_usb_rst_tri_o,
    input logic usb_spi_miso,
    output logic usb_spi_mosi,
    output logic usb_spi_sclk,
    output logic usb_spi_ss,
    
    //UART
    input logic uart_rtl_0_rxd,
    output logic uart_rtl_0_txd,
    
    //HDMI
    output logic hdmi_tmds_clk_n,
    output logic hdmi_tmds_clk_p,
    output logic [2:0]hdmi_tmds_data_n,
    output logic [2:0]hdmi_tmds_data_p,
        
    //HEX displays
    output logic [7:0] hex_segA,
    output logic [3:0] hex_gridA,
    output logic [7:0] hex_segB,
    output logic [3:0] hex_gridB
    );
    
    logic [31:0] keycode0_gpio, keycode1_gpio;
    logic clk_25MHz, clk_125MHz, clk, clk_100MHz;
    logic locked;
    logic [9:0] drawX, drawY;
    logic [9:0]  xpos, ypos;
    logic [9:0]  ghost1x, ghost1y, ghost2x, ghost2y, ghost3x, ghost3y, ghost4x, ghost4y;

    logic hsync, vsync, vde;
    logic [3:0] red, green, blue;
    logic reset_ah;
    
    assign reset_ah = reset_rtl_0;
    
    logic pwin;
    //Keycode HEX drivers
    logic [15:0]score;
    logic [3:0]decimal5 = score/10000;
    logic [3:0]decimal4 = (score - (decimal5)*10000)/1000;
    logic [3:0]decimal3 = (score - ((decimal5)*10000) - (decimal4 * 1000))/100;
    logic [3:0]decimal2 = (score - ((decimal5)*10000) - (decimal4 * 1000) - (decimal3 *100))/10;
    logic [3:0]decimal1 = (score - ((decimal5)*10000) - (decimal4 * 1000) - (decimal3 *100) - (decimal2 * 10));
    
    HexDriver HexA (
        .clk(Clk),
        .reset(reset_ah),
        .in({{4'b0}, {4'b0}, {4'b0}, {decimal5}}),
        .hex_seg(hex_segA),
        .hex_grid(hex_gridA)
    );
    
    HexDriver HexB (
        .clk(Clk),
        .reset(reset_ah),
        .in({{decimal4}, {decimal3}, {decimal2}, {decimal1}}),
        .hex_seg(hex_segB),
        .hex_grid(hex_gridB)
    );
    
    mb_block mb_block_i(
        .clk_100MHz(Clk),
        .gpio_usb_int_tri_i(gpio_usb_int_tri_i),
        .gpio_usb_keycode_0_tri_o(keycode0_gpio),
        .gpio_usb_keycode_1_tri_o(keycode1_gpio),
        .gpio_usb_rst_tri_o(gpio_usb_rst_tri_o),
        .reset_rtl_0(~reset_ah), //Block designs expect active low reset, all other modules are active high
        .uart_rtl_0_rxd(uart_rtl_0_rxd),
        .uart_rtl_0_txd(uart_rtl_0_txd),
        .usb_spi_miso(usb_spi_miso),
        .usb_spi_mosi(usb_spi_mosi),
        .usb_spi_sclk(usb_spi_sclk),
        .usb_spi_ss(usb_spi_ss)
    );
        
    //clock wizard configured with a 1x and 5x clock for HDMI
    clk_wiz_0 clk_wiz (
        .clk_out1(clk_25MHz),
        .clk_out2(clk_125MHz),
        .reset(reset_ah),
        .locked(locked),
        .clk_in1(Clk)
    );
    logic clk25;
    clk_wiz_0 clk_wiz2 (
        .clk_out1(clk25),
        .clk_out2(),
        .reset(reset_ah),
        .locked(1'b0),
        .clk_in1(Clk)
    );
    
    //VGA Sync signal generator
    vga_controller vga (
        .pixel_clk(clk_25MHz),
        .reset(reset_ah),
        .hs(hsync),
        .vs(vsync),
        .active_nblank(vde),
        .drawX(drawX),
        .drawY(drawY)
    );    

    //Real Digital VGA to HDMI converter
    hdmi_tx_0 vga_to_hdmi (
        //Clocking and Reset
        .pix_clk(clk_25MHz),
        .pix_clkx5(clk_125MHz),
        .pix_clk_locked(locked),
        //Reset is active LOW
        .rst(reset_ah),
        //Color and Sync Signals
        .red(red),
        .green(green),
        .blue(blue),
        .hsync(hsync),
        .vsync(vsync),
        .vde(vde),
        
        //aux Data (unused)
        .aux0_din(4'b0),
        .aux1_din(4'b0),
        .aux2_din(4'b0),
        .ade(1'b0),
        
        //Differential outputs
        .TMDS_CLK_P(hdmi_tmds_clk_p),          
        .TMDS_CLK_N(hdmi_tmds_clk_n),          
        .TMDS_DATA_P(hdmi_tmds_data_p),         
        .TMDS_DATA_N(hdmi_tmds_data_n)          
    );
    
     

    
    logic player_wins = (score == 16'h6978);
    logic player_loses = (dist1) || (dist2) || (dist3) || (dist4);
    logic [2:0] curD;
    logic dist1 = ((((xpos - ghost1x) * (xpos - ghost1x)) + ((ypos - ghost1y) * (ypos - ghost1y))) <= 100);
    logic dist2 = ((((xpos - ghost2x) * (xpos - ghost2x)) + ((ypos - ghost2y) * (ypos - ghost2y))) <= 100);
    logic dist3 = ((((xpos - ghost3x) * (xpos - ghost3x)) + ((ypos - ghost3y) * (ypos - ghost3y))) <= 100);
    logic dist4 = ((((xpos - ghost4x) * (xpos - ghost4x)) + ((ypos - ghost4y) * (ypos - ghost4y))) <= 100);
    
    logic move;
    //Ball Module
    ball pacman(
        .Reset(reset_ah),
        .frame_clk(vsync),                    //Figure out what this should be so that the ball will move
        .keycode(keycode0_gpio[7:0]),    //Notice: only one keycode connected to ball by default
        .xpos(xpos),
        .ypos(ypos),
        .curDir(curD),
        .move(move)
    );
    
    logic [1:0]g1curD;
    logic [1:0]g2curD;
    logic [1:0]g3curD;
    logic [1:0]g4curD;    
    logic [1:0]rpath;
    ghost ghost1(.Reset(reset_ah),
                 .frame_clk(vsync),
                 .start({9'd272, 9'd240}),
                 .seed(2881),
                 .xpos(ghost1x),
                 .ypos(ghost1y),
                 .curD(g1curD),
                 .speed(score/9000));
    ghost ghost2(.Reset(reset_ah),
                 .frame_clk(vsync),
                 .start({9'd283, 9'd240}),
                 .seed(2970),
                 .xpos(ghost2x),
                 .ypos(ghost2y),
                 .curD(g2curD),
                 .speed(score/9000));
    ghost ghost3(.Reset(reset_ah),
                 .frame_clk(vsync),
                 .start({9'd277, 9'd240}),
                 .seed(969),
                 .xpos(ghost3x),
                 .ypos(ghost3y),
                 .curD(g3curD),
                 .speed(score/9000));
    ghost ghost4(.Reset(reset_ah),
                 .frame_clk(vsync),
                 .start({9'd288, 9'd240}),
                 .seed(1971),
                 .xpos(ghost4x),
                 .ypos(ghost4y),
                 .curD(g4curD),
                 .speed(score/9000));
    //Color Mapper Module   
    
    color_mapper color_instance(
        .Reset(reset_ah),
        .score(score),
        .DrawX(drawX),
        .DrawY(drawY),
        .move(move),
        .curD(curD),
        .clk(vsync),
        .xpos(xpos),
        .ypos(ypos),
        .g1xpos(ghost1x),
        .g1ypos(ghost1y),
        .g2xpos(ghost2x),
        .g2ypos(ghost2y),
        .g3xpos(ghost3x),
        .g3ypos(ghost3y),
        .g4xpos(ghost4x),
        .g4ypos(ghost4y),
        .g1d(g1curD),
        .g2d(g2curD),
        .g3d(g3curD),
        .g4d(g4curD),
        .Red(red),
        .Green(green),
        .Blue(blue),
        .pwin(pwin));    
endmodule
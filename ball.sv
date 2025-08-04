//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI Lab                                --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input logic Reset, frame_clk,
			   input logic [7:0] keycode,
               output logic [9:0]  xpos, ypos,
               output logic [2:0]curDir,
               output logic move);
    logic [29:0]map[30];
    assign map[0][29:0]  = 30'b111111111111111111111111111111;
    assign map[1][29:0]  = 30'b100000000000001100000000000001;
    assign map[2][29:0]  = 30'b101111110111101101111011111101;
    assign map[3][29:0]  = 30'b101111110111101101111011111101;
    assign map[4][29:0]  = 30'b101111110111101101111011111101;
    assign map[5][29:0]  = 30'b100000000000000000000000000001;
    assign map[6][29:0]  = 30'b101111110110111111011011111101;
    assign map[7][29:0]  = 30'b101111110110111111011011111101;
    assign map[8][29:0]  = 30'b100000000110001100011000000001;
    assign map[9][29:0]  = 30'b111111110111101101111011111111;
    assign map[10][29:0] = 30'b111111110111101101111011111111;
    assign map[11][29:0] = 30'b111111110111101101111011111111;
    assign map[12][29:0] = 30'b111111110110000000011011111111;
    assign map[13][29:0] = 30'b111111110110110011011011111111;
    assign map[14][29:0] = 30'b000000000000100001000000000000;
    assign map[15][29:0] = 30'b111111110110100001011011111111;
    assign map[16][29:0] = 30'b111111110110111111011011111111;
    assign map[17][29:0] = 30'b111111110110000000011011111111;
    assign map[18][29:0] = 30'b111111110110111111011011111111;
    assign map[19][29:0] = 30'b111111110110111111011011111111;
    assign map[20][29:0] = 30'b111111110110111111011011111111;
    assign map[21][29:0] = 30'b100000000000001100000000000001;
    assign map[22][29:0] = 30'b101111110111101101111011111101;
    assign map[23][29:0] = 30'b100000110000000000000011000001;
    assign map[24][29:0] = 30'b111110110101111111101011011111;
    assign map[25][29:0] = 30'b111110110101111111101011011111;
    assign map[26][29:0] = 30'b100000000100001100001000000001;
    assign map[27][29:0] = 30'b101111111111101101111111111101;
    assign map[28][29:0] = 30'b100000000000000000000000000001;
    assign map[29][29:0] = 30'b111111111111111111111111111111;
    logic [2:0]curD;
    assign curDir = curD;
    always_ff @ (posedge frame_clk or posedge Reset) //make sure the frame clock is instantiated correctly
    begin: Move_Player
        if (Reset)  // asynchronous Reset
        begin 
            xpos <= 272;
            ypos <= 368;
            curD <= 3'b011;
            move <= 1'b0;
        end
                
        else 
        begin   
				 if (keycode == 8'h1A && (map[(ypos-1)/16][(xpos-32)/16] == 0) && (map[(ypos-1)/16][((xpos-32) + 15)/16] == 0))
				    begin
                        ypos <= ypos - 10'd1;
                        curD <= 3'b000;
                        move <= 1'b1;
                    end
                 else if (keycode == 8'h04 && (map[(ypos/16)][((xpos-32)-1)/16] == 0) && (map[((ypos + 15)/16)][((xpos-32)-1)/16] == 0))
                     begin
                        curD <= 3'b001;
                        move <= 1'b1;
                        if(xpos == 10'b0000010001)
                            xpos <= 510;         
                        else
                            begin
                                xpos <= xpos - 10'd1;   
                            end
                     end
				 else if (keycode == 8'h16 && (map[(ypos/16) + 1][(xpos-32)/16] == 0) && (map[(ypos/16) + 1][((xpos-32)+15)/16] == 0))
				    begin
                        ypos <= ypos + 10'd1;
                        curD <= 3'b010;
                        move <= 1'b1;
                    end
                 else if (keycode == 8'h07 && (map[(ypos/16)][((xpos-32)/16) + 1] == 0) && (map[((ypos+15)/16)][((xpos-32)/16) + 1] == 0))
                    begin
                        curD <= 3'b011;
                        move <= 1'b1;
                        if(xpos == 10'b1000000000)
                            xpos <= 18;
                        else 
                        begin
                            xpos <= xpos + 10'd1;                         
                        end
                    end
                 else
                    begin
                        if(curD == 3'b000 && (map[(ypos-1)/16][(xpos-32)/16] == 0) && (map[(ypos-1)/16][((xpos-32) + 15)/16] == 0)) 
                            begin
                                ypos <= ypos - 10'd1;
                                move <= 1'b1;
                            end
                        else if(curD == 3'b001 && (map[(ypos/16)][((xpos-32)-1)/16] == 0) && (map[((ypos + 15)/16)][((xpos-32)-1)/16] == 0)) 
                            begin
                                move <= 1'b1;
                                if(xpos == 10'b0000010001)
                                    xpos <= 510;         
                                else
                                    begin
                                        xpos <= xpos - 10'd1;   
                                    end                               
                            end
                        else if(curD == 3'b010 && (map[(ypos/16) + 1][(xpos-32)/16] == 0) && (map[(ypos/16) + 1][((xpos-32)+15)/16] == 0)) 
                            begin
                                ypos <= ypos + 10'd1;
                                move <= 1'b1;
                            end
                        else if(curD == 3'b011 && (map[(ypos/16)][((xpos-32)/16) + 1] == 0) && (map[((ypos+15)/16)][((xpos-32)/16) + 1] == 0)) 
                            begin
                                move <= 1'b1;
                                if(xpos == 10'b1000000000)
                                    xpos <= 18;
                                else 
                                begin
                                    xpos <= xpos + 10'd1;                         
                                end
                            end
                        else 
                            move <= 1'b0; 
                    end
		end  
    end
      
endmodule
module  ghost (input logic Reset, frame_clk,
			   input logic [17:0]start,
			   input logic [15:0]seed,
			   input logic [15:0] speed,
               output logic [9:0]  xpos, ypos,
               output logic [1:0] curD);
               
               



               
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
    assign map[13][29:0] = 30'b111111110110111111011011111111;
    assign map[14][29:0] = 30'b000000000000110011000000000000;
    assign map[15][29:0] = 30'b111111110110110011011011111111;
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
    logic move;
    logic [1:0]pathnum;
    assign pathnum = ((map[(ypos-1)/16][(xpos-32)/16] == 0) && (map[(ypos-1)/16][((xpos-32) + 15)/16] == 0))
                    +((map[(ypos/16)][((xpos-32)-1)/16] == 0) && (map[((ypos + 15)/16)][((xpos-32)-1)/16] == 0))
                    +((map[(ypos/16) + 1][(xpos-32)/16] == 0) && (map[(ypos/16) + 1][((xpos-32)+15)/16] == 0))
                    +((map[(ypos/16)][((xpos-32)/16) + 1] == 0) && (map[((ypos+15)/16)][((xpos-32)/16) + 1] == 0));
    logic [3:0] paths;
    assign paths[0] = ((map[(ypos-1)/16][(xpos-32)/16] == 0) && (map[(ypos-1)/16][((xpos-32) + 15)/16] == 0));
    assign paths[1] = ((map[(ypos/16)][((xpos-32)-1)/16] == 0) && (map[((ypos + 15)/16)][((xpos-32)-1)/16] == 0));
    assign paths[2] = ((map[(ypos/16) + 1][(xpos-32)/16] == 0) && (map[(ypos/16) + 1][((xpos-32)+15)/16] == 0));
    assign paths[3] = ((map[(ypos/16)][((xpos-32)/16) + 1] == 0) && (map[((ypos+15)/16)][((xpos-32)/16) + 1] == 0));
    logic [15:0] lfsr;
    logic x;
    logic [1:0] rpath;
    assign rpath[1:0] = lfsr % 4;
    always_ff @ (posedge frame_clk or posedge Reset) //make sure the frame clock is instantiated correctly
    begin: Move_Player
        if (Reset)  // asynchronous Reset
        begin 
            xpos <= start[17:9];
            ypos <= start[8:0];
            curD <= 2'b00;
            move <= 1'b1;
            lfsr <= seed;
        end
        else
            begin
            x <= lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10];
            lfsr <= {lfsr[14:0], x};
            if((xpos/16)>= 17 && (xpos/16) <= 18 && ypos >= 193 && ypos <= 240)
                        begin                        
                            curD <= 2'b00;
                            ypos <= ypos - 1;
                        end
            else if ((pathnum > 2) || move == 0)                
                begin
                    if(rpath == (curD + 2'b10))
                    begin
                        x <= lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10];
                        lfsr <= {lfsr[14:0], x};
                    end
                    if(paths[rpath[1:0]] == 1'b1)
                        begin
                            curD <= rpath[1:0]; 
                            move <= 1'b1;
                            if(rpath[1:0] == 2'b00)
                                begin
                                    ypos <= ypos - 10'd1; 
                                end
                            else if(rpath[1:0] == 2'b01)
                                begin
                                    if(xpos == 10'b0000010001)
                                        xpos <= 510;         
                                    else
                                        begin
                                            xpos <= xpos - 10'd1;   
                                        end
                                end
                            else if(rpath[1:0] == 2'b10)
                                begin
                                    ypos <= ypos + 10'd1; 
                                end
                            else
                                begin
                                    if(xpos == 10'b1000000000)
                                        xpos <= 18;
                                    else 
                                        begin
                                            xpos <= xpos + 10'd1;                         
                                        end
                                end                    
                        end                                    
                end
                else               
                begin 
                     if ((curD == 2'b00) && (map[(ypos-1)/16][(xpos-32)/16] == 0) && (map[(ypos-1)/16][((xpos-32) + 15)/16] == 0))
                        begin
                            ypos <= ypos - 10'd1;
                            curD <= 2'b00;
                            move <= 1'b1;
                        end
                     else if ((curD == 2'b01) && (map[(ypos/16)][((xpos-32)-1)/16] == 0) && (map[((ypos + 15)/16)][((xpos-32)-1)/16] == 0))
                         begin
                            curD <= 2'b01;
                            move <= 1'b1;
                            if(xpos == 10'b0000010001)
                                xpos <= 510;         
                            else
                                begin
                                    xpos <= xpos - 10'd1;   
                                end
                         end
                     else if ((curD == 2'b10) && (map[(ypos/16) + 1][(xpos-32)/16] == 0) && (map[(ypos/16) + 1][((xpos-32)+15)/16] == 0))
                        begin
                            ypos <= ypos + 10'd1;
                            curD <= 2'b10;
                            move <= 1'b1;
                        end
                     else if (curD == 2'b11 && (map[(ypos/16)][((xpos-32)/16) + 1] == 0) && (map[((ypos+15)/16)][((xpos-32)/16) + 1] == 0))
                        begin
                            curD <= 2'b11;
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
                            if(curD == 2'b00 && (map[(ypos-1)/16][(xpos-32)/16] == 0) && (map[(ypos-1)/16][((xpos-32) + 15)/16] == 0)) 
                                begin
                                    ypos <= ypos - 10'd1;
                                    move <= 1'b1;
                                end
                            else if(curD == 2'b01 && (map[(ypos/16)][((xpos-32)-1)/16] == 0) && (map[((ypos + 15)/16)][((xpos-32)-1)/16] == 0)) 
                                begin
                                    move <= 1'b1;
                                    if(xpos == 10'b0000010001)
                                        xpos <= 510;         
                                    else
                                        begin
                                            xpos <= xpos - 10'd1;   
                                        end                               
                                end
                            else if(curD == 2'b10 && (map[(ypos/16) + 1][(xpos-32)/16] == 0) && (map[(ypos/16) + 1][((xpos-32)+15)/16] == 0)) 
                                begin
                                    ypos <= ypos + 10'd1;
                                    move <= 1'b1;
                                end
                            else if(curD == 2'b11 && (map[(ypos/16)][((xpos-32)/16) + 1] == 0) && (map[((ypos+15)/16)][((xpos-32)/16) + 1] == 0)) 
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
//                if(speed == 1)
//                    begin
                        
//                    end
//                if(speed == 2)
//                    begin
//                    end
          end 
    end
      
endmodule
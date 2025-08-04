module  color_mapper (input logic [9:0] DrawX, DrawY,
                      input logic [9:0] xpos, ypos,
                      input logic [9:0] g1xpos, g1ypos, g2xpos, g2ypos,g3xpos, g3ypos,g4xpos, g4ypos,
                      input logic [1:0] g1d, g2d, g3d, g4d, 
                      input logic clk,
                      input logic Reset,
                      input logic move,
                      input logic [2:0] curD,
                      output logic [3:0]  Red, Green, Blue,
                      output logic [15:0] score,
                      output logic pwin);
    logic [10:0] sprite_addr;
    logic [7:0] sprite_data;
    font_rom font(.addr(sprite_addr), .data(sprite_data));
    
    logic map_on;
    logic score_on;
    logic player_on;
    logic ghost1_on;    
    logic ghost2_on;
    logic ghost3_on;
    logic ghost4_on;
    logic pellet_on;
    logic eyes_on;
    logic winscreen;
    logic lostscreen;
    logic [5:0] xcord, ycord;
    assign xcord = DrawX/16;
    assign ycord = DrawY/16;
    logic ploss;
    logic [5:0] counter;
    logic [2:0] c = 0;
    logic [9:0]dist1,dist2,dist3,dist4;
    logic [15:0]data5, data4, data3, data2, data1;
    assign counter = c[2:1] * 16;
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
    
    logic [29:0]pellets[30];
    
    
    logic [15:0]pacman[48];
    assign pacman[0][15:0] =  16'b0000000000000000;
    assign pacman[1][15:0] =  16'b0000001111000000;
    assign pacman[2][15:0] =  16'b0000111111110000;
    assign pacman[3][15:0] =  16'b0001111111111000;
    assign pacman[4][15:0] =  16'b0011111111111100;
    assign pacman[5][15:0] =  16'b0011111111111100;
    assign pacman[6][15:0] =  16'b0111111111111110;
    assign pacman[7][15:0] =  16'b0111111111111110;
    assign pacman[8][15:0] =  16'b0111111111111110;
    assign pacman[9][15:0] =  16'b0111111111111110;
    assign pacman[10][15:0] = 16'b0011111111111100;
    assign pacman[11][15:0] = 16'b0011111111111100;
    assign pacman[12][15:0] = 16'b0001111111111000;
    assign pacman[13][15:0] = 16'b0000111111110000;
    assign pacman[14][15:0] = 16'b0000001111000000;
    assign pacman[15][15:0] = 16'b0000000000000000;
    
    assign pacman[16][15:0] = 16'b0000000000000000;
    assign pacman[17][15:0] = 16'b0000001111000000;
    assign pacman[18][15:0] = 16'b0000111111110000;
    assign pacman[19][15:0] = 16'b0001111111111000;
    assign pacman[20][15:0] = 16'b0011111111111100;
    assign pacman[21][15:0] = 16'b0011111111110000;
    assign pacman[22][15:0] = 16'b0111111110000000;
    assign pacman[23][15:0] = 16'b0111111000000000;
    assign pacman[24][15:0] = 16'b0111110000000000;
    assign pacman[25][15:0] = 16'b0111111100000000;
    assign pacman[26][15:0] = 16'b0011111111110000;
    assign pacman[27][15:0] = 16'b0011111111111100;
    assign pacman[28][15:0] = 16'b0001111111111000;
    assign pacman[29][15:0] = 16'b0000111111110000;
    assign pacman[30][15:0] = 16'b0000001111000000;
    assign pacman[31][15:0] = 16'b0000000000000000;
    
    assign pacman[32][15:0] = 16'b0000000000000000;
    assign pacman[33][15:0] = 16'b0000001111000000;
    assign pacman[34][15:0] = 16'b0000111111110000;
    assign pacman[35][15:0] = 16'b0001111111110000;
    assign pacman[36][15:0] = 16'b0011111111100000;
    assign pacman[37][15:0] = 16'b0011111110000000;
    assign pacman[38][15:0] = 16'b0111111000000000;
    assign pacman[39][15:0] = 16'b0111110000000000;
    assign pacman[40][15:0] = 16'b0111110000000000;
    assign pacman[41][15:0] = 16'b0111111000000000;
    assign pacman[42][15:0] = 16'b0011111110000000;
    assign pacman[43][15:0] = 16'b0011111111100000;
    assign pacman[44][15:0] = 16'b0001111111110000;
    assign pacman[45][15:0] = 16'b0000111111110000;
    assign pacman[46][15:0] = 16'b0000001111000000;
    assign pacman[47][15:0] = 16'b0000000000000000;
    
    logic [15:0]ghost[16];
    assign ghost[0][15:0]  = 16'b0000000000000000;
    assign ghost[1][15:0]  = 16'b0000001111000000;
    assign ghost[2][15:0]  = 16'b0000111111110000;
    assign ghost[3][15:0]  = 16'b0001111111111000;
    assign ghost[4][15:0]  = 16'b0011111111111100;
    assign ghost[5][15:0]  = 16'b0011001111001100;
    assign ghost[6][15:0]  = 16'b0010000110000100;
    assign ghost[7][15:0]  = 16'b0110000110000110;
    assign ghost[8][15:0]  = 16'b0110000110000110;
    assign ghost[9][15:0]  = 16'b0111001111001110;
    assign ghost[10][15:0] = 16'b0111111111111110;
    assign ghost[11][15:0] = 16'b0111111111111110;
    assign ghost[12][15:0] = 16'b0111111111111110;
    assign ghost[13][15:0] = 16'b0110111001110110;
    assign ghost[14][15:0] = 16'b0100011001100010;
    assign ghost[15][15:0] = 16'b0000000000000000;

    logic [3:0]decimal5 = score/10000;
    logic [3:0]decimal4 = (score - (decimal5)*10000)/1000;
    logic [3:0]decimal3 = (score - ((decimal5)*10000) - (decimal4 * 1000))/100;
    logic [3:0]decimal2 = (score - ((decimal5)*10000) - (decimal4 * 1000) - (decimal3 *100))/10;
    logic [3:0]decimal1 = (score - ((decimal5)*10000) - (decimal4 * 1000) - (decimal3 *100) - (decimal2 * 10));
 
    always_ff @ (posedge clk or posedge Reset)
    begin
          if(Reset)
          begin      
                 score <= 0; 
                 pwin <= 0;
                 ploss <= 0;    
                 pellets[0][29:0]  <= 30'b111111111111111111111111111111;
                 pellets[1][29:0]  <= 30'b100000000000001100000000000001;
                 pellets[2][29:0]  <= 30'b101111110111101101111011111101;
                 pellets[3][29:0]  <= 30'b101111110111101101111011111101;
                 pellets[4][29:0]  <= 30'b101111110111101101111011111101;
                 pellets[5][29:0]  <= 30'b100000000000000000000000000001;
                 pellets[6][29:0]  <= 30'b101111110110111111011011111101;
                 pellets[7][29:0]  <= 30'b101111110110111111011011111101;
                 pellets[8][29:0]  <= 30'b100000000110001100011000000001;
                 pellets[9][29:0]  <= 30'b111111110111101101111011111111;
                 pellets[10][29:0] <= 30'b111111110111101101111011111111;
                 pellets[11][29:0] <= 30'b111111110111101101111011111111;
                 pellets[12][29:0] <= 30'b111111110111111111111011111111;
                 pellets[13][29:0] <= 30'b111111110111111111111011111111;
                 pellets[14][29:0] <= 30'b111111110001111111100011111111;
                 pellets[15][29:0] <= 30'b111111110111111111111011111111;
                 pellets[16][29:0] <= 30'b111111110111111111111011111111;
                 pellets[17][29:0] <= 30'b111111110111111111111011111111;
                 pellets[18][29:0] <= 30'b111111110110111111011011111111;
                 pellets[19][29:0] <= 30'b111111110110111111011011111111;
                 pellets[20][29:0] <= 30'b111111110110111111011011111111;
                 pellets[21][29:0] <= 30'b100000000000001100000000000001;
                 pellets[22][29:0] <= 30'b101111110111101101111011111101;
                 pellets[23][29:0] <= 30'b100000110000000000000011000001;
                 pellets[24][29:0] <= 30'b111110110101111111101011011111;
                 pellets[25][29:0] <= 30'b111110110101111111101011011111;
                 pellets[26][29:0] <= 30'b100000000100001100001000000001;
                 pellets[27][29:0] <= 30'b101111111111101101111111111101;
                 pellets[28][29:0] <= 30'b100000000000000000000000000001;
                 pellets[29][29:0] <= 30'b111111111111111111111111111111; 
          end
          else
            begin
                dist1 <= ((xpos - g1xpos)**2 + (ypos - g1ypos)**2) < 100;
                dist2 <= ((xpos - g2xpos)**2 + (ypos - g2ypos)**2) < 100;
                dist3 <= ((xpos - g3xpos)**2 + (ypos - g3ypos)**2) < 100;
                dist4 <= ((xpos - g4xpos)**2 + (ypos - g4ypos)**2) < 100;
                if (dist1 || dist2  || dist3 || dist4) begin
                    ploss <= 1;
                end                 
                if(pellets[((ypos + 8)/16)][((xpos + 8)/16) - 2] == 0 && ploss == 1'b0)
                begin
                    pellets[((ypos + 8)/16)][((xpos + 8)/16) - 2] <= 1'b1;
                    score <= score + 100;                    
                end
                if(c == 3'b101)
                    c <= 0;
                else
                    c <= c + 1;           
            end
    end
 
always_comb
begin
        
        if (DrawX <= 511 && DrawX >= 32)
            begin
                if(score == 16'h6978)
                    begin
                        winscreen = 1'b1;
                    end
                else if(ploss == 1'b1)
                    begin
                        lostscreen = 1'b1;
                    end
                else if(map[ycord][xcord - 2] == 1'b1) 
                    begin
                        winscreen = 1'b0;
                        lostscreen = 1'b0; 
                        score_on = 1'b0;
                        player_on = 1'b0;
                        ghost1_on = 1'b0;
                        ghost2_on = 1'b0;
                        ghost3_on = 1'b0;
                        ghost4_on = 1'b0; 
                        map_on = 1'b0;
                        pellet_on = 1'b0;
                        eyes_on = 1'b0;
                        if((xcord >= 3) && map[ycord][xcord - 3] == 1'b0)
                            begin
                                if(DrawX >= (16*(xcord)) && DrawX <= (16*(xcord) + 2))
                                    begin
                                        if(DrawY % 5 != 0)
                                            begin
                                                map_on = 1'b1;
                                            end
                                    end
                            end
                       if((xcord <= 30) && map[ycord][xcord - 1] == 1'b0)
                            begin
                                if(DrawX <= (16*(xcord) + 15) && DrawX >= (16*(xcord) + 13))
                                    begin
                                        if(DrawY % 5 != 0)
                                            begin
                                                map_on = 1'b1;
                                            end
                                    end
                            end
                      if((ycord >= 1) && map[ycord - 1][xcord - 2] == 1'b0)
                            begin
                                if(DrawY >= (16*(ycord)) && DrawY <= (16*(ycord)+2))
                                    begin
                                        if(DrawX % 5 != 0)
                                            begin
                                                map_on = 1'b1;
                                            end
                                    end
                            end
                      if((ycord <= 28) && map[ycord + 1][xcord - 2] == 1'b0)
                            begin
                                if(DrawY >= (16*(ycord) + 13) && DrawY <= (16*(ycord)+15))
                                    begin
                                        if(DrawX % 5 != 0)
                                            begin
                                                map_on = 1'b1;
                                            end
                                    end
                            end
                          
                        
                    end
                else 
                    begin                        
                        map_on = 1'b0;
                        score_on = 1'b0;
                        player_on = 1'b0;
                        ghost1_on = 1'b0;
                        ghost2_on = 1'b0;
                        ghost3_on = 1'b0;
                        ghost4_on = 1'b0; 
                        pellet_on = 1'b0;                        
                        eyes_on = 1'b0;
                        if(DrawX >= xpos && DrawX <= xpos + 15 && DrawY >= ypos && DrawY <= ypos + 15 ) 
                            begin
                                if(move == 1'b1)
                                    begin
                                        if(curD == 3'b000)
                                            begin
                                                if(pacman[(DrawX - xpos) + counter][DrawY - ypos] == 1'b1)
                                                    begin
                                                        player_on = 1'b1;
                                                    end   
                                            end
                                        else if(curD == 3'b001)
                                            begin
                                                if(pacman[((DrawY - ypos) + counter)][DrawX - xpos] == 1'b1)
                                                    begin
                                                        player_on = 1'b1;
                                                    end   
                                            end
                                        else if(curD == 3'b010)
                                            begin
                                                if(pacman[((DrawX - xpos) + counter)][16 - (DrawY - ypos)] == 1'b1)
                                                    begin
                                                        player_on = 1'b1;
                                                    end   
                                            end
                                        else
                                            begin
                                                if(pacman[((DrawY - ypos) + counter)][16 - (DrawX - xpos)] == 1'b1)
                                                    begin
                                                        player_on = 1'b1;
                                                    end   
                                            end
                                    end
                                    
                                else 
                                    begin
                                        
                                            if(curD == 3'b000)
                                                begin
                                                    if(pacman[(DrawX - xpos) + 16][DrawY - ypos] == 1'b1)
                                                        begin
                                                            player_on = 1'b1;
                                                        end   
                                                end
                                            else if(curD == 3'b001)
                                                begin
                                                    if(pacman[((DrawY - ypos) + 16)][DrawX - xpos] == 1'b1)
                                                        begin
                                                            player_on = 1'b1;
                                                        end   
                                                end
                                            else if(curD == 3'b010)
                                                begin
                                                    if(pacman[((DrawX - xpos) + 16)][16 - (DrawY - ypos)] == 1'b1)
                                                        begin
                                                            player_on = 1'b1;
                                                        end   
                                                end
                                            else
                                                begin
                                                    if(pacman[((DrawY - ypos) + 16)][16 - (DrawX - xpos)] == 1'b1)
                                                        begin
                                                            player_on = 1'b1;
                                                        end   
                                                end                                                                        
                                        end                                                     
                                end
                   if(DrawX >= g1xpos && DrawX <= g1xpos + 15 && DrawY >= g1ypos && DrawY <= g1ypos + 15)
                        begin
                            if(player_on == 1'b0)
                                begin
                                    if(ghost[((DrawY - g1ypos))][16 - (DrawX - g1xpos)] == 1'b1)
                                        ghost1_on = 1'b1;
                                    else if(g1d == 2'b00)
                                        begin
                                            if(((((DrawX) >= (5 + g1xpos) && (DrawX) <= (6 + g1xpos)) || ((DrawX) >= (11 + g1xpos) && (DrawX) <= (12 + g1xpos))) && ((DrawY) >= (5 + g1ypos) && (DrawY) <= (6 + g1ypos))))
                                                        begin
                                                                eyes_on = 1'b1; 
                                                        end
                                        end
                                    else if(g1d == 2'b01)
                                        begin
                                            if(((((DrawX) >= (4 + g1xpos) && (DrawX) <= (5 + g1xpos)) || ((DrawX) >= (10 + g1xpos) && (DrawX) <= (11 + g1xpos))) && ((DrawY) >= (6 + g1ypos) && (DrawY) <= (7 + g1ypos))))
                                                        begin
                                                                eyes_on = 1'b1; 
                                                        end
                                        end
                                    else if(g1d == 2'b10)
                                        begin
                                            if(((((DrawX) >= (5 + g1xpos) && (DrawX) <= (6 + g1xpos)) || ((DrawX) >= (11 + g1xpos) && (DrawX) <= (12 + g1xpos))) && ((DrawY) >= (8 + g1ypos) && (DrawY) <= (9 + g1ypos))))
                                                        begin
                                                                eyes_on = 1'b1; 
                                                        end
                                        end
                                    else
                                        begin
                                            if(((((DrawX) >= (6 + g1xpos) && (DrawX) <= (7 + g1xpos)) || ((DrawX) >= (12 + g1xpos) && (DrawX) <= (13 + g1xpos))) && ((DrawY) >= (6 + g1ypos) && (DrawY) <= (7 + g1ypos))))
                                                        begin
                                                                eyes_on = 1'b1; 
                                                        end
                                        end
                                end
                        end
                   if(DrawX >= g2xpos && DrawX <= g2xpos + 15 && DrawY >= g2ypos && DrawY <= g2ypos + 15)
                        begin
                            if(player_on == 1'b0 && ghost1_on == 1'b0)
                                begin
                                    if(ghost[((DrawY - g2ypos))][16 - (DrawX - g2xpos)] == 1'b1) begin
                                        ghost2_on = 1'b1;
                                        end 
                                    if(g2d == 2'b00)
                                        begin
                                            if(((((DrawX) >= (5 + g2xpos) && (DrawX) <= (6 + g2xpos)) || ((DrawX) >= (11 + g2xpos) && (DrawX) <= (12 + g2xpos))) && ((DrawY) >= (5 + g2ypos) && (DrawY) <= (6 + g2ypos))))
                                                        begin
                                                                eyes_on = 1'b1; 
                                                        end
                                        end
                                    else if(g2d == 2'b01)
                                        begin
                                            if(((((DrawX) >= (4 + g2xpos) && (DrawX) <= (5 + g2xpos)) || ((DrawX) >= (10 + g2xpos) && (DrawX) <= (11 + g2xpos))) && ((DrawY) >= (6 + g2ypos) && (DrawY) <= (7 + g2ypos))))
                                                        begin
                                                                eyes_on = 1'b1; 
                                                        end
                                        end
                                    else if(g2d == 2'b10)
                                        begin
                                            if(((((DrawX) >= (5 + g2xpos) && (DrawX) <= (6 + g2xpos)) || ((DrawX) >= (11 + g2xpos) && (DrawX) <= (12 + g2xpos))) && ((DrawY) >= (8 + g2ypos) && (DrawY) <= (9 + g2ypos))))
                                                        begin
                                                                eyes_on = 1'b1; 
                                                        end
                                        end
                                    else
                                        begin
                                            if(((((DrawX) >= (6 + g2xpos) && (DrawX) <= (7 + g2xpos)) || ((DrawX) >= (12 + g2xpos) && (DrawX) <= (13 + g2xpos))) && ((DrawY) >= (6 + g2ypos) && (DrawY) <= (7 + g2ypos))))
                                                        begin
                                                                eyes_on = 1'b1; 
                                                        end
                                        end                                                                        
                                end
                        end
                  if(DrawX >= g3xpos && DrawX <= g3xpos + 15 && DrawY >= g3ypos && DrawY <= g3ypos + 15)
                        begin
                            if((player_on == 1'b0) && (ghost1_on == 1'b0) && (ghost2_on == 1'b0))
                                begin
                                    if(ghost[((DrawY - g3ypos))][16 - (DrawX - g3xpos)] == 1'b1)
                                        ghost3_on = 1'b1;
                                
                                    if(g3d == 2'b00)
                                        begin
                                            if(((((DrawX) >= (5 + g3xpos) && (DrawX) <= (6 + g3xpos)) || ((DrawX) >= (11 + g3xpos) && (DrawX) <= (12 + g3xpos))) && ((DrawY) >= (5 + g3ypos) && (DrawY) <= (6 + g3ypos))))
                                                        begin
                                                                eyes_on = 1'b1; 
                                                        end
                                        end
                                    else if(g3d == 2'b01)
                                        begin
                                            if(((((DrawX) >= (4 + g3xpos) && (DrawX) <= (5 + g3xpos)) || ((DrawX) >= (10 + g3xpos) && (DrawX) <= (11 + g3xpos))) && ((DrawY) >= (6 + g3ypos) && (DrawY) <= (7 + g3ypos))))
                                                        begin
                                                                eyes_on = 1'b1; 
                                                        end
                                        end
                                    else if(g3d == 2'b10)
                                        begin
                                            if(((((DrawX) >= (5 + g3xpos) && (DrawX) <= (6 + g3xpos)) || ((DrawX) >= (11 + g3xpos) && (DrawX) <= (12 + g3xpos))) && ((DrawY) >= (8 + g3ypos) && (DrawY) <= (9 + g3ypos))))
                                                        begin
                                                                eyes_on = 1'b1; 
                                                        end
                                        end
                                    else
                                        begin
                                            if(((((DrawX) >= (6 + g3xpos) && (DrawX) <= (7 + g3xpos)) || ((DrawX) >= (12 + g3xpos) && (DrawX) <= (13 + g3xpos))) && ((DrawY) >= (6 + g3ypos) && (DrawY) <= (7 + g3ypos))))
                                                        begin
                                                                eyes_on = 1'b1; 
                                                        end
                                        end
                               end
                        end 
                 if(DrawX >= g4xpos && DrawX <= g4xpos + 15 && DrawY >= g4ypos && DrawY <= g4ypos + 15)
                        begin
                            if((player_on == 1'b0) && (ghost1_on == 1'b0) && (ghost2_on == 1'b0) && (ghost3_on == 1'b0))
                                begin
                                    if(ghost[((DrawY - g4ypos))][16 - (DrawX - g4xpos)] == 1'b1)
                                        ghost4_on = 1'b1;
                                    else if(g4d == 2'b00)
                                        begin
                                            if(((((DrawX) >= (5 + g4xpos) && (DrawX) <= (6 + g4xpos)) || ((DrawX) >= (11 + g4xpos) && (DrawX) <= (12 + g4xpos))) && ((DrawY) >= (5 + g4ypos) && (DrawY) <= (6 + g4ypos))))
                                                        begin
                                                                eyes_on = 1'b1; 
                                                        end
                                        end
                                    else if(g4d == 2'b01)
                                        begin
                                            if(((((DrawX) >= (4 + g4xpos) && (DrawX) <= (5 + g4xpos)) || ((DrawX) >= (10 + g4xpos) && (DrawX) <= (11 + g4xpos))) && ((DrawY) >= (6 + g4ypos) && (DrawY) <= (7 + g4ypos))))
                                                        begin
                                                                eyes_on = 1'b1; 
                                                        end
                                        end
                                    else if(g4d == 2'b10)
                                        begin
                                            if(((((DrawX) >= (5 + g4xpos) && (DrawX) <= (6 + g4xpos)) || ((DrawX) >= (11 + g4xpos) && (DrawX) <= (12 + g4xpos))) && ((DrawY) >= (8 + g4ypos) && (DrawY) <= (9 + g4ypos))))
                                                        begin
                                                                eyes_on = 1'b1; 
                                                        end
                                        end
                                    else
                                        begin
                                            if(((((DrawX) >= (6 + g4xpos) && (DrawX) <= (7 + g4xpos)) || ((DrawX) >= (12 + g4xpos) && (DrawX) <= (13 + g4xpos))) && ((DrawY) >= (6 + g4ypos) && (DrawY) <= (7 + g4ypos))))
                                                        begin
                                                                eyes_on = 1'b1; 
                                                        end
                                        end
                                 end
                        end                     
                if(pellets[ycord][xcord - 2] == 0)
                        begin
                                if(((DrawX%16) >= 7 && (DrawX%16) <= 8 && (DrawY%16) >= 7 && (DrawY%16) <= 8))
                                    begin
                                        if((player_on == 1'b0) && (ghost1_on == 1'b0) && (ghost2_on == 1'b0) && (ghost3_on == 1'b0) && (ghost4_on == 1'b0) && (map_on == 1'b0))
                                            pellet_on = 1'b1; 
                                    end
                        end 
                if(pellets[ycord][xcord - 2] == 0)
                        begin
                                if(((DrawX%16) >= 7 && (DrawX%16) <= 8 && (DrawY%16) >= 7 && (DrawY%16) <= 8))
                                    begin
                                        if((player_on == 1'b0) && (ghost1_on == 1'b0) && (ghost2_on == 1'b0) && (ghost3_on == 1'b0) && (ghost4_on == 1'b0) && (map_on == 1'b0))
                                            pellet_on = 1'b1; 
                                    end
                        end       
                end
                                                                        
            end
        else
            begin
            map_on = 1'b0;
            score_on = 1'b0;
            player_on = 1'b0;
            ghost1_on = 1'b0;
            ghost2_on = 1'b0;
            ghost3_on = 1'b0;
            ghost4_on = 1'b0; 
            pellet_on = 1'b0;
            eyes_on = 1'b0;
            if (DrawY <= 50 && DrawX > 512)
                begin
                if(DrawX >= 514 && DrawX <= 521 && DrawY >= 16 && DrawY <= 31)
                    begin
                        sprite_addr = (DrawY-16 + 16*(16'h30 + decimal5));
                        if (sprite_data[7 - (DrawX-2)%8] == 1'b1)
                            begin
                                score_on = 1'b1;
                            end
                      end                                            
                 if(DrawX >= 522 && DrawX <= 529 && DrawY >= 16 && DrawY <= 31)
                    begin
                        sprite_addr = (DrawY-16 + 16*(16'h30 + decimal4));
                        if (sprite_data[7 - (DrawX-2)%8] == 1'b1)
                            begin
                                score_on = 1'b1;
                            end
                            
                      end
                 if(DrawX >= 530 && DrawX <= 537 && DrawY >= 16 && DrawY <= 31)
                    begin
                          sprite_addr = (DrawY-16 + 16*(16'h30 + decimal3));
                            if (sprite_data[7 - (DrawX-2)%8] == 1'b1)
                                begin
                                    score_on = 1'b1;
                                end
                      end
                 if(DrawX >= 538 && DrawX <= 545 && DrawY >= 16 && DrawY <= 31)
                    begin
                          sprite_addr = (DrawY-16 + 16*(16'h30 + decimal2));
                            if (sprite_data[7 - (DrawX-2)%8] == 1'b1)
                                begin
                                    score_on = 1'b1;
                                end
                      end
                  if(DrawX >= 546 && DrawX <= 553 && DrawY >= 16 && DrawY <= 31)
                    begin
                          sprite_addr = (DrawY-16 + 16*(16'h30 + decimal1));
                            if (sprite_data[7 - (DrawX-2)%8] == 1'b1)
                                begin
                                    score_on = 1'b1;
                                end
                      end                       
                 end
                 
            end
     end 
    
    always_comb
    begin:RGB_Display
        if((winscreen == 1'b1) && (DrawX <= 511))
        begin
            Red = 4'h0;
            Green = 4'hf;               
            Blue = 4'h0;
        end
        else if((lostscreen == 1'b1) && (DrawX <= 511))
        begin
            Red = 4'hf;
            Green = 4'h0;               
            Blue = 4'h0;
        end
        else if ((map_on == 1'b1) && DrawX <= 511) begin 
            Red = 4'h0;
            Green = 4'h0;               
            Blue = 4'h6;
        end
        else if (score_on == 1'b1)
            begin
                Red = 4'hf;
                Green = 4'hf;               
                Blue = 4'hf;
            end
        else if (player_on == 1'b1 && DrawX <= 511) 
            begin
                
                Red = 4'hf;
                Green = 4'hf;               
                Blue = 4'h0;
            end
        else if(ghost1_on == 1'b1 && DrawX <= 511)
            begin
                Red = 4'hf;
                Green = 4'h0;               
                Blue = 4'h0;
            end
        else if(ghost2_on == 1'b1 && DrawX <= 511)
            begin
                Red = 4'h0;
                Green = 4'hf;               
                Blue = 4'hf;
            end
        else if(ghost3_on == 1'b1 && DrawX <= 511)
            begin
                Red = 4'hf;
                Green = 4'hc;               
                Blue = 4'he;
            end
        else if(ghost4_on == 1'b1 && DrawX <= 511)
            begin
                Red = 4'hf;
                Green = 4'h9;               
                Blue = 4'h3;
            end  
        else if (eyes_on == 1'b1)
            begin
                Red = 4'h3;
                Green = 4'h9;               
                Blue = 4'hF;
            end
        else if (pellet_on == 1'b1 && DrawX <= 511)
            begin
                Red = 4'hF;
                Green = 4'hC;               
                Blue = 4'hC;
            end 
        else begin 
            Red = 4'h0; 
            Green = 4'h0;
            Blue = 4'h0;
        end      
    end 
    
endmodule

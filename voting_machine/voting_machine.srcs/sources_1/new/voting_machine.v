`timescale 1ns / 1ps
module button_control(
    input clk,
    input reset,
    input button,
    output reg valid_vote
);
    reg [4:0] counter; // small counter, enough to count till 11

    always @(posedge clk) begin
        if (reset)
            counter <= 0;
        else if (button && counter < 11)
            counter <= counter + 1;
        else if (!button)
            counter <= 0;
    end

    always @(posedge clk) begin
        if (reset)
            valid_vote <= 0;
        else if (counter == 10)
            valid_vote <= 1;
        else
            valid_vote <= 0;
    end
endmodule
module vote_logger(
    input clk,
    input reset,
    input mode, // 0 = voting, 1 = result
    input valid1, valid2, valid3, valid4,
    output reg [7:0] vote1, vote2, vote3, vote4
);
    always @(posedge clk) begin
        if (reset) begin
            vote1 <= 0;
            vote2 <= 0;
            vote3 <= 0;
            vote4 <= 0;
        end else begin
            if (mode == 0) begin
                if (valid1)
                    vote1 <= vote1 + 1;
                else if (valid2)
                    vote2 <= vote2 + 1;
                else if (valid3)
                    vote3 <= vote3 + 1;
                else if (valid4)
                    vote4 <= vote4 + 1;
            end
        end
    end
endmodule
module mode_control(
    input clk,
    input reset,
    input mode, // 0 = vote, 1 = display votes
    input valid_vote_casted,
    input [7:0] vote1, vote2, vote3, vote4,
    input btn1, btn2, btn3, btn4,
    output reg [7:0] leds
);
    reg [4:0] counter;

    always @(posedge clk) begin
        if (reset)
            counter <= 0;
        else if (valid_vote_casted)
            counter <= 1;
        else if (counter > 0 && counter < 10)
            counter <= counter + 1;
        else if (counter == 10)
            counter <= 0;
    end

    always @(posedge clk) begin
        if (reset)
            leds <= 8'h00;
        else if (mode == 0) begin // Voting mode
            if (counter > 0)
                leds <= 8'hFF; // all LEDs on
            else
                leds <= 8'h00;
        end else begin // Count display mode
            if (btn1)
                leds <= vote1;
            else if (btn2)
                leds <= vote2;
            else if (btn3)
                leds <= vote3;
            else if (btn4)
                leds <= vote4;
            else
                leds <= 8'h00;
        end
    end
endmodule
module voting_machine(
    input clk,
    input reset,
    input mode,
    input btn1, btn2, btn3, btn4,
    output [7:0] leds
);
    wire valid1, valid2, valid3, valid4;
    wire [7:0] vote1, vote2, vote3, vote4;
    wire valid_vote_casted = valid1 | valid2 | valid3 | valid4;

    // Instantiate button controls for each candidate
    button_control bc1(clk, reset, btn1, valid1);
    button_control bc2(clk, reset, btn2, valid2);
    button_control bc3(clk, reset, btn3, valid3);
    button_control bc4(clk, reset, btn4, valid4);

    // Instantiate vote logger
    vote_logger vl(
        .clk(clk),
        .reset(reset),
        .mode(mode),
        .valid1(valid1),
        .valid2(valid2),
        .valid3(valid3),
        .valid4(valid4),
        .vote1(vote1), .vote2(vote2), .vote3(vote3), .vote4(vote4)
    );

    // Instantiate mode control
    mode_control mc(
        .clk(clk),
        .reset(reset),
        .mode(mode),
        .valid_vote_casted(valid_vote_casted),
        .vote1(vote1), .vote2(vote2), .vote3(vote3), .vote4(vote4),
        .btn1(btn1), .btn2(btn2), .btn3(btn3), .btn4(btn4),
        .leds(leds)
    );
endmodule
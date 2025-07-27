`timescale 1ns/1ps

module voting_machine_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg mode;           // 0: voting, 1: result mode
    reg btn1, btn2, btn3, btn4;
    wire [7:0] leds;

    // Instantiate the device under test
    voting_machine uut (
        .clk(clk),
        .reset(reset),
        .mode(mode),
        .btn1(btn1),
        .btn2(btn2),
        .btn3(btn3),
        .btn4(btn4),
        .leds(leds)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100MHz

    // Helper: press a button for N clock cycles (duration in clock edges)
    task press_button(input integer which, input integer duration);
        begin
            btn1 = 0; btn2 = 0; btn3 = 0; btn4 = 0;
            case(which)
                1: btn1 = 1;
                2: btn2 = 1;
                3: btn3 = 1;
                4: btn4 = 1;
            endcase
            repeat (duration) @(posedge clk);
            btn1 = 0; btn2 = 0; btn3 = 0; btn4 = 0;
            repeat (5) @(posedge clk); // leave line idle after press
        end
    endtask

    initial begin
        $display("Voting Machine Simulation Begin");
        // Initial reset and all low
        {btn1, btn2, btn3, btn4} = 0;
        mode = 0; // Voting mode
        reset = 1;
        @(posedge clk);
        @(posedge clk);
        reset = 0;
        @(posedge clk);
        @(posedge clk);

        // Simulate voting: Each button needs to be held for 11 clk cycles to register as a vote.

        $display("Vote: Candidate 1");
        press_button(1, 12);
        $display("Vote: Candidate 2");
        press_button(2, 12);
        $display("Vote: Candidate 3");
        press_button(3, 12);
        $display("Vote: Candidate 4");
        press_button(4, 12);

        // Give 2 more votes to candidate 1
        $display("Vote: Candidate 1 again");
        press_button(1, 12);
        $display("Vote: Candidate 1 again");
        press_button(1, 12);

        // Wait a little
        repeat (20) @(posedge clk);

        // Switch to result mode
        mode = 1;
        repeat (3) @(posedge clk);

        // Display each candidate's votes using btn1, btn2, btn3, btn4 in result mode
        btn1 = 1; // Show votes for candidate 1
        repeat (2) @(posedge clk);
        $display("LEDs show votes (Candidate 1): %d", leds);
        btn1 = 0;

        btn2 = 1; // Candidate 2
        repeat (2) @(posedge clk);
        $display("LEDs show votes (Candidate 2): %d", leds);
        btn2 = 0;

        btn3 = 1; // Candidate 3
        repeat (2) @(posedge clk);
        $display("LEDs show votes (Candidate 3): %d", leds);
        btn3 = 0;

        btn4 = 1; // Candidate 4
        repeat (2) @(posedge clk);
        $display("LEDs show votes (Candidate 4): %d", leds);
        btn4 = 0;

        repeat (10) @(posedge clk);

        $display("Done. Halting simulation.");
        $stop;
    end

endmodule

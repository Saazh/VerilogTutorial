// Generator : SpinalHDL v1.5.0    git head : 83a031922866b078c411ec5529e00f1b6e79f8e7
// Component : Blinky
// Git hash  : 028f8d7f972233637a2032f001fe37204c66751b



module Blinky (
  input               io_btn,
  output              io_blink,
  output              io_push,
  input               clk,
  input               reset
);
  wire       [22:0]   _zz_timer_counter_valueNext;
  wire       [0:0]    _zz_timer_counter_valueNext_1;
  reg                 blinkState;
  reg                 timer_state;
  reg                 timer_stateRise;
  wire                timer_counter_willIncrement;
  reg                 timer_counter_willClear;
  reg        [22:0]   timer_counter_valueNext;
  reg        [22:0]   timer_counter_value;
  wire                timer_counter_willOverflowIfInc;
  wire                timer_counter_willOverflow;

  assign _zz_timer_counter_valueNext_1 = timer_counter_willIncrement;
  assign _zz_timer_counter_valueNext = {22'd0, _zz_timer_counter_valueNext_1};
  always @(*) begin
    timer_stateRise = 1'b0;
    if(timer_counter_willOverflow) begin
      timer_stateRise = (! timer_state);
    end
    if(timer_state) begin
      timer_stateRise = 1'b0;
    end
  end

  always @(*) begin
    timer_counter_willClear = 1'b0;
    if(timer_state) begin
      timer_counter_willClear = 1'b1;
    end
  end

  assign timer_counter_willOverflowIfInc = (timer_counter_value == 23'h5b8d7f);
  assign timer_counter_willOverflow = (timer_counter_willOverflowIfInc && timer_counter_willIncrement);
  always @(*) begin
    if(timer_counter_willOverflow) begin
      timer_counter_valueNext = 23'h0;
    end else begin
      timer_counter_valueNext = (timer_counter_value + _zz_timer_counter_valueNext);
    end
    if(timer_counter_willClear) begin
      timer_counter_valueNext = 23'h0;
    end
  end

  assign timer_counter_willIncrement = 1'b1;
  assign io_blink = blinkState;
  assign io_push = io_btn;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      blinkState <= 1'b0;
      timer_state <= 1'b0;
      timer_counter_value <= 23'h0;
    end else begin
      timer_counter_value <= timer_counter_valueNext;
      if(timer_counter_willOverflow) begin
        timer_state <= 1'b1;
      end
      if(timer_state) begin
        blinkState <= (! blinkState);
        timer_state <= 1'b0;
      end
    end
  end


endmodule

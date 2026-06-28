module door_lock(input clk,input reset,input [3:0]password_entry,input enter,output unlock,output ALARM);

parameter s0=4'd0,s1=4'd1,s2=4'd2,s3=4'd3;
parameter attempts=4'd3;
parameter hold=4'd10;
parameter alarm_time=4'd10;
parameter password=4'b1100;

reg [3:0]state,next_state;
reg [3:0]count,timer,alaarm;
wire correct;

reg enter_d;
always @(posedge clk) enter_d <= enter;
wire enter_pulse = enter & ~enter_d;

assign correct = (password_entry==password);

always @(posedge clk)begin
    if(reset)
    state<=s0;
    else
    state<=next_state;
end

always @(posedge clk) begin
if(reset)
count<=4'd0;
else if(state==s2 && count!=attempts)
count<=count+1;
else if(state==s1)
count<=0;
else if(state==s3 && alaarm==alarm_time)
count<=0;
end

always @(posedge clk) begin
    if(reset)
    timer<=0;
    else if(state==s1 && timer!=hold)
    timer<=timer+1;
    else
    timer<=0;
end

always @(posedge clk) begin
    if(reset)
    alaarm<=0;
    else if(state==s3 && alaarm!=alarm_time)
    alaarm<=alaarm+1;
    else
    alaarm<=0;
end


always @(*) begin
    next_state=state;
    case(state) 
   s0:begin
    if(correct && enter_pulse)
    next_state=s1;
    else if(enter_pulse && !correct)
    next_state=s2;
   end

    s2:begin
        if(count==attempts-1)
        next_state=s3;
        else
        next_state=s0;
    end

    s1:begin
        if(timer!=hold)
        next_state=s1;
        else 
        next_state=s0;
    end

    s3: begin
        if(alaarm!=alarm_time)
        next_state=s3;
        else
        next_state=s0;
    end

    default:
        next_state=s0;
endcase
end

assign unlock=(state==s1);
assign ALARM=(state==s3);
endmodule
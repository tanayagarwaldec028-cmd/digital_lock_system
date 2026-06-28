module door_lock_tb;

door_lock dut(.clk(clk),.reset(reset),.password_entry(password_entry),.enter(enter),.unlock(unlock),.ALARM(ALARM));

reg [3:0]password_entry;
reg enter,clk,reset;
 wire ALARM,unlock;

 initial begin
    clk=0;
    forever begin
    #5 clk=~clk;
    end
 end

 initial begin
    reset=1;
    #12 reset=0;
 end

 initial begin
enter=0;
password_entry=0;
    #10
    password_entry=4'b0101;
    enter=1;
    #10
    enter=0;
    #10
    password_entry=4'b1100;
    enter=1;
    #10 enter=1;
    #10 enter=0;
    #10 
    password_entry=4'b1001;
    enter=1;
    #10 enter=0;
    #10 
    password_entry=4'b1000;
    enter=1;
    #10 enter=0;
    #70 
    password_entry=4'b1101;
    enter=1;
    #10 enter=0;

    #200 $finish;
    end

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,door_lock_tb);
    $monitor("Time=%0t,reset=%b,password_entry=%b,enter=%b,ALARM=%b,unlock=%b,count=%d,timer=%d,alaarm=%d",$time,reset,password_entry,enter,ALARM,unlock,dut.count,dut.timer,dut.alaarm);
 end
 endmodule
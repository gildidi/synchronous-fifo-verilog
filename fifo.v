module fifo #(parameter FIFO_DEPTH=16 , FIFO_WIDTH=8, PTR_WIDTH = $clog2(FIFO_DEPTH)) (
	input clk, // Clock
	input reset, // Reset

	// Write Port
	input write_en, // Write enable
	input [FIFO_WIDTH-1:0] data_in, // FIFO Input Data
	output empty, // FIFO empty indication

	// Read Port
	input read_en, // Read enable
	output full, // FIFO full indication
	output reg [FIFO_WIDTH-1:0] data_out // FIFO Output Data
);

reg [PTR_WIDTH -1:0] wr_ptr;
reg [PTR_WIDTH -1:0] rd_ptr;
reg [FIFO_WIDTH-1:0] mem_array [0:FIFO_DEPTH-1];

assign empty = (wr_ptr==rd_ptr) ? 1'b1 : 1'b0;
assign full = (wr_ptr-rd_ptr == FIFO_DEPTH - 1) ? 1'b1 : 1'b0;

always @(posedge reset)
	begin
		wr_ptr =0;
		rd_ptr =0;
	end
	
always @(posedge clk) //write and increament
	begin
		if (write_en && !full) begin
			mem_array[wr_ptr]=data_in;
		if(wr_ptr == FIFO_DEPTH-1)
		wr_ptr=0;
		else
			wr_ptr=wr_ptr+1;
		end
end

always @(posedge clk) //read pointer to point the right adress
begin
	if (read_en && !empty)
		begin
		data_out=mem_array[rd_ptr];
		if(rd_ptr == FIFO_DEPTH -1)
			rd_ptr<=0;
		else
			rd_ptr = rd_ptr+1;
		end	
end 
endmodule


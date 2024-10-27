/*
Branch direction predictor
A branch direction predictor generates taken/not-taken predictions of the direction of conditional branch instructions. 
It sits near the front of the processor pipeline, and is responsible for directing instruction fetch down the (hopefully) correct program execution path. 
A branch direction predictor is usually used with a branch target buffer (BTB), where the BTB predicts the target addresses and the direction predictor chooses 
whether to branch to the target or keep fetching along the fall-through path.

Sometime later in the pipeline (typically at branch execution or retire), 
the results of executed branch instructions are sent back to the branch predictor to train it to predict more accurately in the future by observing past branch behaviour. 
There can also be pipeline flushes when there is a mispredicted branch.
https://hdlbits.01xz.net/wiki/File:Branch_predictor.png
Branch direction predictor located in the Fetch stage. The branch predictor makes a prediction using the current pc and history register, 
with the result of the prediction affecting the next pc value. Training and misprediction requests come from later in the pipeline.

For this exercise, the branch direction predictor is assumed to sit in the fetch stage of a hypothetical processor pipeline shown in the diagram on the right. 
This exercise builds only the branch direction predictor, indicated by the blue dashed rectangle in the diagram.

The branch direction prediction is a combinational path: The pc register is used to compute the taken/not-taken prediction, 
which affects the next-pc multiplexer to determine the value of pc in the next cycle.

Conversely, updates to the pattern history table (PHT) and branch history register take effect at the next positive clock edge, 
as would be expected for state stored in flip-flops.

Branch direction predictors are often structured as tables of counters indexed by the program counter and branch history. 
The table index is a hash of the branch address and history, and tries to give each branch and history combination its own table entry (or at least, reduce the number of collisions). 
Each table entry contains a two-bit saturating counter to remember the branch direction when the same branch and history pattern executed in the past.

One example of this style of predictor is the gshare predictor[1]. In the gshare algorithm, the branch address (pc) and history bits "share" the table index bits. 
The basic gshare algorithm computes an N-bit PHT table index by xoring N branch address bits and N global branch history bits together.

The N-bit index is then used to access one entry of a 2N-entry table of two-bit saturating counters. 
The value of this counter provides the prediction (0 or 1 = not taken, 2 or 3 = taken).

Training indexes the table in a similar way. The training pc and history are used to compute the table index. 
Then, the two-bit counter at that index is incremented or decremented depending on the actual outcome of the branch.

Branch direction predictors are often structured as tables of counters indexed by the program counter and branch history. 
The table index is a hash of the branch address and history, and tries to give each branch and history combination its own table entry 
(or at least, reduce the number of collisions). Each table entry contains a two-bit saturating counter to remember the branch direction when the same branch 
and history pattern executed in the past.

One example of this style of predictor is the gshare predictor[1]. 
In the gshare algorithm, the branch address (pc) and history bits "share" the table index bits. 
The basic gshare algorithm computes an N-bit PHT table index by xoring N branch address bits and N global branch history bits together.

The N-bit index is then used to access one entry of a 2N-entry table of two-bit saturating counters. 
The value of this counter provides the prediction (0 or 1 = not taken, 2 or 3 = taken).

Training indexes the table in a similar way. The training pc and history are used to compute the table index. 
Then, the two-bit counter at that index is incremented or decremented depending on the actual outcome of the branch.

areset is an asynchronous reset that clears the entire PHT to 2b'01 (weakly not-taken). 
It also clears the global history register to 0.
*/


module top_module(
    input clk,
    input areset,

    input  predict_valid,
    input  [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);


    // indicies of predict and train
    wire[6:0] predict_index;
    wire[6:0] train_index;
    assign predict_index = predict_pc ^ predict_history;
    assign train_index = train_pc ^ train_history;

    // 128 bit words for branch prediction inputs
    reg[127:0] train_valid128;
    reg[127:0] train_taken128;
    reg[127:0] taken_prediction128;

    // inputs for history register
    reg predict_valid_his;
    reg train_mispredicted_his;
    reg train_taken_his;
    reg[6:0] train_history_his;


    // calculate the flags for each type of work
    always @(*) begin
        // only prediction is done
        if (predict_valid && !train_valid) begin
            // there is no training => all train_valid for predictors are 0
            train_valid128 = 128'd0;
            // train_valid are all zeroes => no need to use this
            train_taken128 = 128'd0;
            // predict taken is calculated straigtforward, using output taken_prediction and predict index
            predict_taken = taken_prediction128[predict_index];

            // history register should be used for prediction only
            predict_valid_his = 1'b1;

            // training misprediction is 0 (there is no train_valid => no training misprediction)
            train_mispredicted_his = 1'b0;

            // train_taken = 0 => no need to use this
            train_taken_his = 1'd0;

            // train history is not needed at that moment
            train_history_his = 7'd0;

        end
        // only training is done
        else if (train_valid && !predict_valid) begin
            // the only one pht that is going to train is the train_index one
            train_valid128 = 128'b1 << train_index;

            // the only one pht train_taken input is the one with train_index
            train_taken128 = train_taken << train_index;

            // predict taken is not important
            predict_taken = 1'b0;

            // history register should not be used for prediction at all
            predict_valid_his = 1'b0;

            // train misprediction should be taken from input of the module
            train_mispredicted_his = train_mispredicted;

            // train taken should be taken from input of the module
            train_taken_his = train_taken;

            // train taken should be taken from input of the module
            train_history_his = train_history;
        end
        // both prediction and training is done
        else if (train_valid && predict_valid) begin
            // the only one pht that is going to train is the train_index one
            train_valid128 = 128'b1 << train_index;

            // the only one pht train_taken input is the one with train_index
            train_taken128 = train_taken << train_index;

            // if train_index == predict_index
            // the state will change on the next positive edge cycle
            // but the prediction will be calculated now
            // so predict_taken is the result, calculated with old state before training
            predict_taken = taken_prediction128[predict_index];

            // both prediction and training are happening
            // if misprediction is 1
            // training have precendece
            // however, history_register_7bit already have the correct input order
            // if training_misprediction is 1, then it will take precedence
            // otherwise predict_valid will be done
            predict_valid_his = 1'b1;
            train_mispredicted_his = train_mispredicted;

            // train taken should be taken from input of the module
            train_taken_his = train_taken;

            // train taken should be taken from input of the module
            train_history_his = train_history;
            


        end
        // nothing should be done
        else begin
            // no training
            train_valid128 = 128'd0;
            // no need to use this
            train_taken128 = 128'd0;
            // no need to output something meaningful
            predict_taken = 1'd0;
            // history register should be used for prediction
            predict_valid_his = 1'b0;
            // training misprediction is 0 (there is no train_valid => no training misprediction)
            train_mispredicted_his = 1'b0;
            // train_taken = 0 => no need to use this
            train_taken_his = 1'd0;
            // train history is not needed at that moment
            train_history_his = 7'd0;

        end
    end



    branch_predictor_2bit PHTs[127:0] (
        .clk({128{clk}}),
        .areset({128{areset}}),
        .train_valid(train_valid128),
        .train_taken(train_taken128),
        .taken_prediction(taken_prediction128)
    );


    history_register_7bit his_reg (
        .clk(clk),
        .areset(areset),
        .predict_valid(predict_valid_his),
        .predict_taken(predict_taken),
        .predict_history(predict_history),
        .train_mispredicted(train_mispredicted_his),
        .train_taken(train_taken_his),
        .train_history(train_history_his)
    );



endmodule



module branch_predictor_2bit (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output taken_prediction
);

    parameter SNT = 0, WNT = 1, WT = 2, ST = 3;
    reg[1:0] cur_state, next_state;

    always @(*) begin
        if (!train_valid) begin
            next_state = cur_state;
        end
        else if (train_taken && cur_state == ST) begin
            next_state = cur_state;
        end
        else if (train_taken) begin
            next_state = cur_state + 2'd1;
        end
        else if (!train_taken && cur_state == SNT) begin
            next_state = cur_state;
        end
        else if (!train_taken) begin
            next_state = cur_state - 2'd1;
        end
        else begin
            next_state = cur_state;
        end
    end

    always @(posedge clk, posedge areset) begin
        cur_state <= (areset) ? 2'd1 : next_state;
    end

    assign taken_prediction = (cur_state == WT) || (cur_state == ST);


endmodule





module history_register_7bit (
    input clk,
    input areset,

    input predict_valid,
    input predict_taken,
    output [6:0] predict_history,

    input train_mispredicted,
    input train_taken,
    input [6:0] train_history
);


    always @(posedge clk, posedge areset) begin
        if (areset) begin
            predict_history <= 7'd0;
        end
        else if (train_mispredicted) begin
            predict_history <= {train_history[5:0], train_taken};
        end
        else if (predict_valid) begin
            predict_history <= {predict_history[5:0], predict_taken};
        end
        else begin
            predict_history <= predict_history;
        end
    end

endmodule
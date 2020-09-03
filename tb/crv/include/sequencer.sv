`ifndef SEQUENCER
`define SEQUENCER

class sequencer;
    transaction master_0_trans, master_1_trans, master_2_trans, master_3_trans;
    mailbox seq2driv;

    static int unsigned qty_of_iterations_to_be_sended = 1;
    static shortint unsigned delay_between_iterations = 0;
    event finished;

    function new(mailbox seq2driv);
        this.seq2driv = seq2driv;
    endfunction

    static function void SetNumberOfIterations(int unsigned iterations);
        qty_of_iterations_to_be_sended = iterations;
    endfunction

    static function void SetDelayBetweenPackets(shortint unsigned delay);
        delay_between_iterations = delay;
    endfunction

endclass

`endif
        BasicUpstart2(start)

start:
        lda #8          // H
        sta $0400

        lda #5          // E
        sta $0401

        lda #10         // J
        sta $0402

        lda #32         // MELLEMRUM
        sta $0403

        lda #3          // C
        sta $0404

        lda #54         // 6
        sta $0405

        lda #52         // 4
        sta $0406
        
        rts

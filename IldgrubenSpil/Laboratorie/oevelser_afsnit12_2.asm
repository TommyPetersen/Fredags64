        BasicUpstart2(opsaetning)

        // *******************************
        // *** H O V E D P R O G R A M ***
        // *******************************
opsaetning:     
        cld
hovedprg:
        jsr indstilSkaermadresse
        jsr beregnSkaermadresse
        jsr tegnPaaSkaerm

        // ***********************************
        // *** H J A E L P E R U T I N E R ***
        // ***********************************
indstilSkaermadresse:
        lda #$00
        sta $FB
        lda #$04
        sta $FC
        rts
beregnSkaermadresse:
        ldx #0
adderRaekker:
        cpx #RAEKKENR
        beq adderKolonne
        lda #40
        jsr adder8bitTal
        inx
        jmp adderRaekker
adderKolonne:   
        clc
        lda #KOLONNENR
        jsr adder8bitTal
        rts
adder8bitTal:
        clc
        adc $FB
        sta $FB
        lda #0
        adc $FC
        sta $FC
        rts
tegnPaaSkaerm:
        ldy #0
        lda #128
        sta ($FB),y
        rts
        
        // ***************
        // *** D A T A ***
        // ***************
.label RAEKKENR = 6
.label KOLONNENR = 4


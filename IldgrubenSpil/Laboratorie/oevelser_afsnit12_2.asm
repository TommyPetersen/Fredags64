        BasicUpstart2(opsaetning)

        // *******************************
        // *** H O V E D P R O G R A M ***
        // *******************************
opsaetning:     
        cld
hovedprg:
        jsr nulstilSkaermafsaet
        jsr beregnSkaermafsaet
        jsr kopierSkaermafsaet
        jsr adderTegnadrBegynd
        jsr adderFarveadrBegynd
        jsr tegnPaaSkaerm

        // ***********************************
        // *** H J A E L P E R U T I N E R ***
        // ***********************************
nulstilSkaermafsaet:
        lda #$00
        sta $FB
        lda #$00
        sta $FC
        rts
beregnSkaermafsaet:
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
kopierSkaermafsaet:
        lda $FB
        sta $FD
        lda $FC
        sta $FE
        rts
adderTegnadrBegynd:
        clc
        lda #$04
        adc $FC
        sta $FC
        rts
adderFarveadrBegynd:
        clc
        lda #$d8
        adc $FE
        sta $FE
        rts
tegnPaaSkaerm:
        ldy #0
        lda #128
        sta ($FB),y
        lda #3
        sta ($FD),y
        rts
        
        // ***************
        // *** D A T A ***
        // ***************
.label RAEKKENR = 6
.label KOLONNENR = 4


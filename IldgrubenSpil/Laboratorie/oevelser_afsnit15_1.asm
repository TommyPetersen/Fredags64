        BasicUpstart2(opsaetning)

        .label HVID = 1
        .label GRAA = 12
        .label RENS_SKAERM = $e544
        .label RAEKKENR = 6
        .label KOLONNENR = 23
        .label NUL = 48
        .label LAGERADRESSE = $dc00
        
        // *******************************
        // *** H O V E D P R O G R A M ***
        // *******************************
opsaetning:     
        jsr RENS_SKAERM
        cld
opsaetningA:
        lda #0
        sta bitnummer
        lda #RAEKKENR
        sta raekkenr
hovedprgA:
        jsr nulstilSkaermafsaet
        jsr beregnSkaermafsaet
        jsr kopierSkaermafsaet
        jsr adderTegnadrBegynd
        jsr adderFarveadrBegynd
kolonnenavne:       
        lda #GRAA
        sta farve
        ldx #0        
kolonnenavneLoekke:
        clc
        lda bitnummer
        adc #NUL
        sta tegnvaerdi
        jsr tegnPaaSkaerm
        inc bitnummer
        lda bitnummer
        cmp #8
        bne hovedprgA

opsaetningB:
        lda #0
        sta bitnummer
        lda #RAEKKENR + 2
        sta raekkenr
        lda LAGERADRESSE
        sta aflaestLageradresse
hovedprgB:
        jsr nulstilSkaermafsaet
        jsr beregnSkaermafsaet
        jsr kopierSkaermafsaet
        jsr adderTegnadrBegynd
        jsr adderFarveadrBegynd
kolonneindhold:       
        lda #HVID
        sta farve
        ldx #0        
kolonneindholdLoekke:
        clc
        lda bitnummer
        adc #NUL

        lda aflaestLageradresse
        and #%00000001
        adc #NUL
        sta tegnvaerdi
        jsr tegnPaaSkaerm
        lsr aflaestLageradresse
        inc bitnummer
        lda bitnummer
        cmp #8
        bne hovedprgB

        jmp opsaetningB
        
        rts

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
        cpx raekkenr
        beq adderKolonne
        lda #40
        jsr adder8bitTal
        inx
        jmp adderRaekker
adderKolonne:   
        sec
        lda #KOLONNENR
        sbc bitnummer
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
        lda tegnvaerdi
        ldy #0
        sta ($FB),y
        lda farve
        sta ($FD),y
        rts

        // ***************
        // *** D A T A ***
        // ***************
bitnummer:             .byte 0
farve:                 .byte HVID
tegnvaerdi:            .byte 0
raekkenr:              .byte 0
aflaestLageradresse:   .byte 0

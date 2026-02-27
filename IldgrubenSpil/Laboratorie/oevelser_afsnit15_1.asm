        BasicUpstart2(opsaetning)

        .label HVID = 1
        .label GRAA = 12
        .label RENS_SKAERM = $e544
        .label RAEKKENR = 6
        .label KOLONNENR = 16
        .label NUL = 48
        .label STYREPIND2ADRESSE = $dc00
        
        // *******************************
        // *** H O V E D P R O G R A M ***
        // *******************************
opsaetning:     
        cld
        jsr RENS_SKAERM
        jsr beregnTegnOgFarveAdresser
        jsr gemTegnOgFarveAdresser
        
opsaetningA:
        lda #8
        sta bitnummer
        lda #GRAA
        sta farve
kolonnenavneLoekke:
        clc
        lda bitnummer
        adc #NUL - 1
        sta tegnvaerdi
        jsr tegnPaaSkaerm
        lda #1
        sta adresseforskydning
        jsr adderAdresser8bit
        dec bitnummer
        lda bitnummer
        cmp #0
        bne kolonnenavneLoekke

opsaetningB:
        jsr hentTegnOgFarveAdresser
        lda #80
        sta adresseforskydning
        jsr adderAdresser8bit
        lda #8
        sta bitnummer
        lda STYREPIND2ADRESSE
        sta aflaestLageradresse
        lda #HVID
        sta farve
kolonneindholdLoekke:
        lda aflaestLageradresse
        and #%10000000
        jsr lsr7
        clc
        adc #NUL
        sta tegnvaerdi
        jsr tegnPaaSkaerm
        asl aflaestLageradresse
        lda #1
        sta adresseforskydning
        jsr adderAdresser8bit
        dec bitnummer
        lda bitnummer
        cmp #0
        bne kolonneindholdLoekke
        jmp opsaetningB
        
        rts

        // ***********************************
        // *** H J A E L P E R U T I N E R ***
        // ***********************************
beregnTegnOgFarveAdresser:      
        jsr nulstilSkaermafsaet
        jsr beregnSkaermafsaet
        jsr kopierSkaermafsaet
        jsr adderTegnadrBegynd
        jsr adderFarveadrBegynd
        rts
gemTegnOgFarveAdresser:
        lda $FB
        sta gemtFB
        lda $FC
        sta gemtFC
        lda $FD
        sta gemtFD
        lda $FE
        sta gemtFE
        rts
hentTegnOgFarveAdresser:
        lda gemtFB
        sta $FB
        lda gemtFC
        sta $FC
        lda gemtFD
        sta $FD
        lda gemtFE
        sta $FE
        rts
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
adderAdresser8bit:
        clc
        lda adresseforskydning
        adc $FB
        sta $FB
        lda #0
        adc $FC
        sta $FC
        clc
        lda adresseforskydning
        adc $FD
        sta $FD
        lda #0
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
lsr7:
        ldx #0
lsrloekke:      
        lsr
        inx
        cpx #7
        bne lsrloekke
        rts

        // ***************
        // *** D A T A ***
        // ***************
bitnummer:             .byte 0
farve:                 .byte HVID
tegnvaerdi:            .byte 0
aflaestLageradresse:   .byte 0
adresseforskydning:    .byte 0
gemtFB:                .byte 0
gemtFC:                .byte 0
gemtFD:                .byte 0
gemtFE:                .byte 0

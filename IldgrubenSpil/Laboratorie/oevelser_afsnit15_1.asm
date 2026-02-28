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
        clc
        lda aflaestLageradresse
        and #%10000000
        jsr lsr7
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
        lda aktuelTegnadresseLaveByte
        sta gemtTegnadresseLaveByte
        lda aktuelTegnadresseHoejeByte
        sta gemtTegnadresseHoejeByte
        lda aktuelFarveadresseLaveByte
        sta gemtFarveadresseLaveByte
        lda aktuelFarveadresseHoejeByte
        sta gemtFarveadresseHoejeByte
        rts
hentTegnOgFarveAdresser:
        lda gemtTegnadresseLaveByte
        sta aktuelTegnadresseLaveByte
        lda gemtTegnadresseHoejeByte
        sta aktuelTegnadresseHoejeByte
        lda gemtFarveadresseLaveByte
        sta aktuelFarveadresseLaveByte
        lda gemtFarveadresseHoejeByte
        sta aktuelFarveadresseHoejeByte
        rts
nulstilSkaermafsaet:
        lda #$00
        sta skaermafsaetLaveByte
        lda #$00
        sta skaermafsaetLaveByte
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
        adc skaermafsaetLaveByte
        sta skaermafsaetLaveByte
        lda #0
        adc skaermafsaetHoejeByte
        sta skaermafsaetHoejeByte
        rts
kopierSkaermafsaet:
        lda skaermafsaetLaveByte
        sta aktuelTegnadresseLaveByte
        lda skaermafsaetHoejeByte
        sta aktuelTegnadresseHoejeByte
        lda skaermafsaetLaveByte
        sta aktuelFarveadresseLaveByte
        lda skaermafsaetHoejeByte
        sta aktuelFarveadresseHoejeByte
        rts
adderTegnadrBegynd:
        clc
        lda #$04
        adc aktuelTegnadresseHoejeByte
        sta aktuelTegnadresseHoejeByte
        rts
adderFarveadrBegynd:
        clc
        lda #$d8
        adc aktuelFarveadresseHoejeByte
        sta aktuelFarveadresseHoejeByte
        rts
adderAdresser8bit:
        clc
        lda adresseforskydning
        adc aktuelTegnadresseLaveByte
        sta aktuelTegnadresseLaveByte
        lda #0
        adc aktuelTegnadresseHoejeByte
        sta aktuelTegnadresseHoejeByte
        clc
        lda adresseforskydning
        adc aktuelFarveadresseLaveByte
        sta aktuelFarveadresseLaveByte
        lda #0
        adc aktuelFarveadresseHoejeByte
        sta aktuelFarveadresseHoejeByte
        rts
tegnPaaSkaerm:
        ldy #0
        lda aktuelTegnadresseLaveByte
        sta $FB
        lda aktuelTegnadresseHoejeByte
        sta $FC
        lda tegnvaerdi
        sta ($FB),y
        lda aktuelFarveadresseLaveByte
        sta $FD
        lda aktuelFarveadresseHoejeByte
        sta $FE
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
        clc
        rts

        // ***************
        // *** D A T A ***
        // ***************
bitnummer:                      .byte 0
farve:                          .byte HVID
tegnvaerdi:                     .byte 0
aflaestLageradresse:            .byte 0
adresseforskydning:             .byte 0
aktuelTegnadresseLaveByte:      .byte 0
aktuelTegnadresseHoejeByte:     .byte 0
aktuelFarveadresseLaveByte:     .byte 0
aktuelFarveadresseHoejeByte:    .byte 0
gemtTegnadresseLaveByte:        .byte 0
gemtTegnadresseHoejeByte:       .byte 0
gemtFarveadresseLaveByte:       .byte 0
gemtFarveadresseHoejeByte:      .byte 0
skaermafsaetLaveByte:           .byte 0
skaermafsaetHoejeByte:          .byte 0


        BasicUpstart2(klargoering)

        .label HVID = 1
        .label GRAA = 12
        .label RENS_SKAERM = $e544
        .label RAEKKENR = 6
        .label KOLONNENR = 16
        .label NUL = 48
        .label STYREPIND2ADRESSE = $dc00
        .label KNAP_BIT = 5
        .label HOEJRE_BIT = 4
        .label VENSTRE_BIT = 3
        .label NED_BIT = 2
        .label OP_BIT = 1
        
        // *******************************
        // *** H O V E D P R O G R A M ***
        // *******************************
klargoering:     
        cld
        jsr klargoerSprittere
        jsr RENS_SKAERM
        jsr beregnTegnOgFarveAdresser
        jsr gemTegnOgFarveAdresser
        jsr klargoeringA
        rts
klargoerSprittere:      
hovedprg:
        cld
        lda #%00000001  // spritteraktiveringer
        sta $D015
        lda #%00000000  // flerfarver
        sta $D01C
        lda #%00000000  // bit9
        sta $D010
        ldx #0
        ldy #0
opsaetAspekter:
        jsr opsaetningsrutine
        iny
        cpy #3
        bne opsaetAspekter
        rts
        // ***********************************
        // *** H J A E L P E R U T I N E R ***
        // ***********************************
opsaetningsrutine:
        lda startadresserLaveByte,y
        sta $FB
        lda startadresserHoejeByte,y
        sta $FC
        lda iterationsgraenser,y
        sta $FD
        sty $FE
        ldy #0
opsaetningsloekke:
        lda opsaetningsdata,x
        sta ($FB),y
        iny
        inx
        cpy $FD
        bne opsaetningsloekke
        ldy $FE
        rts
        
ajourfoerSpritterkoordinater:
        lda lsr7ud_resultat
        cmp #0
        beq findBittype
        
        lda #$00
        sta $FB
        lda #$D0
        sta $FC
        
        ldx #0
        ldy #0
        lda opsaetningsdata,x
        sta ($FB),y
        
        ldx #1
        ldy #1
        lda opsaetningsdata,x
        sta ($FB),y
        
        rts       
findBittype:
   bittype_HOEJRE: 
        lda bitnummer
        cmp #HOEJRE_BIT
        bne bittype_VENSTRE
        lda #2
        sta $d020
        clc
        ldx #0
        inc opsaetningsdata,x
   bittype_VENSTRE:        
        lda bitnummer
        cmp #VENSTRE_BIT
        bne bittype_NED
        lda #3
        sta $d020
        sec
        ldx #0
        dec opsaetningsdata,x
   bittype_NED:        
        lda bitnummer
        cmp #NED_BIT
        bne bittype_OP
        lda #4
        sta $d020
        clc
        ldx #1
        inc opsaetningsdata,x
   bittype_OP:        
        lda bitnummer
        cmp #OP_BIT
        bne findBittypeUd
        lda #5
        sta $d020
        sec
        ldx #1
        dec opsaetningsdata,x
findBittypeUd:
        rts
        
klargoeringA:
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

klargoeringB:
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
        sta lsr7ind_bitmoenster
        jsr lsr7
        lda lsr7ud_resultat
        adc #NUL
        sta tegnvaerdi
        jsr tegnPaaSkaerm
        jsr ajourfoerSpritterkoordinater
        asl aflaestLageradresse
        lda #1
        sta adresseforskydning
        jsr adderAdresser8bit
        dec bitnummer
        lda bitnummer
        cmp #0
        bne kolonneindholdLoekke
        jmp klargoeringB
        
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
        sta skaermafsaetHoejeByte
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
        lda lsr7ind_bitmoenster
        ldx #0
lsrloekke:      
        lsr
        inx
        cpx #7
        bne lsrloekke
        clc
        sta lsr7ud_resultat
        rts

        // *********************************
        // *** R U T I N E A R E A L E R ***
        // *********************************
lsr7Areal:
inddata:
   lsr7ind_bitmoenster:         .byte 0
uddata:
   lsr7ud_resultat:             .byte 0
              
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

startadresserLaveByte:
        .byte $00,$F8,$27
startadresserHoejeByte:
        .byte $D0,$07,$D0  // $D000: Koordinatadresser, $07F8: Moensteradresser, $D025: Farveadresser
iterationsgraenser:    
        .byte 16,8,10
opsaetningsdata:        
        .byte 173,135,0,0,0,0,0,0,0,0,0,0,0,0,0,0 // spritterkoordinater
        .byte $80,$80,$80,$80,$80,$80,$80,$80 // moensteradresser
        .byte CYAN,CYAN,CYAN,CYAN,CYAN,CYAN,CYAN,CYAN,CYAN,CYAN // spritterfarver

*=$2000 "Sprittere"
spritter0:
        .byte %11111111,%11111111,%11111111
        .byte %11000000,%00000000,%00000011
        .byte %10100000,%00000000,%00000101
        .byte %10010000,%00000000,%00001001
        .byte %10001000,%00000000,%00010001
        .byte %10000100,%00000000,%00100001
        .byte %10000011,%11111111,%11000001
        .byte %10000001,%00000000,%10000001
        .byte %10000001,%00000000,%10000001
        .byte %10000001,%00000000,%10000001
        .byte %10000001,%00000000,%10000001
        .byte %10000001,%00000000,%10000001
        .byte %10000001,%00000000,%10000001
        .byte %10000001,%00000000,%10000001
        .byte %10000011,%11111111,%11000001
        .byte %10000100,%00000000,%00100001
        .byte %10001000,%00000000,%00010001
        .byte %10010000,%00000000,%00001001
        .byte %10100000,%00000000,%00000101
        .byte %11000000,%00000000,%00000011
        .byte %11111111,%11111111,%11111111
        .byte %00000000
spritter1:
        .byte %11111111,%11111111,%11111111
        .byte %11000000,%00000000,%00000011
        .byte %10100000,%00000000,%00000101
        .byte %10010000,%00000000,%00001001
        .byte %10001000,%00000000,%00010001
        .byte %10000100,%00000000,%00100001
        .byte %10000011,%11111111,%11000001
        .byte %10000001,%00000000,%10000001
        .byte %10000001,%00000000,%10000001
        .byte %10000001,%00000000,%10000001
        .byte %10000001,%00000000,%10000001
        .byte %10000001,%00000000,%10000001
        .byte %10000001,%00000000,%10000001
        .byte %10000001,%00000000,%10000001
        .byte %10000011,%11111111,%11000001
        .byte %10000111,%11111111,%11100001
        .byte %10001111,%11111111,%11110001
        .byte %10011111,%11111111,%11111001
        .byte %10111111,%11111111,%11111101
        .byte %11111111,%11111111,%11111111
        .byte %11111111,%11111111,%11111111
        .byte %00000000
spritter2:
        .byte %11111111,%11111111,%11111111
        .byte %00110000,%00000000,%00000010
        .byte %00001100,%00000000,%00000010
        .byte %00000011,%00000000,%00000010
        .byte %00000000,%11000000,%00000010
        .byte %00000000,%00110000,%00000010
        .byte %00000000,%00001100,%00000010
        .byte %00000000,%00000011,%00000010
        .byte %00000000,%00000000,%11000010
        .byte %00000000,%00000000,%00110010
        .byte %00000000,%00000000,%00001010
        .byte %00000000,%00000000,%00010010
        .byte %00000000,%00000000,%01000010
        .byte %00000000,%00000001,%00000010
        .byte %00000000,%00000100,%00000010
        .byte %00000000,%00010000,%00000010
        .byte %00000000,%01000000,%00000010
        .byte %00000001,%00000000,%00000010
        .byte %00000100,%00000000,%00000010
        .byte %00010000,%00000000,%00000010
        .byte %01010101,%01010101,%01010101
        .byte %00000000
spritter3:
        .byte %11111111,%11111111,%11111111
        .byte %10000000,%00000000,%00001100
        .byte %10000000,%00000000,%00110000
        .byte %10000000,%00000000,%11000000
        .byte %10000000,%00000011,%00000000
        .byte %10000000,%00001100,%00000000
        .byte %10000000,%00110000,%00000000
        .byte %10000000,%11000000,%00000000
        .byte %10000011,%00000000,%00000000
        .byte %10001100,%00000000,%00000000
        .byte %10100000,%00000000,%00000000
        .byte %10000100,%00000000,%00000000
        .byte %10000001,%00000000,%00000000
        .byte %10000000,%01000000,%00000000
        .byte %10000000,%00010000,%00000000
        .byte %10000000,%00000100,%00000000
        .byte %10000000,%00000001,%00000000
        .byte %10000000,%00000000,%01000000
        .byte %10000000,%00000000,%00010000
        .byte %10000000,%00000000,%00000100
        .byte %01010101,%01010101,%01010101
        .byte %00000000

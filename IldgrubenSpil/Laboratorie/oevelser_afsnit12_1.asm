        BasicUpstart2(opsaetning)

        // *******************************
        // *** H O V E D P R O G R A M ***
        // *******************************
opsaetning:     
        cld
kontrollogik:
        lda #%00000000
        ora #%00000001          // 00000001
        lsr                     // 00000000, mente: 1
        adc #0                  // 00000001
        ora #%10000000          // 10000001
        asl                     // 00000010, mente: 1
        adc #0                  // 00000011
        and #%00000011          // 00000011
        cmp #%00000011
        bne deErIkkeEns
deErEns:
        jsr begyndIndlaes1
        jmp hovedprg
deErIkkeEns:
        jsr begyndIndlaes2
hovedprg:
        jsr tegnPaaSkaerm1
hovedloekke:
        jsr kopierKantfarve
        jmp hovedloekke

        // ***********************************
        // *** H J A E L P E R U T I N E R ***
        // ***********************************
begyndIndlaes1:
        ldx #0  //x := 0
loekke1: //Indlaes fra stamtabel til arbejdstabel
        lda stamtabel1,x
        sta arbejdstabel,x
        inx
        cpx #9
        bne loekke1
        rts
begyndIndlaes2:
        ldx #0  //x := 0
loekke2: //Indlaes fra stamtabel til arbejdstabel
        lda stamtabel2,x
        sta arbejdstabel,x
        inx
        cpx #9
        bne loekke2
        rts
tegnPaaSkaerm1:
        ldy #0
tegn1:
        tya
        sta $0400,y
        sta $d800,y
        iny
        cpy #256
        bne tegn1
tegnPaaSkaerm2:
        ldy #0
tegn2:
        tya
        sta $0540,y
        lda #1
        sta $d940,y
        iny
        cpy #256
        bne tegn2
        rts
kopierKantfarve:
        ldy #0  //y := 0
kopier: //Kopiér fra arbejdstabel til kantfarve
        lda arbejdstabel,y
        sta $d020
        iny
        cpy #9
        bne kopier
        rts

        // ***************
        // *** D A T A ***
        // ***************
arbejdstabel:
        .byte 0
        .byte 0
        .byte 0
        .byte 0
        .byte 0
        .byte 0
        .byte 0
        .byte 0
        .byte 0
stamtabel1:
        .byte 1
        .byte 1
        .byte 1
        .byte 1
        .byte 1
        .byte 1
        .byte 1
        .byte 1
        .byte 1
stamtabel2:
        .byte 0
        .byte 1
        .byte 2
        .byte 3
        .byte 4
        .byte 5
        .byte 6
        .byte 7
        .byte 8


        

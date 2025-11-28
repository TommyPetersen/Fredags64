        BasicUpstart2(opsaetIndlaes)

opsaetIndlaes:
        ldx #0  //x := 0
indlaes: //Indlaes fra stamtabel til farvetabel
        lda stamtabel,x
        sta arbejdstabel,x
        inx
        sec
        txa
        sbc #8  //Hvis rx = 8 så hop ud af loekken
        beq opsaetKantfarve
        jmp indlaes
opsaetKantfarve:
        ldy #0  //y := 0
kopier: //Kopiér fra arbejdstabel til kantfarve
        lda arbejdstabel,y
        sta $d020
        iny
        sec
        tya
        sbc #8  //Hvis ry = 8 så hop tilbage til opsaetning af loekken
        beq opsaetKantfarve
        jmp kopier
        
        //Farvetabeller
arbejdstabel:
        .byte 0
        .byte 0
        .byte 0
        .byte 0
        .byte 0
        .byte 0
        .byte 0
        .byte 0
stamtabel:
        .byte 5
        .byte 7
        .byte 8
        .byte 2
        .byte 1
        .byte 4
        .byte 6
        .byte 1

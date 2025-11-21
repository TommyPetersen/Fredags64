	BasicUpstart2(kontrollogik)

	// *******************************
	// *** H O V E D P R O G R A M ***
	// *******************************
kontrollogik:
	lda #10
	clc
	adc #5
	sec
	sbc #10
	cmp #5
	bne deErIkkeEns
deErEns:
	jsr begyndIndlaes1
	jmp hovedloekke
deErIkkeEns:	
	jsr begyndIndlaes2
hovedloekke:
	jsr kopierKantfarve
	jmp hovedloekke

	// ***********************************
	// *** H J A E L P E R U T I N E R ***
	// ***********************************
begyndIndlaes1:
	ldx #0	//x := 0
loekke1: //Indlaes fra stamtabel til arbejdstabel
	lda stamtabel1,x
	sta arbejdstabel,x
	inx
	cpx #9
	bne loekke1
	rts
begyndIndlaes2:
	ldx #0	//x := 0
loekke2: //Indlaes fra stamtabel til arbejdstabel
	lda stamtabel2,x
	sta arbejdstabel,x
	inx
	cpx #9
	bne loekke2
	rts

kopierKantfarve:
	ldy #0	//y := 0
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

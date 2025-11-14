	BasicUpstart2(begynd1)

begynd1:

loekke1:
	inc $d020
	//jmp loekke1
	
	rts

begynd2:
	lda #KANTFARVE
	sta $d020

	lda spillerliv
	sta $d021

	ldx #TEGNFARVE1
	stx $d800
	stx $d801
	stx $d802
	
	lda #3		// C
	sta $0400
	lda #54		// 6
	sta $0401
	lda #52		// 4
	sta $0402

	ldx #TEGNFARVE2
	stx $d831
	stx $d832
	stx $d833
	stx $d834
	stx $d835
	stx $d836
	stx $d837
	stx $d838
	stx $d839

	inc $d021
	//jmp begynd2
	
	rts
	
	//Konstant
	.label KANTFARVE = 3
	.label TEGNFARVE1 = 1
	.label TEGNFARVE2 = 7
	
	//Variabel
	spillerliv: .byte 5

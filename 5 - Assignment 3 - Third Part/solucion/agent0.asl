// mars robot 1
movs(0).
/* Initial beliefs */

/* Initial goal */

//!check(slots). 
!start.
/* Plans */

+!start : size(N) <-
	.print("Sabemos el tamaño del tablero:", N);
	!initiateBB(N);
	.print("Iniciamos la partida.");
	!nextPlay.

+!start : not size(N) <- !start.

+!initiateBB(N) : true <- 
	.print("Inicializando el modelo del tablero.");
	+maxBlocks(N/4);
	+maxQueens(N/2);
	+maxHoles(N/4);
	for (.range(I,0,N-1)){
		for (.range(J,0,N-1)){
			+free(I,J);
			}
		};
	+update(done);
	.print("Finalizada la creacion del modelo del tablero.").
	
+!nextPlay : not playAs(Player) & maxBlocks(N) <- !putBlocks(N).

+!nextPlay : not player(X) & not is(first) & playAs(1) <- !nextPlay.

+!nextPlay : playAs(0) & not player(_) & is(first) & update(done) <- 
	?size(N);
	-is(first);
	.print("Blancas comienzan moviendo siempre en pos(", N/2, ",", N/2, " )");
	queen(N/2,N/2);
	!nextPlay.

+!nextPlay : player(Player) & playAs(Player) & update(done) <- 
	.print("Coloco como: ", Player);
	.findall(pos(X,Y), free(X,Y), ListaLibres);
	.length(ListaLibres, N);
	.wait(500);
	!selectMov(ListaLibres);
	/*if (playAs(0)) {
		!selectWhiteMov(ListaLibres); 
	} else {
		!selectBlackMov(ListaLibres);
	};*/
	!nextPlay.
	
+!nextPlay : free(_, _) <- 
	//.wait(100); 
	!nextPlay.
	
+!nextPlay : not free(_,_) <-
	.print("No hay movimientos posibles.").
	
+!selectMov(L) : playAs(0) & L == [] <- 
	.print("No hay movimientos elegibles.").

+!selectMov(L) : playAs(0) & maxBlocks(Cuartos) <- 
	.wait(500);
	if (.member(pos(Cuartos,Y),L) & free(Cuartos,Y)) {
		queen(Cuartos,Y);
		.print("Blancas con conciencia mueve a pos(",Cuartos,", ",Y,")");
	} else {
		if (.member(pos(X,Cuartos),L) & free(X,Cuartos)) {
			queen(X,Cuartos);
			.print("Blancas con conciencia mueve a pos(",X,", ",Cuartos,")");
		} else {
			.nth(0,L,pos(X,Y));
			if (free(X,Y)) {
				queen(X,Y);
				.print("Blancas mueve porque quiere a pos(",X,", ",Y,")");
			} else {
				?free(I,J);
				queen(I,J);
				.print("Blancas mueve a la primera libre que queda: pos(",I,", ",J,")");
			}
		}
	}.

+!selectMov(L) : playAs(1) & L == [] <- 
	.print("No hay movimientos elegibles.").

+!selectMov(L) : playAs(1) & .length(L,N) & .nth(N-1,L,pos(X,Y)) & free(X,Y) <- 
	queen(X,Y);
	.print("Negras mueve con conciencia a pos(",X,", ",Y,")").

+!selectMov(L) : playAs(1) <- 
	?free(I,J);
	queen(I,J);
	.print("Negras mueve porque si a pos(",I,", ",J,")").

/*
+!selectMov(L) : not playAs(N) & L == [] <- 
	.print("No hay movimientos elegibles.").

+!selectMov(L) : not playAs(N) & maxBlocks(Cuartos) <- 
	.print("Juega configurer..........");
	!putBlocks(Cuartos);
	.print("Configurer acaba de mover.").
*/
+!putBlocks(N) : N==0 <- .print("No puedo colocar más bloques.").

+!putBlocks(N) : N > 0 <-
	.findall(pos(X,Y),free(X,Y),Lista);
	.length(Lista,Length);
	if (Length>N) {
		.nth(math.round(Length/(2*N)),Lista,pos(I,J));
		if (free(I,J)) {
			hole(I,J);
			.print("Configurador mueve a la primera libre que queda: pos(",I,", ",J,")");
		} else {
			?free(X,Y);
			block(X,Y);
			.print("Configurador mueve a la primera libre que queda: pos(",X,", ",Y,")");
		};
	} else {
		?free(X,Y);
		block(X,Y);
		.print("Configurador mueve a la primera libre que queda: pos(",X,", ",Y,")");
	};
	!putBlocks(N-1).

+block(X,Y) <- -free(X,Y).

+hole(X,Y) <- -free(X,Y).

+queen(X,Y): size(N) & movs(Mov) <- 
	-update(done);
	-free(X,Y);
	-+movs(Mov+1);
	for (.range(I,0,N-1)){
		if (not I=X){
			-free(I,Y);
			if (Mov mod 2==1) {
				+queenAttack(black,I,Y);
			} else {
				+queenAttack(white,I,Y);
			}
		};
		if (not I=Y){
			-free(X,I);
			if (Mov mod 2==1) {
				+queenAttack(black,X,I);
			} else {
				+queenAttack(white,X,I);
			}
		};
		if ((not I=0) & (Y+I<N) & (X+I<N)){
			-free(X+I,Y+I);
			if (Mov mod 2==1) {
				+queenAttack(black,X+I,Y+I);
			} else {
				+queenAttack(white,X+I,Y+I);
			}
		};
		if ((not I=0) & (Y-I>=0) & (X-I>=0)){
			-free(X-I,Y-I);
			if (Mov mod 2==1) {
				+queenAttack(black,X-I,Y-I);
			} else {
				+queenAttack(white,X-I,Y-I);
			}
		};
		if ((not I=0) & (Y-I>=0) & (X+I<N)){
			-free(X+I,Y-I);
			if (Mov mod 2==1) {
				+queenAttack(black,X+I,Y-I);
			} else {
				+queenAttack(white,X+I,Y-I);
			}
		};
		if ((not I=0) & (Y+I<N) & (X-I>=0)){
			-free(X-I,Y+I);
			if (Mov mod 2==1) {
				+queenAttack(black,X-I,Y+I);
			} else {
				+queenAttack(white,X-I,Y+I);
			}
		};			
	};
	+update(done).

+block(X,Y)[source(S)] : not S=percept <- -block(X,Y)[source(S)].	
+hole(X,Y)[source(S)] : not S=percept <- -hole(X,Y)[source(S)].	




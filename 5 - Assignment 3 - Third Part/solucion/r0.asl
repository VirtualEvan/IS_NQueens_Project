// Agent r3 in project mars.mas2j

/* Initial beliefs and rules */
/*
check(X,Y) :-
  horizontal(X,Y) |
  vertical(X,Y) |
  diagonal(X,Y).


horizontal(X,Y) :-
  (queen(X,_) & not block(X,_)) |
  (queen(X,YQ) & block(X,YB) & not (((Y < YB) & (YB < YQ)) | ((Y > YB) & (YB > YQ)))).

vertical(X,Y) :-
  (queen(_,Y) & not block(_,Y)) |
  (queen(XQ,Y) & block(XB,Y) & not (((X < XB) & (XB < XQ)) | ((X > XB) & (XB > XQ)))).

diagonal(X,Y):-queen(X,Y).
diagonal(X1,Y1) :-
  block(X1,Y1) |
  size(N) &
  ( queen(X2,Y2) & ((X1-X2 == Y1-Y2) | (X2-X1 == Y1-Y2)) & not (block(X3,Y3) & ((X1-X3 == Y1-Y3) | (X3-X1 == Y1-Y3))) ) |
  ( queen(X2,Y2) & (X1-X2 == Y1-Y2) & block(X3,Y3) & (X1-X3 == Y1-Y3) & ((Y3<Y2 & Y2<Y1 & X3<X2 & X2<X1) | //DiagonalSI (Block-Queen-Space)
                                                                         (Y3>Y2 & Y2>Y1 & X3>X2 & X2>X1) | //DiagonalID (Block-Queen-Space)
                                                                         (Y3<Y1 & Y1<Y2 & X3<X1 & X1<X2) | //DiagonalSI (Block-Space-Queen)
                                                                         (Y3>Y1 & Y1>Y2 & X3>X1 & X1>X2)) ) | //DiagonalID (Block-Space-Queen)
  ( queen(X2,Y2) & (X2-X1 == Y1-Y2) & block(X3,Y3) & (X3-X1 == Y1-Y3) & ((Y3<Y2 & Y2<Y1 & X3>X2 & X2>X1) | //DiagonalSD (Block-Queen-Space)
                                                                         (Y3>Y2 & Y2>Y1 & X3<X2 & X2<X1) | //DiagonalII (Block-Queen-Space)
                                                                         (Y3<Y1 & Y1<Y2 & X3>X1 & X1>X2) | //DiagonalII (Block-Space-Queen)
                                                                         (Y3>Y1 & Y1>Y2 & X3<X1 & X1<X2)) ). //DiagonalII (Block-Space-Queen)
*/


/* Initial goals */

!start.

/* Plans */
+!start : playAs(0) <-
  .wait(500);
  ?size(N);
  !amenazadas;
  !play
  .

+!start : playAs(1).


+!start : not playAs(_) <-
  .wait(500);
  !playConfig
  .

+size(N)<-
  +configMovs(N/4);
  !crearTablero(N).

/* ----- Crea un tablero de casillas libres con el numero de casillas que amenaza cada una ----- */
+!crearTablero(N) <-
	for(.range(X,0,N-1)){
		for(.range(Y,0,N-1)){
			+free(X,Y,N*N);
		}
	}.

+queen(X,Y) [source(percept)]  <-
	.print("Actualizando base de conocimientos");
	!ocupar(X,Y);
  .wait(1000);
	!amenazadas;
  .wait(1000);
 // .findall(pos(PosX,PosY,R),free(PosX,PosY,R),Lista);
 // .print("OLA K ASE ",Lista);
  .

/* ----- Comprueba que la casilla esté amenazada ----- */
+!check(X,Y,Check) <-
  if(queen(X,Y)){
    Check = true;
  }
  else {
    +check(false);
    //Filas
    !filaDerecha(X+1,Y,check);
    !filaIzquierda(X-1,Y,check);

    //Columnas
    !columnaSuperior(X,Y-1,check);
    !columnaInferior(X,Y+1,check);

    //Diagonales
    !diagonalSI(X-1,Y-1,check);
    !diagonalSD(X+1,Y-1,check);
    !diagonalII(X-1,Y+1,check);
    !diagonalID(X+1,Y+1,check);
    ?check(Check);
    .abolish(check(_));
  }
  .
-!check(X,Y)<-.print("ERROR CHECK").


/* ----- Elimina casillas que no son libres ----- */
+!ocupar(X,Y) <-
	-free(X,Y,_);
  //Filas
  !filaDerecha(X+1,Y,ocupar);
  !filaIzquierda(X-1,Y,ocupar);

  //Columnas
  !columnaSuperior(X,Y-1,ocupar);
  !columnaInferior(X,Y+1,ocupar);

  //Diagonales
  !diagonalSI(X-1,Y-1,ocupar);
  !diagonalSD(X+1,Y-1,ocupar);
  !diagonalII(X-1,Y+1,ocupar);
  !diagonalID(X+1,Y+1,ocupar).
-!ocupar(X,Y).

/* ----- Actualiza el contador de casillas libres que amenaza cada casilla ----- */
+!amenazadas <-
	?size(N);
  +cont(0);
	for(free(X,Y,AM)){
    -+cont(0);
   // .print("ANALIZANDO ", X,",",Y);
    //Filas
    !filaDerecha(X+1,Y,contar);
    !filaIzquierda(X-1,Y,contar);

    //Columnas
    !columnaSuperior(X,Y-1,contar);
    !columnaInferior(X,Y+1,contar);

    //Diagonales
    !diagonalSI(X-1,Y-1,contar);
    !diagonalSD(X+1,Y-1,contar);
    !diagonalII(X-1,Y+1,contar);
    !diagonalID(X+1,Y+1,contar);

    ?cont(Amenazadas);
		-free(X,Y,AM);
    //La casilla X,Y se cuenta como amenazada tanto en filas como columnas como diagonales (-2)
		+free(X,Y,Amenazadas);
   // .print(X,",",Y,",",Amenazadas);
	}
  .abolish(cont(_)).
-!amenazadas<-.print("ERROR AMENAZADAS").

//Filas
+!filaDerecha(X,Y,Z) : size(N) & not block(X,Y) & X<N <-
  if(Z == check & queen(X,Y) & check(false)){
    -+check(true);
  }
  if(Z == ocupar){
    -free(X,Y,_);
  }
  if(Z == contar & free(X,Y,_)){
    ?cont(AUX);
    -+cont(AUX+1);
   // .print(X,",",Y);
  }
  !filaDerecha(X+1,Y,Z).
+!filaDerecha(X,Y,Z).

+!filaIzquierda(X,Y,Z) : size(N) & not block(X,Y) & X>=0 <-
  if(Z == check & queen(X,Y) & check(false)){
    -+check(true);
  }
  if(Z == ocupar){
    -free(X,Y,_);
  }
  if(Z == contar & free(X,Y,_)){
    ?cont(AUX);
    -+cont(AUX+1);
   // .print(X,",",Y);
  }
  !filaIzquierda(X-1,Y,Z).
+!filaIzquierda(X,Y,Z).

//Columnas
+!columnaSuperior(X,Y,Z) : size(N) & not block(X,Y) & Y>=0 <-
  if(Z == check & queen(X,Y) & check(false)){
    -+check(true);
  }
  if(Z == ocupar){
    -free(X,Y,_);
  }
  if(Z == contar & free(X,Y,_)){
    ?cont(AUX);
    -+cont(AUX+1);
   // .print(X,",",Y,",",Z);
  }
  !columnaSuperior(X,Y-1,Z).
+!columnaSuperior(X,Y,Z).

+!columnaInferior(X,Y,Z) : size(N) & not block(X,Y) & Y<N <-
  if(Z == check & queen(X,Y) & check(false)){
    -+check(true);
  }
  if(Z == ocupar){
    -free(X,Y,_);
  }
  if(Z == contar & free(X,Y,_)){
    ?cont(AUX);
    -+cont(AUX+1);
   // .print(X,",",Y,",",Z);
  }
  !columnaInferior(X,Y+1,Z).
+!columnaInferior(X,Y,Z).

//Diagonales
+!diagonalSI(X,Y,Z) : size(N) & not block(X,Y) & Y>=0 & X>=0 <-
  if(Z == check & queen(X,Y) & check(false)){
    -+check(true);
  }
  if(Z == ocupar){
    -free(X,Y,_);
  }
  if(Z == contar & free(X,Y,_)){
    ?cont(AUX);
    -+cont(AUX+1);
   // .print(X,",",Y);
  }
  !diagonalSI(X-1,Y-1,Z).
+!diagonalSI(X,Y,Z).

+!diagonalSD(X,Y,Z) : size(N) & not block(X,Y) & Y>=0 & X<N <-
  if(Z == check & queen(X,Y) & check(false)){
    -+check(true);
  }
  if(Z == ocupar){
    -free(X,Y,_);
  }
  if(Z == contar & free(X,Y,_)){
    ?cont(AUX);
    -+cont(AUX+1);
   // .print(X,",",Y);
  }
  !diagonalSD(X+1,Y-1,Z).
+!diagonalSD(X,Y,Z).

+!diagonalII(X,Y,Z) : size(N) & not block(X,Y) & Y<N & X>=0 <-
  if(Z == check & queen(X,Y) & check(false)){
    -+check(true);
  }
  if(Z == ocupar){
    -free(X,Y,_);
  }
  if(Z == contar & free(X,Y,_)){
    ?cont(AUX);
    -+cont(AUX+1);
   // .print(X,",",Y);
  }
  !diagonalII(X-1,Y+1,Z).
+!diagonalII(X,Y,Z).

+!diagonalID(X,Y,Z) : size(N) & not block(X,Y) & Y<N & X<N <-
  if(Z == check & queen(X,Y) & check(false)){
    -+check(true);
  }
  if(Z == ocupar){
    -free(X,Y,_);
  }
  if(Z == contar & free(X,Y,_)){
    ?cont(AUX);
    -+cont(AUX+1);
   // .print(X,",",Y);
  }
  !diagonalID(X+1,Y+1,Z).
+!diagonalID(X,Y,Z).


/* ----- Turnos ----- */

+player(N) : playAs(N) <- .wait(500); !play.

+player(N) : playAs(M) & not N==M /*& M\==config*/ <- .wait(300); .print("No es mi turno.").


/* ----- Jugar ----- */
+!play : configMovs(M) & playAs(P) <-
  if (M > 0){

    .print("El configurador dispone de ", M, " movimientos");
    .wait({+block(_,_)},4900,EventTime);
    !select(Max1,Max2);
    .print("Maximo: ", Max1);
    !getPosition(Max1, X1,Y1);
    !getPosition(Max2, X2,Y2);
    queen(X1,Y1);
    if( .random(N) & N > 0.5){
      .print("El jugador ", P ," solicita un bloque en ", Max2);
      .send(configurer, tell, block(X2,Y2));
    } else {
      .print("El jugador ", P ," solicita un agujero en ", Max2);
      .send(configurer, tell, hole(X2,Y2));
    }
  } else {
    .print("El configurador ha agotado todos sus movimientos, se salta su turno");
    .wait(500);
    !select(Max);
    .print("Maximo: ", Max);
    !getPosition(Max, X,Y);
    queen(X,Y);

  }
  .
-!play <-.print("Juego Finalizado").

+!getPosition(pos(N,X,Y),X,Y).


/* ----- Seleccionar la Posición con mayor número de amenazadas ----- */
+!select(Max) <-
	.wait(700);
  //NumAmenazadas,X,Y
  .findall(pos(N,X,Y),free(X,Y,N),ListaPosiciones);
  .print("Posiciones posibles: ",ListaPosiciones);
  .max(ListaPosiciones,Max).
-!select(Max) <- Max = [].

/* ----- Seleccionar las dosi posiciones con mayor número de amenazadas ----- */
+!select(Max1,Max2) <-
	.wait(700);
  //NumAmenazadas,X,Y
  .findall(pos(N,X,Y),free(X,Y,N),ListaPosiciones);
  .print("Posiciones posibles: ",ListaPosiciones);
  .max(ListaPosiciones,Max1);
  .delete(Max1,ListaPosiciones,NuevaLista);
  .max(NuevaLista,Max2).
-!select(Max1,Max2) <- Max1 = [];Max2 = [].


/**********************  A partir de aquí se gestiona el configurador  ******************************/

/* ----- Turno del configurador ----- */
+!playConfig: configMovs(M) & N > 0 <-
  !amenazadas;
 // .wait({+!amenazadas});
 // .print("HA LLEGADO AL playConfig!!!!!!!!!!!!!!!!!!!");
 // .send(Ag, tell, accept),, Ag = {white, black}
  !putBlock
  .

/* ----- Colocar bloque ----- */
+!putBlock : configMovs(M) & M>0 <-
  .findall(pos(X,Y,Ag), (accepted(block(X,Y,Ag)) | accepted(hole(X,Y,Ag))), Accepted);
  if( .length(Accepted)=2 ){
    .print("Posiciones aceptadas ", Accepted);
    .nth(0,Accepted,pos(I,J,A1));
    .nth(1,Accepted,pos(O,K,A2));
    if(free(I,J,_)>free(O,K,_)){
      if (accepted(block(I,J,_))){
        block(I,J);
        .print("Bloque colocado en la posición sugerida por el jugador ", A1);
      } else {
        hole(I,J);
        .print("Agujero colocado en la posición sugerida por el jugador ", A1);
      }
    }
    else {
      if(free(I,J,_)<free(O,K,_)){
        if (accepted(block(O,K,_))){
          block(I,J);
          .print("Bloque colocado en la posición sugerida por el jugador ", A1);
        } else {
          hole(I,J);
          .print("Agujero colocado en la posición sugerida por el jugador ", A1);
        }
      }
      else {
        ?free(P,L,_);
        block(P,L,_);
        .print("Bloque colocado en la primer posición libre");
      }
    }
    .abolish(accepted(_));
  }
  !putBlock;
  .
-!putBlock <- .print("ERROR PUTBLOCK").
+!putBlock <- .print("El configurador no dispone de más movimientos").

/* ----- Acepta la petición ----- */ ///////////////////////////////////////////////////////////////////
/*+!accept(Player) : accepted(block(X,Y)) <-
	.send(Player,tell,accept).

+!accept(Player) <-
	.print("Acepto en cualquier caso.").*/

/* ------ BLOQUES ------ */
+block(X,Y) [source(percept)] : configMovs(M) <-
  -free(X,Y,_);
  -+configMovs(M-1);
	.print("Actualizando base de conocimientos");
  ?size(Size);
  for(.range(V,0,Size-1)){
    for(.range(W,0,Size-1)){
      if(not free(V,W,_) & not block(V,W) & not hole(V,W)){
        !check(V,W,Check);
        if(Check\==true){
          +free(V,W,0);
         // .print("Pos liberada",V,",",W);
        }
      }
    }
  }
  !amenazadas;
  .wait(1000)
  .

+block(X,Y) [source(Ag)] : not Ag == percept & accepted(block(_,_,Ag)) <-
	.print("Ya se ha aceptado una petición de este agente");
	.send(Ag,tell,decline).

+block(X,Y) [source(Ag)] : not Ag == percept & not accepted(block(_,_,Ag)) <-
  -block(X,Y);
	.findall(pos(I,J), free(I,J,_), ListaLibres);
	.length(ListaLibres, Num);
	if (Num > 1 & not queen(X,Y) & not hole(X,Y)) {
		+accepted(block(X,Y,Ag));
		.send(Ag,tell,accept);
    .print("Aceptado bloque del jugador ", Ag);
	} else {
			.send(Ag,tell,decline)
	}.

/* ------ AGUJEROS ------ */
+hole(X,Y) [source(percept)] : configMovs(M) <-
  -free(X,Y,_);
  -+configMovs(M-1);
	.print("Actualizando base de conocimientos");
  ?size(Size);
  for(.range(V,0,Size-1)){
    for(.range(W,0,Size-1)){
      if(not free(V,W,_) & not block(V,W) & not hole(V,W)){
        !check(V,W,Check);
        if(Check\==true){
          +free(V,W,0);
          .print("Pos liberada",V,",",W);
        }
      }
    }
  }
  !amenazadas;
  .wait({+!amenazadas});
  .findall(pos(PosX,PosY),free(PosX,PosY,_),Lista);
  .print(Lista)
 .

+hole(X,Y) [source(Ag)] : not Ag == percept & accepted(hole(_,_,Ag)) <-
	.print("Ya se ha aceptado una petición de este agente");
	.send(Ag,tell,decline).

+hole(X,Y) [source(Ag)] : not Ag == percept & not accepted(hole(_,_,Ag)) <-
  -hole(X,Y);
	.findall(pos(I,J), free(I,J,_), ListaLibres);
	.length(ListaLibres, Num);
	if (Num > 1 & not queen(X,Y) & not block(X,Y)) {
		+accepted(hole(X,Y,Ag));
		.send(Ag,tell,accept);
    .print("Aceptado agujero del jugador ", Ag);
	} else {
			.send(Ag,tell,decline)
	}.

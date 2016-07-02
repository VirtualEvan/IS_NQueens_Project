// Agent r3 in project mars.mas2j

/* Initial beliefs and rules */

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

diagonal(X1,Y1) :-
  block(X1,Y1) |
  ( queen(X2,Y2) & ((X1-X2 == Y1-Y2) | (X2-X1 == Y1-Y2)) & not (block(X3,Y3) & ((X1-X3 == Y1-Y3) | (X3-X1 == Y1-Y3))) ) |
  ( queen(X2,Y2) & (X1-X2 == Y1-Y2) & block(X3,Y3) & (X1-X3 == Y1-Y3) & ((Y3<Y2 & Y2<Y1 & X3<X2 & X2<X1) | //DiagonalSI (Block-Queen-Space)
                                                                         (Y3>Y2 & Y2>Y1 & X3>X2 & X2>X1) | //DiagonalID (Block-Queen-Space)
                                                                         (Y3<Y1 & Y1<Y2 & X3<X1 & X1<X2) | //DiagonalSI (Block-Space-Queen)
                                                                         (Y3>Y1 & Y1>Y2 & X3>X1 & X1>X2)) ) | //DiagonalID (Block-Space-Queen)
  ( queen(X2,Y2) & (X2-X1 == Y1-Y2) & block(X3,Y3) & (X3-X1 == Y1-Y3) & ((Y3<Y2 & Y2<Y1 & X3>X2 & X2>X1) | //DiagonalSD (Block-Queen-Space)
                                                                         (Y3>Y2 & Y2>Y1 & X3<X2 & X2<X1) | //DiagonalII (Block-Queen-Space)
                                                                         (Y3<Y1 & Y1<Y2 & X3>X1 & X1>X2) | //DiagonalII (Block-Space-Queen)
                                                                         (Y3>Y1 & Y1>Y2 & X3<X1 & X1<X2)) ). //DiagonalII (Block-Space-Queen)



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
  !amenazadas;
  !putBlock.

+size(N)<-
  +blockNum(N/4);
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
 // .findall(pos(PosX,PosY),free(PosX,PosY,_),Lista);
 // .print(Lista);
  .wait({+!ocupar(X,Y)});
	!amenazadas;
  .wait({+!amenazadas});
  .

+block(X,Y) <-
  -free(X,Y,_);
	.print("Actualizando base de conocimientos");
  ?size(Size);
  for(.range(V,0,Size-1)){
    for(.range(W,0,Size-1)){
      if(not check(V,W) & not free(V,W,_)){
        +free(V,W,0);
        .print("Pos liberada",V,",",W);
      }
    }
  }
  !amenazadas;
  .wait({+!amenazadas});
  .findall(pos(PosX,PosY),free(PosX,PosY,_),Lista);
  .print(Lista)
 .

/* ----- Elimina casillas que no son libres ----- */
+!ocupar(X,Y) <-
  .print("Reina: ",X,",",Y);
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

//Filas
+!filaDerecha(X,Y,Z) : size(N) & not block(X,Y) & X<N <-
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


/* ----- Actualiza el contador de casillas libres amenazadas ----- */
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

/* ----- Turnos ----- */

+player(N) : playAs(N) <- .wait(500); !play.

+player(N) : playAs(M) & not N==M /*& M\==blocker*/ <- .wait(300); .print("No es mi turno.").


/* ----- Jugar ----- */
+!play : blockNum(B) <-
  if (B > 0){
    .wait({+block(_,_)},1000,EventTime);
    -+blockNum(B-1);
  } else {
    .wait(500);
  }
  !select(Max);
  .print("Maximo: ", Max);
  !getPosition(Max, X,Y);
  queen(X,Y).
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

/* ----- Colocar bloque ----- */
+!putBlock : blockNum(B) & B>0 <-
 // .print("BOQUESSSSSSSSSSSSSSSSSSS: ",B);
 // .random(R);
  .wait({+queen(_,_)});
  !select(Max);
  .print("Maximo: ", Max);
  !getPosition(Max, X,Y);
  if(not queen(X,Y)){
    block(X,Y);
    -+blockNum(B-1);
  }
  !putBlock;
  .
-!putBlock <- .print("ERROR PUTBLOCK").
+!putBlock.

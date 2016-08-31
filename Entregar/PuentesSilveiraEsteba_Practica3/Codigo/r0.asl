// Agent r3 in project mars.mas2j

/* Initial beliefs and rules */

/* Initial goals */

!start.

/* Plans */
+!start : playAs(0) <-
  .wait(500);
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
  .wait(1000);
	!amenazadas;
  .wait(1000);
  .

+block(X,Y) <-
  -free(X,Y,_);
	.print("Actualizando base de conocimientos");
  ?size(Size);
  for(.range(V,0,Size-1)){
    for(.range(W,0,Size-1)){
      if(not free(V,W,_) & not block(V,W) & not hole(V,W)){
        !check(V,W,Check);
        if(Check\==true & not hole(V,W)){
          +free(V,W,0);
          .print("Pos liberada",V,",",W);
        }
      }
    }
  }
  !amenazadas;
  .wait(1000);
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

+player(N) : playAs(M) & not N==M  <- .wait(300); .print("No es mi turno.").


/* ----- Jugar ----- */
+!play : blockNum(B) <-
  if (B > 0){
    .wait({+block(_,_)},1000,EventTime);
    -+blockNum(B-1);
    .wait(1000);
  } else {
    .wait(1000);
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
  .wait(1000);
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

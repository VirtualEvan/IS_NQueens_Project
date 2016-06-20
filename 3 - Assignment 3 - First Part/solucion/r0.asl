// Agent r3 in project mars.mas2j

/* Initial beliefs and rules */

check(X,Y) :-
  horizontal(X,Y) |
  vertical(X,Y) |
  diagonal(X,Y).


horizontal(X,Y) :-
  queen(X,_).

vertical(X,Y) :-
  queen(_,Y).

diagonal(X1,Y1) :-
  queen(X2,Y2) & ((X1-X2 == Y1-Y2) | (X2-X1 == Y1-Y2)) & ((X1-X3 == Y1-Y3) | (X3-X1 == Y1-Y3)).



/* Initial goals */

!start.

/* Plans */
+!start : playAs(0) <- .wait(300);
  !amenazadas;
  !play.

+!start : playAs(1) <- true.

+size(N)<- !crearTablero(N).

/* ----- Crea un tablero de casillas libres con el numero de casillas que amenaza cada una ----- */
+!crearTablero(N) <-
	for(.range(X,0,N-1)){
		for(.range(Y,0,N-1)){
			+free(X,Y,N*N);
		}
	}.

+queen(X,Y) [source(percept)] : playAs(N) <-
	.print("Actualizando base de conocimientos");
	!ocupar(X,Y);
 // .findall(pos(PosX,PosY),free(PosX,PosY,_),Lista);
 // .print(Lista);
	!amenazadas;
  .

/* ----- Elimina casillas que no son libres ----- */
+!ocupar(X,Y) <-
  .print(X,",",Y);
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
+!filaDerecha(X,Y,Z) : size(N) & X<N <-
  if(Z == ocupar){
    -free(X,Y,_);
   // .print(X,",",Y);
  }
  if(Z == contar & free(X,Y,_)){
    ?cont(AUX);
    -+cont(AUX+1);
  }
  !filaDerecha(X+1,Y,Z).
+!filaDerecha(X,Y,Z).

+!filaIzquierda(X,Y,Z) : size(N) & X>=0 <-
  if(Z == ocupar){
    -free(X,Y,_);
   // .print(X,",",Y);
  }
  if(Z == contar & free(X,Y,_)){
    ?cont(AUX);
    -+cont(AUX+1);
  }
  !filaIzquierda(X-1,Y,Z).
+!filaIzquierda(X,Y,Z).

//Columnas
+!columnaSuperior(X,Y,Z) : size(N) & Y>=0 <-
  if(Z == ocupar){
    -free(X,Y,_);
   // .print(X,",",Y,",",Z);
  }
  if(Z == contar & free(X,Y,_)){
    ?cont(AUX);
    -+cont(AUX+1);
  }
  !columnaSuperior(X,Y-1,Z).
+!columnaSuperior(X,Y,Z).

+!columnaInferior(X,Y,Z) : size(N) & Y<N <-
  if(Z == ocupar){
    -free(X,Y,_);
   // .print(X,",",Y,",",Z);
  }
  if(Z == contar & free(X,Y,_)){
    ?cont(AUX);
    -+cont(AUX+1);
  }
  !columnaInferior(X,Y+1,Z).
+!columnaInferior(X,Y,Z).

//Diagonales
+!diagonalSI(X,Y,Z) : size(N) & Y>=0 & X>=0 <-
  if(Z == ocupar){
    -free(X,Y,_);
  //  .print(X,",",Y);
  }
  if(Z == contar & free(X,Y,_)){
    ?cont(AUX);
    -+cont(AUX+1);
  }
  !diagonalSI(X-1,Y-1,Z).
+!diagonalSI(X,Y,Z).

+!diagonalSD(X,Y,Z) : size(N) & Y>=0 & X<N <-
  if(Z == ocupar){
    -free(X,Y,_);
   // .print(X,",",Y);
  }
  if(Z == contar & free(X,Y,_)){
    ?cont(AUX);
    -+cont(AUX+1);
  }
  !diagonalSD(X+1,Y-1,Z).
+!diagonalSD(X,Y,Z).

+!diagonalII(X,Y,Z) : size(N) & Y<N & X>=0 <-
  if(Z == ocupar){
    -free(X,Y,_);
   // .print(X,",",Y);
  }
  if(Z == contar & free(X,Y,_)){
    ?cont(AUX);
    -+cont(AUX+1);
  }
  !diagonalII(X-1,Y+1,Z).
+!diagonalII(X,Y,Z).

+!diagonalID(X,Y,Z) : size(N) & Y<N & X<N <-
  if(Z == ocupar){
    -free(X,Y,_);
   // .print(X,",",Y);
  }
  if(Z == contar & free(X,Y,_)){
    ?cont(AUX);
    -+cont(AUX+1);
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


+player(N) : playAs(N) <- .wait(300); !play.

+player(N) : playAs(M) & not N==M <- .wait(300); .print("No es mi turno.").

/* ----- Turno Blancas ----- */

+player(0):playAs(0) <-
	-player(0)[source(percept)];
	!play.


/* ----- Turno Negras ----- */

+player(1):playAs(1) <-
	-player(1)[source(percept)];
	!play.

/* ----- Jugar ----- */
+!play <-
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

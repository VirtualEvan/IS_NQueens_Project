// Agent r3 in project mars.mas2j

/* Initial beliefs and rules */

comprobar(X,Y) :-
  horizontal(X,Y) |
  vertical(X,Y) |
  diagonal(X,Y).


horizontal(X,Y) :-
  queen(X,_).

vertical(X,Y) :-
  queen(_,Y).

diagonal(X1,Y1) :-
  queen(X2,Y2) &
  ((X1-X2 == Y1-Y2) |
  (X2-X1 == Y1-Y2)).


/* Initial goals */

!start.

/* Plans */
+!start :playAs(0) <- .wait(300);
  !ocupar;
  !amenazadas;
  !play.

+!start :playAs(1) <- true.

+size(N)<- !crearTablero(N).

/* ----- Crea un tablero de casillas libres con el numero de casillas que amenaza cada una ----- */
+!crearTablero(N) <-
	for(.range(X,0,N-1)){
		for(.range(Y,0,N-1)){
			+free(X,Y,N*N);
		}
	}.

+queen(X,Y) [source(percept)] : playAs(N)<-
	.print("Actualizando base de conocimientos");
	!ocupar;
	!amenazadas;
  .


/* ----- Elimina casillas que no son libres ----- */
+!ocupar: size(N)  <-
	for(.range(X,0,N-1)){
		for(.range(Y,0,N-1)){
			if (comprobar(X,Y)){
				-free(X,Y,_);
			}
		}
	}.
-!ocupar.


/* ----- Actualiza el contador de casillas libres amenazadas ----- */
+!amenazadas <-
	?size(N);
  +cont(0);
	for(free(X,Y,AM)){
    -+cont(0);

    // Número de casillas amenazadas en filas y columnas
    .findall(pos(_,X,Y),
            //Condiciones
            free(X,_,_) |
            free(_,Y,_) ,
            //Salida
            FilaColumna);

    // Número de casillas amenazadas en diagonales
    for(.range(I,0,N-1)){
			for(.range(J,0,N-1)){
        if(free(I,J,_)&((X-I == Y-J)|(I-X == Y-J))){
          ?cont(AUX);
          -+cont(AUX+1);
				}
      }
    }

    .length(FilaColumna,FC);
    ?cont(Diagonales);

		-free(X,Y,AM);
    //La casilla X,Y se cuenta como amenazada tanto en filas como columnas como diagonales (-2)
		+free(X,Y,FC+Diagonales-2);
	}
  .abolish(cont(_)).
-!amenazadas<-.print("ERROR AMENAZADAS").


+player(N) : playAs(N) <- .wait(300); !play.

+player(N) : playAs(M) & not N==M <- .wait(300); .print("No es mi turno.").

/* ----- Turno Blancas ----- */
/*
+player(0):playAs(0) <-
	-player(0)[source(percept)];
	!play.
*/

/* ----- Turno Negras ----- */
/*
+player(1):playAs(1) <-
	-player(1)[source(percept)];
	!play.
*/
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

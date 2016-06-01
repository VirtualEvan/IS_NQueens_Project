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
  queen(X2,Y2) &
  ((X1-X2 == Y1-Y2) |
  (X2-X1 == Y1-Y2)).


/* Initial goals */

!start.

/* Plans */
+!start :playAs(0) <-
	queen(0,0).

+!start :playAs(1) <- true.

+size(N)<- !crearTablero(N).

// ----- Crea un tablero de casillas libres con el numero de casillas que amenaza cada una -----
+!crearTablero(N) <-
	for(.range(I,0,N-1)){
		for(.range(J,0,N-1)){
			+free(I,J,N*N);
		}
	}.

+queen(X,Y) [source(percept)] : playAs(N)<-
	.print("Actualizar base de conocimientos");
	!ocupar;
  .print("Hola");
	!amenazadas;
  .print("Adios")
  .


// ----- Elimina casillas que no son libres -----
+!ocupar: size(N)  <-
	for(.range(I,0,N-1)){
		for(.range(J,0,N-1)){
			if (check(I,J)){
				-free(I,J,_);
       // .print(I,",",J);
			}
		}
	}.
-!ocupar.


// ----- Actualiza el contador de casillas libres amenazadas -----
+!amenazadas <-
	?size(N);
	for(free(X,Y,AM)){
    +cont(0);
    ?cont(AUX);
		for(.range(I,0,N-1)){
			for(.range(J,0,N-1)){
        ?cont(AUX);
        .print("X:",X," Y:",Y," I:",I," J:",J," AUX:",AUX);
				if(free(X,J,_)){
          +cont(AUX+1);
         // -cont(AUX);
				}
				if(free(I,Y,_)){
          +cont(AUX+1);
         // -cont(AUX);
				}
				if(free(I,J,_)&((X-I == Y-J)|(I-X == Y-J))){
          +cont(AUX+1);
         // -cont(AUX);
				}
			}
		}
    ?cont(AUX);
		-free(X,Y,AM);
		+free(X,Y,AUX);
   // ?free(W,V,HELP);
   // .print(HELP);
	}
  .abolish(cont(_)).
-!amenazadas<-.print("ERROR AMENAZADAS").

// ----- Juegan Blancas -----
+player(0):playAs(0) <-
	-player(0)[source(percept)];
	!jugar.


// ----- Juegan Negras -----
+player(1):playAs(1) <-
	-player(1)[source(percept)];
	!jugar.

// ----- Jugar -----
+!jugar <-
	!select(ListaPosiciones);
	.print("POSICION: ",ListaPosiciones);
  .nth(0,ListaPosiciones,First);
  !getPosition(First, X,Y);
  queen(X,Y)
	.
-!jugar <-.print("Juego Finalizado").

+!getPosition(pos(X,Y,N),X,Y).


// ----- Movemos al agente a la posicion libre que mas posiciones libres amenaza -----
+!select(ListaPosiciones) <-
	.wait(700);
  .findall(pos(X,Y,N),free(X,Y,N),ListaPosiciones)
	.
-!select(ListaPosiciones)<-.print("ERROR SELECT").

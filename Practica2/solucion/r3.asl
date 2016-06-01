// mars robot 3

/* Initial beliefs */
colocadas([],[],Y,X,[Y],[X]).
colocadas(Ys,Xs,Y,X,[W|Ys],[V|Xs]).

solution(N,Ylist,Y,X) :-
  porcolocar(N,Dx,Du,Dv) &
  atacadas(Y,X,Dx,Dx,Du,Dv,Q,W,E,R) &
  sol(Ylist,Q,W,E,R).

atacadas([],[],Dy,Dx,Du,Dv,Dy,Dx,Du,Dv).
atacadas([Y|Ys],[X|Xs],Dy,Dx,Du,Dv,Q,W,E,R):-
  del(X,Dx,Dx1) &
  del(Y,Dy,Dy1) &
  U = X-Y  &
  del(U,Du,Du1) &
  V = X+Y  &
  del(V,Dv,Dv1) &
  atacadas(Ys,Xs,Dy1,Dx1,Du1,Dv1,Q,W,E,R).

porcolocar(N,T,Du,Dv) :-
  getdim(0,N,T) &
  getdim(-N,N,Du) &
  getdim(0,2*N,Dv).

getdim(Max, Max, [Max]).
getdim(Min, Max, [Min | Result]) :-
 Min <= Max &
 N1 = Min+1 &
 getdim(N1, Max, Result).


sol([],[],Dy,Du,Dv).
sol([Y|Ylist],[X|Dx1],Dy,Du,Dv) :-
 del(Y,Dy,Dy1) &
 U = X-Y &
 del(U,Du,Du1) &
 V = X+Y &
 del(V,Dv,Dv1) &
 sol(Ylist,Dx1, Dy1,Du1,Dv1).

del(Item,[Item|List],List).
del(Item,[First|List],[First|List1]) :-
 del(Item,List,List1).


/* Initial goal */
!start.
//!check(slots).
//!player(0).

/* Plans */
/*
+!start <-
  Colocadas=[1,6,4,-1,-1,-1,-1,3];
  !soluciones(8,Sols,[2,7,0,1],[4,3,1,6]);
  Num = .length(Sols);
  .print("Hay: ", Num, " soluciones.");
  !view_sols(Sols, Colocadas).
*/

+!start <-
     ?size(S);
     !soluciones(S,Sols,Yc,Xc);
     !viewSol(Sols,0, [-1,-1,-1,-1,-1,-1,-1,-1]).
/*
+player(0) <-
    ?size(S);
    ?queen(X, Y);
    ?colocadas(Yc,Xc,Y,X,ToretY,ToretX);
    .print("LAS PUTAS COLOCADAS _______________________________", ToretY);
    Colocadas=[-1,-1,-1,-1,-1,-1,-1,-1];
  	!soluciones(S,Sols,ToretY,ToretX);
    !view_sols(Sols, Colocadas).
-player(0).*/
+player(1) <- -player(1)[source(percept)];
    ?size(S);
    ?queen(X, Y);
    ?colocadas(Yc,Xc,Y,X,ToretY,ToretX);
    Colocadas=[-1,-1,-1,-1,-1,-1,-1,-1];
    !soluciones(S,Sols,ToretY,ToretX);
    !viewSol(Sols,0, Colocadas).

+!viewSol([Col|Cols],N, [Set|Old]) <-
  if (Set == -1){
    move_towards(Col,N);
    put(queen);
    //!viewSol(Cols,N+1,Old);
  } else {
    move_towards(Set,N);
    //put(queen);
    //!viewSol([Col|Cols],N+1,Old);
  }.


+!soluciones(N,ListaSol,Y,X) : solution(N-1,ListaSol,Y,X) <-
  .print("Solucion encontrada.");
  //.findall(X, solution(N-1,X), ListaSol);
	.print("Soluciones: ",ListaSol).
-!soluciones(N,ListaSol,Y,X) <- .print("=============no es solucion").


nqueens(Queens,Size) :-
  field(Size,T,Du,Dv),
  ocupate(Queens,T,T,Du,Dv).

field(N,T,Du,Dv) :-
  NegN is -N,
  DoubleN is 2*N,
  getdim(1,N,T),
  getdim(NegN,N,Du),
  getdim(2,DoubleN,Dv).

getdim(Max, Max, [Max]).
getdim(Min, Max, [Min | Result]) :-
  Min =< Max,
  N1 is Min+1,
  getdim(N1, Max, Result).

ocupate([],[],ListFila,Diag1,Diag2).
ocupate([Y|Fila],[X|Columna],ListFila,Diag1,Diag2) :-
  remove(Y,ListFila,ListFila1),
  V is X-Y,
  remove(V,Diag1,Diag1_1),
  W is X+Y,
  remove(W,Diag2,Diag2_1),
  ocupate(Fila,Columna, ListFila1,Diag1_1,Diag2_1).

remove(X,[X|Cdr],Cdr).
remove(X,[Cat|Cdr],[Cat|Cdr1]) :-
  remove(  X,Cdr,Cdr1).
// Agent liz in project testeenv.mas2j

!start.

+!start : true <- burn.


+fire <- run.


+run [source(A)] 
  <- .print("I receive an hello from ",A).

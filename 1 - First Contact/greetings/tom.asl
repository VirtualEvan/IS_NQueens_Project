// Agent tom in project greetings.mas2j

/* Initial beliefs and rules */

/* Initial goals */

!start.

/* Plans */

+!start : true <- .send(bob,tell,hello).

+hello[source(A)] 
  <- .print("I receive an hello from ",A);
     .send(A,tell,hello).


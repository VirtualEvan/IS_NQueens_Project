// Agent bob in project greetings.mas2j


+hello[source(A)] 
  <- .print("I received a 'hello' from ",A);
     .send(A,tell,hello).

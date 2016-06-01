// mars robot 1

/* Initial beliefs */

at(P) :- pos(P,X,Y) & pos(r1,X,Y).

/* Initial goal */

//!check(slots). 
!start.

/* Plans */
+!start <- 
	move_towards(1,0);
	put(queen);
	move_towards(3,1);
	put(queen);
	move_towards(5,2);
	put(queen);
	move_towards(7,3);
	put(queen);
	move_towards(4,4);
	put(queen);
	move_towards(6,5);
	put(queen);
	move_towards(0,6);
	put(queen);
	move_towards(2,7);
	put(queen).//;
	//move_towards(7,7).

+!check(slots) : not garbage(r1)
   <- next(slot); put(queen);
      !check(slots).
	  
+!check(slots). 


@lg[atomic]
+garbage(r1) : not .desire(carry_to(r2))
   <- !carry_to(r2).
   
+!carry_to(R)
   <- // remember where to go back
      ?pos(r1,X,Y); 
      -+pos(last,X,Y);
      
      // carry garbage to r2
      !take(garb,R);
      
      // goes back and continue to check
      !at(last); 
      !check(slots).

+!take(S,L) : true
   <- !ensure_pick(S); 
      !at(L);
      drop(S).

+!ensure_pick(S) : garbage(r1)
   <- pick(garb);
      !ensure_pick(S).
+!ensure_pick(_).

+!at(L) : at(L).
+!at(L) <- ?pos(L,X,Y);
           move_towards(X,Y);
		   //put(queen);
           !at(L).

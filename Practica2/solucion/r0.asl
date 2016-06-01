// mars robot 1

/* Initial beliefs */


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
	put(queen);
	move_towards(7,7).


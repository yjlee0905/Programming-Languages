(*For the test cases that raise exception, they are commented.*)

(*4-1*)
fun reverse (hd::tl) =
	foldl (fn (a, b) => a::b)
	[] (hd::tl);

reverse [1,2,3];


(*4-2*)
fun composelist v flist =
	case flist of
	[] => v
	| hd::tl => composelist (hd v) tl;

composelist 5 [fn x => x+1, fn x => x*2, fn x => x-3];
composelist "Hello" [fn x => x ^ " World!", fn x => x ^ " I love", fn x => x ^ " PL!"];


(*4-3*)
fun myfoldl f y [] = y
	| myfoldl f y (x::xs) = myfoldl f (f x y) xs;

fun scan_left f key [] = [key]
	| scan_left f key (x::xs) = key::scan_left f (f x key) xs;

scan_left (fn x => fn y => x+y) 0 [1,2,3];


(*4-4*)
exception Mismatch;
fun zip ([], []) = []
	| zip ([], hd2::tl2) = raise Mismatch
	| zip (hd1::tl1, []) = raise Mismatch
	| zip (hd1::tl1, hd2::tl2) = (hd1, hd2)::zip(tl1, tl2);

zip ([1,2,3,4,5], ["a", "b", "c", "d", "e"]);
(*zip ([1,2,3,4,5], ["a", "b", "c", "d"]);*)


(*4-5*)
fun unzip lsts = 
	case lsts of
	[] => ([], [])
	| (hd1, hd2)::tl =>
		let val (lst1, lst2) = unzip tl
		in (hd1::lst1, hd2::lst2) end;

unzip [(1, "a"), (5, "c"), (3, "e")];

(*4-6*)
fun bind NONE y f = NONE
	| bind x NONE f = NONE
	| bind (SOME x) (SOME y) f = SOME (f x y);

fun add x y = x + y;

bind (SOME 4) (SOME 3) add;
bind (SOME 4) NONE add; 


(*4-7*)
fun getitem n [] = NONE
	| getitem n (hd::tl) =
	if n = 1
	then SOME hd
	else getitem (n-1) tl;

getitem 2 [1,2,3,4];
getitem 5 [1,2,3,4];


(*4-8*)
fun getitem2 n [] = NONE
	| getitem2 NONE l = NONE
	| getitem2 (SOME n) (l::ls) =
	if n = 1
	then SOME l
	else getitem2 (SOME (n-1)) ls;

getitem2 (SOME 2) [1,2,3,4];
getitem2 (SOME 5) [1,2,3,4];
getitem2 NONE [1,2,3];
getitem2 (SOME 5) [];
getitem2 (SOME 5) ([] : int list);



(*5 Multi-Level Priority Queue in ML*)

signature MLQPARAM = 
sig
	type element;
	val max: int;
end;


functor MakeQ(Elem: MLQPARAM):
sig
	type 'a mlqueue

	(*exception Overflow*)
	exception Empty
	exception LevelNoExist
	exception NotFound

	val maxlevel: int 
	val new: 'a mlqueue 
	val enqueue: 'a mlqueue -> int -> int -> 'a -> 'a mlqueue
	val dequeue: 'a mlqueue -> 'a * 'a mlqueue 
	val move: ('a -> bool) -> 'a mlqueue -> 'a mlqueue
	val atlevel: 'a mlqueue -> int -> (int * 'a) list
	val lookup: ('a -> bool) -> 'a mlqueue -> int * int 
	val isempty: 'a mlqueue -> bool 
	val flatten: 'a mlqueue -> 'a list
end = struct
	type 'a mlqueue = (int * int * 'a) list;

	exception Overflow;
	exception Empty;
	exception LevelNoExist;
	exception NotFound;

	val maxlevel = Elem.max
	val new = []
	fun isempty (q) = null q
	fun dequeue [] = raise Empty
		| dequeue ((level, priority, item)::q) = (item, q)
	fun flatten q = map (fn (level, priority, item) => item) q

	fun lookup pred [] = raise NotFound
		| lookup pred ((level, priority, item)::tl) =
			if pred(item)
			then (level, priority)
			else lookup pred tl

	fun partition (pred, left, right, []) = (left, right)
		| partition (pred, left, right, x::xs) =
			if pred x
			then partition (pred, left@[x], right, xs)
			else partition (pred, left, right@[x], xs)

	fun enqueue q l p e =
		if l > maxlevel then raise LevelNoExist (*TODO smaller than?*)
		else
			if null q then q @ [(l, p, e)]
			else
				let fun compare((lx, px), (ly, py)) =
					if lx < ly then true
					else
						if ly < lx then false
						else
							if px <= py then true
							else false
					fun pred (lx, px, ix) = compare((lx,px), (l,p))
					(*TODO: change partition*)
					val (left, right) = partition (pred, [], [], q)
				in
					left @ [(l, p, e)] @ right
				end


	(*if moved level exceed maxlevel, do not move*)
	fun move pred q =
		let
			(*TODO partition*)
			val (left, right) = partition((fn (level, priority, item) => pred(item)), [], [], q);
			val lowered = List.map (fn (level, priority, item) => if level+1 <= maxlevel then (level+1, priority, item)
																else (level, priority, item)) left;
		in
			foldl (fn ((level, priority, item), q) => enqueue q level priority item) right lowered
		end

	fun atlevel q l =
        let
        	fun equal (x, y) = if x > y then false 
        					   else
        					   	if y > x then false 
        					   	else true

        	fun exists pred [] = false
    			| exists pred (x::xs) = pred x orelse exists pred xs;

            fun pred (level, priority, item) = equal(level, l)

            val filtered = List.filter pred q
        in
            if l > maxlevel then raise LevelNoExist
            else
            	if exists (fn (level, priority, item) => level = l) q
            	then List.map (fn (level, priority, item) => (priority, item)) filtered
            	else []
        end
 
end;


(*5-1*)
structure MaxLevel2Q : MLQPARAM=
	struct
		type element = int
		val max = 2
	end;

structure maxLevel2PQueue = MakeQ(MaxLevel2Q);

(*5-2*)
val q1 = [];
val q2 = maxLevel2PQueue.enqueue q1 1 1 2;
val q3 = maxLevel2PQueue.enqueue q2 0 0 3;
val q4 = maxLevel2PQueue.enqueue q3 2 0 5;
val q5 = maxLevel2PQueue.enqueue q4 2 2 1;
val q6 = maxLevel2PQueue.enqueue q5 1 0 4;
val q7 = maxLevel2PQueue.enqueue q6 2 1 6;

(*5-3*)
(*5-3 is commented, because it raise exception*)
(*val over_maxlevel_ex1 = maxLevel2PQueue.enqueue q7 3 1 2;*)
(*val over_maxlevel_ex2 = maxLevel2PQueue.enqueue q7 10 1 2;*)

(*5-4*)
val moved = maxLevel2PQueue.move (fn x => (x > 3)) q7;

(*5-5*)
val (elem1, dequeued1) = maxLevel2PQueue.dequeue q7;
val (elem2, dequeued2) = maxLevel2PQueue.dequeue dequeued1;

(*5-6*)
val atlevel = maxLevel2PQueue.atlevel q7 1;

(*below 2 test cases are just for testing atlevel*)
val atlevel = maxLevel2PQueue.atlevel dequeued2 0;
(*val atlevel = maxLevel2PQueue.atlevel dequeued2 3;*)

(*5-7*)
val (level, priority) = maxLevel2PQueue.lookup (fn x => x < 5) q7;
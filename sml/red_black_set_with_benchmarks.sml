signature MEM = sig
  type t
  val compare: t * t -> order
end


signature SET = sig
  type mem
  type t
  val empty: t
  val size: t -> int
  val mem: mem * t -> bool
  val insert: mem * t -> t
  val from_list: mem list -> t
  val tabulate: (int -> mem) -> int -> t
end


functor NaiveSet (Mem: MEM) : SET = struct
  type mem = Mem.t

  datatype t = Lf | Br of mem * t * t

  val empty = Lf
  
  fun size Lf = 0
    | size (Br(_,t1,t2)) = 1 + size t1 + size t2

  fun mem (_, Lf) = false
    | mem (x, Br(y,t1,t2)) = 
        case Mem.compare(x,y) of 
             EQUAL => true 
           | _     => mem(x,t1) orelse mem(x,t2)

  fun insert(x, Lf) = Br (x, Lf, Lf)
    | insert(x, t as Br(y,t1,t2)) = 
        case Mem.compare(x,y) of
             EQUAL => t
           | GREATER => Br (y,t1,insert(x,t2))
           | LESS => Br (y,insert(x,t1),t2)

  val from_list = List.foldl insert empty

  fun tabulate f n = 
    let fun aux (i, acc) = 
      if i=n then acc else aux(i+1, insert(f i, acc))
    in 
      aux (0, empty) 
    end

end

functor RedBlackSet (Mem: MEM) : SET = struct
  type mem = Mem.t

  datatype color = Red | Black
  datatype t = Lf | Br of color * mem * t * t
  
  val empty = Lf

  fun size Lf = 0
    | size (Br(_,_,t1,t2)) = 1 + size t1 + size t2

  fun mem (_, Lf) = false
    | mem (x, Br(_,y,t1,t2)) = 
        case Mem.compare(x,y) of 
             EQUAL => true 
           | _     => mem(x,t1) orelse mem(x,t2)

  fun balance (
    Br (Black, z, Br (Red, y, Br (Red, x, t1, t2), t3), t4)
  | Br (Black, z, Br (Red, x, t1, Br (Red, y, t2, t3)), t4)
  | Br (Black, x, t1, Br (Red, z, Br (Red, y, t2, t3), t4))
  | Br (Black, x, t1, Br (Red, y, t2, Br (Red, z, t3, t4)))
  ) = Br (Red, y, Br (Black, x, t1, t2), Br (Black, z, t1, t2))
    | balance t = t

  fun insert_aux (x, Lf) = Br (Red, x, Lf, Lf)
    | insert_aux (x, t as Br(c,y,t1,t2)) = 
        case Mem.compare(x,y) of
             EQUAL => t
           | GREATER => balance (Br (c,y,t1,insert_aux(x,t2)))
           | LESS => balance (Br (c,y,insert_aux(x,t1),t2))

  exception Impossible

  fun insert (x, t) =
    case insert_aux (x, t) of
         Lf => raise Impossible
       | Br (_,x,t1,t2) => Br(Black,x,t1,t2)

  fun tabulate f n = 
    let fun aux (i, acc) = 
      if i=n then acc else aux(i+1, insert(f i, acc))
    in 
      aux (0, empty) 
    end

  val from_list = List.foldl insert empty
end


(* Testing results *)
signature SET_TESTS = sig
  (* Print average time to look up an element *)
  val random_lookup_time: int -> unit  
  (* Print average time to look up an element among ordered elements*)
  val ordered_lookup_time: int -> unit 
end 


signature TESTABLE_SET = sig 
  include SET
  val random_set_maker: int ->  t
  val ordered_set_maker: int -> t
  val dummy_element: unit -> mem
end


functor Test (Set: TESTABLE_SET) :> SET_TESTS = struct
  fun calc_time prefix make_set n = 
    let
      val i = ref 0
      val seconds = ref 0.0
      val test_runs = 2
      val time_to_real = ((Real.fromLarge IEEEReal.TO_NEAREST) o Time.toReal)
    in 
      while !i < test_runs do (* Average over runs *)
        let 
          val timer = Timer.startRealTimer ()
          val test_set = make_set n
          val build_time = (time_to_real o Timer.checkRealTimer) timer
        in 
          seconds := !seconds + build_time
          ; i := !i + 1
        end
      ; print (prefix ^ Real.toString (!seconds / (Real.fromInt test_runs)) ^ "s" ^ "\n")
    end

  fun random_lookup_time n = 
    let val prefix = "Building set of " ^ Int.toString n ^ " random elements takes: "
    in calc_time prefix Set.random_set_maker n end

  fun ordered_lookup_time n = 
    let val prefix = "Building set of " ^ Int.toString n ^ " ordered elements takes: "
    in calc_time prefix Set.ordered_set_maker n end
end


structure IntMem : MEM = struct
  type t = int
  val compare = Int.compare
end

signature TEST_UTILS = sig
  val foo: int
end

(* I wonder how one could remove the code duplication here?
*  Higher order functors aren't a thing, I think. *)
structure NaiveTestableSet :> TESTABLE_SET = struct
  structure Set = NaiveSet(IntMem)
  open Set

  val dummy_element = 
    let
      val seed = Random.rand(798,435)
      val nextInt = Random.randRange(1,100000) 
    in
      fn () => nextInt seed
    end

  val ordered_set_maker = tabulate (fn n => n)

  val random_set_maker = 
    let
      val seed = Random.rand(132,546)
      val nextInt = Random.randRange(1,100000) 
    in
      tabulate (fn i => nextInt seed)
    end
end


structure RedBlackTestableSet :> TESTABLE_SET = struct
  structure Set = RedBlackSet(IntMem)
  open Set

  val dummy_element = 
    let
      val seed = Random.rand(798,435)
      val nextInt = Random.randRange(1,100000) 
    in
      fn () => nextInt seed
    end

  val ordered_set_maker = tabulate (fn n => n)

  val random_set_maker = 
    let
      val seed = Random.rand(132,546)
      val nextInt = Random.randRange(1,100000) 
    in
      tabulate (fn i => nextInt seed)
    end
end


structure RedBlackTests = Test(RedBlackTestableSet)
structure NaiveTests = Test(NaiveTestableSet)

(* Actually run the tests *)

fun runtests testf = 
  (
  testf 1000 (* Thousand *)
  ; testf 10000 (* Ten thousand *)
  ; testf 20000 (* Twenty thousand *)
  )

val _ = (
  print "Running Red Black Set benchmarks\n"
  ; runtests RedBlackTests.random_lookup_time
  ; runtests RedBlackTests.ordered_lookup_time
  ; print "\n\n"
  )

val _ = (
  print "Running Naive Set benchmarks\n"
  ; runtests NaiveTests.random_lookup_time
  ; runtests NaiveTests.ordered_lookup_time
  ; print "\n\n"
  )

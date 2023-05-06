signature MEM = sig
  type t
  val compare: t * t -> order
end

structure IntMem : MEM = struct
  type t = int
  val compare = Int.compare
end

signature SET = sig
  type mem
  type t
  val empty: t
  val size: t -> int
  val mem: mem * t -> bool
  val insert: mem * t -> t
  val from_list: mem list -> t
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
    Br (Black, x, Br(Red, y, Br(Red, z, t1, t2), t3), t4)
  | Br (Black, x, Br(Red, z, t1, Br(Red, y, t2, t3)), t4)
  | Br (Black, x, t1, Br(Red, z, Br(Red, y, t2, t3), t4))
  | Br (Black, x, t1, Br(Red, y, t2, Br(Red, z, t3, t4)))
  ) = Br (Red, y, Br(Black, x, t1, t2), Br(Black, z, t3, t4))
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

  val from_list = List.foldl insert empty
end

structure RedBlackTestSet = RedBlackSet(IntMem)
structure NaiveTestSet = NaiveSet(IntMem) 

(* Testing results *)

(* Make an ordered list n,n-1,...,0 *)
fun makelist 0 = []
  | makelist n = n :: makelist (n-1)

(* Make a random list of n ints between 1 and 100*)
fun randoms n =
  let
    val seed = Random.rand(123,456)
    val nextInt = Random.randRange(1,n) 
  in 
    List.tabulate(n, fn i => nextInt seed)
  end


(* Benchmarking random elements *)
val ordered_list = makelist 1000000
val random_list = randoms 1000000


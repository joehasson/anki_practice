(* Signatures Required for our Dictionary functor. The
 * functor will return different dictionary types for
 * different types of key. The argument will be another
 * structure which contains (i) The  type of the key
 * and (ii) how they are ordered *)

signature DICTIONARY = sig
  type key
  type 'a t
  exception E of key
  val empty: 'a t
  val lookup: 'a t * key -> 'a
  val insert: 'a t * key * 'a -> 'a t
  val update: 'a t * key * 'a -> 'a t
end

signature KEY = sig
  type t
  val compare: t * t -> order
end

functor Dictionary (Key: KEY) : DICTIONARY = struct
  type key = Key.t
  exception E of key

  abstype 'a t = Lf | Br of (Key.t * 'a) * 'a t * 'a t
  with
    val empty = Lf

    fun lookup (Lf, x) = raise E x
      | lookup (Br ((k,v), t1, t2), x) =
          case Key.compare (x,k) of
               LESS => lookup (t1, x)
             | GREATER => lookup (t2, x)
             | EQUAL => v

    fun insert (Lf, x, y) = Br ((x,y), Lf, Lf)
      | insert (Br ((k,v), t1, t2), x, y) =
          case Key.compare (x,k) of
               LESS => Br ((k,v), insert (t1, x, y), t2)
             | GREATER => Br ((k,v), t1, insert (t2, x, y))
             | EQUAl => raise E x

    fun update (Lf, x, y) = raise E x
      | update (Br ((k,v), t1, t2), x, y) =
          case Key.compare (x,k) of
               LESS => Br ((k,v), update (t1, x, y), t2)
             | GREATER => Br ((k,v), t1, update (t2, x, y))
             | EQUAl => Br ((x,y), t1, t2) 
  end
end

(* Test cases *)

structure IntKey : KEY = struct
  type t = int
  val compare = Int.compare
end

structure StringKey : KEY = struct
  type t = string
  val compare = String.compare
end

structure IntDict = Dictionary(IntKey)
structure StringDict = Dictionary (StringKey)

(* StringDict tests *)
val test_val0 = StringDict.empty;
val test_val1 = StringDict.insert(test_val0, "a", 1)
val test0 = StringDict.lookup(test_val1, "a") = 1
val test1 = (StringDict.lookup(test_val1, "b"); false) handle StringDict.E "b" => true
val test_val2 = StringDict.update(test_val1, "a", 2)
val test2 = StringDict.lookup(test_val2, "a")


signature SET = sig
  type key
  type t
  val insert: key * t -> t
  val mem: key * t -> bool
end

signature KEY = sig
  type t
  val compare: t * t -> order
end

functor RedBlackSet (Key: KEY) :> SET = struct
  type key = Key.t
  datatype color = Red | Black
  type t = Lf | Br of color * key * t * t

  fun mem (k, Lf) = false
    | mem (k, Br(_,x,t1,t2)) = 
        case Key.compare(k,x) of
             GREATER => mem (k, t2)
           | EQUAL => true
           | LESS => mem (k, t1)

  fun balance (
    Br (Black, x, Br(Red, y, Br(Red, z, t1, t2), t3), t4)
  | Br (Black, x, Br(Red, z, t1, Br(Red, y, t2, t3)), t4)
  | Br (Black, x, t1, Br(Red, z, Br(Red, y, t2, t3), t4))
  | Br (Black, x, t1, Br(Red, y, t2, Br(Red, z, t3, t4)))
  ) = Br (Red, y, Br(Black, x, t1, t2), Br(Black, z, t3, t4))
    | balance t = t

  fun insert_aux (k, Lf) = Br (Red, k, Lf, Lf)
    | insert_aux (k, Br(c,x,t1,t2)) = 
        case Key.compare(k,x) of
             GREATER => balance (Br(c,x,t1,insert_aux(k,t2)))
           | EQUAL => Br(c,x,t1,t2)
           | LESS => balance (Br(c,x,insert_aux(k,t1),t2))

  fun insert (k, t) = let val Br(_,x,t1,t2) = insert_aux t 
                      in Br(Black,x,t1,t2) end
end


datatype 'a tree = Lf | Br of 'a * 'a tree * 'a tree

signature DICTIONARY =
sig
  type key
  type 'a t
  exception E of key
  val empty: 'a t
  val lookup: 'a t * key -> 'a
  val insert: 'a t * key * 'a -> 'a t
  val update: 'a t * key * 'a -> 'a t
end


structure Dictionary : DICTIONARY =
struct
  type key = string
  type 'a t = (key * 'a) tree
  exception E of key
  val empty = Lf

  fun lookup (Lf, x) = raise E x
    | lookup (Br((k,v),t1,t2), x) =
        case String.compare(x,k) of
             GREATER => lookup (t2, x)
           | EQUAL => v
           | LESS => lookup (t1, x)

  fun insert (Lf, pr) = Br (pr, Lf, Lf)
    | insert (Br(root as (k,v),t1,t2), pr as (x,y)) =
        case String.compare(x,k) of
             GREATER => Br(root, t1, insert (t2, pr))
           | EQUAL => Br (pr, t1, t2)
           | LESS => Br (root, insert(t1, pr), t2)

  fun update (Lf, pr) = Br (pr, Lf, Lf)
    | update (Br(root as (k,v),t1,t2), pr as (x,y)) =
        case String.compare(x,k) of
             GREATER => Br(root, t1, insert (t2, pr))
           | EQUAL => Br (pr, t1, t2)
           | LESS => Br (root, insert(t1, pr), t2)
end

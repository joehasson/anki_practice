fun allChange (amount, coins) =
    let fun aux (0, coins, acc) = [acc]
          | aux (n, [], acc) = []
          | aux (n, c::coins, acc) = if n < 0 then [] 
                                              else aux (n-c, c::coins, c::acc) @ aux (n, coins, acc)
    in aux (amount, coins, []) end

fun allChangeIter (amount, coins) = 
    let fun aux (0, coins, acc, result) = acc::result
          | aux (n, [], acc, result) = result
          | aux (n, c::coins, acc, result) = if n < 0 then result
                                                      else aux (n, coins, acc, aux(n-c, c::coins, c::acc, result))
    in aux (amount, coins, [], []) end

signature STACK =
sig
  type 'a stack
  val empty: 'a stack
  val pop: 'a stack -> 'a stack
  val push: 'a ->'a stack -> 'a stack
  exception EmptyStack
end

structure Stack :> STACK =
struct
  exception EmptyStack
  type 'a stack = 'a list
  val empty = []
  fun pop [] = raise EmptyStack
    | pop (x::xs) = xs
  fun push x s = x::s
end

fun partition (pivot::xs) = 
  let fun aux (left, right, []) = (left, right)
        | aux (left, right, y::ys) =
            if y < pivot 
            then aux (y::left, right, ys)
            else aux (left, y::right, ys)
  in aux ([], [], xs) end


fun insert (x, []) = [x]
  | insert (x, y::ys) = if x < y then x::y::ys
                        else y::insert(x, ys)

fun insort [] = []
  | insort (x::xs) = insert(x, insort xs)

fun quicker lst =
  let fun quickIter ([], sorted) = sorted
        | quickIter (pivot::xs, sorted) =
            let fun aux (left, right, []) =
                      quickIter (left, pivot::quickIter(right, sorted))
                  | aux (left, right, y::ys) =
                      if y < pivot then aux (y::left, right, ys)
                                   else aux (left, y::right, ys)
            in aux ([], [], xs) end
  in quickIter (lst, []) end

fun powerSet lst =
      let fun aux ([], subset) = [subset]
            | aux (x::xs, subset) =
                aux (xs, x::subset) @ aux (xs, subset)
      in aux (lst, []) end

fun curry f x y = f (x, y)

datatype aexp =
  Num of int
| Add of aexp * aexp
| Mul of aexp * aexp
| Neg of aexp


fun allChangeIter (amount, coins) =
  let fun aux (n, [], coinsAcc, res) = res
        | aux (0, c::cs, coinsAcc, res) = coinsAcc::res
        | aux (n, c::cs, coinsAcc, res) =
                if n < 0 then res
                              else aux (n-c, c::cs, c::coinsAcc, aux (n, cs, coinsAcc, res))
  in aux (amount, coins, [], []) end


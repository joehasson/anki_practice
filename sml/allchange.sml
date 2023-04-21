fun allChange (amount, coins) =
  let fun aux (0, acc, _, ways) = acc::ways
        | aux (n, acc, [], ways) = ways
        | aux (n, acc, c::cs, ways) =
            if n < c then aux (n, acc, cs, ways)
            else aux (n-c, c::acc, c::cs, aux (n, acc, cs, ways))
  in aux (amount, [], coins, []) end
      

val amount = 16
val coins = [50, 20, 10, 5, 2, 1]
val test1 = List.length (allChange(amount, coins)) = 25

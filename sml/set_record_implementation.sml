
val test1 = let val S contents = empty_set
            in ((#size contents) ()) = 0 end

val has1 = let val S contents = empty_set
           in (#add contents) 1 end

val test2 = let val S contents = has1
           in (#contains contents) 1 end

val test3 = let val S contents = has1
           in (#size contents) () = 1 end

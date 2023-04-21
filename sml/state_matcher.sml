val test1 = state [] = true
val test2 = state [1] = false
val test3 = state [1,2,1,2,1] = false
val test4 = state [1,2,1,2,1,2] = true
val test5 = state [1,2,3,1,2,1,2] = false

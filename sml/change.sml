val sum_list = List.foldr (fn (x,y) => x+y) 0 

exception Change

fun change (_, 0) = []
  | change ([], amount) = raise Change
  | change (c::cs, amount) = 
    if c > amount then change (cs, amount)
    else c::change (c::cs, amount-c) handle Change => change (cs, amount)


val test1_val = change ([5,2], 16)  
val test1 = sum_list test1_val = 16
val test2_val =  change([186,419,83,408], 6249)
val test2 = sum_list test2_val = 6249
val test3_val = change([10, 5, 3], 26)
val test3 = sum_list test3_val = 26
val test4 = (change ([10,2], 101) handle Change => [~1]) = [~1]

exception OutOfBounds


val test1 = (quickselect ([0,1,2,3,4], 5); false) handle OutOfBounds => true
val test2 = (quickselect ([0,1,2,3,4], 100); false) handle OutOfBounds => true
val test3 = quickselect ([1,0,4,3,2], 3) = 3
val test4 = quickselect ([0,2,4,3,1], 0) = 0
val test5 = quickselect ([3,4,2,0,1], 4) = 4

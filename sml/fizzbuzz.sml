fun fizzbuzz () =
  let
    val i = ref 0
  in
    while !i <= 100 do
      (case (!i mod 3, !i mod 5) of 
           (0, 0) => print "Fizzbuzz\n"
         | (0, _) => print "Fizz\n"
         | (_, 0) => print "Buzz\n"
         | (_, _) => print (Int.toString (!i) ^ "\n");
      i := (!i) + 1)
  end

val _ = fizzbuzz ()

datatype 'a tree = Lf | Br of 'a * 'a tree * 'a tree


val birnam = Br ("The", Br ("wood", Lf, 
                                   Br ("of", Br ("Birnam", Lf, Lf), 
                                   Lf)), 
                       Lf)

val tree4 = Br (4, Br (2, Br (1, Lf, Lf),
                          Br (3, Lf, Lf)),
                   Br (5, Br (6, Lf, Lf),
                          Br (7, Lf, Lf)))


val preorder_test1 = preorder birnam = ["The", "wood", "of", "Birnam"]
val preorder_test2 = preorder tree4 = [4,2,1,3,5,6,7]
val inorder_test1 = inorder birnam = ["wood", "Birnam", "of", "The"]
val inorder_test2 = inorder tree4 = [1,2,3,4,6,5,7]
val postorder_test1 = postorder birnam = ["Birnam","of","wood","The"]
val postorder_test2 = postorder tree4 = [1,3,2,6,7,5,4]

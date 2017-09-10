fun assertEquals stmt1 stmt2 =
    if (fn (x,y) => x = y) (stmt1, stmt2)
        then "0"
    else "1"
    handle _ => "2";

fun assertEqualsReal stmt1 stmt2 = 
	if (fn (x,y) => Real.==(x,y)) (stmt1, stmt2)
		then "0"
	else "1"
	handle _ => "2";

fun list_compare [] [] = true
  | list_compare [] _ = false
  | list_compare (x::xs) [] = false
  | list_compare (x::xs) (y) = 
        let 
            fun delete _     [] = []
              | delete value (x::xs) = if x = value
                                then xs
                            else x::(delete value xs);
            val lst = delete x y
        in
            list_compare xs lst
        end;

fun assertPermutation stmt1 stmt2 = 
	if (fn (x,y) => list_compare x y) (stmt1, stmt2)
		then "0"
	else "1"
	handle _ => "2";

fun addTest a x y = ();
fun addSubTest a x y z = ();
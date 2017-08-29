fun assertEquals stmt1 stmt2 =
    if (fn (x,y) => x = y) (stmt1, stmt2)
        then "0"
    else "1"
    handle _ => "2";

assertEquals 5 5;


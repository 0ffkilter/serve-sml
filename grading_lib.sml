
local
    fun matchVar v e = 
        if v = "(*)"
            then false
        else
            if e = ("_")
                then true
            else
                v = e;
in
    fun matchEntry (a,b,c) p n =     
        if matchVar a p andalso
            matchVar b n
        then
            true
        else false

end;

fun entry_to_string (a,b,c) = 
     (a ^ "/" ^ b ^ "/" ^ c);

fun entries_to_string nil = ""
    | entries_to_string (x::xs) = 
        let
            val problems = entries_to_string xs
        in
            if problems <> ""
                then
                    x ^ "|" ^ problems
            else 
                x
        end;

fun filterEntries _ _ nil = []
    | filterEntries p n (x::xs) = if 
        matchEntry x p n then
            (entry_to_string x)::(filterEntries p n xs)
        else            
            filterEntries p n xs;

fun buildEntries p n entry_list = 
    let 
        val entry_list = filterEntries p n (entry_list);
    in
        entries_to_string entry_list
    end;

val entries = Array.array(100, ("(*)", "(*)", "1"));

fun addEntry value =
    let 
        val (_, _, idx_str) = (Array.sub(entries, 0))
        val idx = valOf (Int.fromString(idx_str))
    in 
        Array.update(entries, idx, value);
        Array.update(entries, 0, ("(*)", "(*)", Int.toString(idx + 1)))
    end;

fun addTest p n value = 
    addEntry (p, n, value);

fun getProblem p =
        buildEntries p "_" (Array.foldr (op ::) [] entries);

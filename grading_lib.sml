
local
    fun matchVar v e = 
        if v = "(*)"
            then false
        else
            if e = (" ")
                then true
            else
                v = e;
in
    fun matchEntry (a,b,c,d) p s_p n =     
        if matchVar a p andalso
            matchVar b s_p andalso
            matchVar c n
        then
            true
        else false

end;

fun entry_to_string (a,b,c,d) = 
     (a ^ "/" ^ b ^ "/" ^ c ^ "/" ^ d);

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

fun filterEntries _ _ _ nil = 
        let
            val _ = print ("empty?")
        in
            []
        end
    | filterEntries p s_p n (x::xs) = if 
        matchEntry x p s_p n then
            (entry_to_string x)::(filterEntries p s_p n xs)
        else            
            filterEntries p s_p n xs;

fun buildEntries p s_p n entry_list = 
    let 
        val entry_list = filterEntries p s_p n (entry_list);
    in
        entries_to_string entry_list
    end;

val entries = Array.array(100, ("(*)", "(*)", "(*)", "1"));

fun addEntry value =
    let 
        val (_, _, _, idx_str) = (Array.sub(entries, 0))
        val idx = valOf (Int.fromString(idx_str))
    in 
        Array.update(entries, idx, value);
        Array.update(entries, 0, ("(*)", "(*)", "(*)", Int.toString(idx + 1)))
    end;


fun getProblem p s_p =
        buildEntries p s_p " " (Array.foldr (op ::) [] entries);

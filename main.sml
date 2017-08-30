structure Serv = SERVER (structure Buf = DefaultBuffer; structure Par = BasicHTTP);

(* curl -d "a=foo&b=bar" localhost:8787/params *)

fun httpRes responseType extraHeaders body action = 
    ({
    httpVersion = "HTTP/1.1", responseType = responseType, 
    headers = ("Content-Length", Int.toString (String.size body))::extraHeaders,
    body = body
    }, action)

fun route f (request : Serv.Request) socket =
    let val path = case String.fields (curry (op =) #"/") (Serv.resource request) of
               (""::rest) => rest
             | p => p
    val (res, act) = f (Serv.method request) path (Serv.param request)
    in
    Serv.sendRes socket res;
    act
    end

fun doesFileExist filename =
    if OS.FileSys.realPath filename <> ""
        then true
    else
        false
        handle SysError => false;
      
fun simpleRes resCode body =
    httpRes resCode [] body Serv.CLOSE;

fun ok body = httpRes "200 Ok" [] body Serv.CLOSE;
fun err400 body = httpRes "404 Not Found" [] body Serv.CLOSE;
fun err404 body = httpRes "404 Not Found" [] body Serv.CLOSE;

fun err500 body = httpRes "500 Internal Server Error" [] body Serv.CLOSE;

fun build_filename nil = ""
  | build_filename (x::xs) = 
        let 
            val path = build_filename xs
        in
            if path <> ""
                then x ^ "/" ^ path
            else
                x
        end;


fun runFile filename =
    let
        val string_name = build_filename filename
    in 
        if doesFileExist string_name
            then
                (use string_name;
                ok string_name)
        else
            err500 "File not found"
    end;

fun handler "GET" ["status"] _ = 
    ok ("All Good")
  | handler "GET" ("file"::xs) _ = 
    runFile xs
  | handler "GET" ["results", p] _ =
        ok (getProblem p "_")
  | handler "GET" ["results", p, sub_p] _=
    ok (getProblem p sub_p)
  | handler "GET" ["kill"] _ =
    (ok ("Killing server...");
        OS.Process.exit OS.Process.success)
  | handler _ _ _ = 
    err404 "Sorry; I don't know how to do that";


fun getPort (port::_) = 
    let fun p (SOME n) = n
      | p NONE = 8181
    in 
    p (Int.fromString port)
    end
  | getPort _ = 8181;

Serv.serve (getPort (CommandLine.arguments ())) (route (handler)) ;

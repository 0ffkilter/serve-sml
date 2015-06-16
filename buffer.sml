datatype BufferStatus = Complete | Incomplete | Errored

signature BUFFER =
  sig
      type Buffer
      val new : int -> Buffer
      val newStatic : int -> Buffer
      val readInto : Buffer -> ('a,Socket.active Socket.stream) Socket.sock -> BufferStatus
      val toSlice : Buffer -> Word8ArraySlice.slice
      val printBuffer : Buffer -> unit
  end 

structure DefaultBuffer : BUFFER =
  struct 
  type Buffer = { fill : int ref, buf : Word8Array.array ref, done_p: (int -> Word8Array.array -> bool) }
  local 
      fun done {fill, buf, done_p} = done_p (!fill) (!buf)

      fun crlfx2 fill buf = 
	  let fun chk c i = (Word8.fromInt (Char.ord c)) = (Word8Array.sub (buf, fill - i))
	  in 
	      (fill >= 4) andalso (chk #"\r" 4) andalso (chk #"\n" 3) andalso (chk #"\r" 2) andalso (chk #"\n" 1)
	  end

      fun isFull {fill, buf, done_p} = (Word8Array.length (!buf)) = (!fill)

      fun grow {fill, buf, done_p} = 
	  let val len = Word8Array.length (!buf)
	      val newBuf = Word8Array.array (len * 2, Word8.fromInt 0)
	  in 
	      Word8Array.copy {di=0, dst=newBuf, src=(!buf)};
	      buf := newBuf;
	      ()
	  end
  in 

  fun readInto (buffer : Buffer) sock = 
      let val i = Socket.recvArrNB (sock, Word8ArraySlice.slice (!(#buf buffer), !(#fill buffer), SOME 1))
      in 
	  if done buffer
	  then Complete
	  else case i of
		   NONE => Incomplete
		 | SOME n => (#fill buffer := (!(#fill buffer) + n);
			      if isFull buffer then grow buffer else ();
			      readInto buffer sock)
      end
      handle _ => Errored

  fun newStatic size =
      let fun done f b = f = (Word8Array.length b)
      in
	  { fill= ref 0, buf= ref (Word8Array.array (size, Word8.fromInt 0)), done_p= done }
      end

  fun new initSize = 
      { fill= ref 0, buf= ref (Word8Array.array (initSize, Word8.fromInt 0)), done_p=crlfx2 }

  fun toSlice {fill, buf, done_p} = Word8ArraySlice.slice (!buf, 0, SOME (!fill))

  fun printBuffer (buffer : Buffer) =
      let fun printByte bt = 
	      let val chr = (Char.chr (Word8.toInt bt))
	      in 
		  print (Char.toString chr);
		  if chr = #"\n" then print "\n   " else print "";
		  ()
	      end 
      in
	  print "\n   ";
	  Word8ArraySlice.app printByte (toSlice buffer);
	  ()
      end
  end
end

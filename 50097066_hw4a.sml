CM.make "$cml/cml.cm";
open CML;
val chan: int chan = channel();

fun sender number = if number = 100
					then (send(chan, number))
					else (send(chan, number); sender (number+1));

fun receiver () = 	(
						TextIO.print (Int.toString(recv chan));
						TextIO.print("\n");
						receiver ()
					);
					
fun main () =	(
					ignore( spawn( fn() => sender 0) );
					ignore( spawn( fn() => receiver ()) )
				);
			
RunCML.doit(main, NONE);
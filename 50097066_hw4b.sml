CM.make "$cml/cml.cm";
open CML;
val chan1: int chan = channel();
val chan2: int chan = channel();
val chan3: int chan = channel();

fun sender1 num1 limit = 	if limit = 0
							then send(chan2, num1)
							else (
									send(chan2, num1);
									sender1 (recv(chan1)) (limit-1)
								);

fun sender2 num2 = 	let
						val received_number = recv(chan2)
						val new_number = num2 + received_number;
					in
						send(chan1, num2);
						send(chan3, received_number);
						sender2 new_number
					end

fun receiver () = 	(
						TextIO.print (Int.toString(recv chan3));
						TextIO.print("\n");
						receiver ()
					);

fun main () 	= 	(
						ignore( spawn( fn() => receiver () ) );
						ignore( spawn( fn() => sender1 0 43 ) );
						ignore( spawn( fn() => sender2 1 ) )
					);					

RunCML.doit(main, NONE);
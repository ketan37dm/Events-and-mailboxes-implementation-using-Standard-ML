CM.make "$cml/cml.cm";
open CML;

fun mailbox inCh outCh num_list = 	if null num_list
									then(
											select[
												wrap( recvEvt(inCh), fn num => mailbox inCh outCh ( rev(num::rev(num_list)) ) )
											]
										)
									else(
											select[
												wrap( sendEvt(outCh, hd(num_list)), fn() => mailbox inCh outCh (tl(num_list)) ),
												wrap( recvEvt(inCh), fn num => mailbox inCh outCh ( rev(num::rev(num_list)) ) )
											]
										);

fun receiver R_chan = 	(
						TextIO.print (Int.toString(recv R_chan) ^ "\n");
						receiver R_chan
					);

fun sender S_chan num =	if num = 0
						then send(S_chan, 0)
						else (send(S_chan, num); sender S_chan (num-1))

fun generator StartCh NewCh num = 	if num = 1
									then (
											spawn( fn() => mailbox StartCh NewCh nil );
											NewCh
										)
									else (
											spawn( fn() => mailbox StartCh NewCh nil );
											generator NewCh (channel()) (num-1)
										);

fun main () =
  let val chStart = channel()
      val chEnd = generator chStart (channel()) 100
      val _ = spawn (fn () => receiver chEnd)
      val _ = spawn (fn () => ignore (sender chStart 50))
      val _ = spawn (fn () => ignore (sender chStart 50))
  in ()
  end;

RunCML.doit(main, NONE);										
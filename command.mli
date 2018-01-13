

(* Input represents the command that state should evaluate based on the user
 * click. [input] is [Click] if user clicked a tile, [Reset] if user clicked
 * the reset button, [Mode] if user clicked switch flag mode button, or [Check]
 * if user clicked check button (checks if the user correctly flagged all
 * bombs).
 *)
type input = Click of int*int | Reset | Mode | Check

(* [user_input] takes in a [(int,int)] and returns an [input] based on where the
 * user clicked on the GUI. [(int,int)] is the (x,y) position of the mouse click
 * relative to the graphics window.
 *)
val user_input : int*int -> input

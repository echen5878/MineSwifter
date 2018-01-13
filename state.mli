(* State Module
 *
 * State holds the state of the MineSwifter and any functions that change
 * the state.
 *)


(* [finished] represents the state of the game. [finished] is [Win or Lose]
 * if the game has ended and the player has won/lost. Otherwise, it is
 * [Unfinished] if the game is still in progress.
 *)
type finished = Win | Lose | Unfinished

(*[location] is the (x,y) coordinates of a specific tile in a grid*)
type location = (int*int)

(* A [tile] can either contain a bomb ([Bomb]), no bomb and a number of
 * bombs surrounding it ([Safe tile]), or no bomb and no bombs surrounding it
 * ([Blank]). All [tiles] also have a [location], representing which
 * square on a grid it is.
 *)
type tile = Bomb | Safe of int | Blank

(* A [box] is like a [tile] but maintains user information. A [box] is either
 * [Clicked] to reveal the [tile] below, [Unclicked], or [Flagged] by the user.
 *)
type box = Unclicked of tile | Clicked of tile | Flagged of tile

(* [mode] represents whether the user is in flagging mode or in non-flagging
 * mode. [mode] is [Normal] if user is in non-flagging mode (thus clicking boxes
 * to reveal tiles) and is [Flag] if user is in flagging mode (thus clicking
 * boxes to flag tiles to indicate the location of a bomb).
 *)
type mode = Normal | Flag

(* AF: [box_grid] is a [box list] that contains the [location] of a box on the
 * grid along with the data of the [box].
 * RI: The [box_grid] contains no duplicate [locations].
 *)
 type box_grid = (location*box) list

(* AF: [tile_grid] is a [tile list] that contains the [location] of a tile on the
 * grid along with the data of the [tile].
 * RI: The [tile_grid] contains no duplicate [locations].
 *)
 type tile_grid = (location*tile) list

(* The state of the game. [grid] is a [list of tile lists] (in other
 * words, a matrix) representing the underlying [tiles] - which squares have
 * [Bomb], [Safe] or [Blank]. After initialization, this field does not change.
 * [board] is a [list] of [box lists] representing the top layer of "tiles" or
 * [boxes]. The [board] field maintains information about which [boxes] are
 * [Unclicked, Clicked, or Flagged] and thus change based on the player's
 * actions. [curr_mode] represents whether state is in [Normal or Flag] mode
 * [fin] represents whether the game is in the [Win, Lose or Unfinished]
 * state, [flags] is the number of remaining flags that the user can use to
 * to mark bombs.
 *)
 type state = {grid : tile_grid; board : box_grid; curr_mode : mode;
               fin : finished; flags : int}

(* [result] is the input passed to the GUI that tells it what to update.
 * [GameOver] tells the GUI that the game is finished.
 * [Pressed of tile] tells the GUI that the user pressed a tile in [Normal] mode
 * [Flag of box] tells the GUI that the user pressed an [Unflagged] tile in
 * [Flag] mode.
 * [Unflag of box] tells the GUI that the user pressed an [Flagged] tile in
 * [Flag] mode.
 * [Nothing] tells the GUI that the state has not been updated.
 * [Reset] tells the GUI that the user pressed the reset button.
 * [ModeChange] tells the GUI that the user switched between [Flag] and [Normal]
 * mode.
 * [Cascade of int*int*int list] tells the GUI which boxes to reveal based on
 * clicking a box with an underlying Blank tile
 *)
 type result = GameOver | Pressed of tile | Flag of box | Unflag of box
             | Nothing | Reset | ModeChange | Cascade of (int*int*int) list


(* [get_value x y lst] returns the element that corresponds to location
 * [(x,y)] in [lst]. The element returned will either be a [box] or [tile].
 *)
val get_value : int -> int -> (location*'a) list -> 'a

(* [init_state] initializes the initial state of the game board using a random
 * grid and returns that state.
 *)
val init_state : unit -> state

(* [switch_mode] switches the [state] between flag and normal mode. [switch_mode]
 * switches the [state] to [Normal] if it was originally in [Flag] else switches
 * to [Flag] if it was originally in [Normal].
 *)
val switch_mode : state -> state

(* [check] determines whether player has lost or won by correctly flagging all
 * bombs on the [grid] in this [state]. [check] returns [Win] if player has
 * correctly flagged all bombs else returns [Lose]. [check] should only be
 * called when player clicks the "check" button.
 *)
val check : state -> finished


(* [eval] takes in a [input] and a [state] and updates the state based on the
 * [input], returning a [(state, result)].
 *
 * If [input] is:
 *    -[Click]: returns the [state] updated based on the [box] clicked and the
 *              mode the [state] is in, and update the [result] accordingly.
 *    -[Reset]: returns [(init_state, Reset)]
 *    -[Mode] : returns the [state] with the [mode] field switched to [Normal] if
 *              [state] [mode] is [Flagged] else switched to [Flagged] if [mode]
 *              is [Normal] and result = ModeChange
 *    -[Check]: returns the [state] with [finished] as [Win] or [Lose] depending
 *              on if the player correctly flagged all bombs and result = GameOver
 *)
val eval : Command.input -> state -> state*result

(* [extract_state tuple] takes in a [(state, result)] tuple and returns only
 * the [state].
 *)
val extract_state : (state * result) -> state


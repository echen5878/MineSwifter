open GMain
open GdkKeysyms
open Command
open State
let locale = GtkMain.Main.init () (*This is needed to compile*)

(* Initialize global variables *)
let tswift = "tswift.jpg"
let kanye = "yeezy.jpg"
let kanye_flagged = "yeezy_flagged.jpg"
let win = "mineswifter_win.png"
let lose = "mineswifter_lose2.png"
let graysq = "graysquare.jpg"
let darksq = "darksq.jpg"
let logo_img = "logo.jpg"
let one = "1.jpg"
let two = "2.jpg"
let three = "3.jpg"
let four = "4.jpg"
let five = "5.jpg"
let button_array = Array.make_matrix 9 9 (GButton.toggle_button ())
let window = GWindow.window ~width:800 ~height:610
    ~title:"MineSwifter" ()
let st = ref (State.init_state ())
let flag_counter = ref (GButton.toggle_button ())

(* reveal_square x y updates the corresponding 8x8 button square surrounding
 * the button located at [x,y]. Prevents going out of bounds.
 * If the button is is a:
 *  - Safe tile: the square with the corresponding number image is displayed
 *  - Blank tile: the blank square image is displayed
 *  - Bomb: nothing is displayed
 *)
let reveal_square x y =
  match (get_value x y !st.grid) with
  | Safe (n) -> let numfile = (string_of_int n) ^ ".jpg" in
    button_array.(x).(y)#misc#set_sensitive false;
    button_array.(x).(y)#set_image (new GObj.widget (GMisc.image ~file:numfile ())#as_widget);
  | Blank ->
    button_array.(x).(y)#misc#set_sensitive false;
    button_array.(x).(y)#set_image (new GObj.widget (GMisc.image ~file:darksq ())#as_widget); ()
  | Bomb -> ()

(* [reveal_cascade lst] reveals a cascade of buttons. The cascade consists of
 * both blank and number tiles (non-bomb tiles). [lst] is the list of tile
 * locations to be revealed that is returned by State.eval. If the list is
 * empty (there are no tiles to be revealed), then the function does nothing.
 *)
let rec reveal_cascade lst =
  match lst with
  | (x,y,n)::t -> (reveal_square x y; reveal_cascade t)
  | [] -> ()

(* [callback_fun] uses State.eval to determine the action that should be taken
 * based on the current state. [x y] are the indices of [button]. [table] is
 * the current table used in the window. If the result returned by State.eval is:
 *  - Reset: resets the game (and it's state) and resets all buttons on the GUI.
 *  - Flag: flags the current button in the GUI.
 *  - Unflag: unflags the current button in the GUI.
 *  - GameOver: displays the win/lose message and disables all grid buttons.
 *  - Pressed tile: reveals the clicked button.
 *  - ModeChange: changes the mode to flag mode/out of flag mode and updates
 *                the text based on which mode user is in.
 *  - Cascade list: reveals all buttons in the cascading list.
 *  - Nothing: does nothing.
 *)
let rec callback_fun (table : GPack.table) button x y =
  let c = Command.user_input (x,y) in
  let oldst = !st in
  let (st',result) = State.eval c !st in
  st := st';
  match result with
  | Reset -> reset_game table
  | Flag _ -> (button#set_image (new GObj.widget (GMisc.image ~file:tswift ())#as_widget);
               !flag_counter#set_label ("          "^(string_of_int !st.flags)^"          "))
  | Unflag _ -> (button#set_image (new GObj.widget (GMisc.image ~file:graysq ())#as_widget);
                 !flag_counter#set_label ("          "^(string_of_int !st.flags)^"          "))
  | GameOver -> game_over table
  | Pressed (tile) -> reveal_square x y
  | ModeChange -> (match oldst.curr_mode with
      | Normal -> button#set_label "   Exit Flag Mode    "
      | Flag -> button#set_label   "   Enter Flag Mode ")
  | Cascade (lst) -> reveal_cascade lst
  | Nothing -> ()

(* [intialize_buttons table n x y] initializes the grid of buttons. [n] is the
 * total number of tiles, [x] is the number of rows, and [y] is the number of columns.
 * Initializes the array of buttons and sets the inital picture. Changes
 * button in response to click.
 *)

and initialize_buttons (table : GPack.table) n x y =
  match n with
  | 0 -> ()
  | _ -> begin
      let button = GButton.toggle_button () in
      table#attach ~left:x ~top:y (button#coerce);
      button#set_image (new GObj.widget (GMisc.image ~file:graysq ())#as_widget);
      (button#connect#clicked ~callback:(fun () -> callback_fun table button x y));
      button_array.(x).(y) <- button;
      if y = 8 then
        initialize_buttons table (n-1) (x+1) 0
      else
        initialize_buttons table (n-1) x (y+1)
    end

(* [extra_buttons table] creates and attaches non-grid buttons. These buttons
 * consist of the reset, flag and check button. It also creates and displays
 * the flag_counter and logo buttons. [table] is the [GPack.table] that is
 * currently attached to the window.
 *)
and extra_buttons (table : GPack.table) =
  (* add the reset, flag, check button *)
  let reset = GButton.toggle_button () in
  let flag =  GButton.toggle_button () in
  let check =  GButton.toggle_button () in
  table#attach ~left:11 ~top:2 (new GObj.widget (GMisc.label ~text:"                           " ())#as_widget);
  table#attach ~left:12 ~right:16 ~top:1 (flag#coerce);
  table#attach ~left:12 ~right:16 ~top:3 (check#coerce);
  table#attach ~left:12 ~right:16 ~top:5 (reset#coerce);
  reset#set_label "        Reset        ";
  flag#set_label  " Enter Flag Mode ";
  check#set_label "        Check        ";
  (reset#connect#clicked ~callback:(fun () -> callback_fun table reset 12 6));
  (flag#connect#clicked ~callback:(fun () -> callback_fun table flag 12 2));
  (check#connect#clicked ~callback:(fun () -> callback_fun table check 12 4));
  table#attach ~left:12 ~right:16 ~top:7 (!flag_counter#coerce);
  !flag_counter#misc#set_sensitive false;
  !flag_counter#set_label ("          "^(string_of_int !st.flags)^"          ");
  let logo = GButton.toggle_button () in
  table#attach ~left:0 ~right:9 ~top:11 (logo#coerce);
  logo#set_image (new GObj.widget (GMisc.image ~file:logo_img ())#as_widget);
  ()

(* [reset_game table] resets the board to a new game state and updates the gui
 * accordingly. [table] is the current table attached to the window.
 *)
and reset_game (table : GPack.table) =
  st := State.init_state ();
  table#destroy ();
  let newtable = GPack.table ~rows:15 ~columns:15 ~homogeneous:false
      ~packing:window#add () in
  let newflag = GButton.toggle_button () in
  flag_counter := newflag;
  initialize_buttons newtable 81 0 0;
  extra_buttons newtable

(* [reveal_bombs board] reveals the bombs all bombs on the board after the game
 * has ended. If the bomb was correctly flagged, then the bomb image with an
 * X is displayed. Otherwise, the regular bomb image is displayed.
 * [board] is the [board] from the current [state].
 *)
and reveal_bombs board =
  match board with
  | ((x,y),box)::t -> begin
      match box with
      | Flagged tile -> begin
          match tile with
          | Bomb -> (button_array.(x).(y)#misc#set_sensitive false;
            button_array.(x).(y)#set_image (new GObj.widget (GMisc.image ~file:kanye_flagged ())#as_widget);
            reveal_bombs t)
          | _ -> (button_array.(x).(y)#misc#set_sensitive false; reveal_bombs t)
        end
      | Clicked tile -> begin
          match tile with
          | Bomb -> (button_array.(x).(y)#misc#set_sensitive false;
            button_array.(x).(y)#set_image (new GObj.widget (GMisc.image ~file:kanye ())#as_widget);
            reveal_bombs t)
          | _ -> (button_array.(x).(y)#misc#set_sensitive false; reveal_bombs t)
        end
      | Unclicked tile -> begin
          match tile with
          | Bomb -> (button_array.(x).(y)#misc#set_sensitive false;
            button_array.(x).(y)#set_image (new GObj.widget (GMisc.image ~file:kanye ())#as_widget);
            reveal_bombs t)
          | _ -> (button_array.(x).(y)#misc#set_sensitive false; reveal_bombs t)
        end
    end
  | [] -> ()

(* [show_win_lose img] displays the win/lose image based in a new window based
 * on whether the user won or lost. The new window contains a single button
 * with the image displayed that can be clicked to close the window.
 * [img] is the image that should be displayed.
 *)
and show_win_lose img =
  let window2 = GWindow.window ~width:500 ~height:500
      ~title:"MineSwifter" () in
  window2#connect#destroy ~callback:window#show;
  let table2 = GPack.table ~rows:15 ~columns:15 ~homogeneous:false
    ~packing:window2#add () in
  let lose_button = GButton.toggle_button () in
  table2#attach ~left:0 ~top:0 (lose_button#coerce);
  lose_button#set_image (new GObj.widget (GMisc.image ~file:img ())#as_widget);
  lose_button#connect#clicked (window2#destroy);
  window2#show ()

(* [game_over table] displays all bombs in the grid using [reveal bombs] and
 * then displays the win/lose message in a new window. [table] is the current
 * table attached to the window.
 *)
and game_over (table : GPack.table) =
  let boxes = !st.board in
  reveal_bombs boxes;
  match !st.fin with
  | Win -> show_win_lose win
  | Lose -> show_win_lose lose
  | _ -> ()

(* Main function. Creates the initial window and initializes all buttons.
 * Displays the window and enter Gtk+ main loop.
 *)
let main () =
  window#connect#destroy ~callback:Main.quit;
  let table = GPack.table ~rows:15 ~columns:15 ~homogeneous:false
      ~packing:window#add () in
  initialize_buttons table 81 0 0;
  extra_buttons table;
  window#show ();
  Main.main ()

let () = main ()

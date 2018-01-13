open Command

type finished = Win | Lose | Unfinished

type location = (int*int)

type tile = Bomb | Safe of int | Blank

type box = Unclicked of tile | Clicked of tile | Flagged of tile

type mode = Normal | Flag

type box_grid = (location*box) list

type tile_grid = (location*tile) list

type state = {grid : tile_grid; board : box_grid; curr_mode : mode;
              fin : finished; flags : int}

type result = GameOver | Pressed of tile | Flag of box | Unflag of box
            | Nothing | Reset | ModeChange | Cascade of (int*int*int) list

(* [fill_grid x y init_v acc] is a tail recursive helper function for
 * [create_grid] that builds up a list of size [x]*[y] of [init_v] tiles and
 * their [locations] in the grid.
 *)
let rec fill_grid x y init_v acc =
  if x=0 && y=0 then ((x,y), init_v)::acc
  else if x=0 then
    fill_grid 8 (y-1)  init_v (((x,y), init_v)::acc)
  else fill_grid (x-1) y  init_v (((x,y), init_v)::acc)

(* [create_grid init_val] makes a list of 81 [init_val]'s along with the (x, y)
 * locations each value would appear in on a grid, where x and y are both
 * between 0 and 8.
 *)
let rec create_grid init_val =
  fill_grid 8 8 init_val []

let rec get_value x y lst =
  match List.assoc_opt (x, y) lst with
  | None -> failwith "Out of Bounds"
  | Some t -> t

(* [set_value x y v lst] updates the element that corresponds to location
 * [(x,y)] in [lst] to be [v]. A new list identical to [lst] is returned with
 * the element at [(x,y)] changed. x,y must be between 0 and 8
 *)
let set_value x y v lst =
  if x<0 || y<0 || x>8 || y>8 then lst
  else ((x,y),v)::(List.remove_assoc (x, y) lst)


let bomb_locations = Hashtbl.create 10

(* [set_mines () remaining tiles] takes in a tile grid [tiles] and adds mines
 * to the grid. [remaining] is the number of mines to add and [set_mines] takes
 * in a [Hashtbl] to track the locations of the previously set mines so that
 * no two mines are set in the same [location]. Mine locations are randomly
 * generated.
 *)
let rec set_mines () remaining tiles  =
  if remaining = 0 then tiles else
    let x = Random.int 9 in
    let y = Random.int 9 in
    if Hashtbl.mem bomb_locations (x, y) then
      set_mines () remaining tiles
    else
      let new_hash = Hashtbl.add bomb_locations (x, y) 0 in
      set_mines new_hash (remaining-1) (set_value x y Bomb tiles)

(* [check_surrounding x y] returns the number of bombs the [tile] at location
  [(x,y)] is touching.
 *)
let rec check_surrounding x y =
  let top_left = if Hashtbl.mem bomb_locations (x-1, y-1) then 1
    else 0
  in
  let top_mid = if Hashtbl.mem bomb_locations (x, y-1) then 1
    else 0
  in
  let top_right = if Hashtbl.mem bomb_locations (x+1, y-1) then 1
    else 0
  in
  let left = if Hashtbl.mem bomb_locations (x-1, y) then 1
    else 0
  in
  let right = if Hashtbl.mem bomb_locations (x+1, y) then 1
    else 0
  in
  let bot_left = if Hashtbl.mem bomb_locations (x-1, y+1) then 1
    else 0
  in
  let bot_mid = if Hashtbl.mem bomb_locations (x, y+1) then 1
    else 0
  in
  let bot_right = if Hashtbl.mem bomb_locations (x+1, y+1) then 1
    else 0
  in
  top_left + top_mid + top_right + left + right + bot_left + bot_mid + bot_right

(* [set_numbers tiles acc] updates the tile grid [tiles] to include [Safe] tiles.
 * Each [Safe] tile contains the number of bombs that tile is touching.
 *)
let rec set_numbers tiles acc =
  match tiles with
  | [] -> acc
  | h::t ->
    begin
      match h with
      | (x, y), Blank -> let bombs = check_surrounding x y in
        if bombs = 0 then
          set_numbers t (set_value x y (Blank) acc)
        else
          set_numbers t (set_value x y (Safe bombs) acc)
      | _ -> set_numbers t acc
    end

(* [init_tile_grid ()] creates a new tile grid with randomized [Bombs], [Blank],
 * and [Safe of int] tiles.
 *)
let init_tile_grid () = let i = create_grid Blank |> set_mines () 10 in
  set_numbers i i

(* [make_box_grid tiles acc] creates a new box grid with all [Unclicked] boxes
 * on top of the underlying initialized tile grid.
 *)
let rec make_box_grid tiles acc =
  match tiles with
  | [] -> acc
  | (l, h)::t -> make_box_grid t ((l, (Unclicked h))::acc)

(* [init_state] initializes the initial state of the game board using a random
 * grid and returns that state.
*)
let init_state () =
  let init_tiles = init_tile_grid () in
  let init_board = make_box_grid init_tiles [] in
  let _ = Hashtbl.clear bomb_locations in
  {grid = init_tiles; board = init_board ; curr_mode = Normal;
   fin = Unfinished; flags = 10}

(* [switch_mode] switches the [state] between flag and normal mode. [switch_mode]
 * switches the [state] to [Normal] if it was originally in [Flag] else switches
 * to [Flag] if it was originally in [Normal].
*)
let switch_mode st =
  match st.curr_mode with
  | Normal -> {st with curr_mode = Flag}
  | Flag -> {st with curr_mode = Normal}

(* Determines if you've won or losed base on the following criteria:
 * If there's a non-bomb tile and it is flagged you lose,
 * If there's a bomb tile and it is unflagged you lose,
 * Otherwise you win
*)
let rec check_flags box_gr =
  match box_gr with
  | [] -> true
  | (l, h)::t -> begin
      match h with
      | Flagged Bomb -> check_flags t
      | Flagged _ -> false
      | Unclicked Bomb -> false
      | Clicked Bomb -> false
      | _ -> check_flags t
    end

(* [check] determines whether player has lost or won by correctly flagging all
 * bombs on the [grid] in this [state]. [check] returns [Win] if player has
 * correctly flagged all bombs else returns [Lose]. [check] should only be
 * called when player clicks the "check" button.
*)
let check st =
  if check_flags st.board then Win
  else Lose

(* [get_numer x y grid] returns the number of mines surrounding an Unclicked
 * box at (x,y) in the grid [grid], or -1 if the number is out of the bounds of
 * the grid or the box is not clicked. *)
let get_number x y grid =
  if x<0 || y<0 || x>8 || y>8 then -1
  else
    match get_value x y grid with
    | Unclicked Blank -> 0
    | Unclicked (Safe n) -> n
    | _ -> -1

(* [click_surrounding_casc x y grid] tells the grid [grid] to set all
 * boxes surrounding the box at (x,y) and also the box at (x,y)
 * to be clicked, except for boxes with a Blank tile.
 * (x, y) must correspond to a Box with a Blank tile underneath it*)
let click_surrounding_casc x y grid =
  let top_left = get_number (x-1) (y-1) grid in
  let top_mid = get_number x (y-1) grid in
  let top_right = get_number (x+1) (y-1) grid in
  let left = get_number (x-1) y grid in
  let right = get_number (x+1) y grid in
  let bot_left = get_number (x-1) (y+1) grid in
  let bot_mid = get_number x (y+1) grid in
  let bot_right = get_number (x+1) (y+1) grid in
  let tl = if top_left = 0 then Unclicked Blank else Clicked (Safe top_left) in
  let tm = if top_mid = 0 then Unclicked Blank else Clicked (Safe top_mid) in
  let tr = if top_right= 0 then Unclicked Blank else Clicked (Safe top_right) in
  let l = if left = 0 then Unclicked Blank else Clicked (Safe left) in
  let r = if right = 0 then Unclicked Blank else Clicked (Safe right) in
  let bl = if bot_left = 0 then Unclicked Blank else Clicked (Safe bot_left) in
  let bm = if bot_mid = 0 then Unclicked Blank else Clicked (Safe bot_mid) in
  let br = if bot_right = 0 then Unclicked Blank else Clicked (Safe bot_mid) in
  set_value (x-1) (y-1) tl grid |> set_value x (y-1) tm
  |> set_value (x+1) (y-1) tr |> set_value (x-1) y l |> set_value (x+1) y r
  |> set_value (x-1) (y+1) bl |> set_value x (y+1) bm |>set_value (x+1) (y+1) br
  |> set_value x y (Clicked Blank)

(* [filter_helper x] returns false if the third value in [x] is -1, and true
 * otherwise *)
let filter_helper x =
  match x with
  | (_, _, -1) -> false
  | _ -> true

(* [cascade_update casc grid] takes in a list of (x, y, n) and updates all
 * the boxes of grid [grid] at the x's and y's in the list to be clicked with
 * value Safe n, if n is not 0, or Blank if n is 0.*)
let rec cascade_update casc grid =
  match casc with
  | [] -> grid
  | (x, y, 0)::t -> cascade_update t (set_value x y (Clicked Blank) grid)
  | (x,y,n)::t -> cascade_update t (set_value x y (Clicked (Safe n)) grid)

(* [within_bounds x y] returns true if (x, y) are valid coordinates of the grid
*)
let within_bounds x y =
  if x<0 || y<0 || x>8 || y>8 then false else true

(*[q] is a queue with tuples of (x,y,n) for later processing for cascades *)
let q = Queue.create ()
(* [cascade_queue x y grid] Adds all the elements on the grid
 * surrounding a blank to the queue [q] where they will later be processed to
 * turn into a list for cascades.
 *)
let cascade_queue x y grid =
  let top_left = get_number (x-1) (y-1) grid in
  let top_mid = get_number x (y-1) grid in
  let top_right = get_number (x+1) (y-1) grid in
  let left = get_number (x-1) y grid in
  let right = get_number (x+1) y grid in
  let bot_left = get_number (x-1) (y+1) grid in
  let bot_mid = get_number x (y+1) grid in
  let bot_right = get_number (x+1) (y+1) grid in
  Queue.add (x, y, 10) q; Queue.add (x-1, y-1, top_left) q;
  Queue.add (x, y-1, top_mid) q; Queue.add (x+1, y-1, top_right) q;
  Queue.add (x-1, y, left) q; Queue.add (x+1, y, right) q;
  Queue.add (x-1, y+1, bot_left) q; Queue.add (x, y+1, bot_mid) q;
  Queue.add (x+1, y+1, bot_right) q; q

(* [processed] is a queue with tuples of (x,y,n) which have been processed, and
 * will later be put into a list for cascades *)
let processed = Queue.create ()

(* [process_q grid] takes elements from the queue [q] and processes them into
 * [processed] based on [grid] and the value. If the value popped has a triple
 * ending with 0, then the boxes surrounding the location of that value are
 * added to the queue. *)
let rec process_q grid =
  if Queue.is_empty q then ()
  else
    match Queue.pop q with
    | (x, y, 10) ->
      Queue.add (x, y, 0) processed;
      process_q (set_value x y (Clicked Blank) grid)
    | (x, y, 0) -> cascade_queue x y grid; process_q grid
    | (x, y, n) -> Queue.add (x, y, n) processed;
      process_q (set_value x y (Clicked (Safe n)) grid)

(* [list_from_processed acc] creates a list of the contents of processed_q.
 * [acc] is the accumulator, and should be [] *)
let rec list_from_processed acc =
  if Queue.is_empty processed then acc
  else
    list_from_processed (Queue.pop processed :: acc)

(* [casc x y grid] Returns a list of a triples (u, v, w) of ints where
 * for each triple (u, v) is the location of a Box on the grid [grid], and w is
 * the number of mines surrounding the Box at (u, v). The coordinates of boxes
 * in the list are the tiles that would be revealed in a cascade in
 * regular MineSweeper (the stuff that happens when you click a blank and a
 * bunch of boxes get revealed). This has no duplicates.
*)
let casc x y grid = Queue.clear q; Queue.clear processed;
  cascade_queue x y grid; process_q grid;
  list_from_processed [] |> List.filter filter_helper
  |> List.sort_uniq Pervasives.compare

let eval c st =
  match c with
  | Click (x,y) -> begin
      let boxClicked = get_value x y st.board in
      match st.curr_mode with
      | Normal ->
        begin
          match boxClicked with
          | Unclicked t -> begin
              match t with
              | Bomb ->
                ({st with board = set_value x y (Clicked t) st.board; fin = Lose},
                 GameOver)
              | Safe n -> ({st with board = set_value x y (Clicked t) st.board},
                           Pressed t)
              | Blank ->
                let c = casc x y st.board in
                ({st with board = cascade_update c st.board},
                 Cascade c)
            end
          | _ -> (st, Nothing)
        end
      | Flag -> begin
          match boxClicked with
          | Clicked t -> (st, Nothing)
          | Unclicked t ->
            ({st with board = set_value x y (Flagged t) st.board;
                      flags = st.flags - 1}, Flag boxClicked)
          | Flagged t ->
            ({st with board = set_value x y (Unclicked t) st.board;
                      flags = st.flags + 1}, Unflag boxClicked)
        end
    end
  | Reset -> (init_state (), Reset)
  | Mode -> (switch_mode st, ModeChange)
  | Check -> let fin_st = check st in ({st with fin = fin_st}, GameOver)

  let extract_state tuple =
    match tuple with
    | (st, _) -> st

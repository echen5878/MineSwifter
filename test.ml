open OUnit2
open State

let grid1 = [((0, 7), Bomb); ((4, 2), Bomb); ((6, 5), Bomb); ((2, 2), Bomb);
   ((8, 2), Bomb); ((0, 2), Bomb); ((5, 6), Bomb); ((2, 6), Bomb);
   ((0, 1), Bomb); ((8, 7), Bomb); ((0, 0), Safe 1); ((1, 0), Safe 1);
   ((2, 0), Blank); ((3, 0), Blank); ((4, 0), Blank); ((5, 0), Blank);
   ((6, 0), Blank); ((7, 0), Blank); ((8, 0), Blank); ((1, 1), Safe 3);
   ((2, 1), Safe 1); ((3, 1), Safe 2); ((4, 1), Safe 1); ((5, 1), Safe 1);
   ((6, 1), Blank); ((7, 1), Safe 1); ((8, 1), Safe 1); ((1, 2), Safe 3);
   ((3, 2), Safe 2); ((5, 2), Safe 1); ((6, 2), Blank); ((7, 2), Safe 1);
   ((0, 3), Safe 1); ((1, 3), Safe 2); ((2, 3), Safe 1); ((3, 3), Safe 2);
   ((4, 3), Safe 1); ((5, 3), Safe 1); ((6, 3), Blank); ((7, 3), Safe 1);
   ((8, 3), Safe 1); ((0, 4), Blank); ((1, 4), Blank); ((2, 4), Blank);
   ((3, 4), Blank); ((4, 4), Blank); ((5, 4), Safe 1); ((6, 4), Safe 1);
   ((7, 4), Safe 1); ((8, 4), Blank); ((0, 5), Blank); ((1, 5), Safe 1);
   ((2, 5), Safe 1); ((3, 5), Safe 1); ((4, 5), Safe 1); ((5, 5), Safe 2);
   ((7, 5), Safe 1); ((8, 5), Blank); ((0, 6), Safe 1); ((1, 6), Safe 2);
   ((3, 6), Safe 1); ((4, 6), Safe 1); ((6, 6), Safe 2); ((7, 6), Safe 2);
   ((8, 6), Safe 1); ((1, 7), Safe 2); ((2, 7), Safe 1); ((3, 7), Safe 1);
   ((4, 7), Safe 1); ((5, 7), Safe 1); ((6, 7), Safe 1); ((7, 7), Safe 1);
   ((0, 8), Safe 1); ((1, 8), Safe 1); ((2, 8), Blank); ((3, 8), Blank);
   ((4, 8), Blank); ((5, 8), Blank); ((6, 8), Blank); ((7, 8), Safe 1);
   ((8, 8), Safe 1)]

let board1 = [((0, 0), Unclicked (Safe 1)); ((0, 1), Unclicked Bomb);
   ((0, 2), Unclicked Bomb); ((0, 3), Unclicked (Safe 1));
   ((0, 4), Unclicked Blank); ((0, 5), Unclicked Blank);
   ((0, 6), Unclicked (Safe 1)); ((0, 7), Unclicked Bomb);
   ((0, 8), Unclicked (Safe 1)); ((1, 0), Unclicked (Safe 1));
   ((1, 1), Unclicked (Safe 3)); ((1, 2), Unclicked (Safe 3));
   ((1, 3), Unclicked (Safe 2)); ((1, 4), Unclicked Blank);
   ((1, 5), Unclicked (Safe 1)); ((1, 6), Unclicked (Safe 2));
   ((1, 7), Unclicked (Safe 2)); ((1, 8), Unclicked (Safe 1));
   ((2, 0), Unclicked Blank); ((2, 1), Unclicked (Safe 1));
   ((2, 2), Unclicked Bomb); ((2, 3), Unclicked (Safe 1));
   ((2, 4), Unclicked Blank); ((2, 5), Unclicked (Safe 1));
   ((2, 6), Unclicked Bomb); ((2, 7), Unclicked (Safe 1));
   ((2, 8), Unclicked Blank); ((3, 0), Unclicked Blank);
   ((3, 1), Unclicked (Safe 2)); ((3, 2), Unclicked (Safe 2));
   ((3, 3), Unclicked (Safe 2)); ((3, 4), Unclicked Blank);
   ((3, 5), Unclicked (Safe 1)); ((3, 6), Unclicked (Safe 1));
   ((3, 7), Unclicked (Safe 1)); ((3, 8), Unclicked Blank);
   ((4, 0), Unclicked Blank); ((4, 1), Unclicked (Safe 1));
   ((4, 2), Unclicked Bomb); ((4, 3), Unclicked (Safe 1));
   ((4, 4), Unclicked Blank); ((4, 5), Unclicked (Safe 1));
   ((4, 6), Unclicked (Safe 1)); ((4, 7), Unclicked (Safe 1));
   ((4, 8), Unclicked Blank); ((5, 0), Unclicked Blank);
   ((5, 1), Unclicked (Safe 1)); ((5, 2), Unclicked (Safe 1));
   ((5, 3), Unclicked (Safe 1)); ((5, 4), Unclicked (Safe 1));
   ((5, 5), Unclicked (Safe 2)); ((5, 6), Unclicked Bomb);
   ((5, 7), Unclicked (Safe 1)); ((5, 8), Unclicked Blank);
   ((6, 0), Unclicked Blank); ((6, 1), Unclicked Blank);
   ((6, 2), Unclicked Blank); ((6, 3), Unclicked Blank);
   ((6, 4), Unclicked (Safe 1)); ((6, 5), Unclicked Bomb);
   ((6, 6), Unclicked (Safe 2)); ((6, 7), Unclicked (Safe 1));
   ((6, 8), Unclicked Blank); ((7, 0), Unclicked Blank);
   ((7, 1), Unclicked (Safe 1)); ((7, 2), Unclicked (Safe 1));
   ((7, 3), Unclicked (Safe 1)); ((7, 4), Unclicked (Safe 1));
   ((7, 5), Unclicked (Safe 1)); ((7, 6), Unclicked (Safe 2));
   ((7, 7), Unclicked (Safe 1)); ((7, 8), Unclicked (Safe 1));
   ((8, 0), Unclicked Blank); ((8, 1), Unclicked (Safe 1));
   ((8, 2), Unclicked Bomb); ((8, 3), Unclicked (Safe 1));
   ((8, 4), Unclicked Blank); ((8, 5), Unclicked Blank);
   ((8, 6), Unclicked (Safe 1)); ((8, 7), Unclicked Bomb);
   ((8, 8), Unclicked (Safe 1))]

let board2 = [((0, 0), Unclicked (Safe 1)); ((0, 1), Unclicked Bomb);
   ((0, 2), Unclicked Bomb); ((0, 3), Unclicked (Safe 1));
   ((0, 4), Unclicked Blank); ((0, 5), Unclicked Blank);
   ((0, 6), Unclicked (Safe 1)); ((0, 7), Unclicked Bomb);
   ((0, 8), Unclicked (Safe 1)); ((1, 0), Unclicked (Safe 1));
   ((1, 1), Unclicked (Safe 3)); ((1, 2), Unclicked (Safe 3));
   ((1, 3), Unclicked (Safe 2)); ((1, 4), Unclicked Blank);
   ((1, 5), Unclicked (Safe 1)); ((1, 6), Unclicked (Safe 2));
   ((1, 7), Unclicked (Safe 2)); ((1, 8), Unclicked (Safe 1));
   ((2, 0), Unclicked Blank); ((2, 1), Unclicked (Safe 1));
   ((2, 2), Unclicked Bomb); ((2, 3), Unclicked (Safe 1));
   ((2, 4), Unclicked Blank); ((2, 5), Unclicked (Safe 1));
   ((2, 6), Unclicked Bomb); ((2, 7), Unclicked (Safe 1));
   ((2, 8), Unclicked Blank); ((3, 0), Unclicked Blank);
   ((3, 1), Unclicked (Safe 2)); ((3, 2), Unclicked (Safe 2));
   ((3, 3), Unclicked (Safe 2)); ((3, 4), Unclicked Blank);
   ((3, 5), Unclicked (Safe 1)); ((3, 6), Unclicked (Safe 1));
   ((3, 7), Unclicked (Safe 1)); ((3, 8), Unclicked Blank);
   ((4, 0), Unclicked Blank); ((4, 1), Unclicked (Safe 1));
   ((4, 2), Unclicked Bomb); ((4, 3), Unclicked (Safe 1));
   ((4, 4), Unclicked Blank); ((4, 5), Unclicked (Safe 1));
   ((4, 6), Unclicked (Safe 1)); ((4, 7), Unclicked (Safe 1));
   ((4, 8), Unclicked Blank); ((5, 0), Unclicked Blank);
   ((5, 1), Unclicked (Safe 1)); ((5, 2), Unclicked (Safe 1));
   ((5, 3), Unclicked (Safe 1)); ((5, 4), Unclicked (Safe 1));
   ((5, 5), Unclicked (Safe 2)); ((5, 6), Unclicked Bomb);
   ((5, 7), Unclicked (Safe 1)); ((5, 8), Unclicked Blank);
   ((6, 0), Unclicked Blank); ((6, 1), Unclicked Blank);
   ((6, 2), Unclicked Blank); ((6, 3), Unclicked Blank);
   ((6, 4), Clicked (Safe 1)); ((6, 5), Unclicked Bomb);
   ((6, 6), Unclicked (Safe 2)); ((6, 7), Unclicked (Safe 1));
   ((6, 8), Unclicked Blank); ((7, 0), Unclicked Blank);
   ((7, 1), Unclicked (Safe 1)); ((7, 2), Unclicked (Safe 1));
   ((7, 3), Unclicked (Safe 1)); ((7, 4), Unclicked (Safe 1));
   ((7, 5), Unclicked (Safe 1)); ((7, 6), Unclicked (Safe 2));
   ((7, 7), Unclicked (Safe 1)); ((7, 8), Unclicked (Safe 1));
   ((8, 0), Unclicked Blank); ((8, 1), Unclicked (Safe 1));
   ((8, 2), Unclicked Bomb); ((8, 3), Unclicked (Safe 1));
   ((8, 4), Unclicked Blank); ((8, 5), Unclicked Blank);
   ((8, 6), Unclicked (Safe 1)); ((8, 7), Unclicked Bomb);
   ((8, 8), Unclicked (Safe 1))]


let boardFlags = [((0, 0), Unclicked (Safe 1)); ((0, 1), Unclicked Bomb);
   ((0, 2), Unclicked Bomb); ((0, 3), Unclicked (Safe 1));
   ((0, 4), Unclicked Blank); ((0, 5), Unclicked Blank);
   ((0, 6), Unclicked (Safe 1)); ((0, 7), Unclicked Bomb);
   ((0, 8), Unclicked (Safe 1)); ((1, 0), Unclicked (Safe 1));
   ((1, 1), Unclicked (Safe 3)); ((1, 2), Unclicked (Safe 3));
   ((1, 3), Unclicked (Safe 2)); ((1, 4), Unclicked Blank);
   ((1, 5), Unclicked (Safe 1)); ((1, 6), Unclicked (Safe 2));
   ((1, 7), Unclicked (Safe 2)); ((1, 8), Unclicked (Safe 1));
   ((2, 0), Unclicked Blank); ((2, 1), Unclicked (Safe 1));
   ((2, 2), Flagged Bomb); ((2, 3), Unclicked (Safe 1));
   ((2, 4), Flagged Blank); ((2, 5), Unclicked (Safe 1));
   ((2, 6), Unclicked Bomb); ((2, 7), Unclicked (Safe 1));
   ((2, 8), Unclicked Blank); ((3, 0), Unclicked Blank);
   ((3, 1), Flagged (Safe 2)); ((3, 2), Unclicked (Safe 2));
   ((3, 3), Unclicked (Safe 2)); ((3, 4), Unclicked Blank);
   ((3, 5), Unclicked (Safe 1)); ((3, 6), Unclicked (Safe 1));
   ((3, 7), Unclicked (Safe 1)); ((3, 8), Unclicked Blank);
   ((4, 0), Unclicked Blank); ((4, 1), Unclicked (Safe 1));
   ((4, 2), Unclicked Bomb); ((4, 3), Unclicked (Safe 1));
   ((4, 4), Unclicked Blank); ((4, 5), Unclicked (Safe 1));
   ((4, 6), Unclicked (Safe 1)); ((4, 7), Unclicked (Safe 1));
   ((4, 8), Unclicked Blank); ((5, 0), Unclicked Blank);
   ((5, 1), Unclicked (Safe 1)); ((5, 2), Unclicked (Safe 1));
   ((5, 3), Unclicked (Safe 1)); ((5, 4), Unclicked (Safe 1));
   ((5, 5), Unclicked (Safe 2)); ((5, 6), Unclicked Bomb);
   ((5, 7), Unclicked (Safe 1)); ((5, 8), Unclicked Blank);
   ((6, 0), Unclicked Blank); ((6, 1), Unclicked Blank);
   ((6, 2), Unclicked Blank); ((6, 3), Unclicked Blank);
   ((6, 4), Unclicked (Safe 1)); ((6, 5), Unclicked Bomb);
   ((6, 6), Unclicked (Safe 2)); ((6, 7), Unclicked (Safe 1));
   ((6, 8), Unclicked Blank); ((7, 0), Unclicked Blank);
   ((7, 1), Unclicked (Safe 1)); ((7, 2), Unclicked (Safe 1));
   ((7, 3), Unclicked (Safe 1)); ((7, 4), Unclicked (Safe 1));
   ((7, 5), Unclicked (Safe 1)); ((7, 6), Unclicked (Safe 2));
   ((7, 7), Unclicked (Safe 1)); ((7, 8), Unclicked (Safe 1));
   ((8, 0), Unclicked Blank); ((8, 1), Unclicked (Safe 1));
   ((8, 2), Unclicked Bomb); ((8, 3), Unclicked (Safe 1));
   ((8, 4), Unclicked Blank); ((8, 5), Unclicked Blank);
   ((8, 6), Unclicked (Safe 1)); ((8, 7), Unclicked Bomb);
   ((8, 8), Unclicked (Safe 1))]

let boardWin = [((0, 0), Unclicked (Safe 1)); ((0, 1), Flagged Bomb);
   ((0, 2), Flagged Bomb); ((0, 3), Unclicked (Safe 1));
   ((0, 4), Unclicked Blank); ((0, 5), Unclicked Blank);
   ((0, 6), Unclicked (Safe 1)); ((0, 7), Flagged Bomb);
   ((0, 8), Unclicked (Safe 1)); ((1, 0), Unclicked (Safe 1));
   ((1, 1), Unclicked (Safe 3)); ((1, 2), Unclicked (Safe 3));
   ((1, 3), Unclicked (Safe 2)); ((1, 4), Unclicked Blank);
   ((1, 5), Unclicked (Safe 1)); ((1, 6), Unclicked (Safe 2));
   ((1, 7), Unclicked (Safe 2)); ((1, 8), Unclicked (Safe 1));
   ((2, 0), Unclicked Blank); ((2, 1), Unclicked (Safe 1));
   ((2, 2), Flagged Bomb); ((2, 3), Unclicked (Safe 1));
   ((2, 4), Unclicked Blank); ((2, 5), Unclicked (Safe 1));
   ((2, 6), Flagged Bomb); ((2, 7), Unclicked (Safe 1));
   ((2, 8), Unclicked Blank); ((3, 0), Unclicked Blank);
   ((3, 1), Unclicked (Safe 2)); ((3, 2), Unclicked (Safe 2));
   ((3, 3), Unclicked (Safe 2)); ((3, 4), Unclicked Blank);
   ((3, 5), Unclicked (Safe 1)); ((3, 6), Unclicked (Safe 1));
   ((3, 7), Unclicked (Safe 1)); ((3, 8), Unclicked Blank);
   ((4, 0), Unclicked Blank); ((4, 1), Unclicked (Safe 1));
   ((4, 2), Flagged Bomb); ((4, 3), Unclicked (Safe 1));
   ((4, 4), Unclicked Blank); ((4, 5), Unclicked (Safe 1));
   ((4, 6), Unclicked (Safe 1)); ((4, 7), Unclicked (Safe 1));
   ((4, 8), Unclicked Blank); ((5, 0), Unclicked Blank);
   ((5, 1), Unclicked (Safe 1)); ((5, 2), Unclicked (Safe 1));
   ((5, 3), Unclicked (Safe 1)); ((5, 4), Unclicked (Safe 1));
   ((5, 5), Unclicked (Safe 2)); ((5, 6), Flagged Bomb);
   ((5, 7), Unclicked (Safe 1)); ((5, 8), Unclicked Blank);
   ((6, 0), Unclicked Blank); ((6, 1), Unclicked Blank);
   ((6, 2), Unclicked Blank); ((6, 3), Unclicked Blank);
   ((6, 4), Clicked (Safe 1)); ((6, 5), Flagged Bomb);
   ((6, 6), Unclicked (Safe 2)); ((6, 7), Unclicked (Safe 1));
   ((6, 8), Unclicked Blank); ((7, 0), Unclicked Blank);
   ((7, 1), Unclicked (Safe 1)); ((7, 2), Unclicked (Safe 1));
   ((7, 3), Unclicked (Safe 1)); ((7, 4), Unclicked (Safe 1));
   ((7, 5), Unclicked (Safe 1)); ((7, 6), Unclicked (Safe 2));
   ((7, 7), Unclicked (Safe 1)); ((7, 8), Unclicked (Safe 1));
   ((8, 0), Unclicked Blank); ((8, 1), Unclicked (Safe 1));
   ((8, 2), Flagged Bomb); ((8, 3), Unclicked (Safe 1));
   ((8, 4), Unclicked Blank); ((8, 5), Unclicked Blank);
   ((8, 6), Unclicked (Safe 1)); ((8, 7), Flagged Bomb);
   ((8, 8), Unclicked (Safe 1))]

let initState = {grid = grid1; board = board1; curr_mode = Normal;
              fin = Unfinished; flags = 10}

let middleState1 = {grid = grid1; board = boardFlags; curr_mode = Normal;
              fin = Unfinished; flags = 7}

let middleState2 = {grid = grid1; board = boardFlags; curr_mode = Flag;
              fin = Unfinished; flags = 7}

let winState1 = {grid = grid1; board = boardWin; curr_mode = Normal;
              fin = Unfinished; flags = 0}

let winState2 = {grid = grid1; board = boardWin; curr_mode = Flag;
              fin = Unfinished; flags = 0}

let tests =
  [
  "init_state_flags" >:: (fun _ -> assert_equal 10 (init_state()).flags);
  "init_state_fin" >:: (fun _ -> assert_equal Unfinished (init_state()).fin);
  "init_state_curr_mode" >:: (fun _ -> assert_equal Normal (init_state()).curr_mode);

  "gameplay_state_Nflags" >:: (fun _ -> assert_equal 10 (extract_state (eval (Click (6,4)) initState)).flags);
  "gameplay_state_Nfin" >:: (fun _ -> assert_equal Unfinished (extract_state (eval (Click (6,4)) initState)).fin);
  "gameplay_state_Ncurr_mode" >:: (fun _ -> assert_equal Normal (extract_state (eval (Click (6,4)) initState)).curr_mode);
  "gameplay_state_Ngrid" >:: (fun _ -> assert_equal grid1 (extract_state (eval (Click (6,4)) initState)).grid);
  "gameplay_state_Nflags1" >:: (fun _ -> assert_equal 7 (extract_state (eval (Click (8,8)) middleState1)).flags);
  "gameplay_state_Nfin1" >:: (fun _ -> assert_equal Unfinished (extract_state (eval (Click (8,8)) middleState1)).fin);
  "gameplay_state_Ncurr_mode1" >:: (fun _ -> assert_equal Normal (extract_state (eval (Click (8,8)) middleState1)).curr_mode);
  "gameplay_state_Ngrid1" >:: (fun _ -> assert_equal grid1 (extract_state (eval (Click (8,8)) middleState1)).grid);

  "gameplay_state_Fflags" >:: (fun _ -> assert_equal 10 ((eval Mode initState) |> extract_state).flags);
  "gameplay_state_Ffin" >:: (fun _ -> assert_equal Unfinished ((eval Mode initState) |> extract_state).fin);
  "gameplay_state_Fboard" >:: (fun _ -> assert_equal board1 ((eval Mode initState) |> extract_state).board);
  "gameplay_state_Fgrid" >:: (fun _ -> assert_equal grid1 ((eval Mode initState) |> extract_state).grid);
  "gameplay_state_Fflags1" >:: (fun _ -> assert_equal 7 ((eval Mode middleState1) |> extract_state).flags);
  "gameplay_state_Ffin1" >:: (fun _ -> assert_equal Unfinished ((eval Mode middleState1) |> extract_state).fin);
  "gameplay_state_Fgrid1" >:: (fun _ -> assert_equal grid1 ((eval Mode middleState1) |> extract_state).grid);
  "gameplay_state_Fflags2" >:: (fun _ -> assert_equal 6 ((eval (Click(4,2)) middleState2) |> extract_state).flags);
  "gameplay_state_Fcurr_mode2" >:: (fun _ -> assert_equal Normal ((eval Mode middleState2) |> extract_state).curr_mode);
  "gameplay_state_Ffin2" >:: (fun _ -> assert_equal Unfinished ((eval Mode middleState2) |> extract_state).fin);
  "gameplay_state_Fgrid2" >:: (fun _ -> assert_equal grid1 ((eval Mode middleState2) |> extract_state).grid);

  "check_state_flags" >:: (fun _ -> assert_equal 10 ((eval Check initState) |> extract_state).flags);
  "check_state_fin" >:: (fun _ -> assert_equal Lose ((eval Check initState) |> extract_state).fin);
  "check_state_curr_mode" >:: (fun _ -> assert_equal Normal (extract_state (eval Check initState)).curr_mode);
  "check_state_flags1" >:: (fun _ -> assert_equal 0 ((eval Check winState1) |> extract_state).flags);
  "check_state_fin1" >:: (fun _ -> assert_equal Win ((eval Check winState1) |> extract_state).fin);
  "check_state_curr_mode1" >:: (fun _ -> assert_equal Normal (extract_state (eval Check winState1)).curr_mode);
  "check_state_grid1" >:: (fun _ -> assert_equal grid1 (extract_state (eval Check winState1)).grid);
  "check_state_board1" >:: (fun _ -> assert_equal boardWin (extract_state (eval Check winState1)).board);
  "check_state_flags2" >:: (fun _ -> assert_equal 0 ((eval Check winState2) |> extract_state).flags);
  "check_state_fin2" >:: (fun _ -> assert_equal Win ((eval Check winState2) |> extract_state).fin);
  "check_state_grid2" >:: (fun _ -> assert_equal grid1 (extract_state (eval Check winState2)).grid);
  "check_state_board2" >:: (fun _ -> assert_equal boardWin (extract_state (eval Check winState2)).board);
  "check_state_flags3" >:: (fun _ -> assert_equal 7 ((eval Check middleState1) |> extract_state).flags);
  "check_state_fin3" >:: (fun _ -> assert_equal Lose ((eval Check middleState1) |> extract_state).fin);
  "check_state_curr_mode3" >:: (fun _ -> assert_equal Normal (extract_state (eval Check middleState1)).curr_mode);
  "check_state_grid3" >:: (fun _ -> assert_equal grid1 (extract_state (eval Check middleState1)).grid);
  "check_state_board3" >:: (fun _ -> assert_equal boardFlags (extract_state (eval Check middleState1)).board);
  "check_state_flags4" >:: (fun _ -> assert_equal 7 ((eval Check middleState2) |> extract_state).flags);
  "check_state_fin4" >:: (fun _ -> assert_equal Lose ((eval Check middleState2) |> extract_state).fin);
  "check_state_grid4" >:: (fun _ -> assert_equal grid1 (extract_state (eval Check middleState2)).grid);
  "check_state_board4" >:: (fun _ -> assert_equal boardFlags (extract_state (eval Check middleState2)).board);

  "reset_state_flags" >:: (fun _ -> assert_equal 10 ((eval Reset initState) |> extract_state).flags);
  "reset_state_fin" >:: (fun _ -> assert_equal Unfinished ((eval Reset initState) |> extract_state).fin);
  "reset_state_curr_mode" >:: (fun _ -> assert_equal Normal (extract_state (eval Reset initState)).curr_mode);
  "reset_state_flags1" >:: (fun _ -> assert_equal 10 ((eval Reset middleState1) |> extract_state).flags);
  "reset_state_fin1" >:: (fun _ -> assert_equal Unfinished ((eval Reset middleState1) |> extract_state).fin);
  "reset_state_curr_mode1" >:: (fun _ -> assert_equal Normal (extract_state (eval Reset middleState1)).curr_mode);
  "reset_state_flags2" >:: (fun _ -> assert_equal 10 ((eval Reset winState1) |> extract_state).flags);
  "reset_state_fin2" >:: (fun _ -> assert_equal Unfinished ((eval Reset winState1) |> extract_state).fin);
  "reset_state_curr_mode2" >:: (fun _ -> assert_equal Normal (extract_state (eval Reset winState1)).curr_mode);
]

let suite =
  "Mineswifter test suite"
  >::: tests

let _ = run_test_tt_main suite
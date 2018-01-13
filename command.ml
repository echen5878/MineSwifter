
type input = Click of int*int | Reset | Mode | Check

let user_input (x,y) =
  match (x,y) with
  | (12,6) -> Reset
  | (12,2) -> Mode
  | (12,4) -> Check
  | _ -> Click (x,y)

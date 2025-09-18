(*
 * Sudoku / Number place
 *
 * [Grid]
 *     C0 C1 C2 C3 C4 C5 C6 C7 C8
 *    +--------+--------+--------+    R: Row
 *  R0|        |        |        |    C: Column
 *  R1|   B0   |   B1   |   B2   |    B: Box
 *  R2|        |        |        |
 *    +--------+--------+--------+    Cell(x,y) = RxCy
 *  R3|        |        |        |      position = 9x + y
 *  R4|   B3   |   B4   |   B5   |
 *  R5|        |        |        |
 *    +--------+--------+--------+
 *  R6|        |        |        |
 *  R7|   B6   |   B7   |   B8   |
 *  R8|        |        |        |
 *    +--------+--------+--------+
 *
 * [Matrix]
 *        R0C0 R0C1 .. R8C8 | R0#1 R0#2 .. R8#8 R8#9 | C0#1 C0#2 .. C8#8 C8#9 | B0#1 B0#2 .. B8#8 B8#9
 * ----------------------------------------------------------------------------------------------------
 * R0C0#1   1    0  ..   0      1    0  ..   0    0      1    0  ..   0    0      1    0  ..   0    0
 * R0C0#2   1    0  ..   0      0    1  ..   0    0      0    1  ..   0    0      0    1  ..   0    0
 *  ...
 * R0C0#9   1    0  ..   0      0    0  ..   0    0      0    0  ..   0    0      0    0  ..   0    0
 * R0C1#1   0    1  ..   0      1    0  ..   0    0      0    0  ..   0    0      1    0  ..   0    0
 *  ...
 * R0C8#9   0    0  ..   0      0    0  ..   0    0      0    0  ..   0    1      0    0  ..   0    0
 * R1C0#1   0    0  ..   0      0    0  ..   0    0      1    0  ..   0    0      0    0  ..   0    0
 *  ...
 * R8C8#8   0    0  ..   1      0    0  ..   1    0      0    0  ..   1    0      0    0  ..   1    0
 * R8C8#9   0    0  ..   1      0    0  ..   0    1      0    0  ..   0    1      0    0  ..   0    1
 *
 *   Row: RxCy#N -> Cell(x,y) = N
 *   Col: RxCy -> some number is in Cell(x,y)       [cell constraint] (81 columns)
 *        Rx#N -> number 'N' is in the row Rx       [row constraint] (81 columns)
 *        Cy#N -> number 'N' is in the column Cy    [column constraint] (81 columns)
 *        Bz#N -> number 'N' is in the box Bz       [box constraint] (81 columns)
 *)

let print_result lst =
  let re = Str.regexp ".*#" in
  let rec aux n lst =
    if n = 0 then (
      Format.printf "@.";
      aux 9 lst
    ) else (
      match lst with
      | [] -> Format.printf "@.";
      | _ -> Format.printf "%s " (Str.replace_first re "" (List.hd lst)); aux (n - 1) (List.tl lst)
    )
  in
  aux 9 (List.sort compare lst)
;;

let make_tag l n =
  Format.sprintf "%c%d" (Char.chr (Char.code 'a' + l)) (n + 1)
;;

let make_dlx q =
  (* number of columns = 324 (81 + 81 + 81 + 81) *)
  let d = Algo_x.dlx_init 324 in
  let add_row pos n =
    let r, c, b = (pos / 9, pos mod 9, (pos / 27 * 3) + (pos mod 9 / 3)) in
    let add_row' num =
      let tag = Printf.sprintf "R%dC%d#%d" r c num in
      Algo_x.dlx_add_row
        ~name:tag
        d
        [ pos + 1
        ; 81 + 1 + (r * 9) + (num - 1)
        ; (81 * 2) + 1 + (c * 9) + (num - 1)
        ; (81 * 3) + 1 + (b * 9) + (num - 1)
        ]
    in
    if n <> 0 then
      add_row' n
    else
      for i = 1 to 9 do
        add_row' i
      done
  in
  List.iteri
    (fun i n -> add_row i n)
    (List.map int_of_string (Str.split (Str.regexp "") q));
  d
;;

(*
 * 8 . . | . . . | . . .
 * . . 3 | 6 . . | . . .
 * . 7 . | . 9 . | 2 . .
 * ------+-------+------
 * . 5 . | . . 7 | . . .
 * . . . | . 4 5 | 7 . .
 * . . . | 1 . . | . 3 .
 * ------+-------+------
 * . . 1 | . . . | . 6 8
 * . . 8 | 5 . . | . 1 .
 * . 9 . | . . . | 4 . .
 *)
let grid = "800000000003600000070090200050007000000045700000100030001000068008500010090000400"

let () =
  let d = make_dlx  grid in
  match Algo_x.dlx_solve d with
  | None -> ()
  | Some result ->
     List.iter (fun lst -> print_result lst) result
;;

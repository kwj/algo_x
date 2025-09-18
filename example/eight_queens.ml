(*
 * Eight queens puzzle
 *
 *   8 ........
 *   7 ........   C#: Column (a, b, .., h)
 *   6 ........   R#: Row (1, 2, .., 8)
 *   5 ........
 *   4 ........
 *   3 ........
 *   2 ........
 *   1 ........
 *     abcdefgh
 *
 *  SE7    SE13
 *   6 \\\\\\\
 *   5 \\\\\\\\   SE#: Southeast direction (1, 2, .., 13)
 *   4 \\\\\\\\
 *   3 \\\\\\\\     \
 *   2 \\\\\\\\      \
 * SE1 \\\\\\\\       \
 *     \\\\\\\\
 *      \\\\\\\
 *
 *      ///////
 *     ////////   NE#: Northeast direction (1, 2, .., 13)
 * NE1 ////////
 *   2 ////////       /
 *   3 ////////      /
 *   4 ////////     /
 *   5 ////////
 *   6 ///////
 *  NE7    NE13
 *
 * Column, Row (Ca, Cb, .., Ch, R1, R2, .., R8) - 16 constraints
 *   - One queen must be in the line.
 *   - It must be covered excatly once.
 * Diagonal (SE1, SE2, .., SE13, NE1, NE2, .., NE13) - 26 constraints
 *   - One or zero queen must be in the line.
 *   - It must only be covered at most once.
 *
 * [Matrix]
 *              exactly once <--- | ---> at most once
 * Tag  Ca Cb .. Ch | R1 R2 .. R8 | SE1 SE2 .. SE13 | NE1 NE2 .. NE6 NE7 NE8 .. NE13
 * -------------------------------+-----------------------------------------------------
 * a1    1  0 ..  0    1  0 ..  0 |  0   0  ..   0     0   0  ..  0   1   0  ..  0
 * a2    1  0 ..  0    0  1 ..  0 |  1   0  ..   0     0   0  ..  1   0   0  ..  0
 * ..
 * a8    1  0 ..  0    0  0 ..  1 |  0   0  ..   0     0   0  ..  0   0   0  ..  0
 * b1    0  1 ..  0    1  0 ..  0 |  1   0  ..   0     0   0  ..  0   0   1  ..  0
 * b2    0  1 ..  0    0  1 ..  0 |  0   1  ..   0     0   0  ..  0   1   0  ..  0
 * ..
 * h7    0  0 ..  1    0  0 ..  0 |  0   0  ..   1     0   0  ..  0   0   1  ..  0
 * h8    0  0 ..  1    0  0 ..  1 |  0   0  ..   0     0   0  ..  0   1   0  ..  0
 *
 * For eight queens puzzle, we create an object with `Algo_x.dlx_init ~n_exactly_once:(8 * 2) (8 * 2 + 13 * 2)`.
 *)

let print_result lst =
  List.iter (fun s -> Format.printf "%s " s) (List.sort compare lst);
  Format.printf "@."
;;

let make_dlx n =
  assert (n > 0);

  let make_tag l n = Format.sprintf "%c%d" (Char.chr (Char.code 'a' + l)) (n + 1) in
  let n_diag_lines = if n = 1 then 2 * n - 1 else 2 * n - 3 in
  let d = Algo_x.dlx_init ~n_exactly_once:(n * 2) (n * 2 + n_diag_lines * 2) in
  for letter = 0 to (n - 1) do
    for num = 0 to (n - 1) do
      let se = letter + num in
      let se_idx = if se != 0 && se != (n - 1) * 2 then [se + n * 2] else [] in
      let ne = (n - 1) + letter - num in
      let ne_idx = if ne != 0 && ne != (n - 1) * 2 then [ne + (n * 2) + (n - 1) * 2 - 1] else [] in
      let tag = make_tag letter num in
      Algo_x.dlx_add_row ~name:tag d ([letter + 1; (num + 1) + n] @ se_idx @ ne_idx)
    done
  done;
  
  d
;;

let () =
  let d = make_dlx 8 in
  match Algo_x.dlx_solve d with
  | None -> ()
  | Some result ->
     List.iter (fun lst -> print_result lst) result
;;

(*
 * https://en.wikipedia.org/wiki/Knuth%27s_Algorithm_X#Example
 *
 * - the universe _U_ = {1, 2, 3, 4, 5, 6, 7}
 * - the collection of set _S_ = {A, B, C, D, E, F}:
 *   - _A_ = {1, 4, 7}
 *   - _B_ = {1, 4}
 *   - _C_ = {4, 5, 7}
 *   - _D_ = {3, 5, 6}
 *   - _E_ = {2, 3, 6, 7}
 *   - _F_ = {2, 7}
 *)

let print_result lst =
  List.iter (fun s -> Format.printf "%s " s) lst;
  Format.printf "@."
;;

let () =
  let d = Algo_x.dlx_init 7 in
  Algo_x.dlx_add_row ~name:"A" d [1; 4; 7];
  Algo_x.dlx_add_row ~name:"B" d [1; 4];
  Algo_x.dlx_add_row ~name:"C" d [4; 5; 7];
  Algo_x.dlx_add_row ~name:"D" d [3; 5; 6];
  Algo_x.dlx_add_row ~name:"E" d [2; 3; 6; 7];
  Algo_x.dlx_add_row ~name:"F" d [2; 7];
  match Algo_x.dlx_solve d with
  | None -> ()
  | Some result ->
     List.iter (fun lst -> print_result lst) result
;;

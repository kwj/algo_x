# algo_x
A test implementation of Knuth's Algorithm X[1][2].

## Interface
```ocaml
type t

val dlx_init : int -> t
val dlx_add_row : ?name:string -> t -> int list -> unit
val dlx_solve : t -> string list list option

```

## Usage
We will use an example from Wikipedia[1].

- A = {1, 4, 7}
- B = {1, 4}
- C = {4, 5, 7}
- D = {3, 5, 6}
- E = {2, 3, 6, 7}
- F = {2, 7}

|   | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
| - | - | - | - | - | - | - | - |
| A | 1 | 0 | 0 | 1 | 0 | 0 | 1 |
| B | 1 | 0 | 0 | 1 | 0 | 0 | 0 |
| C | 0 | 0 | 0 | 1 | 1 | 0 | 1 |
| D | 0 | 0 | 1 | 0 | 1 | 0 | 0 |
| E | 0 | 1 | 1 | 0 | 0 | 1 | 1 |
| F | 0 | 1 | 0 | 0 | 0 | 0 | 1 |

```ocaml
# let d = dlx_init 7;;
val d : t =                                                                                                                                        <snip>
# dlx_add_row ~name:"A" d [1; 4; 7];;
- : unit = ()
# dlx_add_row ~name:"B" d [1; 4];;
- : unit = ()
# dlx_add_row ~name:"C" d [4; 5; 7];;
- : unit = ()
# dlx_add_row ~name:"D" d [3; 5; 6];;
- : unit = ()
# dlx_add_row ~name:"E" d [2; 3; 6; 7];;
- : unit = ()
# dlx_add_row ~name:"F" d [2; 7];;
- : unit = ()
# let ans = dlx_solve d;;
val ans : string list list option = Some [["B"; "D"; "F"]] 
#
```

## License

MIT License

Copyright (c) 2021 Jun Kawai

---
[1]  [Knuth's Algorithm X](https://en.wikipedia.org/wiki/Knuth%27s_Algorithm_X)

[2]  [Dancing links](https://arxiv.org/abs/cs/0011047)


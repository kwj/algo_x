# algo_x
A test implementation of Knuth's Algorithm X[^1] using dancing links[^2].

## Interface
```ocaml
type t

val dlx_init : int -> t
val dlx_add_row : ?name:string -> t -> int list -> unit
val dlx_solve : t -> string list list option

```

## Usage
We will use an example from Wikipedia[^1].

- A = {1, 4, 7}
- B = {1, 4}
- C = {4, 5, 7}
- D = {3, 5, 6}
- E = {2, 3, 6, 7}
- F = {2, 7}

|   |   1   |   2   |   3   |   4   |   5   |   6   |   7   |
| - | ----- | ----- | ----- | ----- | ----- | ----- | ----- |
| A |   1   |   0   |   0   |   1   |   0   |   0   |   1   |
|*B*|***1***|   0   |   0   |***1***|   0   |   0   |   0   |
| C |   0   |   0   |   0   |   1   |   1   |   0   |   1   |
|*D*|   0   |   0   |***1***|   0   |***1***|***1***|   0   |
| E |   0   |   1   |   1   |   0   |   0   |   1   |   1   |
|*F*|   0   |***1***|   0   |   0   |   0   |   0   |***1***|

```ocaml
# let d = dlx_init 7;;
val d : t = ...
<snip>
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

It can also be used to resolve Sudoku problem.

```
8 . . | . . . | . . .
. . 3 | 6 . . | . . .
. 7 . | . 9 . | 2 . .
------+-------+------
. 5 . | . . 7 | . . .
. . . | . 4 5 | 7 . .
. . . | 1 . . | . 3 .
------+-------+------
. . 1 | . . . | . 6 8
. . 8 | 5 . . | . 1 .
. 9 . | . . . | 4 . .
```

> Note: *sudoku_dlx* is a matrix generator for Sudoku problem. It's not included in this library.

```ocaml
let d = sudoku_dlx "800000000003600000070090200050007000000045700000100030001000068008500010090000400";;
val d : t = ...
<snip>
# let contents = match dlx_solve d with Some v -> v | _ -> [];;
val contents : string list list =
  [["R0C0#8"; "R1C2#3"; "R1C3#6"; "R2C1#7"; "R2C4#9"; "R2C6#2"; "R3C1#5";
    "R0C0#8"; "R1C2#3"; "R1C3#6"; "R2C1#7"; "R2C4#9"; "R2C6#2"; "R3C1#5";
    "R3C5#7"; "R4C4#4"; "R4C5#5"; "R4C6#7"; "R5C3#1"; "R5C7#3"; "R6C2#1";
    "R6C7#6"; "R6C8#8"; "R7C2#8"; "R7C3#5"; "R7C7#1"; "R8C1#9"; "R8C6#4";
    "R7C6#9"; "R6C6#3"; "R6C0#5"; "R6C1#2"; "R6C4#7"; "R0C3#7"; "R1C1#4";
    "R7C0#4"; "R7C8#7"; "R1C7#7"; "R0C1#1"; "R2C0#6"; "R2C2#5"; "R0C2#2";
    "R1C0#9"; "R0C4#5"; "R0C6#6"; "R8C7#5"; "R8C8#2"; "R0C5#3"; "R2C8#3";
    "R2C5#1"; "R8C4#1"; "R6C5#4"; "R6C3#9"; "R2C3#4"; "R2C7#8"; "R5C5#9";
    "R0C7#4"; "R0C8#9"; "R1C4#8"; "R1C5#2"; "R7C5#6"; "R7C1#3"; "R7C4#2";
    "R5C4#6"; "R3C4#3"; "R5C1#8"; "R4C1#6"; "R4C2#9"; "R3C2#4"; "R4C7#2";
    "R3C7#9"; "R4C3#8"; "R3C3#2"; "R3C0#1"; "R3C6#8"; "R3C8#6"; "R4C0#3";
    "R4C8#1"; "R1C8#5"; "R1C6#1"; "R5C2#7"; "R5C0#2"; "R5C6#5"; "R5C8#4";
    "R8C0#7"; "R8C2#6"; "R8C3#3"; "R8C5#8"]]
# List.sort compare (List.hd contents);;
- : string list =
["R0C0#8"; "R0C1#1"; "R0C2#2"; "R0C3#7"; "R0C4#5"; "R0C5#3"; "R0C6#6";
 "R0C7#4"; "R0C8#9"; "R1C0#9"; "R1C1#4"; "R1C2#3"; "R1C3#6"; "R1C4#8";
 "R1C5#2"; "R1C6#1"; "R1C7#7"; "R1C8#5"; "R2C0#6"; "R2C1#7"; "R2C2#5";
 "R2C3#4"; "R2C4#9"; "R2C5#1"; "R2C6#2"; "R2C7#8"; "R2C8#3"; "R3C0#1";
 "R3C1#5"; "R3C2#4"; "R3C3#2"; "R3C4#3"; "R3C5#7"; "R3C6#8"; "R3C7#9";
 "R3C8#6"; "R4C0#3"; "R4C1#6"; "R4C2#9"; "R4C3#8"; "R4C4#4"; "R4C5#5";
 "R4C6#7"; "R4C7#2"; "R4C8#1"; "R5C0#2"; "R5C1#8"; "R5C2#7"; "R5C3#1";
 "R5C4#6"; "R5C5#9"; "R5C6#5"; "R5C7#3"; "R5C8#4"; "R6C0#5"; "R6C1#2";
 "R6C2#1"; "R6C3#9"; "R6C4#7"; "R6C5#4"; "R6C6#3"; "R6C7#6"; "R6C8#8";
 "R7C0#4"; "R7C1#3"; "R7C2#8"; "R7C3#5"; "R7C4#2"; "R7C5#6"; "R7C6#9";
 "R7C7#1"; "R7C8#7"; "R8C0#7"; "R8C1#9"; "R8C2#6"; "R8C3#3"; "R8C4#1";
 "R8C5#8"; "R8C6#4"; "R8C7#5"; "R8C8#2"]
#
```

The answer is as follows.

```
8 1 2 | 7 5 3 | 6 4 9
9 4 3 | 6 8 2 | 1 7 5
6 7 5 | 4 9 1 | 2 8 3
------+-------+------
1 5 4 | 2 3 7 | 8 9 6
3 6 9 | 8 4 5 | 7 2 1
2 8 7 | 1 6 9 | 5 3 4
------+-------+------
5 2 1 | 9 7 4 | 3 6 8
4 3 8 | 5 2 6 | 9 1 7
7 9 6 | 3 1 8 | 4 5 2
```

## License

MIT License

Copyright (c) 2021 Jun Kawai


[^1]: [Knuth's Algorithm X](https://en.wikipedia.org/wiki/Knuth%27s_Algorithm_X)

[^2]: [Dancing links](https://arxiv.org/abs/cs/0011047)


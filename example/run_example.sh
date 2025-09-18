#!/bin/sh

if [ ! -f "../algo_x.cma" -a ! -f "algo_x.cma" ]; then
    echo "algo_x.cma isn't found."
    exit 1
fi

if [ ! -f "../algo_x.cmi" -a ! -f "algo_x.cmi" ]; then
    echo "algo_x.cmi isn't found."
    exit 1
fi

if [ $# -ne 1 ]; then
    echo "usage: run_example.sh <.ml file>"
    exit 1
fi

if [ ! -f $1 ]; then
    echo "$1 isn't found"
    exit 1
fi

ocaml -I +str -I .. algo_x.cma str.cma $1

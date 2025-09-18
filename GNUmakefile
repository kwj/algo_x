
OCAMLC = ocamlc
OCAMLOPT = ocamlopt
OCAMLFLAGS =
OCAMLOPTFLAGS =
OCAMLINC =

TARGET = algo_x.cma algo_x.cmxa

.PHONY: all

all: $(TARGET)

algo_x.cma: algo_x.cmo
	$(OCAMLC) -a -o $@ $+

algo_x.cmxa: algo_x.cmx
	$(OCAMLOPT) -a -o $@ $+

clean:
	rm -f *.cmi *.cma *.cmo *.cmxa *.cmx *.a *.o

.NOTINTERMEDIATE: %.cmi
%.cmi: %.mli
	$(OCAMLC) $(OCAMLFLAGS) $(OCAMLINC) -c $<

%.cmo: %.ml %.cmi
	$(OCAMLC) $(OCAMLFLAGS) $(OCAMLINC) -c $<

%.cmx: %.ml %.cmi
	$(OCAMLOPT) $(OCAMLOPTFLAGS) $(OCAMLINC) -c $<


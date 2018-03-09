SRC = ./SRC
LEX = ./LEX
OBJ = ./OBJ
BIN = ./BIN
CXX = gcc

all: $(BIN)/DescargarYT

$(BIN)/DescargarYT: $(OBJ)/descargarYT.o
	$(CXX) -o $(BIN)/DescargarYT $(OBJ)/descargarYT.o -ll

$(OBJ)/descargarYT.o: $(SRC)/descargarYT.c
	$(CXX) -c $(SRC)/descargarYT.c -o $(OBJ)/descargarYT.o -ll

$(SRC)/descargarYT.c: $(LEX)/descargarYT.lex
	lex -o $(SRC)/descargarYT.c $(LEX)/descargarYT.lex

clean:
	rm -rf $(BIN)/* $(OBJ)/* $(SRC)/descargarYT.c

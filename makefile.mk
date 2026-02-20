# Makefile for building a Flex/Bison scanner+parser
BISON := bison
FLEX  := flex
CC    := gcc
CFLAGS := -Wall -g
LDFLAGS := -lfl

TARGET := a.out
BISON_SRC := parser.y
FLEX_SRC  := lexer.l
INPUT := wrong.c

.PHONY: all clean run

all: $(TARGET)

# Link step: depends on files produced by bison/flex
$(TARGET): parser.tab.c lex.yy.c
	$(CC) $(CFLAGS) -o $@ parser.tab.c lex.yy.c $(LDFLAGS)

# Generate parser sources and header
parser.tab.c parser.tab.h: $(BISON_SRC)
	$(BISON) -d $<

# Generate lexer source; depend on parser header if lexer references token definitions
lex.yy.c: $(FLEX_SRC) parser.tab.h
	$(FLEX) $<

# Run the parser with input
run: $(TARGET)
	./$(TARGET) < $(INPUT)

clean:
	rm -f $(TARGET) parser.tab.c parser.tab.h lex.yy.c

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

$(TARGET): parser.tab.c lex.yy.c
	$(CC) $(CFLAGS) -o $@ parser.tab.c lex.yy.c $(LDFLAGS)


parser.tab.c parser.tab.h: $(BISON_SRC)
	$(BISON) -d $<

lex.yy.c: $(FLEX_SRC) parser.tab.h
	$(FLEX) $<


run: $(TARGET)
	./$(TARGET) < $(INPUT)

clean:
	rm -f $(TARGET) parser.tab.c parser.tab.h lex.yy.c
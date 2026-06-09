CC ?= gcc
AR ?= ar

CFLAGS ?= -O2 -Wall -Wextra -Wpedantic -std=c11
CPPFLAGS ?=

LIB := libalveo.a
LIB_OBJ := alveo.o
EXAMPLE := tutorial
EXAMPLE_OBJ := main.o

.PHONY: all clean

all: $(LIB) $(EXAMPLE)

$(LIB): $(LIB_OBJ)
	$(AR) rcs $@ $^

$(EXAMPLE): $(EXAMPLE_OBJ) $(LIB)
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ $(EXAMPLE_OBJ) -L. -lalveo

%.o: %.c alveo.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

clean:
	rm -f $(LIB_OBJ) $(EXAMPLE_OBJ) $(LIB) $(EXAMPLE)

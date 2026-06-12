CC ?= gcc
AR ?= ar

CFLAGS ?= -O2 -Wall -Wextra -Wpedantic -std=c11
CPPFLAGS ?=

# Software example selected by the user.
# It must match a file in examples/<APP>.c
APP ?= timer_bram

APPS := $(patsubst examples/%.c,%,$(wildcard examples/*.c))

LIB := libalveo.a
LIB_OBJ := alveo.o

TARGET := $(APP)
APP_SRC := examples/$(APP).c
APP_OBJ := examples/$(APP).o

.PHONY: all clean clean_app list_examples check_app

all: check_app $(LIB) $(TARGET)

check_app:
	@test -f $(APP_SRC) || \
		(echo "ERROR: unknown software example '$(APP)'"; exit 1)
	@echo "Selected software example: $(APP)"

list_examples:
	@printf "%s\n" $(APPS) | sort

$(LIB): $(LIB_OBJ)
	$(AR) rcs $@ $^

$(TARGET): $(APP_OBJ) $(LIB)
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ $(APP_OBJ) -L. -lalveo

%.o: %.c alveo.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

clean_app:
	rm -f $(APP_OBJ) $(TARGET)

clean:
	rm -f $(LIB_OBJ) examples/*.o $(LIB) $(APPS)
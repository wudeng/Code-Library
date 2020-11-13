.PHONY:all

all: array.so tuple.so

%.so: %.c
	gcc -g -shared -o $@ -fPIC -llua $<

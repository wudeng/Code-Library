.PHONY:all

all: array.so

array.so: array.c
	gcc -g -shared -o $@ -fPIC -llua $<

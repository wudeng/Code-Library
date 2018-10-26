all:
	gcc -fprofile-arcs -O2 -c test_builtin_expect.c

dump:
	objdump -d test_builtin_expect.o

s:
	gcc -S test_builtin_expect.c

cow:
	gcc -fPIC -shared cow.c -o cow.so

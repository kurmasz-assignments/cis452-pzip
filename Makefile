all: wzip wunzip pzip

CFLAGS = -Wall -g -O2

wzip: wzip.c
	gcc ${CFLAGS} wzip.c -o wzip

wunzip: wunzip.c
	gcc ${CFLAGS} wunzip.c -o wunzip

pzip: pzip.c
	gcc ${CFLAGS} pzip.c -o pzip

clean:
	rm -f wunzip wzip pzip
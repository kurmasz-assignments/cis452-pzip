all: wzip wunzip pzip

wzip: wzip.c
	gcc -Wall -g wzip.c -o wzip

wunzip: wunzip.c
	gcc -Wall wunzip.c -o wunzip

pzip: pzip.c
	gcc -Wall -g pzip.c -o pzip

clean:
	rm -f wunzip wzip pzip
# Parallel Zip

For this project, you will use threading and synchronization to parallelize a 
simple run-length-encoding-based compression algorithm.

This project is based on a project designed by  Remzi and Andrea Arpaci-Dusseau  for their 
Operating Systems courses. 

## wzip/wunzip

Begin by implementing a single-threaded version of the compression (`wzip`) and 
decompression (`wunzip`) algorithms. 

These tools will use a simple form of compression called
*run-length encoding* (*RLE*). RLE is quite simple: when you encounter **n**
characters of the same type in a row, the compression tool (**wzip**) will
turn that into the number **n** and a single instance of the character.

Thus, if we had a file with the following contents:
```
aaaaaaaaaabbbb
```
the tool would turn it (logically) into:
```
10a4b
```

However, the exact format of the compressed file is quite important; here,
you will write out a 4-byte integer in binary format followed by the single
character in ASCII. Thus, a compressed file will consist of some number of
5-byte entries, each of which is comprised of a 4-byte integer (the run
length) and the single character. 

To write out an integer in binary format (not ASCII), you should use
**fwrite()**. Read the man page for more details. For **wzip**, all
output should be written to standard output (the **stdout** file stream,
which, as with **stdin**, is already open when the program starts running). 

Note that typical usage of the **wzip** tool would thus use shell 
redirection in order to write the compressed output to a file. For example,
to compress the file **file.txt** into a (hopefully smaller) **file.z**,
you would type:

```
prompt> ./wzip file.txt > file.z
```

The **wunzip** tool simply does the reverse of the **wzip** tool, taking
in a compressed file and writing (to standard output again) the uncompressed
results. For example, to see the contents of **file.txt**, you would type:

```
prompt> ./wunzip file.z
```

**wunzip** should read in the compressed file (likely using **fread()**)
and print out the uncompressed output to standard output using **printf()**.

### Additional Details 

* Correct invocation should pass one or more files via the command line to the 
  program; if no files are specified, the program should exit with return code
  1 and print "wzip: file1 [file2 ...]" (followed by a newline) or
  "wunzip: file1 [file2 ...]" (followed by a newline) for **wzip** and
  **wunzip** respectively. 
* The format of the compressed file must match the description above exactly
  (a 4-byte integer followed by a character for each run).
* Do note that if multiple files are passed to **wzip*, they are compressed
  into a single compressed output, and when unzipped, will turn into a single
  uncompressed stream of text (thus, the information that multiple files were
  originally input into **wzip** is lost). The same thing holds for
  **wunzip**. 

## pzip 

Once you have `wzip` and `wunzip` working, create a parallel version named `pzip`.
As before, there may be many input files (not just one, as above). However,
internally, the program will use POSIX threads to parallelize the compression
process.  

## Considerations

Doing so effectively and with high performance will require you to address (at
least) the following issues:

- **How to parallelize the compression.** Of course, the central challenge of
    this project is to parallelize the compression process. Think about what
    can be done in parallel, and what must be done serially by a single
    thread, and design your parallel zip as appropriate.

    One interesting issue that the "best" implementations will handle is this:
    what happens if one thread runs more slowly than another? Does the
    compression give more work to faster threads? 

    For example, what should happen if some files are much bigger than 
    others? 

- **How to determine how many threads to create.** On Linux, this means using
    interfaces like `get_nprocs()` and `get_nprocs_conf()`; read the man pages
    for more details. Then, create threads to match the number of CPU
    resources available.

- **How to efficiently perform each piece of work.** While parallelization
    will yield speed up, each thread's efficiency in performing the
    compression is also of critical importance. Thus, making the core
    compression loop as CPU efficient as possible is needed for high
    performance. 

- **How to access the input file efficiently.** On Linux, there are many ways
    to read from a file, including C standard library calls like `fread()` and
    raw system calls like `read()`. One particularly efficient way is to use
    memory-mapped files, available via `mmap()`. By mapping the input file
    into the address space, you can then access bytes of the input file via
    pointers and do so quite efficiently. (This is especially true if you 
    would like multiple threads to cooperate in compressing a single file.)

## Comparisons

Implement at least two versions of `pzip` that distribute the workload differently.

Compare the runtime performance of the different versions of the compression algorithm 
(the sequential version `wzip`, and the parallel versions of `pzip`).
Run your comparison on at least two different combinations of files.  Be sure
to specify the configuration of the machine you are using (OS, number of cores, amount of RAM, etc.)

Discuss the causes of any observed performance differences between the parallel versions.

Before collecting your final data, don't forget to edit the `Makefile` to remove `-g` and 
enable optimization.

## Testing

* You can use `filegen.py` to generate random files (that intentionally include long runs).
* `generateTestData` will generate a bunch of test files. My automated tests use this script, so don't modify it.
  (You can copy it and create your own version if you like.)
* `runTests` is used by my automated tests. Don't modify it.
* I will run some additional tests locally (in particular, tests using very large files). Be sure to test your 
  code locally using large files.
* The directories `temp` and `testData` contain a `.gitignore`. This is intentional. Please don't add large test
  files to your repository. (I don't want a bunch of huge files of random data.)


  
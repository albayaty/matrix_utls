#  matrix_utls

This SWI-Prolog matrix utilities package consists of:
1.  Kronecker (Tensor) product, 
2.  Hadamard (Element-Wise) product, 
3.  Creating (MxN) matrix of empty cells, 
4.  Creating (MxN) matrix of a unique (int/float/letters) value, 
5.  Creating (MxN) matrix of random (int/float) values, 
6.  Creating (MxM) Identity matrix, 
7.  Scalar-by-Vector multiplication, 
8.  Scalar-by-Matrix multiplication, 
9.  Vector-by-Vector multiplication, 
10. Vector-by-Matrix multiplication, 
11. Matrix-by-Vector multiplication, and 
12. Matrix-by-Matrix multiplication.

## Installation

### Checking Step:

Search for the package `matrix_utls` from SWI-Prolog command line using the `pack_list/1` command. Note that, the leading `i` indicates that this package is already installed, and the leading `p` indicates that this package is known by the server.
```
?- pack_list(matrix_utls).
```

### Loading Step:

After finding the package `matrix_utls` on the server, then it can be installed using the `pack_install/2` command.
```
% For matrix_utls version 1.0:
?- pack_install(matrix_utls, [url('https://albayaty.me/wp-content/uploads/matrix_utls-1.0.zip')]).
```
Or,
```
% For matrix_utls version 1.1:
?- pack_install(matrix_utls, [url('https://github.com/albayaty/matrix_utls.git')]).
```

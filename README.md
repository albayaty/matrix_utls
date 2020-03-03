# matrix_utls

Matrix utilities package consists of Kronecker (Tensor) product, Hadamard (Element-Wise) product, creating (MxN) matrix of empty cells, creating (MxN) matrix of a unique (int/float/letters) value, creating (MxN) matrix of random (int/float) values, creating (MxM) Identity matrix, Scalar-by-Vector multiplication, Scalar-by-Matrix multiplication, Vector-by-Vector multiplication, Vector-by-Matrix multiplication, Matrix-by-Vector multiplication, and Matrix-by-Matrix multiplication.

## Installation

### Checking Step

Search for the package `matrix_utls` from SWI-Prolog command line using the `pack_list/1` command. Note that, the leading `i` indicates that this package is already installed, and the leading `p` indicates that this package is known by the server.
```
?- pack_list(matrix_utls).
```

### Loading Step

After finding the package `matrix_utls` on the server, then it can be installed using the `pack_install/2` command.
```
?- pack_install(matrix_utls, [url('https://albayaty.me/wp-content/uploads/matrix_utls-1.0.zip')]).
```

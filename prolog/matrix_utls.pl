% ------------------------------------------------------
% Package: matrix_utls
% Title:   Matrix utilities package consists of:
%          1.  Kronecker (Tensor) product,
%          2.  Hadamard (Element-Wise) product,
%          3.  Creating (MxN) matrix of empty cells,
%          4.  Creating (MxN) matrix of a unique (int/float/letters) value,
%          5.  Creating (MxN) matrix of random (int/float) values,
%          6.  Creating (MxM) Identity matrix,
%          7.  Scalar-by-Vector multiplication,
%          8.  Scalar-by-Matrix multiplication,
%          9.  Vector-by-Vector multiplication,
%          10. Vector-by-Matrix multiplication,
%          11. Matrix-by-Vector multiplication, and
%          12. Matrix-by-Matrix multiplication.
% Version: 1.1
% Authors: Ali Al-Bayaty   <albayaty@pdx.edu>
%          Marek Perkowski <h8mp@pdx.edu>
%          Electrical & Computer Engineering Dept.
%          Portland State University
% Date:    02/25/2020
% ------------------------------------------------------


:- module(matrix_utls,
          [   kronecker/3,
              hadamard/3,
              create_empty_matrix/3,
              create_val_matrix/4,
              create_rand_matrix/5,
              create_I_matrix/2,
              s_v_multiply/3,
              s_m_multiply/3,
              v_v_multiply/3,
              v_m_multiply/3,
              m_v_multiply/3,
              m_m_multiply/3
          ]).


% Saving and restoring the temporary results (facts) to/from the KB:
:- dynamic outRes/1, subOutRes/1, addRes/1.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------------------------------- %
% Kronecker (Tensor) Product                           %
% ---------------------------------------------------- %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Where,
%  A is the input (multiplicand) matrix of size [GxH],
%  B is the input (multiplier) matrix of size [JxK], and
%  O is the output matrix of size [(GxJ)x(HxK)].

kronecker(A, B, O):-
   assert(outRes([])),
   assert(subOutRes([])),
   maplist(get_A_Rows(B), A),
   retract(subOutRes(_)),
   retract(outRes(O)).

% Getting the rows of A:
get_A_Rows(B, A_Row):-
   maplist(get_B_Rows(A_Row), B).

% Getting the cells from 1 row of A:
get_A_Cells(B_Row, A_Cell):-
   maplist(get_B_Cells(A_Cell), B_Row).

% Getting the rows of B:
get_B_Rows(A_Row, B_Row):-
   maplist(get_A_Cells(B_Row), A_Row),
   retract(outRes(Out)),
   retract(subOutRes(SubOut)),
   append(Out, [SubOut], FinalOut),
   assert(subOutRes([])),
   assert(outRes(FinalOut)).

% Getting the cells from 1 row of B:
get_B_Cells(A_Cell, B_Cell):-
   % Element-wise cells multiplications:
   R is A_Cell * B_Cell,
   retract(subOutRes(SubOut)),
   append(SubOut, [R], FinalSubOut),
   assert(subOutRes(FinalSubOut)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------------------------------- %
% Hadamard (Element-Wise) Product                      %
% ---------------------------------------------------- %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Where,
%  A is the input (multiplicand) matrix of size [GxH],
%  B is the input (multiplier) matrix of size [GxH], and
%  O is the output matrix of size [GxH].

hadamard(A, B, O):-
   % Checking the dimensional equality:
   checkRows(A ,B, Num_Rows),
   checkCols(A, B, Num_Cols),
   assert(outRes([])),
   assert(subOutRes([])),
   forall(between(1, Num_Rows, Row_Index),
                                   doRows(A, B, Row_Index, Num_Cols)),
   retract(subOutRes(_)),
   retract(outRes(O)).

% Checking the rows equality:
checkRows(A, B, Num_A_Rows):-
   length(A, Num_A_Rows),
   length(B, Num_B_Rows),
   ( Num_A_Rows =\= Num_B_Rows
      -> writeln('\nError: Matrices do not have equal dimensionality (rows) ...\n'),
         abort
      ;  ! ).

% Checking the cols equality:
checkCols(A, B, Num_A_Cols):-
   nth1(1, A, A_Row),
   nth1(1, B, B_Row),
   length(A_Row, Num_A_Cols),
   length(B_Row, Num_B_Cols),
   ( Num_A_Cols =\= Num_B_Cols
      -> writeln('\nError: Matrices do not have equal dimensionality (columns) ...\n'),
         abort
      ;  !).

doRows(A, B, Row_Index, Num_Cols):-
   nth1(Row_Index, A, A_Row),
   nth1(Row_Index, B, B_Row),
   forall(between(1, Num_Cols, Col_Index),
                                    doCols(A_Row, B_Row, Col_Index)),
   retract(outRes(Out)),
   retract(subOutRes(SubOut)),
   append(Out, [SubOut], FinalOut),
   assert(subOutRes([])),
   assert(outRes(FinalOut)).

doCols(A_Row, B_Row, Col_Index):-
   nth1(Col_Index, A_Row, A_Cell),
   nth1(Col_Index, B_Row, B_Cell),
   R is A_Cell * B_Cell,
   retract(subOutRes(SubOut)),
   append(SubOut, [R], FinalSubOut),
   assert(subOutRes(FinalSubOut)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------------------------------- %
% Creating/Setting (MxN) Matrix                        %
% ---------------------------------------------------- %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Where,
%  Rows is the number of rows,
%  Cols is the number of columns, and
%  Mat is the resultant matrix of size [Rows x Cols].

% Create 2D matrix of empty cells:
create_empty_matrix(Rows, Cols, Mat):-
   length(Mat, Rows),
   % Creating temporary Lists based on the number of rows:
   maplist(create_list(Cols), Mat).

% Create 2D matrix and set with a unique (int/float/letters) value:
create_val_matrix(Rows, Cols, Mat, Value):-
   create_empty_matrix(Rows, Cols, Mat),
   setValue(Value, 1, Mat).

% Create 2D matrix and set with a range of random (int/float) values:
create_rand_matrix(Rows, Cols, Mat, Min_Value, Max_Value):-
   create_empty_matrix(Rows, Cols, Mat),
   setValue([Min_Value, Max_Value], 2, Mat).

% Creating the columns of Mat:
create_list(Cols, Sub_Mat):-
   length(Sub_Mat, Cols).

% Setting values for each cell of Mat:
setValue(Value, Type, Mat):-
   maplist(setRows(Value, Type), Mat).
setRows(Value, Type, Mat_Rows):-
   maplist(setCells(Value, Type), Mat_Rows).
setCells(Value, 1, Mat_Cell):- Mat_Cell = Value, !.
setCells(Value, 2, Mat_Cell):-
   nth1(1, Value, Min_Value),
   nth1(2, Value, Max_Value),
   random(Min_Value, Max_Value, Mat_Cell), !.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------------------------------- %
% Creating Identity (MxM) Matrix                       %
% ---------------------------------------------------- %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Where,
%  Dim is the number of rows and columns, and
%  Mat is the resultant identity matrix of size [Dim x Dim].

create_I_matrix(Dim, Mat):-
   Dim_1 is Dim - 1,
   create_val_matrix(1, Dim_1, Zeros, 0),
   nth1(1, Zeros, Zero),
   length(Mat, Dim),
   numlist(1, Dim, Index),
   maplist(insert_Ones(Zero), Index, Mat).

insert_Ones(Zero, Index, Sub_Mat):-
   nth1(Index, Sub_Mat, 1, Zero).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------------------------------- %
% Scalar-by-Vector Multiplication                      %
% ---------------------------------------------------- %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Where,
%  S is the input (multiplicand) scalar (i.e. number),
%  V is the input (multiplier) vector of size [1xH] or [Gx1], and
%  O is the resultant vector of size [1xH] or [Gx1].

s_v_multiply(S, V, O):-
   s_m_multiply(S, V, O).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------------------------------- %
% Scalar-by-Matrix Multiplication                      %
% ---------------------------------------------------- %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Where,
%  S is the input (multiplicand) scalar (i.e. number),
%  M is the input (multiplier) matrix of size [GxH], and
%  O is the resultant matrix of size [GxH].

s_m_multiply(S, M, O):-
   assert(outRes([])),
   assert(subOutRes([])),
   length(M, M_Rows),
   forall(between(1, M_Rows, Row_Index), do_Rows(S, M, Row_Index)),
   retract(subOutRes(_)),
   retract(outRes(O)).

do_Rows(S, M, Row_Index):-
   nth1(Row_Index, M, M_Row),
   length(M_Row, M_Cols),
   forall(between(1, M_Cols, Col_Index), do_Cols(S, M_Row, Col_Index)),
   retract(outRes(Out)),
   retract(subOutRes(SubOut)),
   append(Out, [SubOut], FinalOut),
   assert(subOutRes([])),
   assert(outRes(FinalOut)).

do_Cols(S, M_Row, Col_Index):-
   nth1(Col_Index, M_Row, M_Cell),
   R is S * M_Cell,
   retract(subOutRes(SubOut)),
   append(SubOut, [R], FinalSubOut),
   assert(subOutRes(FinalSubOut)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------------------------------- %
% Vector-by-Vector Multiplication                      %
% ---------------------------------------------------- %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Where,
%  V1 is the input (multiplicand) vector of size [1xJ] or [Kx1],
%  V2 is the input (multiplier) vector of size [Jx1] or [1xK], and
%  O is the resultant scalar of size [1x1] or matrix of size [KxK].

v_v_multiply(V1, V2, O):-
   m_m_multiply(V1, V2, O).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------------------------------- %
% Vector-by-Matrix Multiplication                      %
% ---------------------------------------------------- %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Where,
%  V is the input (multiplicand) vector of size [1xJ],
%  M is the input (multiplier) matrix of size [JxK], and
%  O is the resultant vector of size [1xK].

v_m_multiply(V, M, O):-
   m_m_multiply(V, M, O).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------------------------------- %
% Matrix-by-Vector Multiplication                      %
% ---------------------------------------------------- %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Where,
%  M is the input (multiplicand) matrix of size [JxK],
%  V is the input (multiplier) vector of size [Kx1], and
%  O is the resultant vector of size [Jx1].

m_v_multiply(M, V, O):-
   m_m_multiply(M, V, O).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------------------------------- %
% Matrix-by-Matrix Multiplication                      %
% ---------------------------------------------------- %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Where,
%  M1 is the input (multiplicand) matrix of size [GxH],
%  M2 is the input (multiplier) matrix of size [HxJ], and
%  O is the resultant matrix of size [GxJ].

m_m_multiply(M1, M2, O):-
   length(M1, Num_M1_Rows),
   length(M2, Num_M2_Rows),
   nth1(1, M1, M1_Row),
   length(M1_Row, Num_M1_Cols),
   nth1(1, M2, M2_Row),
   length(M2_Row, Num_M2_Cols),
   checkDim(Num_M1_Cols, Num_M2_Rows),
   assert(outRes([])),
   assert(subOutRes([])),
   assert(addRes(0.0)),
   forall(between(1, Num_M1_Rows, M1_Row_Index),
          do_M1_Rows(M1, M2, M1_Row_Index, Num_M1_Cols, Num_M2_Cols)),
   retract(addRes(_)),
   retract(subOutRes(_)),
   retract(outRes(O)).

% Checking the equal dimensionality requirement:
checkDim(Num_M1_Cols, Num_M2_Rows):-
   ( Num_M1_Cols =\= Num_M2_Rows
      -> writeln('\nError: Matrices do not have equal dimensionality requirement:'),
         write('M1 cols = '), write(Num_M1_Cols), nl,
         write('M2 rows = '), write(Num_M2_Rows), nl,
         writeln('Hint: Both matrices should have equal dimensions (rows and cols).\n'),
         abort
      ;  ! ).

do_M1_Rows(M1, M2, M1_Row_Index, Num_M1_Cols, Num_M2_Cols):-
   forall(between(1, Num_M2_Cols, M2_Col_Index),
          do_M2_Col(M1, M2, M1_Row_Index,Num_M1_Cols, M2_Col_Index)),
   retract(outRes(Out)),
   retract(subOutRes(SubOut)),
   append(Out, [SubOut], FinalOut),
   assert(subOutRes([])),
   assert(outRes(FinalOut)).

do_M2_Col(M1, M2, M1_Row_Index,Num_M1_Cols, M2_Col_Index):-
   nth1(M1_Row_Index, M1, M1_Row),
   forall(between(1, Num_M1_Cols, M1_Col_Index),
          doMultiply(M1_Row, M2, M1_Col_Index, M2_Col_Index)),
   retract(subOutRes(SubOut)),
   retract(addRes(SubAdd)),
   append(SubOut, [SubAdd], FinalSubOut),
   assert(addRes(0.0)),
   assert(subOutRes(FinalSubOut)).

doMultiply(M1_Row, M2, M1_Col_Index, M2_Col_Index):-
   nth1(M1_Col_Index, M1_Row, M1_Cell),
   nth1(M1_Col_Index, M2, M2_Row),
   nth1(M2_Col_Index, M2_Row, M2_Cell),
   R is M1_Cell * M2_Cell,
   retract(addRes(SubAdd)),
   Out is SubAdd + R,
   assert(addRes(Out)).


% ------------------------------------------------------
% %%%%%%%%%%%%%%%%%%% EXAMPLES %%%%%%%%%%%%%%%%%%%%%%%%%
% ------------------------------------------------------
% ?- kronecker([[1,2],[2,-1]], [[1,2],[3,4]], M).
%    M = [[1, 2,  2,  4],
%         [3, 4,  6,  8],
%         [2, 4, -1, -2],
%         [6, 8, -3, -4]].
%
% ?- hadamard([[1,2],[2,-1]], [[1,2],[3,4]], M).
%    M = [[1,  4],
%         [6, -4]].
%
% ?- create_empty_matrix(2, 3, M).
%    M = [[_928, _934, _940],
%         [_946, _952, _958]].
%
% ?- create_val_matrix(2, 3, M, 1).
%    M = [[1, 1, 1],
%         [1, 1, 1]].
%
% ?- create_val_matrix(2, 3, M, Aa).
%    M = [[Aa, Aa, Aa],
%         [Aa, Aa, Aa]].
%
% ?- create_rand_matrix(2, 3, M, -2.0, 2.0).
%    M = [[-0.331722127869,  1.2472310874774, -0.3789740703109],
%         [0.04395141605513, 0.5567944218039, -0.27190713107775]].
%
% ?- create_I_matrix(3, M).
%    M = [[1, 0, 0],
%         [0, 1, 0],
%         [0, 0, 1]].
%
% ?- s_v_multiply(5, [[1, 2, 3]], M).
%    M = [[5, 10, 15]].
%
% ?- s_v_multiply(5, [[1], [2], [3]], M).
%    M = [[5],
%         [10],
%         [15]].
%
% ?- s_m_multiply(5, [[1,2,3], [4,5,6]], M).
%    M = [[5,  10, 15],
%         [20, 25, 30]].
%
% ?- v_v_multiply([[1, 2, 3]], [[1], [2], [3]], M).
%    M = [[14.0]].
%
% ?- v_v_multiply([[1], [2], [3]], [[1, 2, 3]], M).
%    M = [[1.0, 2.0, 3.0],
%         [2.0, 4.0, 6.0],
%         [3.0, 6.0, 9.0]].
%
% ?- v_m_multiply([[1, 2, 3]], [[1,2], [3,4], [5,6]], M).
%    M = [[22.0, 28.0]].
%
% ?- m_v_multiply([[1,2], [3,4], [5,6]], [[1], [2]], M).
%    M = [[5.0],
%         [11.0],
%         [17.0]].
%
% ?- m_m_multiply([[1,2,3],[4,5,6],[7,8,9]],
%                 [[1,0,0],[0,1,0],[0,0,1]], M).
%    M = [[1.0, 2.0, 3.0],
%         [4.0, 5.0, 6.0],
%         [7.0, 8.0, 9.0]].
%
% ------------------------------------------------------

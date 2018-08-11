A = [3 6 6;
     4 8 8];
col_space = colSpace(A);
row_space = colSpace(A');

Pc = col_space * inv( col_space' * col_space ) * col_space';
Pr = row_space * inv( row_space' * row_space ) * row_space';

B = Pc * A * Pr;
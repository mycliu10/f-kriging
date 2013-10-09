module regression
   implicit none
   contains
      !!
      ! this function creates computes the regression mat
      ! Right now, it's [1, x_1^1, x_2^1, x_1^2, x_2^2 ..
      !
      ! input:
      !  x: location of evaluation (f(x))
      !
      ! output:
      !  f(x): [1, x_1^1, ...]
      SUBROUTINE construct_f(f,x,Order,D,Ns)
         IMPLICIT NONE
         INTEGER :: Order, D, Ns
         INTEGER :: oo,dd,i
         DOUBLE PRECISION :: f(1 + Order*D)
         DOUBLE PRECISION :: x(D)
         i = 2;
         f(1) = 1.0D0;
         DO oo=1,Order
            DO dd=1,D
               f(i) = x(dd) ** oo
               i = i + 1
            END DO
         END DO
      END SUBROUTINE

      !! 
      ! This function builds the regression matrix F.
      ! F is built as [f(X_1),f(X_2),...,f(X_NsNAP)]^T
      ! where, in this case, 
      ! f(X_1) = [1,x_1^1,x_2^1,...,x_D^1,x_1^2,...,x_D^2,...,x_1^O,...,x_D^]^T
      ! 
      ! example: (D = 2, O = 3) :
      ! f(X_1) = [1,  x_1^1, x_2^1,  x_1^2, x_2^2,  x_1^3, x_2^3]^T
      !
      ! inputs:
      !  snap_pos: the vector of snapshot positions
      !  Ns: number of snapshots
      !  D: number of dimensions
      !  Order: Order of the polynomial chosen.
      !
      ! Output:
      !  F: The regression matrix without the coefficients. 
      SUBROUTINE construct_fmat(F,snap_pos,Order,D,Ns)
         IMPLICIT NONE
         INTEGER :: Order, D, Ns
         INTEGER :: nn
         DOUBLE PRECISION :: F(Ns,1 + Order*D)
         DOUBLE PRECISION :: snap_pos(Ns,D)
         DO nn=1,Ns
            call construct_f(F(nn,:),snap_pos(nn,:),Order,D,Ns)
         END DO
      END SUBROUTINE
end module
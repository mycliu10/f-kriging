module analytical_solver
   contains

   SUBROUTINE solver(XNEW,YNEW,theta,MSE,XMIN,XMAX,X,Y,D,Ns,NsNew,func_name,S)
      USE PARAMS, ONLY: Raug
      USE ANALYTICAL_FUNCTIONS, ONLY: Y_GRADIENT
      use cokrigingmodule, only:cokriging
      IMPLICIT NONE
      ! arguments
      INTEGER, INTENT(IN) :: D,Ns,NsNew
      DOUBLE PRECISION, INTENT(IN) :: XNEW(NSNEW,D)
      DOUBLE PRECISION, INTENT(IN) :: XMIN(D), XMAX(D)
      DOUBLE PRECISION, INTENT(INOUT) :: theta(D)
      DOUBLE PRECISION, INTENT(OUT) :: MSE(NsNew)
      DOUBLE PRECISION, INTENT(OUT) :: YNEW(NsNew,1)
      DOUBLE PRECISION, INTENT(OUT), optional, target :: S(nsnew,1)
      CHARACTER(len=20),INTENT(IN) :: func_name

      ! work variables
      DOUBLE PRECISION :: YGRAD(Ns,D+1)
      DOUBLE PRECISION :: GRAD(Ns,D)
      DOUBLE PRECISION, intent(out) :: Y(Ns,1)
      DOUBLE PRECISION, intent(in) :: X(Ns,D)
      
      YGRAD = Y_GRADIENT(X,D,Ns,func_name)

      Y(1:NS,1) = YGRAD(1:NS,1)
      GRAD(1:NS,1:D) = YGRAD(1:NS,2:(D+1))

      if (present(S)) then
         CALL COKRIGING(XNEW,YNEW,theta,MSE,X,Y,GRAD,Raug,D,Ns,NsNew,S)
      else 
         CALL COKRIGING(XNEW,YNEW,theta,MSE,X,Y,GRAD,Raug,D,Ns,NsNew)
      endif

   END SUBROUTINE
end module

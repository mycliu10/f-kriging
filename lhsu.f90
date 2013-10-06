MODULE LHSU

CONTAINS
   FUNCTION LHS(XMIN,XMAX,D,Ns)
      IMPLICIT NONE
      INTEGER, INTENT(IN) :: D, Ns
      DOUBLE PRECISION, INTENT(IN) :: xmin(D), xmax(D)
      DOUBLE PRECISION, DIMENSION(NS,D) :: LHS

      INTEGER :: idx(Ns,1)
      DOUBLE PRECISION :: ran(NS,D), P(Ns,1) 
      integer :: ii

      CALL init_random_seed()
      CALL RANDOM_NUMBER(ran)

      DO ii=1,D
         CALL rperm(Ns,idx(1:Ns,1))
         P(1:Ns,1) = (idx(1:Ns,1)-ran(1:Ns,ii))/Ns
         LHS(1:Ns,ii) = xmin(ii) + P(1:Ns,1) * (XMAX(ii) - XMIN(ii))
      END DO
         
   END FUNCTION

   ! from the web
   SUBROUTINE init_random_seed()
      implicit none
      integer, allocatable :: seed(:)
      integer :: i, n, un, istat, dt(8), pid, t(2), s
      integer(8) :: count, tms
    
      call random_seed(size = n)
      allocate(seed(n))
      ! First try if the OS provides a random number generator
      open(newunit=un, file="/dev/urandom", access="stream", &
           form="unformatted", action="read", status="old", iostat=istat)
      if (istat == 0) then
         read(un) seed
         close(un)
      else
         ! Fallback to XOR:ing the current time and pid. The PID is
         ! useful in case one launches multiple instances of the same
         ! program in parallel.
         call system_clock(count)
         if (count /= 0) then
            t = transfer(count, t)
         else
            call date_and_time(values=dt)
            tms = (dt(1) - 1970) * 365_8 * 24 * 60 * 60 * 1000 &
                 + dt(2) * 31_8 * 24 * 60 * 60 * 1000 &
                 + dt(3) * 24 * 60 * 60 * 60 * 1000 &
                 + dt(5) * 60 * 60 * 1000 &
                 + dt(6) * 60 * 1000 + dt(7) * 1000 &
                 + dt(8)
            t = transfer(tms, t)
         end if
         s = ieor(t(1), t(2))
         pid = getpid() + 1099279 ! Add a prime
         s = ieor(s, pid)
         if (n >= 3) then
            seed(1) = t(1) + 36269
            seed(2) = t(2) + 72551
            seed(3) = pid
            if (n > 3) then
               seed(4:) = s + 37 * (/ (i, i = 0, n - 4) /)
            end if
         else
            seed = s + 37 * (/ (i, i = 0, n - 1 ) /)
         end if
      end if
      call random_seed(put=seed)
   end subroutine init_random_seed

   ! Knuth shuffle, from the web
	SUBROUTINE RPERM(N, P)

      INTEGER, INTENT(IN) :: N
      INTEGER, DIMENSION(:), INTENT(OUT) :: P

      INTEGER :: I
      INTEGER :: K, J, IPJ, ITEMP, M
      DOUBLE PRECISION, DIMENSION(100) :: U

      P = (/ (I, I=1,N) /)

      ! GENERATE UP TO 100 U(0,1) NUMBERS AT A TIME.
      DO I=1,N,100
      M = MIN(N-I+1, 100)
      CALL RANDOM_NUMBER(U)
      DO J=1,M
      IPJ = I+J-1
      K = INT(U(J)*(N-IPJ+1)) + IPJ
      ITEMP = P(IPJ)
      P(IPJ) = P(K)
      P(K) = ITEMP
      END DO
      END DO
      RETURN

	END SUBROUTINE RPERM
   
END MODULE

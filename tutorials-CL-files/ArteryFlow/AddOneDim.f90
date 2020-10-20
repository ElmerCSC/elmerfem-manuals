PROGRAM AddOneDim
IMPLICIT NONE
        
INTEGER :: tila, nodeindex, luku, i, nodes, n1d, polyn, e1d, &
           elements, boundaries, surf, surfmax, e2d, bodynro, &
           enro, ebody, etype, bodymax, boundary, boundarymax, &
           bcnro1, bcnro2, cdirection

REAL :: x, y, z, length, dx, maxx, maxy, maxz

OPEN (9, FILE='mesh.header',status='old')
OPEN (10, FILE='mesh.elements',status='old')
OPEN (11, FILE='mesh.boundary',status='old')
OPEN (12, FILE='mesh.nodes',status='old')

!--------------------------------------------------------
! Reading mesh.header -file

READ (9,*) nodes, elements, boundaries
CLOSE(9)

!--------------------------------------------------------
! Check if 1D elements are already added and what is
! the largest body-index = 1D model body nro

bodymax = 0

DO i=1,elements
  READ (10,*,IOSTAT=tila) enro, ebody, etype
  IF (ebody > bodymax) bodymax = ebody
END DO
        
CLOSE(10)         

IF (etype == 203) THEN
  PRINT*,'Model already contains 1D elements' 
  STOP
END IF

bodynro = bodymax + 1

!--------------------------------------------------------
! Check the largest boundary-index and set the 
! 1D inlet and outlet boundary indexes

boundarymax = 0

DO i=1,boundaries
 READ (11,*,IOSTAT=tila) surf, boundary
 IF ( boundary > boundarymax ) boundarymax = boundary
END DO

CLOSE(11)         

bcnro1 = boundarymax + 1 
bcnro2 = boundarymax + 2 

!--------------------------------------------------------
! Read the maximum x, y, and z coordinates

maxx = 0.0
maxy = 0.0
maxz = 0.0

DO i=1,nodes
   READ (12,*,IOSTAT=tila) nodeindex, luku, x, y, z
   IF ( x > maxx ) maxx = x
   IF ( y > maxy ) maxy = y
   IF ( z > maxz ) maxz = z
END DO

CLOSE(12)         
!--------------------------------------------------------

WRITE(*,*)'Give the length of the 1D model (meter)'
READ(*,*) length

WRITE(*,*) 'Give the number of elements of the 1D model'
READ(*,*) e1d

WRITE(*,*) 'Give the coordinate direction of the 1D model'
WRITE(*,*) 'x = 1, y = 2, z = 3'
READ(*,*) cdirection

!--------------------------------------------------------
! Writing the new mesh-files

OPEN (10, FILE='mesh.elements',status='old')
OPEN (11, FILE='mesh.boundary',status='old')
OPEN (12, FILE='mesh.nodes',status='old')
OPEN (13, FILE='mesh.header',status='old')
        
polyn=2
n1d = polyn * e1d + 1
dx = length/(polyn*e1d)

tila=0

!--------------------------------------------------------
! mesh.nodes update

DO i=1,nodes
   READ (12,*,IOSTAT=tila) nodeindex, luku, x, y, z
END DO

IF (cdirection == 1) THEN         
  DO i=1,n1d
     WRITE(12,18) nodes+i,maxx+(i-1)*dx 
  END DO

ELSE IF (cdirection == 2) THEN
  DO i=1,n1d
     WRITE(12,19) nodes+i,maxy+(i-1)*dx 
  END DO

ELSE
  DO i=1,n1d
     WRITE(12,20) nodes+i,maxz+(i-1)*dx 
  END DO

END IF         
!--------------------------------------------------------
! mesh.boundary update

DO i=1,boundaries
   READ (11,*,IOSTAT=tila) surf
END DO
         
WRITE(11,11) boundaries+1,bcnro1,elements+1,nodes+1
WRITE(11,12) boundaries+2,bcnro2,elements+e1d,nodes+n1d

!--------------------------------------------------------
! mesh.element update

DO i=1,elements
   READ (10,*,IOSTAT=tila) enro, ebody, etype
END DO
         
DO i=1,e1d
   WRITE(10,9) elements+i,bodynro,nodes+1+(i-1)*2, &
               nodes+1+(i-1)*2+2, nodes+1+(i-1)*2+1
END DO

!--------------------------------------------------------
! mesh.header update

WRITE(13,13) nodes+n1d, elements+e1d, boundaries+2
WRITE(13,14) 
WRITE(13,15) elements 
WRITE(13,16) boundaries+e1d
WRITE(13,17) 

!--------------------------------------------------------

CLOSE(10)
CLOSE(11)
CLOSE(12)
CLOSE(13)

9  FORMAT(I4,1X,I3,1X,'203',1X,I4,1X,I4,1X,I4) 
11 FORMAT(I4,1X,I3,1X,I4,1X,'0',1X,'101',1X,I4)
12 FORMAT(I4,1X,I3,1X,I4,1X,'0',1X,'101',1X,I4)
13 FORMAT(I4,1X,I4,1X,I4)
14 FORMAT('3')
15 FORMAT('408',1X,I4)
16 FORMAT('203',1X,I4)
17 FORMAT('101',1X,'2')
18 FORMAT(I4,1X,'-1',1X,F8.6,1X,'0.0',1X,'0.0')
19 FORMAT(I4,1X,'-1',1X,'0.0',1X,F8.6,1X,'0.0')
20 FORMAT(I4,1X,'-1',1X,'0.0',1X,'0.0',1X,F8.6)

END PROGRAM AddOneDim


















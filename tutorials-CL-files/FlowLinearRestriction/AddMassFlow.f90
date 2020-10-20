!------------------------------------------------------------------------------
FUNCTION AddMassFlow( Model, Solver, StiffMatrix, ForceVector, &
     Solution, NORs, DOFs, Norm ) RESULT( ReturnValue )
!DEC$ATTRIBUTES DLLEXPORT:: AddMasFlow
!------------------------------------------------------------------------------
!******************************************************************************
!  This function will create a restriction matrix to ConstraintMatrix-field
!  of the StiffMatrix and then call SolveWithLinearRestriction.
!  This restriction matrix ( and restriction vector ) will set
!  sinusoidal (time dependent) massflow to a pipe.
!
!  ARGUMENTS:
!
!  TYPE(Model_t) :: Model,  
!     INPUT: All model information (mesh,materials,BCs,etc...)
!
!  TYPE(Solver_t) :: Solver
!     INPUT: Linear equation solver options
!
!  TYPE(Matrix_t), POINTER :: StiffMatrix
!     INPUT: Linear equation matrix information
!
!  INTEGER :: DOFs
!     INPUT: Number of degrees of freedon of the equation
!
!  INTEGER :: NORs
!     INPUT: Length of solution vector i.e. number of rows in matrix
!
!  REAL(KIND=dp) :: Solution( NORs )
!     INPUT: The unknown in the linear equation
!
!  REAL(KIND=dp) :: ForceVector( NORs )
!     INPUT: The right hand side of the linear equation
!
!  REAL(KIND=dp) :: Norm
!     INPUT: The norm to determine the convergence of the nonlinear system
!
!  INTEGER :: ReturnValue
!     Return value of this function.
!     If 0, then SolveSystem is called after this function.
!     If 1, then assumed that system is already solved
!     NOTE: This function will always return 1.
!
!******************************************************************************

  USE DefUtils
  IMPLICIT NONE
  INTEGER :: ReturnValue
!-----------------------------------------------------------------------------  
  TYPE(model_t)  :: Model
  TYPE(solver_t) :: Solver
  TYPE(matrix_t), POINTER :: StiffMatrix
  INTEGER :: DOFs, NORs
  REAL(KIND=dp) :: ForceVector( NORs ), Solution( NORs ), Norm
!------------------------------------------------------------------------------
  TYPE(Matrix_t),POINTER  :: RestMatrix
  TYPE(Element_t),POINTER :: CurrentElement
  TYPE(Variable_t), POINTER :: TimeVar
  
  REAL(KIND=dp), POINTER :: RestVector(:)
  REAL(KIND=dp) :: y, CurrentTime

  INTEGER, POINTER :: NodeIndexes(:), Perm(:)
  INTEGER, ALLOCATABLE :: VisitedNodes(:)
  INTEGER :: i, j, k, n, istat, NumberOfValues
!------------------------------------------------------------------------------
  CALL Info( 'AddMassFlow', ' ' )
  Perm => Solver % Variable % Perm

  ALLOCATE( VisitedNodes( NORs ), STAT=istat )
  IF ( istat /= 0 ) CALL Fatal( 'AddMassFlow', 'Memory allocation error' )

!------------------------------------------------------------------------------
! Get the current time
!------------------------------------------------------------------------------
  TimeVar => VariableGet( Solver % Mesh % Variables, 'Time' )
  IF ( ASSOCIATED( TimeVar ) ) THEN
     CurrentTime = TimeVar % Values(1)
  ELSE
     CALL Fatal( 'AddMassFlow', 'CurrentTime not found' )
  END IF

!------------------------------------------------------------------------------
! Set RestMatrix point to ConstraintMatrix-field. Allocate memory if necessary.
!------------------------------------------------------------------------------
  RestMatrix => StiffMatrix % ConstraintMatrix

  IF ( .NOT. ASSOCIATED( RestMatrix ) ) THEN
     
     StiffMatrix % ConstraintMatrix => AllocateMatrix()
     RestMatrix => StiffMatrix % ConstraintMatrix
     RestMatrix % NumberOfRows = 1

! Count number of values in RestMatrix:
!--------------------------------------
     NumberOfValues = 0
     VisitedNodes = 0

     DO i = 1, Solver % Mesh % NumberOfBoundaryElements
        CurrentElement => GetBoundaryElement(i)
        IF ( .NOT. ActiveBoundaryElement() ) CYCLE

! Pick nodes from boundary condition 2 ( this number is set in .sif file ):
!--------------------------------------------------------------------------
        IF ( CurrentElement % BoundaryInfo % Constraint == &
             Model % BCs(2) % Tag ) THEN

           n = GetElementNOfNodes()
           NodeIndexes => CurrentElement % NodeIndexes(1:n)

           DO j = 1,n
              k = Perm( NodeIndexes(j) )
              y = Solver % Mesh % Nodes % y(k)
              k = (k-1) * DOFs + 1

              IF ( y == 0.0d0 .OR. y == 1.0d0 ) CYCLE

              IF ( .NOT. ANY( VisitedNodes == k ) ) THEN
                 NumberOfValues = NumberOfValues +1
                 VisitedNodes( NumberOfValues ) = k              

              END IF! <- node already visited
           END DO! <- nodes in boundary element           
        END IF! <- element is on correct boundary
     END DO! <- all boundary elements

     ALLOCATE( RestMatrix % Rows(2), &
          RestMatrix % Cols( NumberOfValues ), &
          RestMatrix % Diag( 1 ), &
          RestMatrix % Values( NumberOfValues ), &
          RestMatrix % RHS(1), &
          STAT = istat )

     IF ( istat /= 0 ) CALL Fatal( 'AddMassFlow', 'Memory allocation error' )

  END IF! <- RestMatrix memory allocation
!------------------------------------------------------------------------------

  RestVector => RestMatrix % RHS

  RestMatrix % Rows = 0
  RestMatrix % Cols = 0
  RestMatrix % Diag = 0
  RestMatrix % Values = 0.0d0

  NumberOfValues = SIZE( RestMatrix % Values )

!------------------------------------------------------------------------------
! Now we have the RestMatrix, next we set the values.
!------------------------------------------------------------------------------

! Set rows is RestMatrix, just one row here:
!-------------------------------------------
  RestMatrix % Rows(1) = 1
  RestMatrix % Rows(2) = NumberOfValues +1

! Set cols and diag in RestMatrix:
!---------------------------------
  VisitedNodes = 0
  NumberOfValues = 1! <- this is used as a counter here

  DO i = 1, Solver % Mesh % NumberOfBoundaryElements
     CurrentElement => GetBoundaryElement(i)
     IF ( .NOT. ActiveBoundaryElement() ) CYCLE

     IF ( CurrentElement % BoundaryInfo % Constraint == &
          Model % BCs(2) % Tag ) THEN
           
        n = GetElementNOfNodes()
        NodeIndexes => CurrentElement % NodeIndexes(1:n)

        DO j = 1,n
           k = Perm( NodeIndexes(j) )
           y = Solver % Mesh % Nodes % y(k)
           k = (k-1) * DOFs + 1
           
           IF ( y == 0.0d0 .OR. y == 1.0d0 ) CYCLE
           
           IF ( .NOT. ANY( VisitedNodes == k ) ) THEN
              VisitedNodes( NumberOfValues ) = k
              RestMatrix % Cols( NumberOfValues ) = k

              IF ( k == 1 ) RestMatrix % Diag(1) = NumberOfValues           
              NumberOfValues = NumberOfValues +1              

           END IF! <- is node already visited
        END DO! <- nodes of boundary element        
     END IF! <- element is on correct boundary
  END DO! <- all boundary elements

! Set the values, all are values are one:
!----------------------------------------
  RestMatrix % Values = 1.0d0

!------------------------------------------------------------------------------
! Set the sinusoidal RHS to RestMatrix
!------------------------------------------------------------------------------
  RestVector = SIZE( RestMatrix % Values )
  RestVector = RestVector * SIN( 2.0d0 * Pi * CurrentTime ) * 10

!------------------------------------------------------------------------------
!  Solve the system, set return value and return
!------------------------------------------------------------------------------
  CALL SolveWithLinearRestriction( &
       StiffMatrix, ForceVector, Solution, Norm, DOFs, Solver)

  CALL Info( 'AddMassFlow', 'All done' )
  ReturnValue = 1
  RETURN

!------------------------------------------------------------------------------
END FUNCTION AddMassFlow
!------------------------------------------------------------------------------



  








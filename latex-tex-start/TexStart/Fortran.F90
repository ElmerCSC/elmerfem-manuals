!   Comment line that ends in column  70 *****************************
!   Comment line that ends in column  80 ***************************************
!   Comment line that ends in column  90 *************************************************
!   Comment line that ends in column 100 ***********************************************************
!*****************************************************************************************
!>
!  Kinds for Minpack

    module minpack_kinds
    use iso_fortran_env, only: real64
    implicit none
    private

    ! Use the same double precision type as rest of Elmer
    integer,parameter,public :: wp = SELECTED_REAL_KIND(12)

!*****************************************************************************************
    end module minpack_kinds
!*****************************************************************************************

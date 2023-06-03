! gracec.f90
program main
    !! Grace example program that calls the C interface.
    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env, only: i8 => int64
    use :: grace
    implicit none (type, external)

    logical, parameter :: WITH_ARGS = .true.

    character(len=80) :: line
    integer           :: i, rc

    if (WITH_ARGS) then
        ! Open Grace with additional command-line arguments. Character
        ! strings have to be null-terminated.
        rc = grace_open_va('xmgrace' // c_null_char, 2048, '-nosafe' // c_null_char, &
                           '-noask' // c_null_char, '-noprint' // c_null_char)
    else
        rc = grace_open(2048)
    end if

    if (rc == -1) stop 'Error: failed to open pipe to Grace'

    rc = grace_register_error_function(error)

    rc = grace_command('world xmax 100')
    rc = grace_command('world ymax 10000')
    rc = grace_command('xaxis tick major 20')
    rc = grace_command('xaxis tick minor 10')
    rc = grace_command('yaxis tick major 2000')
    rc = grace_command('yaxis tick minor 1000')
    rc = grace_command('s0 on')
    rc = grace_command('s0 symbol 1')
    rc = grace_command('s0 symbol size 0.3')
    rc = grace_command('s0 symbol fill pattern 1')
    rc = grace_command('s1 on')
    rc = grace_command('s1 symbol 1')
    rc = grace_command('s1 symbol size 0.3')
    rc = grace_command('s1 symbol fill pattern 1')

    do i = 1, 100
        if (grace_is_open() /= 1) exit

        write (line, '("g0.s0 point ", i0, ", ", i0)') i, 2 * i
        rc = grace_command(line)

        write (line, '("g0.s1 point ", i0, ", ", i0)') i, i**2
        rc = grace_command(line)

        if (modulo(i, 10) == 0) then
            rc = grace_command('redraw')

            ! Wait a second, just to simulate some time needed for
            ! calculations. Your real application shouldn't wait.
            call sleep(1)
        end if
    end do

    rc = grace_close()
contains
    subroutine error(ptr) bind(c)
        !! The C error function is a little more complex than the
        !! FORTRAN 77 counterpart.
        type(c_ptr), intent(in), value  :: ptr     !! Passed C pointer to error message.
        character(kind=c_char), pointer :: ptrs(:) !! Pointers to single characters.
        character(len=:), allocatable   :: str     !! Error message.
        integer(kind=i8)                :: sz      !! Error message length.

        interface
            ! size_t strlen(const char *str)
            function c_strlen(str) bind(c, name='strlen')
                import :: c_ptr, c_size_t
                implicit none
                type(c_ptr), intent(in), value :: str
                integer(kind=c_size_t)         :: c_strlen
            end function c_strlen
        end interface

        ! Convert C pointer to Fortran character string.
        sz = c_strlen(ptr)
        if (sz < 0) return

        call c_f_pointer(ptr, ptrs, [ sz ])
        allocate (character(len=sz) :: str)

        do i = 1, size(ptrs)
            str(i:i) = ptrs(i)
        end do

        ! Output the Fortran string.
        print '("Grace Error: ", a)', str
    end subroutine error
end program main

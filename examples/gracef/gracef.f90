! gracef.f90
program main
    !! Grace example program that calls the FORTRAN 77 interface.
    use :: grace
    implicit none (type, external)

    character(len=80) :: line
    integer           :: i, rc

    rc = graceopenf(2048)
    if (rc == -1) stop 'Error: failed to open pipe to Grace'

    call graceregistererrorfunctionf(error)

    rc = gracecommandf('world xmax 100')
    rc = gracecommandf('world ymax 10000')
    rc = gracecommandf('xaxis tick major 20')
    rc = gracecommandf('xaxis tick minor 10')
    rc = gracecommandf('yaxis tick major 2000')
    rc = gracecommandf('yaxis tick minor 1000')
    rc = gracecommandf('s0 on')
    rc = gracecommandf('s0 symbol 1')
    rc = gracecommandf('s0 symbol size 0.3')
    rc = gracecommandf('s0 symbol fill pattern 1')
    rc = gracecommandf('s1 on')
    rc = gracecommandf('s1 symbol 1')
    rc = gracecommandf('s1 symbol size 0.3')
    rc = gracecommandf('s1 symbol fill pattern 1')

    do i = 1, 100
        if (graceisopenf() /= 1) exit

        write (line, '("g0.s0 point ", i0, ", ", i0)') i, 2 * i
        rc = gracecommandf(trim(line))

        write (line, '("g0.s1 point ", i0, ", ", i0)') i, i**2
        rc = gracecommandf(trim(line))

        if (modulo(i, 10) == 0) then
            rc = gracecommandf('redraw')

            ! Wait a second, just to simulate some time needed for
            ! calculations. Your real application shouldn't wait.
            call sleep(1)
        end if
    end do

    rc = graceclosef()
contains
    subroutine error(str)
        character(len=*), intent(in) :: str

        print '("Grace Error: ", a)', str
    end subroutine error
end program main

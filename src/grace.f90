! grace.f90
!
! Author:  Philipp Engel
! Licence: ISC
module grace
    !! A collection of interfaces to the Grace plotting library
    !! for Fortran 2018.
    use, intrinsic :: iso_c_binding
    implicit none (type, external)
    private

    abstract interface
        subroutine graceerrorfunctionf(str)
            character(len=*), intent(in) :: str
        end subroutine graceerrorfunctionf

        ! void (*GraceErrorFunctionType) (const char *)
        subroutine grace_error_function(ptr) bind(c)
            import :: c_ptr
            implicit none (type, external)
            type(c_ptr), intent(in), value :: ptr
        end subroutine grace_error_function
    end interface

    interface
        integer function graceclosef()
        end function graceclosef

        integer function graceclosepipef()
        end function graceclosepipef

        integer function gracecommandf(cmd)
            character(len=*), intent(in) :: cmd
        end function gracecommandf

        integer function graceflushf()
        end function graceflushf

        integer function graceisopenf()
        end function graceisopenf

        integer function graceopenf(buffer_size)
            integer, intent(in) :: buffer_size
        end function graceopenf

        subroutine graceregistererrorfunctionf(f)
            procedure(graceerrorfunctionf) :: f
        end subroutine graceregistererrorfunctionf
    end interface

    interface
        ! int GraceClose(void)
        function grace_close() bind(c, name='GraceClose')
            !! Close the communication channel and exit the Grace subprocess.
            import :: c_int
            implicit none (type, external)
            integer(kind=c_int) :: grace_close
        end function grace_close

        ! int GraceClosePipe(void)
        function grace_close_pipe() bind(c, name='GraceClosePipe')
            !! Close the communication channel and leave the Grace subprocess
            !! alone.
            import :: c_int
            implicit none (type, external)
            integer(kind=c_int) :: grace_close_pipe
        end function grace_close_pipe

        ! int GraceCommand(const char *command)
        function grace_command_(command) bind(c, name='GraceCommand')
            !! Send an already formated command to the Grace subprocess.
            import :: c_char, c_int
            implicit none (type, external)
            character(kind=c_char), intent(in) :: command
            integer(kind=c_int)                :: grace_command_
        end function grace_command_

        ! int GraceFlush(void)
        function grace_flush() bind(c, name='GraceFlush')
            !! Flush all the data remaining in the buffer.
            import :: c_int
            implicit none (type, external)
            integer(kind=c_int) :: grace_flush
        end function grace_flush

        ! int GraceIsOpen(void)
        function grace_is_open() bind(c, name='GraceIsOpen')
            !! Test if a Grace subprocess is currently connected.
            import :: c_int
            implicit none (type, external)
            integer(kind=c_int) :: grace_is_open
        end function grace_is_open

        ! int GraceOpen(int bs)
        function grace_open(buffer_size) bind(c, name='GraceOpen')
            !! Equivalent to `GraceOpenVA("xmgrace", buffer_size, "-nosafe", "-noask", NULL)`.
            import :: c_int
            implicit none (type, external)
            integer(kind=c_int), intent(in), value :: buffer_size
            integer(kind=c_int)                    :: grace_open
        end function grace_open

        ! int GraceOpenVA(char *exe, int bs, ...)
        function grace_open_va(exe, buffer_size, arg1, arg2, arg3, arg4, arg5, arg6, arg7, &
                               arg8, arg9) bind(c, name='GraceOpenVA')
            !! Launch a Grace executable exe and open a communication channel
            !! with it using `buffer_size` bytes for data buffering. The
            !! remaining NULL-terminated list of options is command-line
            !! arguments passed to the Grace process.
            import :: c_char, c_int
            implicit none (type, external)
            character(kind=c_char), intent(in)           :: exe
            integer(kind=c_int),    intent(in), value    :: buffer_size
            character(kind=c_char), intent(in), optional :: arg1
            character(kind=c_char), intent(in), optional :: arg2
            character(kind=c_char), intent(in), optional :: arg3
            character(kind=c_char), intent(in), optional :: arg4
            character(kind=c_char), intent(in), optional :: arg5
            character(kind=c_char), intent(in), optional :: arg6
            character(kind=c_char), intent(in), optional :: arg7
            character(kind=c_char), intent(in), optional :: arg8
            character(kind=c_char), intent(in), optional :: arg9
            integer(kind=c_int)                          :: grace_open_va
        end function grace_open_va

        ! int GracePrintf(const char *format, ...)
        function grace_printf_(fmt, str) bind(c, name='GracePrintf')
            !! Format a command and send it to the Grace subprocess.
            import :: c_char, c_int
            implicit none (type, external)
            character(kind=c_char), intent(in) :: fmt
            character(kind=c_char), intent(in) :: str
            integer(kind=c_int)                :: grace_printf_
        end function grace_printf_

        ! GraceErrorFunctionType GraceRegisterErrorFunction(GraceErrorFunctionType f)
        function grace_register_error_function_(f) bind(c, name='GraceRegisterErrorFunction')
            !! Register a user function f to display library errors.
            import :: c_funptr
            implicit none (type, external)
            type(c_funptr), intent(in), value :: f
            type(c_funptr)                    :: grace_register_error_function_
        end function grace_register_error_function_
    end interface

    public :: graceclosef
    public :: graceclosepipef
    public :: gracecommandf
    public :: graceerrorfunctionf
    public :: graceflushf
    public :: graceisopenf
    public :: graceopenf
    public :: graceregistererrorfunctionf

    public :: grace_close
    public :: grace_close_pipe
    public :: grace_command
    public :: grace_error_function
    public :: grace_flush
    public :: grace_is_open
    public :: grace_open
    public :: grace_open_va
    public :: grace_printf
    public :: grace_register_error_function
contains
    integer function grace_command(command) result(rc)
        character(len=*), intent(in) :: command

        rc = grace_command_(command // c_null_char)
    end function grace_command

    integer function grace_printf(str) result(rc)
        character(len=*), intent(in) :: str

        rc = grace_printf_('%s' // c_null_char, trim(str) // c_null_char)
    end function grace_printf

    integer function grace_register_error_function(f) result(rc)
        procedure(grace_error_function) :: f
        type(c_funptr)                  :: ptr

        rc = -1
        ptr = grace_register_error_function_(c_funloc(f))
        if (.not. c_associated(ptr)) return
        rc = 0
    end function grace_register_error_function
end module grace

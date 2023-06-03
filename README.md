# fortran-grace
A collection of Fortran 2018 interfaces to the scientific plotting tool
[Grace](https://plasma-gate.weizmann.ac.il/Grace/)/XmGrace. This library covers
the FORTRAN 77 and the C API of Grace.

You will need Grace/XmGrace with development headers. On FreeBSD, run:

```
# pkg install math/grace
```

Link your Fortran programs against `libfortran-grace.a -lgrace_np`.

## Build Instructions

Download the *fortran-grace* repository, and execute the Makefile:

```
$ git clone https://github.com/interkosmos/fortran-grace
$ cd fortran-grace/
$ make
```

If you prefer the [Fortran Package Manager](https://github.com/fortran-lang/fpm),
run:

```
$ fpm build --profile=release
```

You can add *fortran-grace* as a dependency to your `fpm.toml`:

```toml
[dependencies]
fortran-grace = { git = "https://github.com/interkosmos/fortran-grace.git" }
```

## Examples

Example programs are provided in `examples/`:

* **gracec** demonstrates access to the C API.
* **gracef** calls the FORTRAN 77 API through modern Fortran interfaces.

Build the examples with:

```
$ make examples
```

## Coverage

## C API

| C Procedure                    | Fortran Interface                 | Wrapper |
|--------------------------------|-----------------------------------|---------|
| `GraceClose()`                 | `grace_close()`                   |         |
| `GraceClosePipe()`             | `grace_close_pipe()`              |         |
| `GraceCommand()`               | `grace_command()`                 |    ✓    |
| `GraceFlush()`                 | `grace_flush()`                   |         |
| `GraceIsOpen()`                | `grace_is_open()`                 |         |
| `GraceOpen()`                  | `grace_open()`                    |         |
| `GraceOpenVA()`                | `grace_open_va()`                 |         |
| `GracePrintf()`                | `grace_printf()`                  |    ✓    |
| `GraceRegisterErrorFunction()` | `grace_register_error_function()` |    ✓    |

## FORTRAN 77 API

| FORTRAN 77 Procedure            |
|---------------------------------|
| `graceclosef()`                 |
| `graceclosepipef()`             |
| `gracecommandf()`               |
| `graceflushf()`                 |
| `graceisopenf()`                |
| `graceopenf()`                  |
| `graceregistererrorfunctionf()` |

## Licence

ISC

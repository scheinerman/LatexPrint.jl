# LatexPrint

[![Build Status](https://travis-ci.org/scheinerman/LatexPrint.jl.svg?branch=master)](https://travis-ci.org/scheinerman/LatexPrint.jl)

[![codecov.io](http://codecov.io/github/scheinerman/LatexPrint.jl/coverage.svg?branch=master)](http://codecov.io/github/scheinerman/LatexPrint.jl?branch=master)



Print Julia objects in LaTeX form.


## Key functions

This module provides functions for converting Julia objects into
string representations for use in LaTeX mathematics mode. The primary
function is `laprintln` which behaves precisely like `println` except
Julia objects are first converted to a form suitable for
LaTeX. Because `laprintln` is a lot to type, we also provide the
abbreviation `lap`.

```julia
julia> using LatexPrint

julia> x = 2//6
1//3

julia> lap(x)
\frac{1}{3}
```

We also provide the function `laprint` which does not append a new
line (just like `print`).

These functions rely on `latex_form` which converts a Julia object
into an `String` representation in its LaTeX form:

```julia
julia> latex_form(x)
"\\frac{1}{3}"
```

The double backslash in the output of `latex_form` is converted to a
single backslash when run through a `print` function.


## Supported Types

### Numbers

#### Integers and floating point numbers

`FloatingPoint` and `Integer` numbers are printed unchanged.

```julia
julia> lap(sqrt(2))
1.4142135623730951

julia> lap(23)
23
```

However, infinite and invalid values are printed as follows:

```julia
julia> lap(1/0)
\infty

julia> lap(-1/0)
-\infty

julia> lap(0/0)
\text{NaN}
```

Julia's `MathConst` numbers are printed using their expected LaTeX
form:

```julia
julia> lap(pi)
\pi
```

#### Rational numbers

Rational numbers are printed as fractions (unless the denominator
happens to be 1, in which case we print as an integer).

```julia
julia> lap(10//4)
\frac{5}{2}

julia> lap(10//2)
5
```

#### Complex numbers

Complex numbers always include a real and an imaginary part, even if
either part equals zero:

```julia
julia> z = 1+im
1 + 1im

julia> lap(z)
1+1i

julia> lap(z*z)
0+2i

julia> lap(im^im)
0.20787957635076193+0.0i
```

### Boolean values

The `Bool` values `true` and `false` output like this:
```julia
julia> lap(true)
\mathrm{T}

julia> lap(false)
\mathrm{F}
```

### Text

The LaTeX version of an `String` is wrapped in the command
`\text` (which requires the `amsmath` package in LaTeX). The rationale
is that we always want to able to paste the output of `lap` directly
into mathematics mode in LaTeX.

```julia
julia> lap("Hello, world!")
\text{Hello, world!}
```



### Arrays

Vectors (one-dimensional arrays) and matrices (two-dimensional arrays)
are converted into LaTeX `array` environments bounded by square
brackets with centering alignment. (These default options can be
changed; see "Customizing existing types" later in this document.)

```julia
julia> x = [1,2,3]
3-element Array{Int64,1}:
 1
 2
 3

julia> lap(x)
\left[
\begin{array}{c}
1 \\
2 \\
3 \\
\end{array}
\right]

julia> A = eye(3)
3x3 Array{Float64,2}:
 1.0  0.0  0.0
 0.0  1.0  0.0
 0.0  0.0  1.0

julia> lap(A)
\left[
\begin{array}{ccc}
1.0 & 0.0 & 0.0 \\
0.0 & 1.0 & 0.0 \\
0.0 & 0.0 & 1.0 \\
\end{array}
\right]
```

Vectors are, by default, rendered as a column. To typeset a vector as
a row, simply take its transpose:

```julia
julia> x = [2//3, 4//3, 6//3]
3-element Array{Rational{Int64},1}:
 2//3
 4//3
 2//1

julia> lap(x')
\left[
\begin{array}{ccc}
\frac{2}{3} & \frac{4}{3} & 2 \\
\end{array}
\right]
```

### Sets

Julia `Set` and `IntSet` objects are rendered as a comma separated
list between curly braces. The elements are sorted into ascending
order (if possible). An empty set is returned as `\emptyset` (unless
another form is specified using `set_empty`).

```julia
julia> A = Set({3.5, 2, -5})
Set{Any}({2,-5,3.5})

julia> lap(A)
\left\{-5,2,3.5\right\}

julia> B = IntSet(4,5,1)
IntSet([1, 4, 5])

julia> lap(B)
\left\{1,4,5\right\}

julia> C = Set()
Set{Any}({})

julia> lap(C)
\emptyset
```

## The `tabular` function

If `A` is a matrix (two-dimensional array), then `laprintln(A)` (or
`lap(A)`) prints the LaTeX code for that matrix (complete with
bounding delimeters) for inclusion in LaTeX's mathematics mode.

As an alternative, we also provide the function `tabular` that prints
the array for inclusion in LaTeX's text mode in the `tabular`
environment.

```julia
julia> A = Array(Any,(2,2));

julia> A[1,1] = 1; A[1,2] = 3+im; A[2,1]=5//2; A[2,2] = 1/0;

julia> tabular(A)
\begin{tabular}{cc}
$1$ & $3+1i$\\
$\frac{5}{2}$ & $\infty$
\end{tabular}
```

Notice that each entry is encased in dollar signs.

By default, each column is center aligned. This can be modified in
two ways. See the `set_align` function described below or by calling
`tabular` with an optional second argument like this:

```julia
julia> tabular(A,"l|r")
\begin{tabular}{l|r}
$1$ & $3+1i$\\
$\frac{5}{2}$ & $\infty$
\end{tabular}
```


## Customization

### Customizing existing types

The `LatexPrint` module comes with default LaTeX representations for
infinity, not-a-number, and so forth. Some of these can be modified by
the following functions.

* `set_inf` is used to set the representation of infinity. The default
	creates the output `\infty` but here's how it can be changed.
	```julia
	julia> lap(1/0)
	\infty

	julia> set_inf("\\text{inf}")  # note the double backslash
	"\\text{inf}"

	julia> lap(1/0)
	\text{inf}
	```

* `set_nan` is used to set the LaTeX for not-a-number:
  ```
  julia> lap(0/0)
  \text{NaN}

  julia> set_nan("\\text{nan}")
  "\\text{nan}"

  julia> lap(0/0)
  \text{nan}
  ```

* `set_bool` is used to set the LaTeX form of `true` and `false`. By
  default, these output `\textrm{T}` and `\textrm{F}`. This is how
  these can be changed:
  ```julia
  julia> lap(true)
  \mathrm{T}

  julia> set_bool("\\textsf{true}", "\\textsf{false}")
  ("\\textsf{true}","\\textsf{false}")

  julia> lap(true)
  \textsf{true}
  ```

* `set_im` changes the symbol used for the imaginary unit. Some folks
  like *j* instead of *i*:
  ```julia
  julia> z = 3+2im
  3 + 2im

  julia> lap(z)
  3+2i

  julia> set_im("j")
  "j"

  julia> lap(z)
  3+2j
  ```
* `set_emptyset` is used to specify how an empty set should be
  rendered.
  ```julia
  julia> C = Set()
  Set{Any}({})

  julia> lap(C)
  \emptyset

  julia> set_emptyset("\\{ \\}")
  "\\{ \\}"

  julia> lap(C)
  \{ \}
  ```
  Users might like to try `\varnothing` as a nice alternative to
  `\empytset`. In that case, the Julia command would be
  `set_emptyset("\\varnothing")`.

* `set_align` is used to specify the alignment character for
  arrays. By default elements of columns are aligned to their
  center. Use one of `l`, `r`, or `c` as the alignment character.
  ```julia
  julia> lap(A)
  \left[
  \begin{array}{c}
  2 \\
  10 \\
  -544 \\
  \end{array}
  \right]

  julia> set_align("r")

  julia> lap(A)
  \left[
  \begin{array}{r}
  2 \\
  10 \\
  -544 \\
  \end{array}
  \right]
  ```

* `set_delims` is used to specify the left and right delimiters used
  for vectors and matrices.
  ```julia
  julia> A = int(eye(2))
  2x2 Array{Int64,2}:
   1  0
   0  1

  julia> lap(A)
  \left[
  \begin{array}{cc}
  1 & 0 \\
  0 & 1 \\
  \end{array}
  \right]

  julia> set_delims("(", ")")  # set delimiters to be open/close parens
  ("(",")")

  julia> lap(A)
  \left(
  \begin{array}{cc}
  1 & 0 \\
  0 & 1 \\
  \end{array}
  \right)
  ```


### Adding new types

There are other Julia types (such as `UnitRange`) for which
we have not implemented a conversion to LaTeX. In this
case `lap` (and our other functions) simply convert the type
to an `String`.

```julia
julia> lap(1:10)
1:10
```

If we want to create a LaTeX representation, then we
need to define a suitable version of `latex_form` like this:

```julia
julia> import LatexPrint.latex_form

julia> latex_form(x::UnitRange) = "[" * string(x.start) * "," * string(x.stop) * "]"
latex_form (generic function with xxx methods)

julia> lap(1:10)
[1,10]
```

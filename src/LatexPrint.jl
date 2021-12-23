module LatexPrint
export latex_form, laprint, laprintln, lap, tabular

export set_nan, set_inf, set_emptyset, set_delims, set_align
export set_im, set_bool, set_nothing

using Requires

const EOL = " \\\\\n"  # end rows in matrices
const TAB = " & "      # tab for matrices

global NAN = "\\text{NaN}"     # default for NaN
global INF = "\\infty"         # default for infinity
global TRUE = "\\mathrm{T}"    # default for boolean true
global FALSE = "\\mathrm{F}"   # default for boolean false
global IM = "i"                # default for sqrt(-1)

global EMPTYSET = "\\emptyset" # default for empty set
global NOTHING = "\\mathrm{nothing}"  # default for nothing value

global LEFT = "["    # default left delimiter for matrices
global RIGHT = "]"   # default right delimiter
global ALIGN = "c"   # default alignment character

global STD_EOL = "\\\\"
global HLINE_EOL = "\\\\ \\hline"

# The set_xxx functions may take a string or a single character
Ctype = Union{String,Char}

"""
`set_nan(msg)` sets the `latex_print` output for a `NaN` value.
"""
function set_nan(msg::Ctype)
    global NAN = string(msg)
end

"""
`set_nothing(msg)` sets the `latex_print` output for a `nothing` value.
"""
function set_nothing(msg::Ctype)
    global NOTHING = string(msg)
end

"""
`set_inf(msg)` sets the `latex_print` output for infinity.
"""
function set_inf(msg::Ctype)
    global INF = string(msg)
end

"""
`set_emptyset(msg)` sets the `latex_print` output for the empty set.
"""
function set_emptyset(msg::Ctype)
    global EMPTYSET = string(msg)
end

"""
`set_delims(lt,rt)` sets the `latex_print` output for left and right
matrix delimeters.
"""
function set_delims(lt::Ctype, rt::Ctype)
    global LEFT = string(lt)
    global RIGHT = string(rt)
    return (lt,rt)
end

"""
`set_align(ch)` sets the alignment character for matrices. Should
be one of `l`, `r`, or `c`.
"""
function set_align(ch::Ctype)
    global ALIGN = string(ch)
    if length(ALIGN) != 1
        warn("Alignment character should be a single character")
    end
end

"""
`set_im(ch)` sets the output for \$i\$ (square root of -1).
"""
function set_im(i::Ctype)
    global IM = string(i)
end

"""
`set_bool(tmsg, fmsg)` sets the output for the Boolean values
`true` and `false`.
"""
function set_bool(t::Ctype, f::Ctype)
    global TRUE = string(t)
    global FALSE = string(f)
    return (TRUE,FALSE)
end

# The latex_form function is the central workhorse for converting a
# Julia object to a character string (of type String) that can be
# printed (and then pasted into LaTeX mathmode). We create a version
# for each Julia datatype that we might want to render in LaTeX. Users
# can define more (as described in the README document).

# character strings we wrap in "\text"
"""
`latex_form(arg)` writes `arg` to the screen in a form
suitable for pasting into a LaTeX document.
"""
latex_form(words::AbstractString) = "\\text{" * words * "}"

# floating point numbers are passed through, unless NaN or Inf
function latex_form(x::AbstractFloat)
    if isnan(x)
        return NAN
    end
    if isinf(x)
        if x>0
            return INF
        end
        return "-" * INF
    end
    return string(x)
end

# special case for MathConst's
function latex_form(x::Irrational)
    if x==Base.MathConstants.pi
        return "\\pi"
    end

    if x==Base.MathConstants.e
        return "e"
    end

    if x==Base.MathConstants.golden
        return "\\phi"
    end

    if x==Base.MathConstants.eulergamma
        return "\\gamma"
    end

    return latex_form(float(x))  # some math constant we don't know
end

# integers are easy: just convert to string
latex_form(x::Integer) = string(x)

# booleans
latex_form(x::Bool) = x ? TRUE : FALSE

# rational numbers are presented as \frac fractions
function latex_form(q::Rational{T}) where T
    a::T = numerator(q)
    b::T = denominator(q)

    if b==0  # This is some form of infinity
        if a>0
            return INF
        else
            return "-" * INF
        end
    end

    if b==1  # Just print the numerator; it's an integer value
        return latex_form(a)
    end

    return "\\frac{" * latex_form(a) * "}{" * latex_form(b) * "}"
end

# Complex numbers
function latex_form(z::Complex{T}) where T
    if isnan(z)
        return NAN
    end
    if isinf(z)
        return INF
    end

    a,b = reim(z)

    if T == Bool  # Complex{Bool} treated like Complex{Int}
        a = Int(a)
        b = Int(b)
    end

    op = b >= 0 ? "+" : "-"

    return latex_form(a) * op * latex_form(abs(b)) * IM
end

# Sets
function latex_form(A::Union{Set,BitSet})
    if isempty(A)
        return EMPTYSET
    end
    elements = collect(A)
    try
        sort!(elements)
    catch
    end
    n = length(elements)

    result = "\\left\\{"
    for k=1:n
        result *= latex_form(elements[k])
        if k<n
            result *= ","
        else
            result *= "\\right\\}"
        end
    end
    return result
end

# Vectors (1-dimensional arrays)
function latex_form(A::AbstractArray{T,1}) where T
    result = "\\left" * LEFT * "\n\\begin{array}{" * ALIGN * "}\n"
    for x in A
        result *= latex_form(x)*EOL
    end
    result *= "\\end{array}\n\\right" * RIGHT
    return result
end

# Matrices (2-dimensional arrays)
function latex_form(A::AbstractArray{T,2}) where T
    (r,c) = size(A)

    # Header
    result  = "\\left" * LEFT * "\n\\begin{array}{"
    result *= (ALIGN ^ c) * "}\n"

    # Row-by-row
    for a=1:r
        for b=1:c
            result *= latex_form(A[a,b])
            if b<c
                result *= TAB
            else
                result *= EOL
            end
        end
    end

    # close up
    result *= "\\end{array}\n\\right" * RIGHT
    return result
end

# form for a `nothing` value
latex_form(x::Nothing) = NOTHING

# catch all for any types we've not implemented
latex_form(x::Any) = string(x)

# The print functions in all their forms. They simply apply latex_form
# to their argument(s) and pass the resulting string(s) to the
# corresponding version of print.
"""
`laprint(x...)` is like Julia's `print` but converts each
argument using `latex_print`.
"""
 function laprint(x...)
    xs = map(latex_form,x)
    print(xs...)
end

"""
`laprintln(x...)` is like Julia's `print` but converts each
argument using `latex_print`.
"""
function laprintln(x...)
    xs = map(latex_form,x)
    println(xs...)
end

"""
`lap(x...)` is a short version of `laprintln(x...)`.
"""
lap(x...) = laprintln(x...)  # abbreviation

# Same functions, but now with IO option.

function laprint(io::IO, x...)
    xs = map(latex_form,x)
    print(io, xs...)
end

function laprintln(io::IO, x...)
    xs = map(latex_form,x)
    println(io, xs...)
end

lap(io::IO, x...) = laprintln(io, x...)

get_eol(std::Bool) = std ? STD_EOL : HLINE_EOL

"""
`tabular(A)` returns a LaTeX version of the two-dimensional array `A`.
This function takes two optional (named) arguments:
* `alignment` is a `String` giving the LaTeX alignment codes for the columns.
    For example, if `A` is a `2`-by-`3` array, then `"cc|r"` would specify that the
    first two columns are centered, then a vertical bar,
    and then the third column is right justified. Default
    is that all columns are `c` unless this default is changed by `set_align()`.
* `hlines` is a `Bool` for controlling the addition of `\\hline` at the end of
    every row (except the last row). This is `false` by default.
"""
function tabular(A::AbstractArray{T,2}; alignment::String="", hlines::Bool=false) where T
    eol = get_eol(!hlines)
    (r,c) = size(A)

    if length(alignment)==0
        alignment = ALIGN^c
    end

    println("\\begin{tabular}{", alignment, "}")
    for a=1:r
        for b=1:c
            print("\$",latex_form(A[a,b]),"\$")
            if b<c
                print(" & ")
            else
                if a<r
                    println(eol)
                end
            end
        end
    end
    println("\n\\end{tabular}")
end

function __init__()
    @require DataFrames="a93c6f00-e57d-5684-b7b6-d8193f3e46c0" include("tabular_dataframes.jl")
    @require Measurements="eff96d63-e80a-5855-80a2-b1b0885c5ab7" begin
        using .Measurements: Measurement
        latex_form(x::Measurement) = latex_form(x.val) * "\\pm " * latex_form(x.err)
    end
end

end # end of module LatexPrint

module LatexPrint

export latex_form, laprint, laprintln, lap

export set_nan, set_inf, set_emptyset, set_delims, set_align
export set_im, set_bool

const EOL = " \\\\\n"  # end rows in matrices
const TAB = " & "      # tab for matrices

global NAN = "\\text{NaN}"     # default for NaN
global INF = "\\infty"         # default for infinity
global TRUE = "\\mathrm{T}"    # default for boolean true
global FALSE = "\\mathrm{F}"   # default for boolean false
global IM = "i"                # default for sqrt(-1)

global EMPTYSET = "\\emptyset" # default for empty set

global LEFT = "["    # default left delimiter for matrices
global RIGHT = "]"   # default right delimiter
global ALIGN = "c"   # default alignment character

# The set_xxx functions may take a string or a single character
Ctype = Union(ASCIIString,Char)

function set_nan(msg::Ctype)
    global NAN = string(msg)
end

function set_inf(msg::Ctype)
    global INF = string(msg)
end

function set_emptyset(msg::Ctype)
    global EMPTYSET = string(msg)
end

function set_delims(lt::Ctype, rt::Ctype)
    global LEFT = string(lt)
    global RIGHT = string(rt)
    return (lt,rt)
end

function set_align(ch::Ctype)
    global ALIGN = string(ch)
    if length(ALIGN) != 1
        warn("Alignment character should be a single character")
    end
end

function set_im(i::Ctype)
    global IM = string(i)
end

function set_bool(t::Ctype, f::Ctype)
    global TRUE = string(t)
    global FALSE = string(f)
    return (TRUE,FALSE)
end

# The latex_form function is the central workhorse for converting a
# Julia object to a character string (of type ASCIIString) that can be
# printed (and then pasted into LaTeX mathmode). We create a version
# for each Julia datatype that we might want to render in LaTeX. Users
# can define more (as described in the README document).

# character strings we wrap in "\text"
latex_form(words::String) = "\\text{" * words * "}"

# floating point numbers are passed through, unless NaN or Inf
function latex_form(x::FloatingPoint)
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
function latex_form(x::MathConst)
    if x==pi
        return "\\pi"
    end

    if x==e
        return "e"
    end

    if x==golden
        return "\\phi"
    end

    if x==eulergamma
        return "\\gamma"
    end

    return latex_form(float(x))  # some math constant we don't know 
end

# integers are easy: just convert to string
latex_form(x::Integer) = string(x)

# booleans
latex_form(x::Bool) = x ? TRUE : FALSE

# rational numbers are presented as \frac fractions
function latex_form{T}(q::Rational{T})
    a::T = num(q)
    b::T = den(q)

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
function latex_form{T}(z::Complex{T})
    if isnan(z)
        return NAN
    end
    if isinf(z)
        return INF
    end

    a,b = reim(z)

    if T == Bool  # Complex{Bool} treated like Complex{Int}
        a = int(a)
        b = int(b)
    end

    op = b >= 0 ? "+" : "-"

    return latex_form(a) * op * latex_form(abs(b)) * IM
end

# Sets
function latex_form(A::Union(Set,IntSet))
    if isempty(A)
        return EMPTYSET
    end
    elements = collect(A)
    try
        sort!(elements)
    end
    n = length(elements)

    result = "\\{"
    for k=1:n
        result *= latex_form(elements[k])
        if k<n
            result *= ","
        else
            result *= "\\}"
        end
    end
    return result
end

# Vectors (1-dimensional arrays)
function latex_form{T}(A::Array{T,1})
    result = "\\left" * LEFT * "\n\\begin{array}{" * ALIGN * "}\n"
    for x in A
        result *= latex_form(x)*EOL
    end
    result *= "\\end{array}\n\\right" * RIGHT 
    return result
end

# Matrices (2-dimensional arrays)
function latex_form{T}(A::Array{T,2})
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
    
# catch all for any types we've not implemented
latex_form(x::Any) = string(x)

# The print functions in all their forms. They simply apply latex_form
# to their argument(s) and pass the resulting string(s) to the
# corresponding version of print.

function laprint(x...)
    xs = map(latex_form,x)
    print(xs...)
end

function laprintln(x...)
    xs = map(latex_form,x)
    println(xs...)
end

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

end # end of module LatexPrint

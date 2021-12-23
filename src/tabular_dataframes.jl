import .DataFrames.DataFrame


function tabular(io::IO, A::DataFrame; alignment::String="", rounding::Int = 0)
    (r,c) = size(A)

    if length(alignment)==0
        alignment = ALIGN^c
    end

    println(io, "\\begin{tabular}{", alignment, "}")
    println(io, "\\hline")
    for (i,name) in enumerate(names(A))
        print(io, name)
        if i < length(names(A))
            print(io, " & ")
        end
    end
    println(io, get_eol(false))
    println(io, "\\hline")
    for a=1:r
        for b=1:c
            print(io, "\$",latex_form((rounding > 0) && typeof(A[a,b])<:Number ? round(A[a,b],rounding) : A[a,b]),"\$")
            if b<c
                print(io, " & ")
            else
                if a<r
                    println(io, "\\\\")
                end
            end
        end
    end
    println(io, "\n\\end{tabular}")
end

tabular(A::DataFrame; kwargs...) = tabular(stdout, A; kwargs...)

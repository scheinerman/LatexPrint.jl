import DataFrames.DataFrame


function tabular(A::DataFrame; alignment::String="", rounding::Int = 0)
    (r,c) = size(A)

    if length(alignment)==0
        alignment = ALIGN^c
    end

    println("\\begin{tabular}{", alignment, "}")
    println("\\hline")
    for (i,name) in enumerate(names(A))
        print(name)
        if i < length(names(A))
            print(" & ")
        end
    end
    println(line_end)
    println("\\hline")
    for a=1:r
        for b=1:c
            print("\$",latex_form((rounding > 0) && typeof(A[a,b])<:Number ? round(A[a,b],rounding) : A[a,b]),"\$")
            if b<c
                print(" & ")
            else
                if a<r
                    println("\\\\")
                end
            end
        end
    end
    println("\n\\end{tabular}")
end

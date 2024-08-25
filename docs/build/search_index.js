var documenterSearchIndex = {"docs":
[{"location":"#LatexPrint","page":"LatexPrint","title":"LatexPrint","text":"","category":"section"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"Print Julia objects in LaTeX form.","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"Instead of seeing 1//3 in your document, you get to have frac13. ","category":"page"},{"location":"#Key-Functions","page":"LatexPrint","title":"Key Functions","text":"","category":"section"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"This module provides functions for converting Julia objects into string representations for use in LaTeX mathematics mode. The primary function is laprintln which behaves precisely like println except Julia objects are first converted to a form suitable for LaTeX. Because laprintln is a lot to type, we also provide the abbreviation lap.","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"julia> using LatexPrint\n\njulia> x = 2//6\n1//3\n\njulia> lap(x)\n\\frac{1}{3}","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"We also provide the function laprint which does not append a new line (just like print).","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"These functions rely on latex_form which converts a Julia object into an String representation in its LaTeX form:","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"julia> latex_form(x)\n\"\\\\frac{1}{3}\"","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"The double backslash in the output of latex_form is converted to a single backslash when run through a print function.","category":"page"},{"location":"#Numbers","page":"LatexPrint","title":"Numbers","text":"","category":"section"},{"location":"#Integers-and-floating-point-numbers","page":"LatexPrint","title":"Integers and floating point numbers","text":"","category":"section"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"FloatingPoint and Integer numbers are printed unchanged.","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"julia> lap(sqrt(2))\n1.4142135623730951\n\njulia> lap(23)\n23","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"However, infinite and invalid values are printed as follows:","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"julia> lap(1/0)\n\\infty\n\njulia> lap(-1/0)\n-\\infty\n\njulia> lap(0/0)\n\\text{NaN}","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"Julia's MathConst numbers are printed using their expected LaTeX form:","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"julia> lap(pi)\n\\pi","category":"page"},{"location":"#Rational-numbers","page":"LatexPrint","title":"Rational numbers","text":"","category":"section"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"Rational numbers are printed as fractions (unless the denominator happens to be 1, in which case we print as an integer).","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"julia> lap(10//4)\n\\frac{5}{2}\n\njulia> lap(10//2)\n5","category":"page"},{"location":"#Complex-numbers","page":"LatexPrint","title":"Complex numbers","text":"","category":"section"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"Complex numbers always include a real and an imaginary part, even if either part equals zero:","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"julia> z = 1+im\n1 + 1im\n\njulia> lap(z)\n1+1i\n\njulia> lap(z*z)\n0+2i\n\njulia> lap(im^im)\n0.20787957635076193+0.0i","category":"page"},{"location":"#Boolean-Values","page":"LatexPrint","title":"Boolean Values","text":"","category":"section"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"The Bool values true and false output like this:","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"julia> lap(true)\n\\mathrm{T}\n\njulia> lap(false)\n\\mathrm{F}","category":"page"},{"location":"#nothing","page":"LatexPrint","title":"nothing","text":"","category":"section"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"A nothing value is rendered as \\mathrm{nothing}.","category":"page"},{"location":"#Text","page":"LatexPrint","title":"Text","text":"","category":"section"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"The LaTeX version of an String is wrapped in the command \\text (which requires the amsmath package in LaTeX). The rationale is that we always want to able to paste the output of lap directly into mathematics mode in LaTeX.","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"julia> lap(\"Hello, world!\")\n\\text{Hello, world!}","category":"page"},{"location":"#Arrays","page":"LatexPrint","title":"Arrays","text":"","category":"section"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"Vectors (one-dimensional arrays) and matrices (two-dimensional arrays) are converted into LaTeX array environments bounded by square brackets with centering alignment. (These default options can be changed; see \"Customizing existing types\" later in this document.)","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"julia> x = [1,2,3]\n3-element Array{Int64,1}:\n 1\n 2\n 3\n\njulia> lap(x)\n\\left[\n\\begin{array}{c}\n1 \\\\\n2 \\\\\n3 \\\\\n\\end{array}\n\\right]\n\njulia> A = eye(3)\n3x3 Array{Float64,2}:\n 1.0  0.0  0.0\n 0.0  1.0  0.0\n 0.0  0.0  1.0\n\njulia> lap(A)\n\\left[\n\\begin{array}{ccc}\n1.0 & 0.0 & 0.0 \\\\\n0.0 & 1.0 & 0.0 \\\\\n0.0 & 0.0 & 1.0 \\\\\n\\end{array}\n\\right]","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"Vectors are, by default, rendered as a column. To typeset a vector as a row, simply take its transpose:","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"julia> x = [2//3, 4//3, 6//3]\n3-element Array{Rational{Int64},1}:\n 2//3\n 4//3\n 2//1\n\njulia> lap(x')\n\\left[\n\\begin{array}{ccc}\n\\frac{2}{3} & \\frac{4}{3} & 2 \\\\\n\\end{array}\n\\right]","category":"page"},{"location":"#Sets","page":"LatexPrint","title":"Sets","text":"","category":"section"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"Julia Set and IntSet objects are rendered as a comma separated list between curly braces. The elements are sorted into ascending order (if possible). An empty set is returned as \\emptyset (unless another form is specified using set_empty).","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"julia> A = Set({3.5, 2, -5})\nSet{Any}({2,-5,3.5})\n\njulia> lap(A)\n\\left\\{-5,2,3.5\\right\\}\n\njulia> B = IntSet(4,5,1)\nIntSet([1, 4, 5])\n\njulia> lap(B)\n\\left\\{1,4,5\\right\\}\n\njulia> C = Set()\nSet{Any}({})\n\njulia> lap(C)\n\\emptyset","category":"page"},{"location":"#The-tabular-Function","page":"LatexPrint","title":"The tabular Function","text":"","category":"section"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"If A is a matrix (two-dimensional array), then laprintln(A) (or lap(A)) prints the LaTeX code for that matrix (complete with bounding delimeters) for inclusion in LaTeX's mathematics mode.","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"As an alternative, we also provide the function tabular that prints the array for inclusion in LaTeX's text mode in the tabular environment.","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"julia> A = Array{Any}(nothing,2,2);\n\njulia> A[1,1] = 1; A[1,2] = 3+im; A[2,1]=5//2; A[2,2] = 1/0;\n\njulia> tabular(A)\n\\begin{tabular}{cc}\n$1$ & $3+1i$\\\\\n$\\frac{5}{2}$ & $\\infty$\n\\end{tabular}","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"Notice that each entry is encased in dollar signs.","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"By default, each column is center aligned. This can be modified in two ways. See the set_align function described below or by calling tabular with the named alignment argument, like this:","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"julia> tabular(A,alignment=\"l|r\")\n\\begin{tabular}{l|r}\n$1$ & $3+1i$\\\\\n$\\frac{5}{2}$ & $\\infty$\n\\end{tabular}","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"In addition, the end-of-line command \\\\ can be changed to \\\\ \\hline (so LaTeX inserts a horizontal line between rows) by means of the named hlines argument:","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"julia> tabular(A,hlines=true)\n\\begin{tabular}{cc}\n$1$ & $3+1i$\\\\ \\hline\n$\\frac{5}{2}$ & $\\infty$\n\\end{tabular}","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"Note that the last row of the array does not include an \\hline.","category":"page"},{"location":"#Customization","page":"LatexPrint","title":"Customization","text":"","category":"section"},{"location":"#Customizing-existing-types","page":"LatexPrint","title":"Customizing existing types","text":"","category":"section"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"The LatexPrint module comes with default LaTeX representations for infinity, not-a-number, and so forth. Some of these can be modified by the following functions.","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"set_inf is used to set the representation of infinity. The default","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"creates the output `\\infty` but here's how it can be changed.\n```\njulia> lap(1/0)\n\\infty\n\njulia> set_inf(\"\\\\text{inf}\")  # note the double backslash\n\"\\\\text{inf}\"\n\njulia> lap(1/0)\n\\text{inf}\n```","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"set_nan is used to set the LaTeX for not-a-number:\njulia> lap(0/0)\n\\text{NaN}\n\njulia> set_nan(\"\\\\text{nan}\")\n\"\\\\text{nan}\"\n\njulia> lap(0/0)\n\\text{nan}\nset_bool is used to set the LaTeX form of true and false. By default, these output \\textrm{T} and \\textrm{F}. This is how these can be changed:\njulia> lap(true)\n\\mathrm{T}\n\njulia> set_bool(\"\\\\textsf{true}\", \"\\\\textsf{false}\")\n(\"\\\\textsf{true}\",\"\\\\textsf{false}\")\n\njulia> lap(true)\n\\textsf{true}\nset_im changes the symbol used for the imaginary unit. Some folks like j instead of i:\njulia> z = 3+2im\n3 + 2im\n\njulia> lap(z)\n3+2i\n\njulia> set_im(\"j\")\n\"j\"\n\njulia> lap(z)\n3+2j\nset_emptyset is used to specify how an empty set should be rendered.\njulia> C = Set()\nSet{Any}({})\n\njulia> lap(C)\n\\emptyset\n\njulia> set_emptyset(\"\\\\{ \\\\}\")\n\"\\\\{ \\\\}\"\n\njulia> lap(C)\n\\{ \\}\nUsers might like to try \\varnothing as a nice alternative to \\empytset. In that case, the Julia command would be set_emptyset(\"\\\\varnothing\").\nset_align is used to specify the alignment character for arrays. By default elements of columns are aligned to their center. Use one of l, r, or c as the alignment character.\njulia> lap(A)\n\\left[\n\\begin{array}{c}\n2 \\\\\n10 \\\\\n-544 \\\\\n\\end{array}\n\\right]\n\njulia> set_align(\"r\")\n\njulia> lap(A)\n\\left[\n\\begin{array}{r}\n2 \\\\\n10 \\\\\n-544 \\\\\n\\end{array}\n\\right]\nset_delims is used to specify the left and right delimiters used for vectors and matrices.\njulia> A = int(eye(2))\n2x2 Array{Int64,2}:\n 1  0\n 0  1\n\njulia> lap(A)\n\\left[\n\\begin{array}{cc}\n1 & 0 \\\\\n0 & 1 \\\\\n\\end{array}\n\\right]\n\njulia> set_delims(\"(\", \")\")  # set delimiters to be open/close parens\n(\"(\",\")\")\n\njulia> lap(A)\n\\left(\n\\begin{array}{cc}\n1 & 0 \\\\\n0 & 1 \\\\\n\\end{array}\n\\right)\nset_nothing is used to specify the output of a nothing value. For example, to output an em-dash, we can do this:\njulia> lap(nothing)\n\\mathrm{nothing}\n\njulia> set_nothing(\"\\\\mathrm{---}\")\n\"\\\\mathrm{---}\"\n\njulia> lap(nothing)\n\\mathrm{---}","category":"page"},{"location":"#Adding-new-types","page":"LatexPrint","title":"Adding new types","text":"","category":"section"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"There are other Julia types (such as UnitRange) for which we have not implemented a conversion to LaTeX. In this case lap (and our other functions) simply convert the type to an String.","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"julia> lap(1:10)\n1:10","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"If we want to create a LaTeX representation, then we need to define a suitable version of latex_form like this:","category":"page"},{"location":"","page":"LatexPrint","title":"LatexPrint","text":"julia> import LatexPrint.latex_form\n\njulia> latex_form(x::UnitRange) = \"[\" * string(x.start) * \",\" * string(x.stop) * \"]\"\nlatex_form (generic function with xxx methods)\n\njulia> lap(1:10)\n[1,10]","category":"page"}]
}
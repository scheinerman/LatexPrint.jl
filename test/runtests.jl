using Test
using LatexPrint
using Measurements

@test latex_form(-5) == "-5"
@test latex_form(2.2) == "2.2"
@test latex_form("Hello") == "\\text{Hello}"
@test latex_form(-3//5) == "\\frac{-3}{5}"
@test latex_form(im) == "0+1i"
@test latex_form(1/0) == "\\infty"
@test latex_form(0/0) == "\\text{NaN}"
@test latex_form(pi) == "\\pi"
@test latex_form([1,2]) == "\\left[\n\\begin{array}{c}\n1 \\\\\n2 \\\\\n\\end{array}\n\\right]"
@test latex_form([1,2]') == "\\left[\n\\begin{array}{cc}\n1 & 2 \\\\\n\\end{array}\n\\right]"
@test latex_form(pi) == "\\pi"
@test latex_form(Set(1:4)) == "\\left\\{1,2,3,4\\right\\}"
@test latex_form(true) == "\\mathrm{T}"
@test latex_form(nothing) == "\\mathrm{nothing}"
@test latex_form(7.0±2.0) == "7.0\\pm 2.0"

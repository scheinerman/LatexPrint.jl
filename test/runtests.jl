using Base.Test
using LatexPrint

x = -3//5
@test latex_form(x) == "\\frac{-3}{5}"


using SixSteps: Permutation, Pairs
using Test

span((a,b)) = abs(a-b)

function orderedelements(pairs::Pairs{T}) where T
    elements = Vector{T}(undef, 2length(pairs))
    for (i,p) in enumerate(pairs)
        elements[2i-1] = first(p)
        elements[2i] = last(p)
    end
    sort!(elements)
end

@testset "Condition #1, n=$n" for n=2:12
    @test orderedelements(Pairs(n)) == repeat(1:n, inner=2)
end

@testset "Condition #2, n=$n" for n=2:12
    @test maximum(span.(Pairs(n))) == n-1
end

@testset "Condition #3, n=$n" for n=2:12
    @test minimum(span.(Pairs(n))) == max(1, n ÷ 3)
end
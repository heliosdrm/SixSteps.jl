module SixSteps

"""
    Permutation(n::Integer)

Create an iterator over the permutation of the integers
between 1 and `n` using the "six-steps" algorithm.
"""
struct Permutation{T<:Integer}
    N::T
    H::T
    
    function Permutation(n::T) where T
        new{T}(n, n - n>>1)
    end
end

function g(p::Permutation{T}, d, r) where T
    return (r === 0 ? p.H + T(d) :
            r === 1 ? T(2d + 1)        :
            r === 2 ? p.N - T(2d)     :
            r === 3 ? p.H - T(d) :
            r === 4 ? p.N - T(2d + 1) :
                      T(2d + 2)
    )
end

function Base.iterate(p::Permutation{T}, state=(0,1)) where T
    d, r = state
    (6d+r > p.N) && return nothing
    value = g(p, d, r)
    state = (r===5) ? (d+1, 0) : (d,r+1)
    return value, state
end

Base.length(p::Permutation) = p.N
Base.eltype(::Permutation{T}) where T = T

function Base.last(p::Permutation{T})::T where T
    d, r = divrem(p.N, 6)
    return convert(T, g(p, d, r))
end

"""
    Pairs(x)

If `x` is an integer number, create an iterator over
the pairs containing the between 1 and `x`.
If it is a `SixSteps.Permutation`, create
an iterator over its sequential pairs.
"""
struct Pairs{T<:Integer}
    permutation::Permutation{T}
end

Pairs(n::Integer) = Pairs(Permutation(n))

Base.length(prs::Pairs) = length(prs.permutation)
Base.eltype(::Pairs{T}) where T = Tuple{T,T}
Base.last(prs::Pairs) = (last(prs.permutation), first(prs.permutation))

function Base.iterate(prs::Pairs, args...)
    ls = prs.permutation
    thisit = iterate(ls, args...)
    (thisit === nothing) && return nothing
    value, state = thisit
    d, r = state
    (6d+r > ls.N) && return ((value, first(ls)), state)
    nextvalue, _ = iterate(ls, state)
    return ((value, nextvalue), state)
end

end # module

module LatticeTest

using Test
using Elsa
using Elsa: nsites, nlinks

@test Bravais() isa Bravais{Float64,0,0,0}
@test Bravais((1,2),(3,3)) isa Bravais{Int64,2,2,4}
@test Bravais([1.,2.],[3,3]) isa Bravais{Float64,2,2,4}
@test Bravais([1.,2.], @SVector [3,3]) isa Bravais{Float64,2,2,4}
@test Bravais(@SMatrix [1. 2.; 3 3]) isa Bravais{Float64,2,2,4}

@test Bravais(Float32) isa Bravais{Float32,0,0,0}
@test Bravais(Float32, (1,2),(3,3)) isa Bravais{Float32,2,2,4}
@test Bravais(Float32, [1.,2.],[3.,3]) isa Bravais{Float32,2,2,4}
@test Bravais(Float32, [1.,2.], @SVector [3,3]) isa Bravais{Float32,2,2,4}
@test Bravais(Float32, @SMatrix [1. 2.; 3 3]) isa Bravais{Float32,2,2,4}

@test Bravais(Float32[1.,2.], @SVector [3f0,3f0]) isa Bravais{Float32,2,2,4}

@test Sublat() isa Sublat{Float64,0}
@test Sublat((3,3)) isa Sublat{Int64,2}
@test Sublat((3,3.)) isa Sublat{Float64,2}
@test Sublat([3,3.]) isa Sublat{Float64,2}
@test Sublat(@SVector[3,3]) isa Sublat{Int64,2}
@test Sublat(@SVector[3.,3]) isa Sublat{Float64,2}
@test Sublat(@SVector[3.,3], (3,3)) isa Sublat{Float64,2}
@test Sublat([3,4.], [3,3]) isa Sublat{Float64,2}
@test Sublat((3,4.), [3,3]) isa Sublat{Float64,2}
@test Sublat(@SVector[3f0,3f0]) isa Sublat{Float32,2}

@test Sublat(Float32, ) isa Sublat{Float32,0}
@test Sublat(Float32, (3,3)) isa Sublat{Float32,2}
@test Sublat(Float32, (3,3.)) isa Sublat{Float32,2}
@test Sublat(Float32, [3,3.]) isa Sublat{Float32,2}
@test Sublat(Float32, @SVector[3,3]) isa Sublat{Float32,2}
@test Sublat(Float32, @SVector[3.,3]) isa Sublat{Float32,2}
@test Sublat(Float32, @SVector[3.,3], (3,3)) isa Sublat{Float32,2}
@test Sublat(Float32, [3,4.], [3,3]) isa Sublat{Float32,2}
@test Sublat(Float32, (3,4.), [3,3]) isa Sublat{Float32,2}
@test Sublat(Float64, @SVector[3f0,3f0]) isa Sublat{Float64,2}

@test Sublat(:A, @SVector[3f0,3f0], (3,4)) isa Sublat{Float32,2}
@test Sublat(Float64, :A, (3f0,3)) isa Sublat{Float64,2}

@test Lattice(:honeycomb, Dim(3), Precision(Float32)) isa Lattice{Float32,3,2}
@test Elsa.nsites(Lattice(:honeycomb, Region(:square, 300))) == 207946
@test Elsa.nsites(Lattice(:square, Supercell(31))) == 961
@test Elsa.nsites(Lattice(:bcc, Region(:spheroid, (10,4,4)))) == 1365

@test Elsa.nlinks(Lattice(:honeycomb, LinkRule(1/√3), Region(:square, 300))) == 311273
@test Elsa.nlinks(Lattice(:square, Supercell(31), LinkRule(2))) == 6074
@test Elsa.nlinks(Lattice(:square, LinkRule(2), Supercell(31))) == 6074
@test Elsa.nlinks(Lattice(:bcc, LinkRule(1), Region(:spheroid, (10,4,4)))) == 8216

@test LinkRule(1.2, 1, (2,3)) isa LinkRule{Elsa.AutomaticRangeLinking,Tuple{Tuple{Int64,Int64},Tuple{Int64,Int64}}}
@test LinkRule(1, sublats = (1, (2, 3))).sublats == ((1, 1), (2, 3))

@test begin
    lat1 = Lattice(:honeycomb, LinkRule(1/sqrt(3)), Region(:circle, 7))
    lat2 = Lattice(:square, LinkRule(2), Region(:circle, 6))
    lat3 = combine(lat1, lat2)
    (nlinks(lat3) == nlinks(lat1) + nlinks(lat2)) &&
    (nsites(lat3) == nsites(lat1) + nsites(lat2))
end

@test begin
    lat1 = Lattice(:honeycomb, LinkRule(1/sqrt(3)))
    lat2 = combine(lat1, lat1)
    transform!(lat1, r -> 2r)
    isapprox(lat1.sublats[1].sites[1], 2 * lat2.sublats[1].sites[1])
end

@test Elsa.nlinks(wrap(Lattice(:square, LinkRule(√2), Supercell(2)), exceptaxes = (1,))) == 14
@test Elsa.nlinks(wrap(Lattice(:square, LinkRule(√2), Supercell(2)), exceptaxes = (2,))) == 14
@test Elsa.nlinks(wrap(Lattice(:square, LinkRule(√2), Supercell(2)))) == 6

@test begin
    lat = mergesublats(Lattice(Preset(:honeycomb_bilayer, twistindex = 2)), (2,1,1,1))
    Elsa.nlinks(lat) == 32 && Elsa.nsublats(lat) == 2
end

end # module

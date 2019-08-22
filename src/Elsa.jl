module Elsa

using StaticArrays, NearestNeighbors, SparseArrays, LinearAlgebra, OffsetArrays,
      FFTW, ProgressMeter, Arpack

import Base: convert, iterate, ==
import SparseArrays: sparse!

export Sublat, Bravais, Lattice, System, Model, Hopping, Onsite,
       grow, combine, transform, transform!, hamiltonian, bound,
       sitepositions, neighbors, bravaismatrix, marchingmesh
export MomentaKPM, dosKPM
export LatticePresets, SystemPresets, RegionPresets

export @SMatrix, @SVector, SMatrix, SVector

# const NameType = String
# const nametype = string
const NameType = Symbol
const nametype = Symbol

include("presets.jl")
include("model.jl")
include("lattice.jl")
include("operators.jl")
include("system.jl")
include("iterators.jl")
include("system_methods.jl")
include("KPM.jl")
include("mesh.jl")
include("bandstructure.jl")
include("convert.jl")
include("tools.jl")

end

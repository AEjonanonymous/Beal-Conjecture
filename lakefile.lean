import Lake
open Lake DSL

package "beal-conjecture"

@[default_target]
lean_lib «Beal_Symmetry_Collision»

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.29.0"

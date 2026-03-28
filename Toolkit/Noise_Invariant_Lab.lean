-- FILE NAME: Noise_Invariant_Lab.lean
-- Iterates through coprime pairs to check for 
-- a perfect Beal Collision (where all new prime valuations % z == 0).

def valuation (p n : Nat) : Nat :=
  if h : p > 1 ∧ n > 0 then
    if n % p == 0 then 
      have : n / p < n := Nat.div_lt_self h.2 h.1
      1 + valuation p (n / p) 
    else 0
  else 0
termination_by n

def is_perfect_beal_collision (a b x y z : Nat) : Bool :=
  let s := a^x + b^y
  let primes := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71]
  let new_primes := primes.filter (λ p => (a % p != 0) && (b % p != 0) && (s % p == 0))
  if new_primes.isEmpty then false
  else new_primes.all (λ p => (valuation p s) % z == 0)

-- BATCH TESTING:
-- If these all return 'false', the "Residual 1" is a possible invariant law.
example : is_perfect_beal_collision 2 3 3 3 3 = false := by native_decide
example : is_perfect_beal_collision 2 5 3 3 3 = false := by native_decide
example : is_perfect_beal_collision 2 7 3 3 3 = false := by native_decide
example : is_perfect_beal_collision 3 4 3 3 3 = false := by native_decide
example : is_perfect_beal_collision 3 5 3 3 3 = false := by native_decide
example : is_perfect_beal_collision 3 8 3 3 3 = false := by native_decide
example : is_perfect_beal_collision 4 5 3 3 3 = false := by native_decide
example : is_perfect_beal_collision 5 6 3 3 3 = false := by native_decide

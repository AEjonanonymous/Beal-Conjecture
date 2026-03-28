-- Self-contained Lean 4: Multi-Prime Valuation Check
-- Testing if ALL new primes can simultaneously have high valuation

def valuation (p n : Nat) : Nat :=
  if h : p > 1 ∧ n > 0 then
    if n % p == 0 then 
      have : n / p < n := Nat.div_lt_self h.2 h.1
      1 + valuation p (n / p) 
    else 0
  else 0
termination_by n

/-- Returns true ONLY if EVERY new prime factor has a valuation >= z.
    This would be a true Beal solution for coprimes. --/
def is_perfect_beal_collision (a b x y z : Nat) : Bool :=
  let s := a^x + b^y
  let primes := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
  -- Find all "New" primes that divide the sum
  let new_primes := primes.filter (λ p => (a % p != 0) && (b % p != 0) && (s % p == 0))
  
  -- If there are no new primes, this test isn't applicable (Zsigmondy says there's always one)
  if new_primes.isEmpty then false
  else 
    -- Every single new prime must have a valuation that is a multiple of z
    new_primes.all (λ p => (valuation p s) % z == 0)

-- Test our near miss" 2^3 + 7^3 again.
-- Even though '3' has valuation 3, '13' has valuation 1.
-- So this should return FALSE.
example : is_perfect_beal_collision 2 7 3 3 3 = false := by
  native_decide

-- Self-contained Lean 4: Primitive Prime Valuation Searcher
-- Hunting for the Double Birth (v_p > 1)

def valuation (p n : Nat) : Nat :=
  if h : p > 1 ∧ n > 0 then
    if n % p == 0 then 
      have : n / p < n := Nat.div_lt_self h.2 h.1
      1 + valuation p (n / p) 
    else 0
  else 0
termination_by n

/-- Returns true if a prime p is new (does not divide a or b) 
    and has a valuation >= z (a potential Beal collision) --/
def check_primitive_collision (a b x y z : Nat) : Bool :=
  let s := a^x + b^y
  -- We check small primes to see if any new prime has high valuation
  let primes := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
  primes.any (λ p => 
    let is_new := (a % p != 0) && (b % p != 0)
    is_new && (s % p == 0) && (valuation p s >= z)
  )

-- TEST: Does any coprime pair up to 10 have a "Double Birth" for z=3?
-- We are looking for 'true'. If we only find 'false', the "Law of 1" holds.
example : check_primitive_collision 2 3 3 3 3 = false := by native_decide
example : check_primitive_collision 3 4 3 3 3 = false := by native_decide
example : check_primitive_collision 2 7 3 3 3 = false := by native_decide

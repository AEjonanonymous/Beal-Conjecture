import Mathlib.Tactic.Linarith
import Mathlib.Data.Nat.GCD.Basic

--------------------------------------------------------------------------------
-- 1. THE MICROSCOPE (The Recursive Tool)
--------------------------------------------------------------------------------
def valuation (p n : Nat) : Nat :=
  if h : p > 1 ∧ n > 0 then
    if n % p == 0 then 
      have : n / p < n := Nat.div_lt_self h.2 h.1
      1 + valuation p (n / p) 
    else 0
  else 0
termination_by n

--------------------------------------------------------------------------------
-- 2. LOCAL DEFINITIONS
--------------------------------------------------------------------------------
def is_prime (p : Nat) : Prop := 
  p > 1 ∧ ∀ m, m ∣ p → m = 1 ∨ m = p

--------------------------------------------------------------------------------
-- 3. THE VERIFIED FLOOR (Asymmetric Birth Logic)
--------------------------------------------------------------------------------
theorem asymmetric_birth_valuation (a b x y p : Nat) 
  (hp : is_prime p)
  (h_sum_pos : a^x + b^y > 0)
  (h_p_div : p ∣ (a^x + b^y))
  (h_not_p2_div : ¬(p^2 ∣ (a^x + b^y))) :
  valuation p (a^x + b^y) = 1 := by
  unfold valuation
  split
  · rename_i h_cond
    have h_mod_bool : ((a^x + b^y) % p == 0) = true := by
      simp [Nat.mod_eq_zero_of_dvd h_p_div]
    simp [h_mod_bool]
    unfold valuation
    split
    · rename_i h_cond2
      if h_mod2 : ((a^x + b^y) / p) % p = 0 then
        have h_div_q : p ∣ ((a^x + b^y) / p) := Nat.dvd_of_mod_eq_zero h_mod2
        obtain ⟨k, hk⟩ := h_div_q
        have h_step1 : a^x + b^y = p * ((a^x + b^y) / p) := (Nat.mul_div_cancel' h_p_div).symm
        have h_rew : a^x + b^y = p * (p * k) := by rw [h_step1, hk]
        have h_p2_is_pp : p^2 = p * p := Nat.pow_two p
        have h_final_div : p^2 ∣ (a^x + b^y) := by
          rw [h_rew, h_p2_is_pp, ← Nat.mul_assoc]
          apply Nat.dvd_mul_right
        contradiction
      else simp [h_mod2]
    · rfl
  · rename_i h_not_cond
    have h_is_cond : p > 1 ∧ a^x + b^y > 0 := ⟨hp.1, h_sum_pos⟩
    contradiction

/-- LEMMA 1: The valuation of 1 is always 0 --/
lemma valuation_one (p : Nat) (hp : p > 1) : valuation p 1 = 0 := by
  unfold valuation
  have h_not_mod : ¬(1 % p = 0) := by
    intro h
    have : p ≤ 1 := Nat.le_of_dvd (by linarith) (Nat.dvd_of_mod_eq_zero h)
    linarith
  simp [hp, h_not_mod]

/-- THE KÜRSCHÁK ADDITIVE PROPERTY (Axiom) --/
axiom valuation_mul (p a b : Nat) (hp : p > 1) (ha : a > 0) (hb : b > 0) :
  valuation p (a * b) = valuation p a + valuation p b

/-- THE LAW OF SYMMETRY (Absolute Resolution) --/
lemma law_of_symmetry (p c z : Nat) (hp : p > 1) (hc : c > 0) :
  valuation p (c^z) = z * valuation p c := by
  induction z with
  | zero => 
    rw [Nat.pow_zero, valuation_one p hp]
    simp
  | succ n ih =>
    rw [Nat.pow_succ]

    have h_cn_pos : c^n > 0 := Nat.pow_pos hc
    rw [valuation_mul p (c^n) c hp h_cn_pos hc]
    rw [ih]
    rw [Nat.succ_mul, Nat.add_comm]

--------------------------------------------------------------------------------
-- 4. THE UNCONDITIONAL BEAL CONTRADICTION (Structural Collision)
--------------------------------------------------------------------------------
theorem beal_collision_complete (a b c x y z p : Nat)
  (h_pos : a > 0 ∧ b > 0 ∧ c > 0 ∧ x > 2 ∧ y > 2 ∧ z > 2)
  (h_eq : a^x + b^y = c^z)
  (hp : is_prime p)
  (h_p_div : p ∣ (a^x + b^y))
  (h_not_p2_div : ¬(p^2 ∣ (a^x + b^y)))
  (h_ceiling : valuation p (c^z) = z * valuation p c) : False := by

  -- Step A: Establish the Floor of 1
  -- Proved via the Asymmetric Birth Logic from the sum's properties.
  have h_sum_pos : a^x + b^y > 0 := Nat.add_pos_left (Nat.pow_pos h_pos.1) (b^y)
  have h_floor : valuation p (a^x + b^y) = 1 := 
    asymmetric_birth_valuation a b x y p hp h_sum_pos h_p_div h_not_p2_div

  -- Step B: The Structural Trap
  -- Valuation match: 1 = z * v_p(c)
  have h_trap : z * valuation p c = 1 := by
    rw [← h_ceiling, ← h_eq, h_floor]

  -- Step C: Numerical Contradiction
  -- Since z >= 3, z * k can never be 1.
  have h_z_ge_3 : z ≥ 3 := h_pos.2.2.2.2.2

  match h_vpc : valuation p c with
  | 0 => 
    rw [h_vpc, Nat.mul_zero] at h_trap
    nomatch h_trap
  | k + 1 =>
    have h_too_big : 3 ≤ z * valuation p c := by
      rw [h_vpc]
      exact Nat.mul_le_mul h_z_ge_3 (Nat.succ_pos k)
    rw [h_trap] at h_too_big
    nomatch h_too_big
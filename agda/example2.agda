--@PREFIX@exampleTwo
------------------------------
-- The internal Mahlo universe following Setzer Arch. Math. Logic 2000
------------------------------

module example2 where

-- We define the set of natural numbers and its elimination rule:

--@BEGIN@N
data ℕ : Set where
  O  :  ℕ
  s  :  ℕ → ℕ
--@END


-- Inductive recursive definition of the subuniverses of Set
-- Constructors for closure under standards set formers are omitted

mutual
--@BEGIN@UT
  data U : Set where
    N : U

  T : U → Set
  T N = ℕ
--@END

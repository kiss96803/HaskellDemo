module MyMonadMod
    (
      MyMonadType
    ) where

import Control.Applicative

data MyMonadType x = MyMonad x
                   | Error String

instance Monad MyMonadType where
  -- return :: a -> MyMonadType a
  return = MyMonad
  -- (>>=) :: MyMonadType a -> (a -> MyMonadType b) -> MyMonadType b
  (MyMonad x) >>= f = f x
  Error s >>= f = Error s
  -- fail :: String -> MyMonadType a
  fail = Error

instance Functor MyMonadType where
  -- fmap :: (a -> b) -> MyMonadType a -> MyMonadType b
  fmap f (MyMonad x) = MyMonad (f x)

instance Applicative MyMonadType where
  -- pure :: a -> MyMonadType a
  pure = MyMonad
  -- (<*>) :: MyMonadType (a -> b) -> MyMonadType a -> MyMonadType b
  (MyMonad x) <*> g = fmap x g

op1 :: MyMonadType Integer
op1 = return 100
op2 :: MyMonadType Integer
op2 = op1 >>= (\x -> if x == 100 then MyMonad 101 else Error "Not hundred")

op3 :: MyMonadType Integer
op3 = do
  o1 <- return 100
  if o1 == 100 then return 101 else fail "MyError"
-- |My Demo Module
module Lib
    ( someFunc
    , isPrime
    , isPrimes
--    , permutations
    , permutations2
    , window
    , divisors
    , areAmicable
    , amicablesTill
    , createSumDivisorCacheTill
    , findAmicables
    , extractAmicables
    , digitize
    , euler30
    , euler31
    , euler24
    ) where

import Control.Parallel
import Control.Parallel.Strategies
import Data.List
import Data.Char

-- |Very basic print function (alias)
someFunc :: IO ()
someFunc = putStrLn "someFunc"

-- |Checks if the argument is prime
isPrime :: Integer -> Bool
isPrime 0 = False
isPrime 1 = False
isPrime 2 = True
isPrime x = 2 ^ x `mod` x == 2

-- |Checks (in parallel) if the elements in the array are prime
isPrimesPar :: [Integer] -> [Bool]
isPrimesPar =
  parMap rseq isPrime

-- |Checks if the elements in the array are prime
isPrimes :: [Integer] -> [Bool]
isPrimes =
  map isPrime

-- |Calculates the factorial of the argument
fact :: (Num b, Enum b) => b -> b
fact n = foldr (*) 1 [1..n]

-- |Calculates the factorial of the argument
fact' :: Integer -> Integer
fact' n = product [1..n]

-- |Deletes a value from the list
remove :: (Eq a) => [a] -> a -> [a]
remove [] _ = []
remove (x:xs) i
  | x == i = remove xs i 
  | otherwise = x : remove xs i

-- permutations' :: Eq a => [a] -> [[a]]
-- permutations' [] = [[]]
-- permutations' as = do a <- as
--                      let l = remove as a
--                      ls <- permutations' l
--                      return $ a : ls

permutationsAux :: (Eq a) => [a] -> [a]-> [[a]]
permutationsAux path [] = [path]
permutationsAux path arr = concatMap (\item -> permutationsAux (path ++ [item]) (remove arr item)) arr

-- |Tells all the permutations of an array
permutations2 :: (Eq a) => [a]-> [[a]]
permutations2 = permutationsAux []

-- |Euler 8
-- | Sligind window implementation
-- | *l* The length of the window
window l = filter (\x -> length x == l) . map (take l) . tails

-- euler8Input = "7316717653133062491922511967442657474235534919493496983520312774506326239578318016984801869478851843858615607891129494954595017379583319528532088055111254069874715852386305071569329096329522744304355766896648950445244523161731856403098711121722383113622298934233803081353362766142828064444866452387493035890729629049156044077239071381051585930796086670172427121883998797908792274921901699720888093776657273330010533678812202354218097512545405947522435258490771167055601360483958644670632441572215539753697817977846174064955149290862569321978468622482839722413756570560574902614079729686524145351004748216637048440319989000889524345065854122758866688116427171479924442928230863465674813919123162824586178664583591245665294765456828489128831426076900422421902267105562632111110937054421750694165896040807198403850962455444362981230987879927244284909188845801561660979191338754992005240636899125607176060588611646710940507754100225698315520005593572972571636269561882670428252483600823257530420752963450"
-- ss = window 13 euler8Input
-- v = map (\s -> (s, product (map (\c -> ord c - ord '0') s))) ss
-- e8res = sortBy (\(x,v1) (y,v2) -> if v1 > v2 then GT else LT) v

-- |Finds all divisors of the number
divisors :: (Integral a) => a -> [a]
divisors x = [x `div` i | i <- [2..x], x `mod` i == 0]

-- |Tells if the two arguments are amicable (Project Euler 21)
areAmicable :: (Integral a) => a -> a -> Bool
areAmicable x y
  | x < 0 || y < 0 = False
  | x == y = False
areAmicable x y = (sum (divisors x) == y) && (sum (divisors y) == x)

-- |Tells all the amicable numbers until *n*
amicablesTill :: (Integral a) => a -> [(a, a)]
amicablesTill n
  | n < 2 = []
amicablesTill n = filter (uncurry areAmicable) [(x, y) | x <- [1..n], y <- [x..n]]

createSumDivisorCacheTill :: (Integral a) => a -> [(a, a, [a])]
createSumDivisorCacheTill n = 
  [(x, (sum . divisors) x, divisors x) | x <- [1..n]]

findSumInCache :: (Integral a) => [(a, a, [a])] -> a -> a -> Bool
findSumInCache cache value index =
  case f of Nothing -> False
            Just (i, _, _) -> i == index
  where f = (find (\(_, v, _) -> v == value) cache)

findAmicables :: (Integral a) => [(a, a, [a])] -> [(a, a, [a])]
findAmicables cache = filter (\(n, s, ds) -> n /= s && findSumInCache cache n s) cache

extractAmicables :: (Integral a) => [(a, a, [a])] -> [a]
extractAmicables cache = map (\(n, s, ds) -> n) $ findAmicables cache 

digitize :: Int -> [Int]
digitize = map (\d -> ord d - ord '0') . show

euler30 = [x | x <- [1..], sum (map (\d -> d ^ 5) (digitize x)) == x]

euler24 = (sort (permutations "0123456789")) !! 999999


euler31 = [
    (p1, p2, p5, p10, p20, p50, p100, p200) |
    p1 <- [0..200],
    p2 <- [0..100],
    p5 <- [0..40],
    p10 <- [0..20],
    p20 <- [0..10],
    p50 <- [0..4],
    p100 <- [0..2],
    p200 <- [0..1],
    p1 + p2*2 + p5*5 * p10*10 + p20*20 + p50*50 + p100*100 + p200*200 == 200
  ]
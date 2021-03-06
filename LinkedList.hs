module LinkedList where

data LinkedList a = Head a (LinkedList a) | Nil
instance (Show a) => Show (LinkedList a) where
    show Nil = show "Nil"
    show (Head y Nil) = show y
    show (Head y tail) = show y ++ ", " ++ show tail

first :: LinkedList a -> a
first (Head y _) = y

rest :: LinkedList a -> LinkedList a
rest Nil = Nil
rest (Head _ tail) = tail

newList :: a -> LinkedList a
newList x = Head x Nil

prepend :: a -> LinkedList a -> LinkedList a
prepend x xs = Head x xs

append :: a -> LinkedList a -> LinkedList a
append x Nil = newList x
append x (Head y tail) = Head y (append x tail)

appendList :: LinkedList a -> LinkedList a -> LinkedList a
appendList Nil xs = xs
appendList xs Nil = xs
appendList xs (Head y tail) = Head y (appendList xs tail)

len :: LinkedList a -> Integer
len Nil = 0
len (Head _ tail) = 1 + len tail

contains :: Eq a => a -> LinkedList a -> Bool
contains _ Nil = False
contains x (Head y tail) = x == y || contains x tail

atIndex :: Integer -> LinkedList a -> Maybe a
atIndex _ Nil = Nothing
atIndex 0 xs = Just (first xs)
atIndex x xs = atIndex (x - 1) (rest xs)

removeFirst :: Eq a => a -> LinkedList a -> LinkedList a
removeFirst _ Nil = Nil
removeFirst x (Head y tail)
    | x == y = tail
    | otherwise = Head y (removeFirst x tail)

mapFun :: (a -> b) -> LinkedList a -> LinkedList b
mapFun f Nil = Nil
mapFun f (Head y tail) = Head (f y) (mapFun f tail)

invert :: LinkedList a -> LinkedList a
invert Nil = Nil
invert (Head y tail) = append y (invert tail)

removeDuplicates :: Eq a => LinkedList a -> LinkedList a
removeDuplicates Nil = Nil
removeDuplicates (Head y tail)
    | contains y tail = removeDuplicates tail
    | otherwise = Head y (removeDuplicates tail)

isAscending :: Ord a => LinkedList a -> Bool
isAscending Nil = True
isAscending (Head _ Nil) = True
isAscending (Head y (Head z tail)) = y >= z && isAscending tail

retain :: Integer -> LinkedList a -> LinkedList a
retain 0 _ = Nil
retain x xs@(Head y tail)
    | x == len xs = xs
    | otherwise = Head y (retain (x - 1) tail)

discard :: Integer -> LinkedList a -> LinkedList a
discard 0 xs = xs
discard x (Head _ tail) = discard (x - 1) tail

{-
Support index greater than length of LinkedList

discard :: Integer -> LinkedList a -> LinkedList a
discard _ Nil = Nil
discard x xs@(Head y tail)
    | x > 0 = discard (x - 1) tail
    | otherwise = xs
-}

fold :: (a -> b -> b) -> b -> LinkedList a -> b
fold _ x Nil = x
fold f x (Head y tail) = f y (fold f x tail)

inverseFold :: (a -> b -> b) -> b -> LinkedList a -> b
inverseFold f x xs = fold f x (invert xs)

mergeSort :: Ord a => LinkedList a -> LinkedList a
mergeSort Nil = Nil
mergeSort x@(Head y Nil) = x
mergeSort xs = merge (mergeSort first) (mergeSort second)
    where first = retain half xs
          second = discard half xs
          half = len xs `div` 2

merge :: Ord a => LinkedList a -> LinkedList a -> LinkedList a
merge xs Nil = xs
merge Nil ys = ys
merge xs ys
    | first xs <= first ys = Head (first xs) (merge (rest xs) ys)
    | otherwise = Head (first ys) (merge xs (rest ys))

filt :: (a -> Bool) -> LinkedList a -> LinkedList a
filt f Nil = Nil
filt f xs@(Head y tail)
    | f y = Head y (filt f tail)
    | otherwise = filt f tail

quickSort :: Ord a => LinkedList a -> LinkedList a
quickSort Nil = Nil
quickSort xs@(Head y rest) = appendList (quickSort bigHalf) (append y (quickSort smallHalf))
    where smallHalf = filt (< y) xs
          bigHalf = filt (> y) xs

-- Generate a short list with static values for playing around in the inveractive console
forgeList :: Num a => LinkedList a
forgeList = Head 4 (Head 3 (Head 9 (Head 1 (Head 19 Nil))))

module Dynamic where

import Data.Dynamic
import Data.Maybe

-- 
-- A list of dynamic 
--
hlist :: [Dynamic]
hlist = [ toDyn "string"
        , toDyn (7 :: Int)
        , toDyn (pi :: Double)
        , toDyn 'x'
        , toDyn ((), Just "foo")
        ]
 
dyn :: Dynamic 
dyn = hlist !! 1
 
--
-- unwrap the dynamic value, checking the type at runtime
--
v :: Int
v = case fromDynamic dyn of
        Nothing -> error "Type mismatch"
        Just x  -> x

class Typeable x => Foo x where
  bar :: x -> Bool

data FooD = FooD Int 

data FooD' = FooD' Int

instance Foo FooD where
  bar (FooD x) = x > 5


instance Foo FooD' where
  bar (FooD' x) = x < 3

hl2 :: [Dynamic]
hl2 = [ toDyn (FooD 1),
        toDyn (FooD 10),
        toDyn (FooD' 1),
        toDyn (FooD' 4),
        toDyn (FooD' 10)]

printFoo :: Dynamic -> Bool
printFoo d = doit $ fromDynamic d
  where doit :: Maybe (Foo x) -> Bool
        doit Nothing = False
        doit (Just x) = x >6 
                   
  
  

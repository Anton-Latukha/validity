{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}

module SydCheck.GenValid where

import Data.List.NonEmpty (NonEmpty)
import Data.Validity
import Data.Word
import GHC.Float (castWord64ToDouble)
import SydCheck.Gen

-- Laws:
-- 1: Every generated value must be valid
-- 2: With enough randomness, every valid value must be generated eventually.
-- 3: Annoying values should have increased likelihood of being generated.
--
-- Ideally the generated values are particularly anoying.
-- So we try to generate values around the bounds with increased probability
class Validity a => GenValid a where
  genValid :: Gen a

instance GenValid () where
  genValid = pure ()

instance GenValid Bool where
  genValid = genBool False

instance GenValid Ordering where
  genValid = genOrdering LT

instance (GenValid a, GenValid b) => GenValid (a, b) where
  genValid = (,) <$> genValid <*> genValid

instance (GenValid a, GenValid b, GenValid c) => GenValid (a, b, c) where
  genValid = (,,) <$> genValid <*> genValid <*> genValid

instance (GenValid a, GenValid b, GenValid c, GenValid d) => GenValid (a, b, c, d) where
  genValid = (,,,) <$> genValid <*> genValid <*> genValid <*> genValid

instance (GenValid a, GenValid b, GenValid c, GenValid d, GenValid e) => GenValid (a, b, c, d, e) where
  genValid = (,,,,) <$> genValid <*> genValid <*> genValid <*> genValid <*> genValid

instance (GenValid a, GenValid b, GenValid c, GenValid d, GenValid e, GenValid f) => GenValid (a, b, c, d, e, f) where
  genValid = (,,,,,) <$> genValid <*> genValid <*> genValid <*> genValid <*> genValid <*> genValid

instance GenValid a => GenValid (Maybe a) where
  genValid = genMaybeOf genValid

instance (GenValid a, GenValid b) => GenValid (Either a b) where
  genValid = genEitherOf genValid genValid

instance GenValid a => GenValid [a] where
  genValid = genListOf genValid

instance GenValid a => GenValid (NonEmpty a) where
  genValid = genNonEmptyOf genValid

instance GenValid Word8 where
  genValid = genFromSingleRandomWord $ \case
    Nothing -> 0
    Just w -> fromIntegral (w `rem` (fromIntegral (maxBound :: Word8)))

instance GenValid Word64 where
  genValid = takeNextRandomWord

instance GenValid Double where
  genValid = castWord64ToDouble <$> takeNextRandomWord

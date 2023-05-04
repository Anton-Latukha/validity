{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}

module SydCheck.GenValidSpec (spec) where

import Data.Int
import Data.List.NonEmpty (NonEmpty (..))
import Data.Word
import SydCheck.GenSpec (genDefinitelyGenerates, goldenGenSpec)
import SydCheck.GenValid
import Test.Syd

spec :: Spec
spec = do
  describe "runGen" $ do
    goldenGenValidSpec @() "unit"
    goldenGenValidSpec @Bool "bool"
    genValidDefinitelyGeneratesSpec @Bool True
    genValidDefinitelyGeneratesSpec @Bool False
    goldenGenValidSpec @Ordering "ordering"
    genValidDefinitelyGeneratesSpec @Ordering LT
    genValidDefinitelyGeneratesSpec @Ordering EQ
    genValidDefinitelyGeneratesSpec @Ordering GT
    goldenGenValidSpec @Char "char"
    goldenGenValidSpec @Word8 "word8"
    genValidDefinitelyGeneratesSpec @Word8 0
    genValidDefinitelyGeneratesSpec @Word8 maxBound
    goldenGenValidSpec @Word16 "word16"
    genValidDefinitelyGeneratesSpec @Word16 0
    genValidDefinitelyGeneratesSpec @Word16 maxBound
    goldenGenValidSpec @Word32 "word32"
    genValidDefinitelyGeneratesSpec @Word32 0
    genValidDefinitelyGeneratesSpec @Word32 maxBound
    goldenGenValidSpec @Word64 "word64"
    genValidDefinitelyGeneratesSpec @Word64 0
    genValidDefinitelyGeneratesSpec @Word64 maxBound
    goldenGenValidSpec @Word "word"
    genValidDefinitelyGeneratesSpec @Word 0
    genValidDefinitelyGeneratesSpec @Word maxBound
    goldenGenValidSpec @Int8 "int8"
    genValidDefinitelyGeneratesSpec @Int8 0
    genValidDefinitelyGeneratesSpec @Int8 minBound
    genValidDefinitelyGeneratesSpec @Int8 maxBound
    goldenGenValidSpec @Int16 "int16"
    genValidDefinitelyGeneratesSpec @Int16 0
    genValidDefinitelyGeneratesSpec @Int16 minBound
    genValidDefinitelyGeneratesSpec @Int16 maxBound
    goldenGenValidSpec @Int32 "int32"
    genValidDefinitelyGeneratesSpec @Int32 0
    genValidDefinitelyGeneratesSpec @Int32 minBound
    genValidDefinitelyGeneratesSpec @Int32 maxBound
    goldenGenValidSpec @Int64 "int64"
    genValidDefinitelyGeneratesSpec @Int64 0
    genValidDefinitelyGeneratesSpec @Int64 minBound
    genValidDefinitelyGeneratesSpec @Int64 maxBound
    goldenGenValidSpec @Int "int"
    genValidDefinitelyGeneratesSpec @Int 0
    genValidDefinitelyGeneratesSpec @Int minBound
    genValidDefinitelyGeneratesSpec @Int maxBound
    goldenGenValidSpec @Float "float"
    goldenGenValidSpec @Double "double"
    goldenGenValidSpec @(Word8, Word8) "tuple-word8-word8"
    goldenGenValidSpec @(Maybe Word8) "maybe-word8"
    goldenGenValidSpec @(Either Word8 Word8) "either-word8-word8"
    goldenGenValidSpec @[Word8] "list-word8"
    genValidDefinitelyGeneratesSpec @[Word8] []
    goldenGenValidSpec @[()] "list-unit"
    genValidDefinitelyGeneratesSpec @[()] []
    goldenGenValidSpec @(NonEmpty Word8) "nonempty-word8"
    goldenGenValidSpec @(NonEmpty ()) "nonempty-unit"
    goldenGenValidSpec @(NonEmpty (NonEmpty Word8)) "nonempty-nonempty-word8"
    goldenGenValidSpec @[[Word8]] "list-list-word8"
    genValidDefinitelyGeneratesSpec @[[Word8]] []

goldenGenValidSpec :: forall a. (Show a, GenValid a) => FilePath -> Spec
goldenGenValidSpec = goldenGenSpec (genValid @a)

genValidDefinitelyGeneratesSpec :: (Show a, Eq a, GenValid a) => a -> Spec
genValidDefinitelyGeneratesSpec = genDefinitelyGenerates genValid
{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Test.Syd.SydCheck.Runner (runSydCheckPropertyWithArgs) where

import Data.Typeable
import SydCheck
import SydCheck.PList
import SydCheck.Runner
import Test.Syd
import Test.Syd.SydCheck.Utils

instance Show (PList ls) => IsTest (TypedPropertyT ls IO) where
  type Arg1 (TypedPropertyT ls IO) = ()
  type Arg2 (TypedPropertyT ls IO) = ()
  runTest func = runTest (\() () -> func)

instance Show (PList ls) => IsTest (arg -> TypedPropertyT ls IO) where
  type Arg1 (arg -> TypedPropertyT ls IO) = ()
  type Arg2 (arg -> TypedPropertyT ls IO) = arg
  runTest func = runTest (\() arg -> func arg)

instance Show (PList ls) => IsTest (outerArgs -> innerArg -> TypedPropertyT ls IO) where
  type Arg1 (outerArgs -> innerArg -> TypedPropertyT ls IO) = outerArgs
  type Arg2 (outerArgs -> innerArg -> TypedPropertyT ls IO) = innerArg
  runTest = runSydCheckPropertyWithArgs

runSydCheckPropertyWithArgs ::
  Show (PList ls) =>
  (outerArgs -> innerArg -> TypedProperty ls) ->
  TestRunSettings ->
  ProgressReporter ->
  ((outerArgs -> innerArg -> IO ()) -> IO ()) ->
  IO TestRunResult
runSydCheckPropertyWithArgs computeProperty TestRunSettings {..} progressReporter wrapper = do
  let report = reportProgress progressReporter
  -- TODO progress per example too
  -- TODO progress for when shrinking starts

  report ProgressTestStarting
  errOrResult <- applyWrapper2 wrapper $ \outers inner -> do
    let mSeed = case testRunSettingSeed of
          RandomSeed -> Nothing
          FixedSeed s -> Just (fromIntegral s)
    runTypedPropertyT
      testRunSettingMaxSuccess
      (Size testRunSettingMaxSize)
      testRunSettingMaxShrinks
      testRunSettingMaxDiscardRatio
      mSeed
      (computeProperty outers inner)
  report ProgressTestDone

  print errOrResult
  let (testRunResultStatus, testRunResultException, testRunResultNumTests, testRunResultFailingInputs, testRunResultExtraInfo) = case errOrResult of
        Left someException ->
          ( TestFailed,
            Just someException,
            Nothing,
            [],
            Nothing
          )
        Right failedToGenOrMCounterexample -> case failedToGenOrMCounterexample of
          Left errs ->
            ( TestFailed,
              Nothing,
              Just $ length errs,
              [],
              Just $ unlines $ "Failed to generate enough values: " : errs
            )
          Right mCounterexample ->
            case mCounterexample of
              Nothing ->
                ( TestPassed,
                  Nothing,
                  Just testRunSettingMaxSuccess,
                  [],
                  Nothing
                )
              Just counterexample ->
                -- TODO: number of tests when a counterexample is found.
                ( TestFailed,
                  Nothing,
                  Nothing,
                  showPList counterexample,
                  Nothing
                )

  let testRunResultNumTests = Nothing
  let testRunResultNumShrinks = Nothing
  let testRunResultLabels = Nothing
  let testRunResultClasses = Nothing
  let testRunResultTables = Nothing
  let testRunResultGoldenCase = Nothing

  pure TestRunResult {..}

showPList :: PList ls -> [String]
showPList = \case
  PNil -> []
  PCons e pl -> ppShow e : showPList pl
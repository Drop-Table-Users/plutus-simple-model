import Prelude

import Test.Tasty (TestTree, defaultMain, testGroup)

import Suites.Plutarch as Plutarch

main :: IO ()
main = do
  defaultMain $ do
    testGroup
      "Test Suites"
      [ Plutarch.tests ]

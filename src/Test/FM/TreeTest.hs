module Test.FM.TreeTest where

import Test.HUnit

import Control.Lens
import Data.Tree
import Data.Tree.Lens

import Data.FM.FeatureModel
import Data.FM.Expression
import Data.FM.Feature
import Data.FM.Tree
import Data.FM.SAT



------------------- FEATURE MODEL - TEST 01 -------------------

ft01 = Node (Feature "iris" BasicFeature Mandatory) [
             (Node (Feature "security" OrFeature Mandatory) [
                (Node (Feature "sha-256" BasicFeature Optional) []),
                (Node (Feature "RSA" BasicFeature Optional) [])
             ]),
             (Node (Feature "persist" AltFeature Mandatory) [
                (Node (Feature "SQL" BasicFeature Optional) []),
                (Node (Feature "NoSQL" BasicFeature Optional) [])
             ])
            ]



fm01 = FeatureModel ft01 []

fm02 = FeatureModel ft01 [Not (Ref "iris")]

fm03 = FeatureModel ft01 [Not (Ref "persist")]

fm04 = FeatureModel ft01 [And (Not (Ref "SQL")) (Not (Ref "NoSQL"))]

test01 = TestCase (assertEqual "SAT solving"
                  True (satSolver fm01))

test02 = TestCase (assertEqual "SAT not solving"
                  False (satSolver fm02))

test03 = TestCase (assertEqual "SAT not solving"
                  False (satSolver fm03))

test04 = TestCase (assertEqual "SAT not solving"
                  False (satSolver fm04))

testTree = Node 0 [
            Node 1 [Node 2 []],
            Node 3 [Node 4 [Node 5 []]]
        ]




ft02 = Node (Feature "iris" BasicFeature Mandatory) [
         (Node (Feature "security" OrFeature Mandatory) [
            (Node (Feature "sha-256" BasicFeature Mandatory) []),
            (Node (Feature "RSA" BasicFeature Mandatory) [])
         ]),
         (Node (Feature "persist" AltFeature Mandatory) [
            (Node (Feature "SQL" AltFeature Mandatory) [
              (Node (Feature "PostgreSQL" BasicFeature Optional) []),
              (Node (Feature "MySQL" BasicFeature Optional) []),
              (Node (Feature "LiteSQL" BasicFeature Optional) [])
            ]),
            (Node (Feature "NoSQL" BasicFeature Mandatory) [
              (Node (Feature "MongoDB" BasicFeature Mandatory) [])
            ])
         ])
        ]

foo :: (Functor f, Num b) => f b -> f b
foo = fmap (+1)
    -- where
    --     bar (Node v) [] = even v
    --     bar (Node v) cs = even v && and cs

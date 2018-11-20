module Lib where

{- Functions:
      Use -- defined per-item
      Take
      Put
      Go
      Look
-}

{-
  constants to hold room names
-}
let
  YARD = "Yard"
  KITCHEN = "Kitchen"
  LIVINGROOM = "Living Room"
in

newtype Description = Description String
newtype RoomName = RoomName String
newtype ItemName = Itemname String
newtype Inventory = Inventory [Item]
type Rooms = [(RoomName, Room)]
type World = (Rooms, Player)

data Player =
  MkPlayer { getInventory :: Inventory
           , getLocation :: RoomName
           , getHealth :: Int
           } deriving (Eq, Show)

data Item =
  MkItem { getName :: ItemName
         , getUse :: World -> World
         } deriving (Eq, Show)

data Room =
  MkRoom { getDescription :: Description
         , getName :: RoomName
         , northExit :: Maybe RoomName
         , eastExit :: Maybe RoomName
         , westExit :: Maybe RoomName
         , southExit :: Maybe RoomName
         , northeastExit :: Maybe RoomName
         , northwestExit :: Maybe RoomName
         , southeastExit :: Maybe RoomName
         , southwestExit :: Maybe RoomName
         , getItems :: [Item]
         , getUnits :: [Unit]
         } deriving (Eq, Show)


take :: Rooms -> Player -> Item -> World
take rs p i =
  ((removeItem i rs), (addItem i p))

addItem :: Item -> Player -> Player
addItem i p =
  let inventory' = (++) i $ getInventory p in
    mkPlayer { getInventory = inventory'
             , getLocation  = getLocation p
             , getHealth    = getHealth p
             }

removeItem :: Item -> Rooms -> Rooms
removeItem i (rd:rs) | rs == [] = [rd]
                     | hasItem i rd == True = (++) (removeItem' i rd) $ removeItem rs
                     | otherwise = (++) rd $ removeItem rs

removeItem' :: Item -> (RoomName, Room) -> (RoomName, Room)
removeItem' i (name, room) =
  let
    items = [ i' | i' /= i, i'<-(getItems r)]
    room' = MkRoom { getItems = items
                   , getDescription = getDescription room
                   , getName = getName room
                   , northExit = northExit room
                   , eastExit = eastExit room
                   , westExit = westExit room
                   , southExit = southExit room
                   , northeastExit = northeastExit room
                   , northwestExit = northwestExit room
                   , southeastExit = southeastExit room
                   , southwestExit = southwestExit room
                   , getUnits = getUnits room
                   }
  in
    (name, room')

hasItem :: Item -> (RoomName, Room)
hasItem i (name, room) = elem i (getItems room)


livingRoom = MkRoom { getDescription = Description "living room desc"
                    , getName = RoomName LIVINGROOM
                    , northExit = Nothing
                    , eastExit = Nothing
                    , westExit = Nothing
                    , southExit = Just KITCHEN
                    , northwestExit = Nothing
                    , northeastExit = Nothing
                    , southwestExit = Nothing
                    , southeastExit = Nothing
                    , getItems = []
                    , getUnits = []
                    }

kitchen = MkRoom { getDescription = Description "kitchen"
                 , getName = RoomName KITCHEN
                 , northExit = Just LIVINGROOM
                 , eastExit = Nothing
                 , westExit = KITCHEN
                 , southExit = Nothing
                 , northwestExit = Nothing
                 , northeastExit = Nothing
                 , southwestExit = Nothing
                 , southeastExit = Nothing
                 , getItems = []
                 , getUnits = []
                 }

yard = MkRoom { getDescription = Description "yard"
              , getName = RoomName YARD
              , northExit = Nothing
              , eastExit = KITCHEN
              , westExit = Nothing
              , southExit = Nothing
              , northwestExit = Nothing
              , northeastExit = Nothing
              , southwestExit = Nothing
              , southeastExit = Nothing
              , getItems = []
              , getUnits = []
              }


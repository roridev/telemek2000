-- Alice's Types
-- They don't exist on code and should all be type aliases.
-- Exists only for clarifying code from the infered intent.

type SlotIdMap = Map Int Int

---
--- Code Flow for Mekanism 1.12.0
---

--- Hope you like redirection and needless abstraction
--- Ain't touching any of those that i really don't need to.
--- Tip: Go listen to some Akira Complex while reading this file,
---      "Reality Distortion" and "Hypersynthetic" are both good albums
---      that fit the mood quite nicely. RIP Charlie, she'll  be missed.


type TransitRequest = Map HashedItem (Int, SlotIdMap)

fromTransport :: TransportStack -> TransitRequest
fromStack :: ItemStack -> TransitRequest
buildInventoryMap :: TileEntity -> EnumFacing -> Int -> TransitRequest
buildInventoryMap :: TileEntity -> EnumFacing -> Int -> Finder -> TransitRequest
isEmpty :: Boolean
addItem :: ItemStack -> Int -> IO ()
getSingleStack :: ItemStack
hasType :: ItemStack -> Boolean

data TransitResponse = TransitResponse { idMap :: SlotIdMap, toSend :: ItemStack }

getSendingAmount :: Int
isEmpty :: Boolean
getRejected :: ItemStack -> Boolean
getInvStack :: TileEntity -> EnumFacing -> InvStack 

data InvStack = InvStack { tile  :: TileEntity
                         , side  :: EnumFacing
                         , idMap :: SlotIdMap
                         , item  :: HashedItem
                         , count :: Int
                         }

getStack :: ItemStack
appendStack :: Int -> ItemStack -> IO ()

-- Called `use` for no god forsaken reason.
-- I guess it because it "uses" the items from the parent inventory
-- This just removes the given quantity of items from the InvStack
use :: Int -> IO ()
-- This variation removes everything, so i doubt i'll ever see it.
-- Its used on the *digital miner* and in `TileComponentEjector`.
-- I'll follow the data types for now until I get a complete grasp
-- of this mess.
use -> IO ()

-------
-------       A file we actually want to see
-------

--- ILogisticalTransporter.java
---        src/main/java/mekanism/common/base/ILogisticalTransporter.java

----- This file is really fun, it is the interface that defines the behavior
----- of "Logistical Transporters", since everything on mekanism has a cool
----- name, thats their "Item Pipe". It took me a while to find out that it
----- wasn't an internal implementation name and that it was the name of the
----- *actual item*. Searching for "pipe" only gives you the "Universal Pipe"
----- which apart from the name, isn't "Universal" at all, it can *only*
----- transport *energy*. There was lots of hours of my life gone searching
----- for the wrong data on the only file named "Pipe".

---- Now for a break in the lovely ML-like syntax

-- ILogisticalTransporter : IGridTransmiter<TileEntity, InventoryNetwork,Void>, IBlockableConnection {

--- Its a can of worms only the most sadistic ever wish to unravel,
--- but here *we* are.

--- IGridTransmitter.java
---        src/main/java/mekanism/api/transmitters/IGridTransmitter.java

----- Boy, if you thought you were deep, let me tell you a thing:
----- Mekanism has abstracted things to an undescribable extent.
----- These are some generics that'd make Polyanna proud,
----- And *i am* a functional programming nerd, i love generic code
----- but this ain't it chief.

-- IGridTransmitter<ACCEPTOR, NETWORK extends DynamicNetwork<ACCEPTOR, NETWORK, BUFFER>, BUFFER> extends ITransmitter

----- Phew! That was a mouthful. Unfortunately, this is moonrunes unless we know 
----- what in the world a `DynamicNetwork` is.

--- DynamicNetwork.java
---        src/main/mekanism/api/transmitters/DynamicNetwork.java

-- DynamicNetwork<ACCEPTOR, NETWORK extends DynamicNetwork<ACCEPTOR, NETWORK, BUFFER>, BUFFER> implements IClientTicker, INetworkDataHandler

----- This wretched spawn of satan has *no documentation whatsoever*.
----- Do they *really* expect no one to end up here?
----- Unfortunately for them, i'm already here, Let's "unpick the seams of reality
----- so that the normal rules no longer apply" and this codebase is finally understood.

-- This is illegal haskell syntax, but i'll do
class DynamicNetwork a n b where
    transmitters :: Set (IGridTransmitter a n b)
    transmittersToAdd :: Set (IGridTransmitter a n b)
    transmittersAdded :: Set (IGridTransmitter a n b)

    -- Yes, A network contains transmitters, but a transmitter also has a network

    possibleAcceptors  :: Set Coord4d -- finally a concrete type!
    acceptorDirections :: Map Coord4d (EnumSet EnumFacing)
    -- This is the reason why i chose haskell.
    -- Map<IGridTransmitter<ACCEPTOR, NETWORK, BUFFER>, EnumSet<EnumFacing>>
    changedAcceptors :: Map (IGridTransmitter a n b) (EnumSet Facing)

    packetRange :: Range4d

    capacity :: Int
    doubleCapacity :: Int
    meanCapacity :: Int

    needsUpdate :: Boolean
    updateDelay :: Int

    firstUpdate :: Boolean
    world :: World

    updateQueue :: Set DelayQueue

    -- We finally got to the functions for this lad
    -- Which honestly is the things i'm interested on

    -- But unfortunately, the can of worms isn't yet fully defined.
    -- Theres `Coord4d`, `Range4d` and `DelayQueue` to be discovered

    -- Unfortunately, All things must come to an end.
    -- This exploration of Mekanism 1.12 via type peeking must end for today.
    -- We will eventually get a good grasp of what in the world all of this
    -- is doing, but that'll be for another day.

    -- A good thing of documenting my process is that i can just resume
    -- this tomorrow, or whenever i feel like it.

    -- I *could* just modify things without understanding this, but it'll lead
    -- to me trying in vain to change things on the wrong places
    -- (it happened twice, and twice is one time too many) which is a waste of
    -- time. More so then getting to know this lovely mess that got rewritten.

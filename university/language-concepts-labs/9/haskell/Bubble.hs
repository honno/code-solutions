module Main where

import Control.Concurrent
import Control.Concurrent.STM

main :: IO ()
main =
    do -- ie the value is an imperative procedure
    -- create shared state variable:
    stateTV <- atomically $ newTVar initState
    -- create and start some threads:
    -- *** TASK 9.2.(d) ***
    forkIO $ bubbleAB stateTV
    forkIO $ bubbleBC stateTV
    forkIO $ bubbleCD stateTV

    -- give the state a sorting task:
    putStrLn "Starting"
    setAll stateTV 5 1 3 1
    waitUntilSorted stateTV
    putStrLn "Finishing"
    -- the forked threads will be aborted automatically now

data State =
    State
    {
        state_a :: Int,
        state_b :: Int,
        state_c :: Int,
        state_d :: Int,
        state_printing :: Bool
    }

initState = State 0 0 0 0 False

bubbleAB stateTV =
    do
    swapAB stateTV
    printState stateTV
    bubbleAB stateTV -- go to the beginning

swapAB stateTV =
    atomically $
        do
        state <- readTVar stateTV
        let a = state_a state
        let b = state_b state
        if a <= b || state_printing state
            then retry
            else
                do
                let new_state = state { state_a = b, state_b = a, state_printing = True }
                writeTVar stateTV new_state

bubbleBC stateTV =
    do
    swapBC stateTV
    printState stateTV
    bubbleBC stateTV -- go to the beginning

swapBC stateTV =
    atomically $
        do
        state <- readTVar stateTV
        let b = state_b state
        let c = state_c state
        if b <= c || state_printing state
            then retry
            else
                do
                let new_state = state { state_b = c, state_c = b, state_printing = True }
                writeTVar stateTV new_state

bubbleCD stateTV =
    do
    swapCD stateTV
    printState stateTV
    bubbleCD stateTV

swapCD stateTV =
    atomically $
        do
        state <- readTVar stateTV
        let c = state_c state
        let d = state_d state
        if c <= d || state_printing state
            then retry
            else
                do
                let new_state = state { state_c = d, state_d = c, state_printing = True }
                writeTVar stateTV new_state

setAll stateTV a b c d =
    do
    atomically $
        do
        writeTVar stateTV state
    printState stateTV
    where
    state = State a b c d True

printState stateTV =
    do
    state <- atomically $ readTVar stateTV
    let (State a b c d printing) = state
    putStrLn $
        "a = " ++ show a
            ++ "; b = " ++ show b
            ++ "; c = " ++ show c
            ++ "; d = " ++ show d
    -- signal that printing is finished:
    atomically $ writeTVar stateTV (state { state_printing = False })

waitUntilSorted stateTV =
    atomically $ -- ie critical section
        do
        state <- readTVar stateTV
        -- extract all four state components at once:
        let (State a b c d printing) = state
        -- check whether sorted and block if not yet:
        -- *** TASK 9.2.(e) ***
        if a <= b && b <= c && c <= d && not printing
          then return state
          else retry

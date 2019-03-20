# dance_magic_dance

CLI game similar to the board game "Das verrückte Labyrinth" by Ravensburger, which is particularly popular in Germany.

We will publish a blog series about our experiences coding this game.

## Status: This is WIP, work in progress.

19 Mar 2019:
- working board, piece types with orientation and pushing pieces
- working players and moving them through labyrinth
- working card stacks and working them off when player lands on the respective pieces
- accepts user input via CLI
- working unlimited moves and WIN game when card stack is empty => FULL GAME!
- code refactored
- board surrounding graphics: directions, slots
- display current piece-in-hand and card

TO DO:
- test suite
- save and load game state
- display last players path on board

## Run

After cloning this repository, just enter into terminal: `ruby app.rb`

## Core Contributors

- [Oliver Thamm - pickledolives](https://github.com/pickledolives)
- [Kiersten Mounce - kierstenmounce](https://github.com/kierstenmounce)

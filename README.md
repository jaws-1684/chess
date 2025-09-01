![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white)

# Chess

A basic command line ruby chess game where two players can play against each other or against a **simple computer**.

[!NOTE]
> This is the final project in the Ruby curriculum at The Odin Project.

## Description
This chess engine supports:
+ move generation/validation
+ piece placement/movement
+ enpassant and promotion for pawns
+ castling for king
+ check/checkmate/stalemate detection
+ saving the game

## Structure

```
├── bin
│├── chess
│└── chess_20250901.dat
├── chess-1.1.0.gem
├── chess_v1.1.gemspec
├── Gemfile
├── Gemfile.lock
├── lib
│└── chess
│    ├── actionable.rb
│    ├── algebraic_notation.rb
│    ├── board.rb
│    ├── computer
│    │└── computer.rb
│    ├── db.rb
│    ├── displayable.rb
│    ├── game.rb
│    ├── gamestate
│    │└── gamestate.rb
│    ├── piece.rb
│    ├── pieces
│    │├── bishop.rb
│    │├── king.rb
│    │├── knight.rb
│    │├── pawn.rb
│    │├── queen.rb
│    │└── rook.rb
│    ├── rememberable.rb
│    └── utilities.rb
├── LICENSE
├── README.md
└── spec
    ├── chess
    │├── bishop_spec.rb
    │├── gamestate_spec.rb
    │├── king_spec.rb
    │├── knight_spec.rb
    │├── pawn_spec.rb
    │├── queen_spec.rb
    │└── rook_spec.rb
    └── spec_helper.rb

```

## Installation

Run the following command to install this game as a ruby gem:

```sh
	gem install chess-1.1.0.gem
```
Then run the game from your terminal with `chess`.

[!TIP]
> If installing the gem is not an option, after cloning the repository, first install the dependecies:
	```sh
		bundle install 
	```
And run the game with `bin/chess`.


## Author

jaws

## License

This project is licensed under the MIT License. See the LICENSE file for details.
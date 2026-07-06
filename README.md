# chess.rb - Chess 
<a href="https://codesandbox.io/p/github/jaws-1684/chess/main">View on codesandox.</a>

## Description
A basic command line chess game written in ruby where two players can play against each other or against a **simple computer player**.
>[!NOTE]
> This project was build as the last assignment in the Ruby curriculum at The Odin Project.

## About The Project
<p align="center">
  <img height="350" src="https://raw.githubusercontent.com/jaws-1684/chess/refs/heads/images/demo.gif">
</p>
&nbsp&nbspChess is a board game for two players, played on a square board consisting of 64 squares arranged in an 8×8 grid. The players, referred to as "White" and "Black", each control sixteen pieces: one king, one queen, two rooks, two bishops, two knights, and eight pawns, with each piece type having a different pattern of movement (https://en.wikipedia.org/wiki/Chess).<br>&nbsp&nbspThe project implements the following key features:

* **Move generation/validation**
* **Piece placement/movement**
* **Enpassant and promotion for pawns**
* **Castling for king**
* **Check/Checkmate/Stalemate state detection**
* **Saving the game state**

### Built With
<img height="25" style="margin-right: 15px" src="https://images.icon-icons.com/3049/PNG/512/ruby_icon_189423.png"/>
<img height="25" style="margin-right: 15px" src="https://support.testmo.com/hc/article_attachments/39192821548557">
<img height="25" style="margin-right: 15px" src="https://media.proglib.io/posts/2020/12/16/199f892bf6ebd668f777e0b15a043e76.jpg"/>




---

## Getting Started
### Prerequisites
Make sure you have ruby installed.

### Installation from gemfile

Run the following command to install this game as a ruby gem:

```sh
gem install chess-1.1.0.gem
```

###  Installation from source

1. Clone the repository
   ```sh
   git clone https://github.com/jaws-1684/chess.git
   ```
2. Navigate into the project directory
   ```sh
   cd chess
   ```
3. Install dependencies
   ```sh
   bundle install
   ```

## Usage

### Run 
```sh
bin/chess
```

### Run tests
```sh
bundle exec rspec
```
### Run linter
```sh
bundle exec rubocop
```



---
## How to play
1. Select color
2. Make a move
3. Play



## Project Structure

```
├── Gemfile
├── Gemfile.lock
├── LICENSE
├── README.md
├── bin
│   ├── chess
│   ├── chess_20250903.dat
│   └── chess_20260702.dat
├── chess-1.1.0.gem
├── chess_v1.1.gemspec
├── lib
│   ├── chess
│   │   ├── actionable
│   │   ├── algebraic_refinements.rb
│   │   ├── board.rb
│   │   ├── computer.rb
│   │   ├── coordinates.rb
│   │   ├── db
│   │   ├── displayable.rb
│   │   ├── game.rb
│   │   ├── gamestate.rb
│   │   ├── piece.rb
│   │   ├── pieces
│   │   ├── rememberable.rb
│   │   └── utilities.rb
│   └── chess.rb
└── spec
    ├── lib
    │   └── chess
    └── spec_helper.rb
```


---

## Contributing
If you have some *amazing* improvement ideas *feel free* to contribute.

1. Clone this repo
2. Create your Feature Branch (`git checkout -b feature/my_amazing_feature`)
3. Commit your Changes (`git commit -m 'Add some amazing_feature'`)
4. Push to the Branch (`git push origin feature/amazing_feature`)
5. Open a Pull Request


---

## License

Distributed under the MIT License. See `LICENSE` for more information.

---

## Contact

GitHub: [jaws-1684](https://github.com/jaws-1684)
Project Link: [https://github.com/jaws-1684/chess](https://github.com/jaws-1684/chess)


---

## Acknowledgments
The following resources proved to be quite helpful:
* [The Odin Project](https://www.theodinproject.com)
* [Chess](https://en.wikipedia.org/wiki/Chess)


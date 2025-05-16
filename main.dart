import 'dart:io';
import 'dart:math';

List<String> board = ["1","2","3","4","5","6","7","8","9"];

String currentPlayer = 'X' ;

bool playWithBot = false;
bool botTurn = false;

bool playAgain = false;

void main() {

print('Welcome to Khader Tic-Tac-Toe Game. \n');

do{
  cleanUpBoard();
  gameMode();
  choosePlayerSymbol();
  print("Let's get started !");
  play();
} while (playAgain);

}

// reset and clean the board.
void cleanUpBoard(){
  board = ["1","2","3","4","5","6","7","8","9"];
}

// Select game mode based on user input.
// Also it contain a retry selection in case Invalid selection was done.
// expected input 1 or 2
void gameMode() {
  print('We have 2 options to play the game:');
  print('1- Play with your friend');
  print('2- Play with an AI bot \n');

  String? input;
  do {
    stdout.write('Please select either (1 or 2): ');
    input = stdin.readLineSync();
    if (input != '1' && input != '2') {
      print('Invalid selection. Please enter 1 or 2.');
    }
  }while (input != '1' && input != '2');
  playWithBot = input == '2' ? true : false;

}

// a function that let the user select his/her symbol for the game.
// Also it contain a retry selection in case Invalid selection was done.
// expected input X or O
void choosePlayerSymbol() {
  String? input;
  do {
    stdout.write('Please choose either X or O Symbol: ');
    input = stdin.readLineSync();

    if (input == null || (input.toUpperCase() != 'X' && input.toUpperCase() != 'O')) {
      print('Invalid selection. Please enter X or O.');
    }
  }while (input == null || (input.toUpperCase() != 'X' && input.toUpperCase() != 'O'));

  currentPlayer = input.toUpperCase();
}

// my game logic
void play(){
  while (true){
    displayBoard();
    if (playWithBot) {
      if(botTurn){
        print("Bot turn");
        aiMove(currentPlayer);
        botTurn = false;
      }else {
        playerMove(currentPlayer);
        botTurn = true;
      }
    } else {
      playerMove(currentPlayer);
    }

    if (checkWin(currentPlayer)) {
      displayBoard();
      print('Player $currentPlayer wins!');
      askReplay();
      break;
    } else if (checkDraw()) {
      displayBoard();
      print('It\'s a draw!');
      askReplay();
      break;
    }
    currentPlayer = currentPlayer == 'X' ? 'O' : 'X' ;
  }
}

// a function that used to print our current board status.
void displayBoard() {
  print('Tic Tac Toe Board: \n');
  for (var i = 0; i < 3; i++) {
    print(' ${board[i * 3]} | ${board[i * 3 + 1]} | ${board[i * 3 + 2]} ');
    if (i < 2) {
      print('-----------');
    }
  }
  print("");
}

// a function that let the user select his/her move for the game.
// Also it contain a retry selection in case Invalid selection was done.
// expected input number from 1 to 9
void playerMove(String player) {
  int move = -1;

  do {
    stdout.write('Player $player, enter your move (1-9): ');
    var input = stdin.readLineSync();
    int? parsed = int.tryParse(input!);
    if (parsed != null) {
      move = parsed;
    } else {
      move = -1;
    }
  } while (!isValidMove(move));

  board[move - 1] = player;
}

// Check if the move is valid or not.
bool isValidMove(int move) {
  return move >= 1 && move <= 9 && board[move - 1] != 'X' && board[move - 1] != 'O';
}

// function that select a random number for AI bot
// it checks whether the cell has already been selected.
// if it hasn’t, it selects it. if it has, it tries again.
void aiMove(String Player){
  Random random = Random();
  while(true){
    int randomMove = random.nextInt(9) + 1;
    if (board [randomMove - 1] != 'X' && board [randomMove - 1] != 'O' ){
      board[randomMove - 1] = Player;
      break;
    }
  }
}

// Check if we have a win condition
bool checkWin(String player) {
  List<List<int>> winPatterns = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
    [0, 4, 8], [2, 4, 6]             // diagonals
  ];

  for (var pattern in winPatterns) {
    bool isWinningPattern = true;
    for (int index in pattern) {
      if (board[index] != player){
        isWinningPattern = false;
        break;
      }
    }
    if (isWinningPattern) {
      return true;
    }
  }
  return false;
}

// Check if we have a draw by checking our cell if they are empty or not.
bool checkDraw() {
  for (var cell in board) {
    if (cell != 'X' && cell != 'O') {
      return false;
    }
  }
  return true;
}

// Ask if user wants to replay
// Also it contain a retry selection in case Invalid selection was done.
// expected input y or n
void askReplay() {
   String? input;

  do{
    stdout.write('Play again? (y/n): ');
    input = stdin.readLineSync();
    if (input == null || input.toLowerCase() != 'y' && input.toLowerCase() != 'n') {
      print('Invalid selection. Please enter y or n.');
    }
  }while( input == null || input.toLowerCase() != 'y' && input.toLowerCase() != 'n');
  playAgain = input.toLowerCase() == 'y';
}

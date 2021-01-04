import processing.net.*;

Client myClient;

color lightbrown = #FFFFC3;
color darkbrown  = #D8864E;
PImage wrook, wbishop, wknight, wqueen, wking, wpawn;
PImage brook, bbishop, bknight, bqueen, bking, bpawn;
boolean firstClick;
int row1, col1, row2, col2;
boolean myTurn = false;
int type;
char lastPieceTaken;
boolean canUndo = true;
boolean menu = false;


char grid[][] = {
  {'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'}, 
  {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'}, 
  {'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'}
};

void setup() {
  size(800, 800);
  myClient = new Client(this, "127.0.0.1", 1234);
  firstClick = true;

  brook = loadImage("blackRook.png");
  bbishop = loadImage("blackBishop.png");
  bknight = loadImage("blackKnight.png");
  bqueen = loadImage("blackQueen.png");
  bking = loadImage("blackKing.png");
  bpawn = loadImage("blackPawn.png");

  wrook = loadImage("whiteRook.png");
  wbishop = loadImage("whiteBishop.png");
  wknight = loadImage("whiteKnight.png");
  wqueen = loadImage("whiteQueen.png");
  wking = loadImage("whiteKing.png");
  wpawn = loadImage("whitePawn.png");
}

void draw() {
  drawBoard();
  drawPieces();
  receiveMove();
  menu();
}

void receiveMove() {
  if (myClient.available() > 0) { 
    String incoming = myClient.readString();
    int r1 = int(incoming.substring(0, 1)); 
    int c1 = int(incoming.substring(2, 3));
    int r2 = int(incoming.substring(4, 5));
    int c2 = int(incoming.substring(6, 7));
    int type = int(incoming.substring(8, 9));
    if (type == 0) { //move
      lastPieceTaken = grid[r2][c2];
      grid[r2][c2] = grid[r1][c1];
      grid[r1][c1] = ' ';
      myTurn = true;
      if (grid[0][c2] == 'p') {
        myTurn = false;
      }
    }
    if (type == 1) { //promote
      if (r2 == 1)  grid[r1][c1] = 'q'; //queen
      if (r2 == 2)  grid[r1][c1] = 'r'; //rook
      if (r2 == 3)  grid[r1][c1] = 'n'; //knight
      if (r2 == 4)  grid[r1][c1] = 'b'; //bishop
      myTurn = true;
    }
    if (type == 2) { //undo
      myTurn = false;
      grid[r1][c1] = grid[r2][c2];
      grid[r2][c2] = lastPieceTaken;
    }
    // if (type == 3) { //castle
    // lastPieceTaken = grid[r2][c2];
    //  grid[r2][c2] = grid[r1][c1];
    //  grid[r1][c1] = ' ';
    //  grid[7][5] = 'r';
    //  grid[7][7] = ' ';
    //  myTurn = true;
    //}
  }
}

void drawBoard() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) { 
      if ( (r%2) == (c%2) ) { 
        fill(lightbrown);
      } else { 
        fill(darkbrown);
      }
      rect(c*100, r*100, 100, 100);
    }
  }
}

void drawPieces() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      if (grid[r][c] == 'r') image (wrook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'R') image (brook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'b') image (wbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'B') image (bbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'n') image (wknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'N') image (bknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'q') image (wqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'Q') image (bqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'k') image (wking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'K') image (bking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'p') image (wpawn, c*100, r*100, 100, 100);
      if (grid[r][c] == 'P') image (bpawn, c*100, r*100, 100, 100);
    }
  }
}

void menu() {
  if (grid[7][col2] == 'P') {
    menu = true;
  }
  if (menu == true) {
    stroke(0);
    fill(255);
    rect(200, 300, 400, 200);  
    image (bqueen, width/2 - 200, 300, 100, 100);
    image (brook, width/2 - 100, 300, 100, 100);
    image (bbishop, width/2, 300, 100, 100);
    image (bknight, width/2 + 100, 300, 100, 100);
    textSize(50);
    fill(0);
    text("q", width/2-175, 450);
    text("r", width/2-75, 450);
    text("b", width/2+25, 450);
    text("n", width/2+125, 450);
  }
}

void mouseReleased() {
  if (myTurn) {
    if (firstClick) {
      row1 = mouseY/100;
      col1 = mouseX/100;
      firstClick = false;
    } else {
      row2 = mouseY/100;
      col2 = mouseX/100;
      //temp
      lastPieceTaken = grid[row2][col2];
      if (!(row2 == row1 && col2 == col1)) {
        grid[row2][col2] = grid[row1][col1];
        grid[row1][col1] = ' ';
        myClient.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + type);
        firstClick = true;
        myTurn = false;
        canUndo = true;
      }
    }
  }
}

void keyReleased() {
  if (key == 'z' || key == 'Z') {
    if (canUndo == true) {
      grid[row1][col1] = grid[row2][col2];
      grid[row2][col2] = lastPieceTaken;
      myClient.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + 2);
      myTurn = true;
      canUndo = false;
      menu = false;
    }
  }
  if (grid[7][col2] == 'P') {
    if (key == 'q' || key == 'Q') {
      grid[7][col2] = 'Q';
      myClient.write(7 + "," + col2 + "," + 1 + "," + 0 + "," + 1);
    }
    if (key == 'r' || key == 'R') {
      grid[7][col2] = 'R';
      myClient.write(7 + "," + col2 + "," + 2 + "," + 0 + "," + 1);
    }
    if (key == 'n' || key == 'N') {
      grid[7][col2] = 'N';
      myClient.write(7 + "," + col2 + "," + 3 + "," + 0 + "," + 1);
    }
    if (key == 'b' || key == 'B') {
      grid[7][col2] = 'B';
      myClient.write(7 + "," + col2 + "," + 4 + "," + 0 + "," + 1);
    }
    menu = false;
  }
}

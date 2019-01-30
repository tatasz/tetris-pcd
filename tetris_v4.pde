/*
COISAS PARA CORRIGIR
1. Quando a peça está quase assentada, podemos mexer ela. Desabilitar rotação uma vez que dá splat?.
3. Ajustar o amostrador de peças. No momento, gera um número aleatório, porém depois vou querer as 
  peças básicas mais alguma das peças bizarras, seguindo alguma lógica
*/


int blocksize = 25;
int starts = 0;


TetrisGame tetris;
TetrisShape[] shapes;

void settings(){
  size(blocksize * 12 + 100, blocksize * 24);
}

void setup() {
  tetris = new TetrisGame(10, 20, starts);
  tetris.update();
  tetris.display();
}

void draw() {
  if (!tetris.gameOver & !tetris.nextLevel) {
    tetris.update();
    tetris.display();
  } else {
    if (tetris.gameOver) tetris.endGame();
    if (tetris.nextLevel) tetris.nextLevelStats(tetris.bonusRows);
  }
}

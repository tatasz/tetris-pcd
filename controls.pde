//os controles
void keyPressed(){ 
  if (key == 'P' | key=='p') tetris.pause = !tetris.pause;
  if (this.tetris.pause) return;
  if (key == 'R' | key=='r') tetris.restart();
  if (key == 'N' | key=='n') tetris.nextLevel();
  if ((keyCode == UP)) tetris.currentShape.rotate();
  if ((keyCode == DOWN) | (keyCode == 32)) tetris.currentShape.moveY(1);
  if (keyCode == LEFT) tetris.currentShape.moveX(-1);
  if (keyCode == RIGHT) tetris.currentShape.moveX(1);
}

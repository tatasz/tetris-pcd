class TetrisGame{
  // tamanho da "caixa"
  int nx, ny;
  // nível
  int level;
  // grid dentro da "caixa"
  int[][] grid;
  // pontos
  int score;
  // linhas que foram limpas
  int clearedLines;
  // timer
  Timer timer;
  // timer para eventos especiais
  Timer eventTimer;
  // começa com peça nova
  boolean spawn = true;
  // ID peça atual
  int currentShapeID;
  // ID peça seguinte
  int nextShapeID;
  //peça atual
  TetrisShape currentShape;
  //pausa
  boolean pause;
  //re-começa
  boolean restart;
  //fim do jogo
  boolean gameOver;
  //próximo nível
  boolean nextLevel;
  //linhas bonus = número de linhas vazias quando atinge o objetivo
  int bonusRows;
  //level 
  TetrisLevel currentLevel;
  
  // cria um jogo
  TetrisGame(int x, int y, int l) {
    nx = x;
    ny = y;
    level = l;
    score = 0;
    setAll();
  }
  
  // setup de variáveis tal como elas são no começo do nível
  void setAll(){
    pause = false;
    restart = false;
    gameOver = false;
    nextLevel = false;
    currentLevel = setLevel(level);
    bonusRows = 0;
    clearedLines = 0;
    grid = makeState(nx, ny, level);
    timer = new Timer();
    timer.reset(600 - currentLevel.speed);
    eventTimer = new Timer();
    eventTimer.reset(currentLevel.eventSpeed * 100);
    currentShapeID = nextShapeID;
    nextShapeID = floor(random(7)) + 1;
    currentShape = new TetrisShape(currentShapeID);
    
    timer.setTime();
    eventTimer.setTime();
    
  }
  
  //display
  void display() {
    //fundo
    background(10);
    fill(0);
    stroke(100);
    //desenha a caixa
    rect(blocksize, blocksize, blocksize * nx, blocksize * (ny + 2));
    
    //texto: nível, pontuação e por aí vai
    textAlign(LEFT, TOP);
    fill(120);
    textSize(15);
    text("score", blocksize * (nx + 2), blocksize); 
    fill(200);
    textSize(20);
    text(str(score), blocksize * (nx + 2), blocksize * 2); 
    fill(120);
    textSize(15);
    text("level", blocksize * (nx + 2), blocksize * 4); 
    fill(200);
    textSize(20);
    text(str(level + 1), blocksize * (nx + 2), blocksize * 5); 
    fill(120);
    textSize(15);
    text("goal", blocksize * (nx + 2), blocksize * 7); 
    fill(200);
    textSize(20);
    text(str(currentLevel.goalLines), blocksize * (nx + 2), blocksize * 8); 
    fill(120);
    textSize(15);
    text("cleared", blocksize * (nx + 2), blocksize * 10); 
    fill(200);
    textSize(20);
    text(str(clearedLines), blocksize * (nx + 2), blocksize * 11);

    //desenha os blocos que já cairam
    for (int i=0; i<nx; i++){
      for (int j=0; j<ny; j++){
        if (grid[i][j] > 0) {
          block(i, j + 2, blocksize, palette[grid[i][j]]);
        }
      }
    }
    
    //desenha a próxima peça
    for (int i=0; i<4; i++){
      for (int j=0; j<4; j++){
        if (shapelist[nextShapeID][j][i] > 0) {
          block(i + nx + 1, j + 13, blocksize, palette[nextShapeID]);
        }
      }
    }
    
    //desenha a peça atual
    for (int i=0; i<4; i++){
      for (int j=0; j<4; j++){
        if (currentShape.geom[j][i] > 0) {
          block(i + currentShape.x, j + currentShape.y, blocksize, currentShape.col);
        }
      }
    }
    
    //Time to next event
    if (currentLevel.addRandomLines | currentLevel.addRandomBlocks){
      fill(120);
      textSize(15);
      text("next event", blocksize * (nx + 2), blocksize * 19); 
      fill(200);
      textSize(20);
      int sec = round((eventTimer.duration - eventTimer.getTime()) / 1000);
      text(str(sec), blocksize * (nx + 2), blocksize * 20);
    }
  }
  
  //atualiza
  void update() {
    //se pausa, não faz nada
    if(pause){
      return;
    }
    //se precisa soltar uma peça nova...
    if (spawn) {
      //peça seguinte vira peça atual
      currentShapeID = nextShapeID;
      //FAZER AMOSTRADOR, PARA LIDAR COM PEÇAS ESPECIAIS
      nextShapeID = floor(random(7)) + 1;
      // incializa a peça
      currentShape = new TetrisShape(currentShapeID);
      // zera o timer
      timer.setTime();
      spawn = false;
    }
    // se o jogo avança um passo
    if(timer.updateStep()){
      // testamos se a peça vai colidir
      boolean test = currentShape.collision(0, 0);
      if (!test) {
        //peça cai um bloco
        currentShape.y += 1;
      } else {
        //a peça cai na superfície
        splatShape();
        //precisamos gerar nova peça
        spawn = true;
      }
    }
    
    //realiza eventos
    if(eventTimer.updateStep()){
      if(currentLevel.addRandomLines){
        addLine(); //<>//
      }
      if(currentLevel.addRandomBlocks){
        addBlock();
      }
      // testamos se a peça vai colidir
      boolean test = currentShape.collision(0, 0);
      if (test) {
        //a peça cai na superfície
        splatShape();
        //precisamos gerar nova peça
        spawn = true;
      }
    }
  }
  
  // quando a peça cai
  void splatShape() {
    for (int i=0; i<currentShape.dim; i++){
      int I = i + currentShape.x;
      for (int j=0; j<currentShape.dim; j++){
        int J = j + currentShape.y - 2;
        // se a peça saiu do copo, termina o jogo
        if (J <= 0) {
          endGame();
          return;
        } else {
          // adicionamos a peça ao grid
          if (currentShape.geom[j][i] > 0) grid[I][J] = currentShapeID * currentShape.geom[j][i];
          checkRows();
        }
      }
    }
  }
  
  //fim do jogo
  void endGame(){
    tetris.gameOver = true;
    //escreve mensagem de fim de jogo
    textAlign(CENTER, TOP);
    fill(250);
    stroke(0);
    textSize(40);
    text("Game Over", blocksize * 6, blocksize * 10); 
    textSize(25);
    text("Press R to restart", blocksize * 6, blocksize * 12); 
  }
  
  // reinicia
  void restart(){
    tetris = new TetrisGame(10, 20, starts);
  }
  
  // calcula bonus: número de linhas vazias
  void getBonus(){
    for (int j=0; j< ny; j++){
      int s = 0;
      for (int i=0; i<nx; i++){
        s += grid[i][j];
      }
      if (s == 0) {
        bonusRows += 1;
      } else {
        j = ny;
        break;
      }
    }
    //adiciona o bonus à pontuação
    score += bonusRows;
  }
  
  //desenha a mensagem de avançar nível
  void nextLevelStats(int bonusRows){
    textAlign(CENTER, TOP);
    fill(250);
    stroke(0);
    textSize(30);
    text("Bonus", blocksize * 6, blocksize * 8); 
    textSize(50);
    text(str(bonusRows), blocksize * 6, blocksize * 10); 
    textSize(20);
    text("Press N for next level", blocksize * 6, blocksize * 14); 
  }
  
  //avança nível
  void nextLevel(){
    level += 1;
    setAll();
  }
  
  //checa se alguma linha foi completada
  void checkRows(){
    int count = 0;
    for (int j=ny-1; j>=0; j--){
      boolean completed = true;
      for (int i=0; i<nx; i++){
        if (grid[i][j] == 0) {
          completed = false;
          i = nx;
        }
      }
      //se a linha foi completada, remove ela e desce a parte do grid que estava em cima uma linha
      if (completed) {
        int[][] newgrid = grid;
        for (int J=j; J>=1; J--){
          for (int I=0; I<nx; I++){
            newgrid[I][J] = grid[I][J-1];
          }
        }
        grid = newgrid;
        count += 1;
        j += 1;
      }
    }
    //atualiza a pontuação
    if (count > 0){
      score += count * count;
      clearedLines += count;
      eventTimer.setTime();
    }
    // se atingiu o objetivo, avança para o próximo
    if (clearedLines >= currentLevel.goalLines){
      nextLevel = true;
      getBonus();
    }
  }
  
  //adiciona linha
  void addLine(){
    int[][] newgrid = randomGrid(nx, ny, 1);
    for (int J=ny-2; J>=0; J--){
      for (int I=0; I<nx; I++){
        newgrid[I][J] = grid[I][J+1];
      }
    }
    grid = newgrid;
    //checa se o jogo acabou:
    boolean test = false;
    for (int I=0; I<nx; I++){
      if (grid[I][0] > 0) test = true;
    }
    if (test) endGame();
    eventTimer.setTime();
  }
  
  //adiciona linha
  void addBlock(){
    int X = 0;
    int Y = 0;
    int I = floor(random(nx));
    for (int J=0; J<ny; J++){
      if (grid[I][J] > 0) {
        Y = J - 1;
        X = I;
        break;
      }
    }
    grid[X][Y] = 8;
    println("!!!");
  }
}


//desenha um bloco
//fiz função a parte porque queria fazer algo mais bonitinho depois
void block(int i, int j, int blocksize, color c){
  fill(c);
  stroke(255);
  int X = (i + 1) * blocksize;
  int Y = (j + 1) * blocksize;
  rect(X, Y, blocksize, blocksize);
}

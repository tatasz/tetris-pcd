//nível
//decidi fazer uma classe porque vai ter coisas estranhas aqui depois
class TetrisLevel {
  //número de linhas para eliminar
  int goalLines;
  //estado inicial do grid
  int initialState;
  //velocidade das peças
  int speed;
  //velocidade de eventos
  int eventSpeed;
  //peças disponíveis
  int mShapes;
  //adiciona linhas
  boolean addRandomLines;
  //adiciona blocos
  boolean addRandomBlocks;
}

//cria os níveis
TetrisLevel setLevel(int l) {
  //níveis vão em grupos de 3
  int i = l % 3;
  int j = (l - i) /3;
  TetrisLevel level = new TetrisLevel();
  //objetivo é o objetivo base +5 e +10 linhas
  level.goalLines =  goal[j] + 5 * i;
  //estado inicial do grid
  level.initialState = iState[j];
  //velocidade base do nível
  level.speed = levelSpeed[j] + i * 50;
  //peças disponíveis
  level.mShapes = 7;
  //velocidade eventos
  level.eventSpeed = evSpeed[j] - i*30;
  //linhas aleatórias
  level.addRandomLines = (addLines[j] > 0);
  //blocos aleatórios
  level.addRandomBlocks = (addBlocks[j] > 0);
  return level;  
}

//cria o grid (depois vai ter mais casos
int[][] makeState(int nx, int ny, int id) {
  int[][] st = new int[nx][ny];
  int I = id % 3;
  int J = (id - I) / 3;
  switch(iState[J]) {
    case 0:
    //grid vazio
    for (int i=0; i < nx; i++) {
      for (int j=0; j < ny; j++) {
        st[i][j] = 0;
      }
    }
    break;
    case 1:
    //grid random
    int check = randomFill[J] + I * 2;
    st = randomGrid(nx, ny, check);
    break;
  }
  return st;
}

int[][] randomGrid(int nx, int ny, int c) {
  int check = ny - c;
  int[][] st = new int[nx][ny];
  for (int j=0; j < ny; j++) {
    if (j < check) {
      for (int i=0; i < nx; i++) {
        st[i][j] = 0;
      }
    } else {
      for (int i=0; i < nx; i++) {
        st[i][j] = floor(random(7))+1;
      }
      for (int i=0; i < 5; i++) {
        st[floor(random(nx))][j] = 0;
      }
    }
  }
  return st;
}

//valores para níveis
//no momento, sem ideias para generalizar, por isso entrada de vetorzão mesmo
int[] goal = {5, 5, 5, 5};
int[] iState = {0, 1, 0, 0};
int[] levelSpeed = {0, 0, 0, 0};
int[] randomFill = {0, 3, 0, 0};
int[] evSpeed = {9999, 9999, 220, 100};
int[] addLines = {0, 0, 1, 0};
int[] addBlocks = {0, 0, 0, 1};

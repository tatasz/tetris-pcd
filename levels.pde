//nível
//decidi fazer uma classe porque vai ter coisas estranhas aqui depois
class TetrisLevel {
  //número de linhas para eliminar
  int goalLines;
  //estado inicial do grid
  int initialState;
  //velocidade das peças
  int speed;
  //peças disponíveis
  int mShapes;
}

//cria os níveis
void setLevels() {
  //níveis vão em grupos de 3
  int numCycles = 1;
  levels = new TetrisLevel[numCycles * 3];
  for (int j=0; j < numCycles; j++){
    for (int i=0; i < 3; i++) {
      int I = j * 3 + i;
      //cria nível
      levels[I] = new TetrisLevel();
      //objetivo é o objetivo base +5 e +10 linhas
      levels[I].goalLines =  goal[j] + 5 * i;
      //estado inicial do grid
      levels[I].initialState = iState[j];
      //velocidade base do nível
      levels[I].speed = levelSpeed[j];
      //peças disponíveis
      levels[I].mShapes = 7;
    }
  }
}

//cria o grid (depois vai ter mais casos
int[][] makeState(int nx, int ny, int id) {
  int[][] st = new int[nx][ny];
  switch(id) {
    case 0:
    //grid vazio
    for (int i=0; i < nx; i++) {
      for (int j=0; j < ny; j++) {
        st[i][j] = 0;
      }
    }
    break;
  }
  return st;
}

//valores para níveis
//no momento, sem ideias para generalizar, por isso entrada de vetorzão mesmo
int[] goal = {5};
int[] iState = {0};
int[] levelSpeed = {0};

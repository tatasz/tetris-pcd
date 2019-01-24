//peças, 0 é vazia, 1-7 são peças normais, 8+ são peças especiais
int[][][] shapelist = {
  { {0, 0, 0, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0} },
  { {1, 1, 0, 0},
    {1, 1, 0, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0} },
  { {0, 1, 0, 0},
    {0, 1, 0, 0},
    {0, 1, 1, 0},
    {0, 0, 0, 0} },
  { {0, 1, 0, 0},
    {0, 1, 0, 0},
    {1, 1, 0, 0},
    {0, 0, 0, 0} },
  { {1, 1, 0, 0},
    {0, 1, 1, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0} },
  { {0, 1, 1, 0},
    {1, 1, 0, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0} },
  { {0, 0, 0, 0},
    {1, 1, 1, 0},
    {0, 1, 0, 0},
    {0, 0, 0, 0} },
  { {0, 1, 0, 0},
    {0, 1, 0, 0},
    {0, 1, 0, 0},
    {0, 1, 0, 0} },
  { {1, 0, 0, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0} }
};

//cores
color[] palette = {
    color(255), //void
    color(235, 59, 90), // 1
    color(250, 130, 49), // 2
    color(247, 183, 49), // 3
    color(32, 191, 107), // 4
    color(45, 152, 218), // 5
    color(56, 103, 214), // 6
    color(136, 84, 208), // 7
    color(100), // 8
};

//largura das peças
int[] wd = {0, 2, 3, 3, 3, 3, 3, 4, 1};

//velocidade base das peças
int[] defSpeed = {1, 1, 1, 1, 1, 1, 1, 1, 2};

//define uma nova peça
class TetrisShape {
  //cor
  color col;
  //geometria
  int[][] geom;  
  //posição x,y
  int x, y;
  //velocidade
  int speed;
  //tamanho
  int dim;
  
  //peça nova, índice i
  TetrisShape(int i) {
    col = palette[i];
    geom = copy(shapelist[i]);
    x = 4;
    y = 0;
    speed = defSpeed[i];
    dim = wd[i];
  }
  
  //colisão com coisas no grid
  boolean collision(int[][] grid, int nx, int ny, int dx, int dy) {
    boolean test = false;
    for (int i=0; i<dim; i++){
      for (int j=0; j<dim; j++){
        int px = x + i + dx;
        int py = y + j - 1 + dy;
        int val_grid  = getGridVal(grid, px, py, nx, ny);
        int val_shape = geom[j][i];
        if(val_grid * val_shape != 0){
          test = true;
        }
      }
    }
    return test;
  }
  
  //rotação da peça
  void rotate() {
    int[][] newgeom = copy(shapelist[0]);
    for (int i=0; i<dim; i++){
      for (int j=0; j<dim; j++){
        newgeom[i][j] = geom[dim - j - 1][i];
      }
    }
    geom = copy(newgeom);
  }
  
  //move horizontalmente
  //PS: tem um negócio estranho rolando, mas estou com preçuiça de arrumar, por isso o -1
  void moveX(int dx) {
    boolean test = collision(tetris.grid, tetris.nx, tetris.ny, dx, -1);
    if (!test) {
      x += dx;
    }
  }
  //move verticalmente
  void moveY(int dy) {
    boolean test = collision(tetris.grid, tetris.nx, tetris.ny, 0, dy);
    if (!test) {
      y += dy;
    }
  }
}

//pega valores do grid
int getGridVal(int[][] grid, int i, int j, int nx, int ny) {
  int val = 0;
  if (i < 0 | i >= nx) {
    val = 1;
  } else {
    if (j < 0) {
      val = 0;
    } else {
      if (j >= ny) {
        val = 1;
      } else {
        val = grid[i][j];
      }
    }
  }
  return val;
}

//copia
int[][] copy(int[][] a){
  int[][] b = new int[4][4];
  for (int i=0; i<4; i++){
    for (int j=0; j<4; j++){
      b[i][j] = a[i][j];
    }
  }
  return b;
}

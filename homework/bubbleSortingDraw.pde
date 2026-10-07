int n = 16;
int m = n * (n - 1) / 2;
int step = m;
boolean isPlaying = false;

int loop = 0;
int[][] arr;

void setup() {
 size(800, 600);
 frameRate(60);
 arrAdd();
 arrPrint();
 println("\n");
 bubbleSort(arr);
 arrPrint();
}


void arrAdd() {
  int i;
  arr = new int[m][n];
  for(i=0; i<n; i++) {
    arr[0][i] = (int) random(100);
  }
}
void arrPrint() {
  int i, j;
  for(j=0; j<m; j++) {
    for(i=0; i<n; i++) {
      print(arr[j][i], " ");
    }
    println();
  }
}
void bubbleSort(int arr[][]) {
 int tmp;
 int step = 0;
 for(int i=0; i<arr.length-1; i++) {
  for(int j = 0; j < n - i - 1; j++) {
    if(step + 1 >= m) break;
    copy(step, step + 1);
    if (arr[step + 1][j] > arr[step + 1][j + 1]) {
      tmp = arr[step + 1][j];
      arr[step + 1][j] = arr[step + 1][j + 1];
      arr[step + 1][j + 1] = tmp;
    }
    step++;
  }
 }
}
void draw() {
  if(isPlaying) {
    loop++;
    if(loop >= m) {
      loop = m -1;
      isPlaying = false;
    }
  }
  int i;
  float mx, dx, my, dy;
  background(32);
  mx = my = 20.;
  dx = (width-2*mx)/n;
  dy = (height-2*my)/100;
  for(i=0; i<n; i++) {
    fill(255);
    rect(mx+dx*i, height-dy*arr[loop][i]-my, dx, dy*arr[loop][i]);
  }
  fill(255);
  textSize(18);
  text("Step: " + loop + " / " + (m - 1), 20, 30);
}

void mousePressed() {
  if(mouseButton == RIGHT) {
    loop++;
    if(loop>=m) loop=0;
  }
  else if(mouseButton == LEFT) {
    loop--;
    if(loop<0) loop=m-1;
  }
}

void keyPressed() {
  if(key == 'n' || key == 'N') {
    if (loop >= step) {
      loop = 0;
    }
    isPlaying = !isPlaying;
    if(isPlaying) {
      frameRate(15);
    } else {
      frameRate(60);
    }
  }
}

void copy(int i, int j) { // i-->j
  for(int k=0; k<n; k++) {
    arr[j][k] = arr[i][k];
  }
}

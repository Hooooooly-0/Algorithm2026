int n = 16;
int m = n * (n - 1) / 2;
int loop =0;
int totalCount = 0;
int step = 0;
boolean isPlaying= false;

int[][] arr;

void setup() {
  frameRate(60);
  size(800, 600);
  arrAdd(n, m);
  arrPrint(arr);
  println("\n");
  insertionSort(arr);
  arrPrint(arr);
}


void arrAdd(int n, int m) {
 arr = new int[m][n];
 for(int i = 0; i < n; i++) {
   arr[0][i] = (int)random(100);
 } 
}

void arrPrint(int arr[][]) {
 for(int i=0; i<m; i++) {
   for(int j = 0; j < n; j++) {
     print(arr[i][j], " ");
   }
   println();
 }
}
void insertionSort(int arr[][]) {
  int i, j, tmp;
  step = 0;
 for(i = 1; i < n; i++) {
   tmp = arr[step][i];
   for(j = i - 1; j>= 0; j--){
     if(step + 1 >= m) break;
     if(arr[step][j] > tmp){
       copy(step, step + 1);
       arr[step + 1][j+1] = arr[step+ 1 ][j];
       step++;
     } else {
       break;
     }
   }
   if(step + 1 < m) {
     copy(step, step +1);
     arr[step + 1][j+1] = tmp;
     step++;
   }
 }
}

void draw() {
  if(isPlaying) {
    loop++;
    if(loop >= step+1) {
      loop = step;
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
  text("Step: " + loop + " / " + step, 20, 30);
}

void mousePressed() {
  if(mouseButton == RIGHT) {
    loop++;
    if(loop > step) loop=0;
  }
  else if(mouseButton == LEFT) {
    loop--;
    if(loop<0) loop=step;
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
  int k;
  for(k=0; k<n; k++) {
    arr[j][k] = arr[i][k];
  }  
}

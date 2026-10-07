int n = 16;
int m = n * (n -1) / 2;
int step = 0;
int loop = 0;
boolean isPlaying = false;
int[][] arr;

void setup() {
 size(800, 600);
 frameRate(60);
 arrAdd(n, m);
 arrPrint(arr);
 println("\n");
 quickSort(arr, 0, n-1);
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

void quickSort(int arr[][], int p, int r) {
  if (p < r) {
    int q = partition(arr, p, r);
    quickSort(arr, p, q-1);
    quickSort(arr, q+1, r);
  }
}

int partition(int arr[][], int p, int r){
  int i, j, pivot, tmp;
  i = p -1;
  pivot = arr[step][r];
  for(j = p; j<r; j++) {
    if (arr[step][j] <= pivot) {
      i++;
      if(i != j) {
        if(step + 1 >= m) break;
        copy(step, step+1);
        tmp = arr[step][i];
        arr[step+1][i] = arr[step][j];
        arr[step+1][j] = tmp;
        step++;
      }
    }
  }
  if (i + 1 != r && step + 1 < m) {
  copy(step, step +1);
    tmp = arr[step][i+1];
    arr[step+1][i+1] = arr[step][r];
    arr[step+1][r] = tmp;
    step++;
  }
  
  return i+1;
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

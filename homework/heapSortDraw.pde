int n = 16;
int log2n = (int)(log(n) / log(2));
int m = 2 * n * log2n;
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
 heapSort(arr);
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

void heapSort(int arr[][]) {
  int i, tmp;
  int n = arr[0].length;
  step = 0;
  buildHeap(arr, arr[0].length);
  for(i = n-1; i>0; i--) {
    if(step + 1 >= m) break;
    copy(step, step+1);
    tmp = arr[step][0];
    arr[step+1][0] = arr[step][i];
    arr[step+1][i] = tmp;
    step++;
    heapify(arr, i, 0);
  }
}
void buildHeap(int arr[][], int n) {
  for(int i =(n/2)-1; i >= 0; i--) {
    heapify(arr, n, i);
  }
}
void heapify(int arr[][], int n, int i) {
  int largest = i;
  int left = 2*i+1;
  int right = 2*i+2;
  if(left<n && arr[step][left] > arr[step][largest]) {
    largest = left;
  }
    if(right<n && arr[step][right] > arr[step][largest]) {
    largest = right;
  }
  if(largest != i) {
    copy(step, step+1);
    int tmp = arr[step][i];
    arr[step + 1][i] = arr[step][largest];
    arr[step + 1][largest] = tmp;
    step++;
    heapify(arr, n, largest);
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

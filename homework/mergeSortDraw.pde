int n = 16;
int log2n = (int)(log(n) / log(2));
int m = 2 * n * log2n - 2 + 1;;
int step = 0;
int loop = 0;
boolean isPlaying = false;
int[][] arr;

void setup() {
  size(800, 600);
  frameRate(60);
 arrAdd(n, m);
 println("before");
 arrPrint(arr);
 println("정렬 시작");
 step = 0;
 mergeSort(arr, 0, n - 1);
 println("정렬 완료");
 println("after");
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

void mergeSort(int arr[][], int p, int r) {
  if (p < r) {
    int q = (p + r)/2;
    mergeSort(arr, p, q);
    mergeSort(arr, q+1, r);
    merge(arr, p, q, r);
    arrPrint(arr);
  }
}

void merge(int arr[][], int p, int q, int r) {
  if(step + 1 >= m) return;
  int[] C = new int[r-p+1];
  int i = 0;
  int left = p;
  int right = q + 1;
  int startStep = step;
  while(left <= q && right <= r){
    if(arr[step][left] <= arr[startStep][right]) {
      C[i] = arr[startStep][left];
      left++;
    } else {
      C[i] = arr[startStep][right];
      right++;
    }
    i++;
  }
  while (left<=q) {
    C[i] = arr[startStep][left];
    left++;
    i++;
  }
    while (right<=r) {
    C[i] = arr[startStep][right];
    right++;
    i++;
  }
  for(i=0; i<C.length; i++) {
    if(step + 1 >= m) break;
    copy(step, step + 1);
    arr[step+1][p+i] = C[i];
    step++;
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

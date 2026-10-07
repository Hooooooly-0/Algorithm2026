int n = 16;
int m = 16; // selection Sort
int[][] arr;
int loop;
int step = m-1;
boolean isPlaying = false;

void setup() {
  size(800, 600);
  frameRate(60);
  intArr();
  printArr();
  selectionSorting();
  printArr();
  loop=0;
}

void intArr() {
  int i;
  arr = new int[m][n];
  for(i=0; i<n; i++) {
    arr[0][i] = (int) random(100);
  }
}

void printArr() {
  int i, j;
  for(j=0; j<m; j++) {
    for(i=0; i<n; i++) {
      print(arr[j][i], " ");
    }
    println();
  }  
}
void selectionSorting() {
  int i, j, max, index, tmp;
  for(i=0; i<m-1; i++) {
    max = index = -1;
    copy(i, i+1); 
    loop++;
    for(j=0; j<n-i; j++) {
      if(max<arr[loop][j]) {
        index = j;
        max = arr[loop][j];
      }
    }
    tmp = arr[loop][n-i-1];
    arr[loop][n-i-1] = max;
    arr[loop][index] = tmp;
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

void copy(int i, int j) { // i-->j
  int k;
  for(k=0; k<n; k++) {
    arr[j][k] = arr[i][k];
  }  
}

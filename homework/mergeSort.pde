int[] arr = {20, 12, 32, 9};

void setup() {
 arrAdd(50);
 arrPrint(arr);
 println("\n");
 //selectionSort(arr);
 mergeSort(arr, 0, arr.length-1);
 //arr = merge(arr, 0, 0, 1);
 //arr = merge(arr, 2, 2, 3);
 //arr = merge(arr, 0, 1, 3);
 arrPrint(arr);
}


void arrAdd(int n) {
 arr = new int[n];
 for(int i=0; i<arr.length; i++) {
   arr[i] = (int)random(100);
 } 
}
void arrPrint(int arr[]) {
 for(int i=0; i<arr.length; i++) {
   print(arr[i], " ");
 }
}
void mergeSort(int arr[], int p, int r) {
  if (p < r) {
    int q = (p + r)/2;
    mergeSort(arr, p, q);
    mergeSort(arr, q+1, r);
    merge(arr, p, q, r);
  }
}

int[] merge(int arr[], int p, int q, int r) {
  int[] C = new int[r-p+1];
  int i = 0;
  int n = p;
  int m = q + 1;
  while(n <= q && m <= r){
    if(arr[n] <= arr[m]) {
      C[i] = arr[n];
      n++;
    } else {
      C[i] = arr[m];
      m++;
    }
    i++;
  }
  while (n<=q) {
    C[i] = arr[n];
    n++;
    i++;
  }
    while (m<=r) {
    C[i] = arr[m];
    m++;
    i++;
  }
  for(i=0; i<C.length; i++) {
    arr[p+i] = C[i];
  }
  return arr;
}

void draw() {
  
}

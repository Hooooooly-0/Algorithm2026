int[] arr = {20, 12, 32, 9};

void setup() {
 arrAdd(50);
 arrPrint(arr);
 println("\n");
 heapSort(arr);
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
void heapSort(int arr[]) {
  int i, tmp;
  int n = arr.length;
  buidHeap(arr, arr.length);
  for(i = n-1; i>0; i--) {
    tmp = arr[0];
    arr[0] = arr[i];
    arr[i] = tmp;
    heapify(arr, i, 0);
  }
}
void buidHeap(int arr[], int n) {
  for(int i =(n/2)-1; i >= 0; i--) {
    heapify(arr, n, i);
  }
}
void heapify(int arr[], int n, int i) {
  int largest = i;
  int left = 2*i+1;
  int right = 2*i+2;
  if(left<n && arr[left] > arr[largest]) {
    largest = left;
  }
    if(right<n && arr[right] > arr[largest]) {
    largest = right;
  }
  if(largest != i) {
    int tmp = arr[i];
    arr[i] = arr[largest];
    arr[largest] = tmp;
    heapify(arr, n, largest);
  }
}
void draw() {
  
}

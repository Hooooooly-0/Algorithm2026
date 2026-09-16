int[] arr = {20, 12, 32, 9};

void setup() {
 arrAdd(50);
 arrPrint(arr);
 println("\n");
 quickSort(arr, 0, arr.length-1);
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
void quickSort(int arr[], int p, int r) {
  if (p < r) {
    int q = partition(arr, p, r);
    quickSort(arr, p, q-1);
    quickSort(arr, q+1, r);
  }
}

int partition(int arr[], int p, int r){
  int i, j, pivot, tmp;
  i = p -1;
  pivot = arr[r];
  for(j = p; j<r; j++) {
    if (arr[j] <= pivot) {
      i++;
      tmp = arr[i];
      arr[i] = arr[j];
      arr[j] = tmp;
    }
  }
  tmp = arr[i+1];
  arr[i+1] = arr[r];
  arr[r] = tmp;
  
  return i+1;
}

void draw() {
  
}

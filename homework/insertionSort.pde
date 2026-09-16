int[] arr = {20, 12, 32, 9};

void setup() {
 arrAdd(16);
 arrPrint(arr);
 println("\n");
 //selectionSort(arr);
 insertionSort(arr);
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
void insertionSort(int arr[]) {
  int i, j, index, tmp;
 for(i=0; i<arr.length-1; i++) {
   tmp = index = -1;
   tmp = arr[i+1];
  for(j=i; j>=0; j--) {
    if(arr[j]>arr[i+1]) {
      index = j;
      arr[j+1] = arr[j];
    }
  }
  arr[index] = tmp;
 }
}

void draw() {
  
}

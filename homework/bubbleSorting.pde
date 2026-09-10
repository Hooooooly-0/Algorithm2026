int[] arr = {20, 12, 32, 9};

void setup() {
 arrAdd(16);
 arrPrint(arr);
 println("\n");
 //selectionSort(arr);
 bubbleSort(arr);
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
void selectionSort(int arr[]) {
  int i, j, max, index, tmp;
 for(i=0; i<arr.length; i++) {
   max = index = -1;
  for(j=0; j<arr.length-i; j++) {
    if(max<arr[j]) {
     index = j;
     max = arr[j];
    }
  }
  tmp = arr[arr.length-i-1];
  arr[arr.length-i-1] = max;
  arr[index] = tmp;
 }
}
void bubbleSort(int arr[]) {
 int i, j, tmp;
 for(i=0; i<arr.length-1; i++) {
  for(j=0; j<arr.length-i-1; j++) {
    if(arr[j] > arr[j+1]) {
      tmp = arr[j];
      arr[j] = arr[j+1];
      arr[j+1] = tmp;
    }
  }
 }
}
void draw() {
  
}

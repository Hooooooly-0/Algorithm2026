int[] arr = {20, 12, 32, 9};

void setup() {
 arrAdd(16);
 arrPrint(arr);
 println("\n");
 selectionSort(arr);
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
void draw() {
  
}

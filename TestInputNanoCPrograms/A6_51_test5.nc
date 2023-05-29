int printInt(int num);
int printStr(char * c);
int readInt(int *eP);

int arr[10];

// A function to implement bubble sort
void bubbleSort(int n) { 
  int i;
  int j;
  for (i = 0; i < n - 1; i = i + 1){
    int a = n - i - 1;
    for (j = 0; j < a ; j = j + 1){
      if (arr[j] > arr[j + 1]) {
        int temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
      }
    }
  }
  return;
}
//A recursive binary search function. It returns location of x
//in given array arr[l..r] is present, otherwise -1
int binarySearch(int l, int r, int x) {
  if (r >= l) {
    int mid = l + (r - l) / 2;
    // If the element is present at the middle itself
    if (arr[mid] == x)
      return mid;
    // If element is smaller than mid, then it can only be present in left subarray
    if (arr[mid] > x){
      return binarySearch(l, mid - 1, x);
    }
    // Else the element can only be present in right subarray
    return binarySearch(mid + 1, r, x);
  }
  // We reach here when element is not present in array
  return -1;
}
int main() {

  printStr("\n\tBubble Sort and Binary Search\n\n");
  int* ep;
  printStr("Enter the number of elements in the array: ");
  int n = readInt(ep);

  printStr("Enter the elements of the array: ");
  int i;
  for (i = 0; i < n; i = i + 1){
    arr[i] = readInt(ep);
  }
  printStr("Enter the element to be searched: ");
  int x = readInt(ep);

  // first sort the numbers
  bubbleSort(n);
  // print the sorted array
  printStr("The sorted array is: ");
  for (i = 0; i < n; i = i + 1){
    int a = arr[i];
    printInt(a);
    printStr(" ");
  }
  printStr("\n");

  // then we search for the element
  int result = binarySearch(0, n - 1, x);
  if (result == -1){
    printStr("\nElement is not present in array");
  }
  else {
    printStr("\nElement is present at index ");
    printInt(result);
  }
  printStr("\n");
  return 0;
}
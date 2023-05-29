
int printInt(int num);
int printStr(char * c);
int readInt(int *eP);

int ncr(int n, int r){
  int i;
  int num = 1;
  int den = 1;
  for(i = 1; i <= r; i = i + 1){
    num = num * (n - i + 1);
    den = den * i;
  }
  return num/den;
}

int get_prod(int a, int b){
  int prod = a * b;
  return prod;
}

int main() {
  int* ep;
  printStr("\n\tComputing product and ncr\n\n");
  printStr("Enter 2 integers: ");
  int a = readInt(ep);
  int b = readInt(ep);
  int c = get_prod(a,b);
  printStr("The product is: ");
  printInt(c);
  printStr("\n");
  c = ncr(a,b);
  printStr("The ncr is: ");
  printInt(c);
  printStr("\n");
  return 0;
}

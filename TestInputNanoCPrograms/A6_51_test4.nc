// Recursive factorial

int printInt(int num);
int printStr(char * c);
int readInt(int *eP);

int factorial(int n){
  if(n == 0)
    return 1;
  else
    return (n * factorial(n - 1)) % 100;

  return 0;
}

int main() {
  int* ep;
  printStr("\n\tRecursive factorial\n\n");
  printStr("Enter an integer: ");
  int n = readInt(ep);
  int fact = factorial(n);
  printStr("The factorial mod 100 is: ");
  printInt(fact);
  printStr("\n");
  return 0;
}
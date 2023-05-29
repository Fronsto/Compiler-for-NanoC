int printInt(int num);
int printStr(char * c);
int readInt(int *eP);

int f_odd(int n);
int f_even(int n);
int fibonacci(int n) {
return ((n % 2) == 0) ? f_even(n): f_odd(n);
}
int f_odd(int n) {
return (n == 1) ? 1 : ( f_even(n-1) + f_odd(n-2));
}
int f_even(int n) {
return (n == 0) ? 0 : (f_odd(n-1) + f_even(n-2));
}

int main()
{
    printStr("\n\tFibonacci numbers\n\n");
    printStr("Enter a number : ");
    int val = readInt(ep);
    printStr("Read value: ");
    printInt(val);
    printStr("\n");

    int res = fibonacci(val);
    printStr("Fibonacci of ");
    printInt(val);
    printStr(" is ");
    printInt(res);
    printStr("\n");

    return 0;
}
// Testing boolean and if-else statements

int printInt(int num);
int printStr(char * c);
int readInt(int *eP);

int testingBoolean(int a, int b ,int c){
  int flag = 0;
  if( ( a < 10 ) || ( b < 10 ) || (c < 10) ){
    printStr("One of the numbers is less than 10\n");
  }
  else if( (a<=100) && (b <=100) && (c<=100)){
    if( (!(a==b)) && (b!=c) && (a!=c)){
      printStr("The numbers fit the criteria\n");
      flag = 1;
    } else {
      printStr("Two or more numbers are equal\n");
    }
  }
  else{
    printStr("One of the numbers is greater than 100\n");
  }
  return flag;
} 

int main(){
  int* ep;
  printStr("\n\tBoolean expressions and if-else\n\n");
  printStr("Enter 3 distinct integers between 10 and 100: ");
  int a = readInt(ep);
  int b = readInt(ep);
  int c = readInt(ep);
  int ret = testingBoolean(a,b,c);
  if(ret == 1) {
    printStr("SUCCESS\n");
  } else {
    printStr("FAILURE\n");
  }
  return 0;
}
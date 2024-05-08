int read(int __fd, const void *__buf, int __n){
    int ret_val;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall write code (63) \n"
    "ecall               # invoke syscall \n"
    "mv %0, a0           # move return value to ret_val\n"
    : "=r"(ret_val)  // Output list
    : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
  return ret_val;
}

void write(int __fd, const void *__buf, int __n)
{
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}

void exit(int code)
{
  __asm__ __volatile__(
    "mv a0, %0           # return code\n"
    "li a7, 93           # syscall exit (64) \n"
    "ecall"
    :   // Output list
    :"r"(code)    // Input list
    : "a0", "a7"
  );
}

void _start()
{
  int ret_code = main();
  exit(ret_code);
}

#define STDIN_FD  0
#define STDOUT_FD 1

void hex_code(int val){
    char hex[11];
    unsigned int uval = (unsigned int) val, aux;

    hex[0] = '0';
    hex[1] = 'x';
    hex[10] = '\n';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    write(1, hex, 11);
}

int main()
{
  char str[25];
  /* Read up to 20 bytes from the standard input into the str buffer */
  int n = read(STDIN_FD, str, 29);
  /* Write n bytes from the str buffer to the standard output */
  int n1 = 0;
  int n2 = 0;
  int n3 = 0;
  int n4 = 0;
  int n5 = 0;
  //0123456789 
  //SDDDD SDDDD SDDDD SDDDD SDDDD\n
  for (int i = 1; i < 5; i++){
    n1 = n1 * 10 + str[i] - '0';
    
  }
  for (int i = 7; i < 11; i++){
    n2 = n2 * 10 + str[i] - '0';
  }
  for (int i = 13; i < 17; i++){
    n3 = n3 * 10 + str[i] - '0';
  }
  for (int i = 19; i < 23; i++){
    n4 = n4 * 10 + str[i] - '0';
  }
  for (int i = 25; i < 29; i++){
    n5 = n5 * 10 + str[i] - '0';
  }


  if(str[0] == '-'){
    n1 = -n1;
  }
  if(str[6] == '-'){
    n2 = -n2;
  }
  if(str[12] == '-'){
    n3 = -n3;
  }
  if(str[18] == '-'){
    n4 = -n4;
  }
  if(str[24] == '-'){
    n5 = -n5;
  }


  int resultado = 0;

  n5 = n5 & 0b1111111;
  n5 = n5 << 25;
  n4 = n4 & 0b1111;
  n4 = n4 << 21;
  n3 = n3 & 0b111111111;
  n3 = n3 << 12;
  n2 = n2 & 0b1111111;
  n2 = n2 << 5;
  n1 = n1 & 0b11111;

  resultado = resultado | n5;
  resultado |= n4;
  resultado |= n3;
  resultado |= n2;
  resultado |= n1;

  hex_code(resultado);
  return 0;
}
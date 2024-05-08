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

int hexa_deci(char *hexadecimal){

}


#define STDIN_FD  0
#define STDOUT_FD 1

int main()
{
  char str[20];
  /* Read up to 20 bytes from the standard input into the str buffer */
  int n = read(STDIN_FD, str, 20);
  char binario[32];
  char hexadecimal[8];
  char octal[16];
  int decimal = 0;
  
  /* Caso hexadecimal */
  if (str[0] == '0' && str[1] == 'x'){
    //copia a string hexadecimal
    int digito_atual = 0;
    while (str[digito_atual] != '\n'){
        hexadecimal[digito_atual] = str[digito_atual];
        digito_atual++;
    }

    //converte a string hexadecimal para binário
    digito_atual = 0;
    while (str[digito_atual] != '\n'){
        int digito;
        if (str[digito_atual] > 57){
            digito = str[digito_atual] - 'a' + 10;
        }
        else{
            digito = str[digito_atual];
        }
        int j = 0;
        while(digito / 2 != 1){
            int bit = digito % 2;
            binario[j] = bit;
            j++;

            digito = digito / 2;
        }
        digito_atual++;
    }
    binario[digito_atual] = '\n';

    //converte binário para decimal
    for (int i = 0; i < digito_atual; i++){
        decimal = 2 * decimal + binario[i];
    }

  }
  /*Decimal negativo*/
  else if(str[0] == '-'){

  }
  /*Decimal positivo*/
  else{
    //decimal
    int digito_atual = 0;
    while (str[digito_atual] != '\n'){
        decimal = 10 * decimal + str[digito_atual];
    }

    int aux = decimal;
    int digito;
    int j = 0;
    while (aux / 16 != 1)
    {
        digito = aux % 16;
        hexadecimal[j] = digito;

        aux = aux / 16;
        j++;
    }
    


    

  }
  write(STDOUT_FD, str, n);
  return 0;
}
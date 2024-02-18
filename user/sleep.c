#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"
/*Implement a user-level sleep program for xv6, along the lines of the UNIX sleep command. Your sleep should pause for a user-specified number of ticks. A tick is a notion of time defined by the xv6 kernel, namely the time between two interrupts from the timer chip. Your solution should be in the file user/sleep.c.*/
int main(int argc, char *argv[])
{
  if (argc != 2)
  {
    fprintf(2, "Usage: sleep <ticks>\n");
    exit(1);
  }
  printf("Sleeping for %d ticks\n", atoi(argv[1]));
  sleep(atoi(argv[1]));
  //print when the sleep is done
  printf("Done sleeping\n");
  exit(0);
}
#include <stdlib.h>
#include <stdio.h>

#include "utils.h"//

int main (int argc, char** argv) {
	print ("Hello, World!");

	char i = 1;
	if (1 < argc) print (argv[i]);

	print ("Good bye, World!");

	return EXIT_SUCCESS;
}
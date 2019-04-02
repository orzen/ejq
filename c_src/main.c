#include <stdio.h>
#include <stdlib.h>

#include "internal.h"

int main(int argc, char **argv) {
	struct ejq_state *ejq = NULL;
	char *res = NULL;

	ejq = calloc(1, sizeof(struct ejq_state));
	if (ejq == NULL) {
		return -1;
	}
	printf("query '%s', json '%s'\n", argv[1], argv[2]);

	res = parse(ejq, argv[1], argv[2]);
	printf("result '%s'\n", res);

	free(res);
	free(ejq);

	return 0;
}

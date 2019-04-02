#ifndef INTERNAL_H
#define INTERNAL_H

#include <jq.h>
#include <jv.h>

#define error(fmt, ...) fprintf(stderr, "EJQ_ERROR:%s:%s:%d "fmt, __FILE__, __func__, __LINE__, ##__VA_ARGS__)

struct ejq_state {
	jq_state *state;
	jv_parser *parser;
	int output_flags;
	int parser_flags;
};

char* parse(struct ejq_state *ejq, const char *query, const char *json);

#endif

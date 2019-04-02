#define _XOPEN_SOURCE 500

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <jq.h>
#include <jv.h>

#include "internal.h"

static void error_callback(void *data, jv msg) {
	fprintf(stderr, "jq_error: '%s'\n", jv_string_value(msg));
	jv_free(msg);
}

static int initialize(struct ejq_state **ejq) {
	jq_state *jq = NULL;
	struct ejq_state *e = NULL;

	if (ejq == NULL) {
		return -1;
	}

	jq = jq_init();
	if (jq == NULL) {
		return -1;
	}

	jq_set_error_cb(jq, error_callback, NULL);

	e = *ejq;

	e->state = jq;
	e->output_flags = 0;
	e->parser_flags = 0;
	e->parser = jv_parser_new(e->parser_flags);

	return 0;
}

static void teardown_jq(struct ejq_state *ejq) {
	if (ejq->parser != NULL) {
		jv_parser_free(ejq->parser);
		ejq->parser = NULL;
	}
	if (ejq->state != NULL) {
		jq_teardown(&ejq->state);
		ejq->state = NULL;
	}
}

static char* strconcat(const char *str1, const char *str2) {
	char *res = NULL;
	size_t len = 0;

	if (str1 == NULL || str2 == NULL) {
		return NULL;
	}

	len = strlen(str1) + strlen(str2) + 1;

	res = calloc(len, sizeof(char));

	res = strcpy(res, str1);
	res = strcat(res, str2);

	return res;
}

static char* process(struct ejq_state *ejq, jv value) {
	jv result;
	jv entry;
	const char *string = NULL;
	char *acc = strdup("");
	char *tmp = NULL;

	jq_start(ejq->state, value, 0);

	result = jq_next(ejq->state);
	while(jv_is_valid(result)) {
		//if (jv_get_kind(result) != JV_KIND_NULL) {
			entry = jv_dump_string(result, ejq->output_flags);
			string = jv_string_value(entry);

			tmp = strconcat(acc, string);
			free(acc);
			jv_free(entry);
			acc = tmp;
		//}

		result = jq_next(ejq->state);
	}

	jv_free(result);

	return acc;
}

static char* feed(struct ejq_state *ejq, const char *json_str, unsigned int json_len) {
	jv value;
	char *acc = strdup("");
	char *tmp = NULL;
	char *processed = NULL;

	jv_parser_set_buf(ejq->parser, json_str, json_len, 1);

	value = jv_parser_next(ejq->parser);
	while(jv_is_valid(value)) {
		processed = process(ejq, value);

		tmp = strconcat(acc, processed);
		free(acc);
		free(processed);
		acc = tmp;

		value = jv_parser_next(ejq->parser);
	}

	return acc;
}

char* parse(struct ejq_state *ejq, const char *query, const char *json) {
	char *res = NULL;
	int r = 0;

	if (query == NULL || json == NULL) {
		error("empty args\n");
		return NULL;
	}

	r = initialize(&ejq);
	if (r != 0) {
		error("jq_init_error\n");
		teardown_jq(ejq);
		return NULL;
	}

	if (!jq_compile(ejq->state, query)) {
		error("jq_compile_error\n");
		teardown_jq(ejq);
		return NULL;
	}

	res = feed(ejq, json, strlen(json));

	teardown_jq(ejq);

	return res;
}

#define _XOPEN_SOURCE 500

#include <stdio.h>
#include <string.h>

#include "erl_nif.h"
#include "ejq.h"
#include "internal.h"

struct priv_data {
	ErlNifResourceType *state_type;
};

ERL_NIF_TERM mkatom(ErlNifEnv *env, const char *atom);
ERL_NIF_TERM mkerr(ErlNifEnv *env, const char *msg);

ERL_NIF_TERM mkatom(ErlNifEnv *env, const char *atom) {
	ERL_NIF_TERM ret;

	if (!enif_make_existing_atom(env, atom, &ret, ERL_NIF_LATIN1)) {
		return enif_make_atom(env, atom);
	}

	return ret;
}

ERL_NIF_TERM mkerr(ErlNifEnv *env, const char *msg) {
	return enif_make_tuple2(env, mkatom(env, "error"), mkatom(env, msg));
}

static size_t get_enif_binary(ErlNifEnv *env,
                              ERL_NIF_TERM value,
                              char **output) {
	ErlNifBinary bin;
	char *tmp = NULL;

	if (output == NULL || *output != NULL) {
		error("bad args");
		return 0;
	}

	if(!enif_inspect_binary(env, value, &bin)) {
		error("failed to inspect binary");
		return 0;
	}

	tmp = calloc((bin.size + 1), sizeof(char));
	tmp = strncpy(tmp, (char *) bin.data, bin.size);
	tmp[bin.size] = '\0';

	*output = tmp;

	return bin.size;
}

static size_t get_enif_string(ErlNifEnv *env,
                              ERL_NIF_TERM term_str,
                              char **output) {
	int r = 0;
	unsigned int len = 0;
	char *buf = NULL;

	if (output == NULL || *output != NULL) {
		error("bad args");
		return 0;
	}

	r = enif_get_list_length(env, term_str, &len);
	if(!r) {
		fprintf(stderr, "%s:%s:%d: failed to determine length of string", __FILE__, __func__, __LINE__);
		return 0;
	}

	len += 1;

	buf = calloc(len, sizeof(char));
	if (buf == NULL) {
		fprintf(stderr, "%s:%s:%d: failed allocate string", __FILE__, __func__, __LINE__);
		return 0;
	}

	r = enif_get_string(env, term_str, buf, len, ERL_NIF_LATIN1);
	if (r == 0) {
		free(buf);
		fprintf(stderr, "%s:%s:%d: failed convert string", __FILE__, __func__, __LINE__);
		return 0;
	}

	*output = buf;
	return len;
}

static int term_to_char(ErlNifEnv *env,
                        ERL_NIF_TERM term,
                        char **output) {
	if (enif_is_binary(env, term)) {
		return get_enif_binary(env, term, output);
	} else if (enif_is_list(env, term)) {
		return get_enif_string(env, term, output);
	} else {
		error("bad term type");
		return 0;
	}
}

static void teardown(struct ejq_state *ejq) {
	enif_release_resource(ejq);
}

static ERL_NIF_TERM query_iface(ErlNifEnv *env,
                                int argc,
                                const ERL_NIF_TERM argv[]) {
	struct priv_data *priv = NULL;
	struct ejq_state *ejq = NULL;
	char *res = NULL;
	char *json = NULL;
	char *query = NULL;
	unsigned int len = 0;
	ERL_NIF_TERM ret;

	if (argc != 2) {
		return enif_make_badarg(env);
	}

	priv = enif_priv_data(env);
	ejq = enif_alloc_resource(priv->state_type,
	                          sizeof(struct ejq_state));
	if (ejq == NULL) {
		return mkerr(env, "jq_alloc_error");
	}

	//program == jq query
	len = term_to_char(env, argv[0], &query);
	if (len == 0) {
		return mkerr(env, "jq_arg_error");
	}

	len = term_to_char(env, argv[1], &json);
	if (len == 0) {
		return mkerr(env, "jq_arg_error");
	}

	res = parse(ejq, query, json);
	if (res == NULL) {
		return mkerr(env, "jq_internal_error");
	}

	ret = enif_make_string(env, res, ERL_NIF_LATIN1);

	teardown(ejq);
	free(res);
	free(query);
	free(json);

	return enif_make_tuple2(env, mkatom(env, "ok"), ret);
}

static ErlNifFunc nif_funcs[] = {
	{"query", 2, query_iface}
};

int load(ErlNifEnv *env, void **priv_data, ERL_NIF_TERM load_info) {
	struct priv_data *data = NULL;
	ErlNifResourceType *state_type = NULL;
	ErlNifResourceFlags tried;

	state_type = enif_open_resource_type(env,
	                                     NULL,
	                                     "ejq_state_type",
	                                     NULL,
	                                     ERL_NIF_RT_CREATE,
	                                     &tried);
	if (state_type == NULL) {
		return 1;
	}

	data = calloc(1, sizeof(struct priv_data));
	if (data == NULL) {
		return 1;
	}

	data->state_type = state_type;
	*priv_data = data;

	return 0;
}

void unload(__attribute__((unused)) ErlNifEnv *env, void *priv_data) {
	free(priv_data);
}

ERL_NIF_INIT(ejq, nif_funcs, load, NULL, NULL, unload);

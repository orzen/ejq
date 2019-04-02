#ifndef _EJQ_H_
#define _EJQ_H_


int load(ErlNifEnv *env, void **priv_data, ERL_NIF_TERM load_info);
void unload(__attribute__((unused)) ErlNifEnv *env, void *priv_data);

#endif

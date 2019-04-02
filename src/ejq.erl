-module(ejq).
-export([query/2]).
-on_load(init/0).

-include_lib("eunit/include/eunit.hrl").

-define(APPNAME, ?MODULE).
-define(LIBNAME, ?MODULE).

query(_, _) ->
    not_loaded(?LINE).

init() ->
    SO_name = case code:priv_dir(?APPNAME) of
        {error, bad_name} ->
            Path = filename:join(["..", priv]),
            case filelib:is_dir(Path) of
                true -> [Path, ?LIBNAME];
                false -> [priv, ?LIBNAME]
            end;
        Dir -> [Dir, ?LIBNAME]
    end,
    erlang:load_nif(filename:join(SO_name), 0).

not_loaded(Line) ->
    exit({not_loaded, [{module, ?MODULE}, {line, Line}]}).

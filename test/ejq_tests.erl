-module(ejq_tests).

-include_lib("eunit/include/eunit.hrl").
-define(MOD, ejq).
-define(DEBUG, true).

-define(RES0, "{\"sha\":\"e944fe843651b3044e5387c69b28b28f4999e9ea\",\"node_id\":\"MDY6Q29tbWl0NTEwMTE0MTplOTQ0ZmU4NDM2NTFiMzA0NGU1Mzg3YzY5YjI4YjI4ZjQ5OTllOWVh\",\"commit\":{\"author\":{\"name\":\"RicardoConstantino\",\"email\":\"wiiaboo@gmail.com\",\"date\":\"2019-05-29T19:36:18Z\"},\"committer\":{\"name\":\"NicoWilliams\",\"email\":\"nico@cryptonector.com\",\"date\":\"2019-06-11T16:57:02Z\"},\"message\":\"Makefile.am:fixbuiltin.incwithout-of-rootbuilds\",\"tree\":{\"sha\":\"b01b1c7994f97b782a75f552fd6226de3a3d201f\",\"url\":\"https://api.github.com/repos/stedolan/jq/git/trees/b01b1c7994f97b782a75f552fd6226de3a3d201f\"},\"url\":\"https://api.github.com/repos/stedolan/jq/git/commits/e944fe843651b3044e5387c69b28b28f4999e9ea\",\"comment_count\":0,\"verification\":{\"verified\":false,\"reason\":\"unsigned\",\"signature\":null,\"payload\":null}},\"url\":\"https://api.github.com/repos/stedolan/jq/commits/e944fe843651b3044e5387c69b28b28f4999e9ea\",\"html_url\":\"https://github.com/stedolan/jq/commit/e944fe843651b3044e5387c69b28b28f4999e9ea\",\"comments_url\":\"https://api.github.com/repos/stedolan/jq/commits/e944fe843651b3044e5387c69b28b28f4999e9ea/comments\",\"author\":{\"login\":\"wiiaboo\",\"id\":111605,\"node_id\":\"MDQ6VXNlcjExMTYwNQ==\",\"avatar_url\":\"https://avatars2.githubusercontent.com/u/111605?v=4\",\"gravatar_id\":\"\",\"url\":\"https://api.github.com/users/wiiaboo\",\"html_url\":\"https://github.com/wiiaboo\",\"followers_url\":\"https://api.github.com/users/wiiaboo/followers\",\"following_url\":\"https://api.github.com/users/wiiaboo/following{/other_user}\",\"gists_url\":\"https://api.github.com/users/wiiaboo/gists{/gist_id}\",\"starred_url\":\"https://api.github.com/users/wiiaboo/starred{/owner}{/repo}\",\"subscriptions_url\":\"https://api.github.com/users/wiiaboo/subscriptions\",\"organizations_url\":\"https://api.github.com/users/wiiaboo/orgs\",\"repos_url\":\"https://api.github.com/users/wiiaboo/repos\",\"events_url\":\"https://api.github.com/users/wiiaboo/events{/privacy}\",\"received_events_url\":\"https://api.github.com/users/wiiaboo/received_events\",\"type\":\"User\",\"site_admin\":false},\"committer\":{\"login\":\"nicowilliams\",\"id\":604851,\"node_id\":\"MDQ6VXNlcjYwNDg1MQ==\",\"avatar_url\":\"https://avatars2.githubusercontent.com/u/604851?v=4\",\"gravatar_id\":\"\",\"url\":\"https://api.github.com/users/nicowilliams\",\"html_url\":\"https://github.com/nicowilliams\",\"followers_url\":\"https://api.github.com/users/nicowilliams/followers\",\"following_url\":\"https://api.github.com/users/nicowilliams/following{/other_user}\",\"gists_url\":\"https://api.github.com/users/nicowilliams/gists{/gist_id}\",\"starred_url\":\"https://api.github.com/users/nicowilliams/starred{/owner}{/repo}\",\"subscriptions_url\":\"https://api.github.com/users/nicowilliams/subscriptions\",\"organizations_url\":\"https://api.github.com/users/nicowilliams/orgs\",\"repos_url\":\"https://api.github.com/users/nicowilliams/repos\",\"events_url\":\"https://api.github.com/users/nicowilliams/events{/privacy}\",\"received_events_url\":\"https://api.github.com/users/nicowilliams/received_events\",\"type\":\"User\",\"site_admin\":false},\"parents\":[{\"sha\":\"ad9fc9f559e78a764aac20f669f23cdd020cd943\",\"url\":\"https://api.github.com/repos/stedolan/jq/commits/ad9fc9f559e78a764aac20f669f23cdd020cd943\",\"html_url\":\"https://github.com/stedolan/jq/commit/ad9fc9f559e78a764aac20f669f23cdd020cd943\"}]}").

-define(RES1, "[{\"message\":\"Makefile.am:fixbuiltin.incwithout-of-rootbuilds\",\"name\":\"NicoWilliams\"},{\"message\":\"Improvejv_is_integer()\",\"name\":\"NicolasWilliams\"},{\"message\":\"jq_util_input_init:Zeromemoryusingcalloc\\n\\nCallocwillzerotheallocatedmemorywhichmakesonememsetanda\\nnumberofexplicitzeroassignmentsredundant.\",\"name\":\"NicoWilliams\"},{\"message\":\"Dockerfile:Uninstallonigurumabeforedistclean\\n\\nRun`makeuninstall`foronigurumabeforerunningtherecursive\\ndistcleanthatwillremoveoniguruma'sMakefileandcauseabuilderror\\nduetomissingmaketarget.\",\"name\":\"NicoWilliams\"},{\"message\":\"Dockerfile:Fetchdependencyasgitsubmodule\\n\\nFetchonigurumausinggitsubmoduleinsteadofareleasetarball.It\\nwillfixabuildproblem,causedbyjq'sautotoolsconfiguration,trying\\ntorun`makedistclean`recursivelyinanemptymodulesdirectory.This\\nwillalsoimprovethemaintainabilityoftheDockerfile.\",\"name\":\"NicoWilliams\"}]").

-define(RES2, "[{\"message\":\"Makefile.am:fixbuiltin.incwithout-of-rootbuilds\",\"name\":\"NicoWilliams\",\"parents\":[\"https://github.com/stedolan/jq/commit/ad9fc9f559e78a764aac20f669f23cdd020cd943\"]},{\"message\":\"Improvejv_is_integer()\",\"name\":\"NicolasWilliams\",\"parents\":[\"https://github.com/stedolan/jq/commit/263e1061ea03a10ba280ef820adf537ffd71f3c0\"]},{\"message\":\"jq_util_input_init:Zeromemoryusingcalloc\\n\\nCallocwillzerotheallocatedmemorywhichmakesonememsetanda\\nnumberofexplicitzeroassignmentsredundant.\",\"name\":\"NicoWilliams\",\"parents\":[\"https://github.com/stedolan/jq/commit/4f58a59f4d501390381522061b339af377c1c6dd\"]},{\"message\":\"Dockerfile:Uninstallonigurumabeforedistclean\\n\\nRun`makeuninstall`foronigurumabeforerunningtherecursive\\ndistcleanthatwillremoveoniguruma'sMakefileandcauseabuilderror\\nduetomissingmaketarget.\",\"name\":\"NicoWilliams\",\"parents\":[\"https://github.com/stedolan/jq/commit/584370127a49bf0663b864cb5b3a836ee8cb8399\"]},{\"message\":\"Dockerfile:Fetchdependencyasgitsubmodule\\n\\nFetchonigurumausinggitsubmoduleinsteadofareleasetarball.It\\nwillfixabuildproblem,causedbyjq'sautotoolsconfiguration,trying\\ntorun`makedistclean`recursivelyinanemptymodulesdirectory.This\\nwillalsoimprovethemaintainabilityoftheDockerfile.\",\"name\":\"NicoWilliams\",\"parents\":[\"https://github.com/stedolan/jq/commit/528a4f59450402b1fe97a6f20307e5187c190eb7\"]}]").

load_json(Filename) ->
    case file:read_file(Filename) of
        {ok, Binary} ->
            {ok, binary_to_list(Binary)};
        {error, Reason} ->
            {error, Reason}
    end.

query_test_() ->
   Data = load_json("test/test.json"),
   ?assertMatch({ok, _}, Data),
   {ok, Json} = Data,
   Stripped = re:replace(Json, "(\n+|\s+)", "", [global, {return, list}]),

   Load = fun() -> Stripped end,

   Query_and_result = [
                       {".", Stripped},
                       {".[0]", ?RES0},
                       {"[.[] | {message: .commit.message, name: .commit.committer.name}]", ?RES1},
                       {"[.[] | {message: .commit.message, name: .commit.committer.name, parents: [.parents[].html_url]}]", ?RES2}
                      ],

   Tests = [fun(Json_data) ->
                query_json(Json_data, Query, Result)
            end || {Query, Result} <- Query_and_result],

   {foreach, Load, Tests}.

query_json(Data, Query, Expected) ->
    {ok, Actual} = ?MOD:query(Query, Data),
    ?_assertEqual(Expected, Actual).

query_binary_test() ->
    Expected = "1",
    Query = <<".bar">>,
    Data = <<"{\"foo\": 0, \"bar\": 1}">>,
    {ok, Actual} = ?MOD:query(Query, Data),
    ?assertEqual(Expected, Actual).

non_matching_query_test() ->
    Expected = "null",
    Query = <<".baz">>,
    Data = <<"{\"foo\": 0, \"bar\": 1}">>,
    {ok, Actual} = ?MOD:query(Query, Data),
    ?assertEqual(Expected, Actual).

null_query_test() ->
    Expected = "[null,null]",
    Query = <<".">>,
    Data = <<"[null, null]">>,
    {ok, Actual} = ?MOD:query(Query, Data),
    ?assertEqual(Expected, Actual).

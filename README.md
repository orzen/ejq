ejq
=====
Erlang packing of https://stedolan.github.io/jq/

An OTP application

Build
-----

    $ rebar3 compile

Usage
-----

    1> ejq:parse(".bar", "{\"foo\": 0, \"bar\": 1}").
    2> "1"

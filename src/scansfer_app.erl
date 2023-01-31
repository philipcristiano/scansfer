%%%-------------------------------------------------------------------
%% @doc scansfer public API
%% @end
%%%-------------------------------------------------------------------

-module(scansfer_app).

-behaviour(application).

-include_lib("kernel/include/logger.hrl").

-export([start/2, stop/1]).

start(_Type, _Args) ->
    {ok, Pid} = scansfer_sup:start_link(),
    {ok, Pid}.

stop(_State) ->
    ok.

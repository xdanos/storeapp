%%%-------------------------------------------------------------------
%%% @author xtovarn
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. VIII 2015 17:46
%%%-------------------------------------------------------------------
-module(tcp_ets_store).
-author("xtovarn").

-behaviour(gen_tcp_server).

%% API
-export([handle_accept/2, handle_tcp/3, handle_close/3, start_link/2]).

-record(state, {name :: atom(), count :: integer(), buffer :: list()}).

%%%-----------------------------------------------------------------------------
%%% API functions
%%%-----------------------------------------------------------------------------

%% @doc Start a TCP echo server.
-spec start_link(atom(), integer()) -> {ok, pid()}.
start_link(Name, Port) ->
	gen_tcp_server:start_link(Name, ?MODULE, Port, [{packet, line}]).

%%%-----------------------------------------------------------------------------
%%% gen_tcp_server_handler callbacks
%%%-----------------------------------------------------------------------------

%% @private
handle_accept(_Socket, Name) ->
	{ok, #state{name = Name, count = 1, buffer = []}}.

%% @private
handle_tcp(_Socket, IoData, State = #state{count = Count, buffer = Buffer}) when Count rem 1000 == 0 ->
	ok = store_ets:store('node@kefalos.fi.muni.cz', Count, lists:reverse([IoData | Buffer])),
	{ok, State#state{count = Count + 1, buffer = []}};
handle_tcp(_Socket, IoData, State = #state{count = Count, buffer = Buffer}) ->
	{ok, State#state{count = Count + 1, buffer = [IoData | Buffer]}}.

%% @private
handle_close(_Socket, _Reason, _State) ->
	ok.

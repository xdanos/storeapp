%%%-------------------------------------------------------------------
%%% @author xtovarn
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. VIII 2015 17:46
%%%-------------------------------------------------------------------
-module(tcp_store).
-author("xtovarn").

-behaviour(gen_tcp_server).

%% API
-export([handle_accept/2, handle_tcp/3, handle_close/3, start_link/2]).

-record(state, {name :: atom()}).

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
	{ok, #state{name = Name}}.

%% @private
handle_tcp(_Socket, IoData, State) ->
	store_ets:store(IoData),
	{ok, State}.

%% @private
handle_close(_Socket, _Reason, _State) ->
	ok.

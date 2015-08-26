%%%-------------------------------------------------------------------
%%% @author xtovarn
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. VIII 2015 17:52
%%%-------------------------------------------------------------------
-module(store_ets).
-author("xtovarn").

-behaviour(gen_server).

%% API
-export([start_link/0, store/3]).

%% gen_server callbacks
-export([init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	terminate/2,
	code_change/3]).

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

store(Node, Id, IOData) ->
	gen_server:call({?MODULE, Node}, {store, {Id, IOData}}).

%%%===================================================================
%%% callbacks
%%%===================================================================

init([]) ->
	ets:new(mytable, [set, named_table]),
	{ok, #state{}}.

handle_call({store, {Id, IOData}}, _From, State) ->
	true = ets:insert(mytable, {Id, IOData}),
	{reply, ok, State}.

handle_cast(_Request, State) ->
	{noreply, State}.

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

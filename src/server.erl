%%%-------------------------------------------------------------------
%%% @author xtovarn
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. IX 2015 8:23
%%%-------------------------------------------------------------------
-module(server).
-author("xtovarn").

%% API
-export([start/1, client/2, server/1]).

start(Port) ->
	case gen_tcp:listen(Port, [binary, {active, true}, {packet, line}]) of
		{ok, ListenSock} ->
			spawn(?MODULE, server, [ListenSock]),
			{ok, ListenSock};
		{error, Reason} ->
			{error, Reason}
	end.

server(LS) ->
	case gen_tcp:accept(LS) of
		{ok, S} ->
			io:format("connected, in loop!~n", []),
			loop(S);
		Other ->
			io:format("accept returned ~w - goodbye!~n", [Other]),
			ok
	end.

loop(S) ->
	receive
		{tcp, _Socket, Data} ->
			io:format("Received ~p~n", [Data]),
			loop(S);
		{tcp_closed, S} ->
			io:format("Socket ~w closed [~w]~n", [S, self()]),
			ok
	end.

client(PortNo, Message) ->
	{ok, Sock} = gen_tcp:connect("localhost", PortNo, [binary, {active, false}, {packet, 2}]),
	gen_tcp:send(Sock, Message),
	{ok, A} = gen_tcp:recv(Sock, 0),
	gen_tcp:close(Sock),
	A.
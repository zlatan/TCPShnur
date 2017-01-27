-module(echo_protocol).
-behaviour(ranch_protocol).

-export([start_link/4,init/4]).

start_link(Ref, Socket, Transport, Opts) ->
	Pid = spawn_link(?MODULE, init, [Ref, Socket, Transport, Opts]),
	{ok, Pid}.

init(Ref, Socket, Transport, _Opts = []) ->
	ok = ranch:accept_ack(Ref),
	loop(Socket, Transport).


loop(Socket, Transport) ->
	case Transport:recv(Socket, 0, 500000) of
		{ok, Data} when Data =/= <<4>> ->
			 db:insert(binary_to_list(Data),self()),
			receive
				test ->
					Transport:send(Socket, "Data..."),
					loop(Socket, Transport);
				stop ->
					true
			end,
			loop(Socket, Transport);
		_ ->
			ok = Transport:close(Socket)
  end.

-module(tcp_shnur_app).
-behaviour(application).

-export([start/2,stop/1]).

start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/", toppage_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(http, 1, [{port, 8080}], #{
		env => #{dispatch => Dispatch}
	}),
	{ok, _} = ranch:start_listener(tcp_shnur_listener, 1, ranch_tcp, [{port, 5555}], echo_protocol, []),
	db:init(),
	tcp_shnur_sup:start_link().

stop(_State) ->
	ok.

-module(db).
-export([insert/2,get/1, search/1, init/0]).

-record(data, {key, value}).

init() ->
mnesia:start(),
mnesia:create_table(data, [{ram_copies, [node()]}, {attributes, record_info(fields, data)}]).


insert(Key, Val) ->
    Record = #data{key = Key, value = Val},
    F = fun() ->
		mnesia:write(Record)
	end,
    mnesia:transaction(F).

retrieve(Key) ->
    F = fun() ->
		mnesia:read({data, Key})
	end,
    {atomic, Data} = mnesia:transaction(F),
    Data.

get(Key) ->
  Result = lists:nth(1, retrieve(Key)),
  Result#data.value.

search(Val) ->
    F = fun() ->
		mnesia:match_object(#data{key = '_', value = Val})
	end,
    {atomic, Data} = mnesia:transaction(F),
    Data.

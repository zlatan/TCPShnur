-module(db).
-export([insert/2,get/1, search/1, init/0]).
-record(data, {key, value}).

-export([retrieve/1]).

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
  Akey=atom_to_list(Key),
  Result = lists:nth(1, retrieve(Akey)),
  Result#data.value.

search(Val) ->
    F = fun() ->
		mnesia:match_object(#data{key = '_', value = Val})
	end,
    {atomic, Data} = mnesia:transaction(F),
    Data.

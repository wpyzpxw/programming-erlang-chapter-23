-module (sellaprime_supervisor).
-behaviour (supervisor).

-export ([start/0, start_link/1, start_in_shell_for_testing/0]).
-export ([init/1]).

start() ->
    spawn(fun() ->
        supervisor:start_link({local, ?MODULE}, ?MODULE, _Arg = [])
    end).

start_in_shell_for_testing() ->
    {ok, Pid} = supervisor:start_link({local, ?MODULE}, ?MODULE, _Arg = []),
    unlink(Pid).

start_link(Args) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

init([]) ->
    gen_event:swap_handler(alarm_handler,
        {alarm_handler, swap},
        {my_alarm_handler, xyz}),
    {ok,
        {
            {one_for_one, 3, 10},
            [{tag1,
                {area_server, start_link, []},
                permanent,
                10000,
                worker,
                [area_server]},
            {tag2,
                {prime_server, start_link, []},
                permanent,
                10000,
                worker,
                [prime_server]},
            {tag3,
                {queue_server, start_link, []},
                permanent,
                10000,
                worker,
                [queue_server]},
            {tag4,
                {prime_tester_server, start_link, []},
                permanent,
                10000,
                worker,
                [prime_tester_server]}]}}.

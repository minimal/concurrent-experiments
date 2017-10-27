#!/usr/bin/env swipl

:- initialization main.

main :-
    thread_self(Me),
    thread_create((thread_get_message(X),
                   thread_get_message(Y),
                   thread_get_message(Z),
                   Sum is X + Y + Z,
                   swritef(Res, '%w + %w + %w = %w', [X, Y, Z, Sum]),
                   thread_send_message(Me, Res, [])), Proc, []),
    thread_create((X is 2 * 10, thread_send_message(Proc, X, [])), Id1, []),
    thread_create((X is 2 * 20, thread_send_message(Proc, X, [])), Id2, []),
    thread_create((X is 30 + 40, thread_send_message(Proc, X, [])), Id3, []),
    thread_join(Id1, true),
    thread_join(Id2, true),
    thread_join(Id3, true),
    thread_get_message(Result),
    writef(Result).

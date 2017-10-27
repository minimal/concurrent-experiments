#!/usr/bin/env swipl

:- initialization main.

proc(Return) :-
    thread_get_message(X),
    thread_get_message(Y),
    thread_get_message(Z),
    Sum is X + Y + Z,
    swritef(Res, '%w + %w + %w = %w', [X, Y, Z, Sum]),
    thread_send_message(Return, Res, []).

main :-
    thread_self(Me),
    thread_create(proc(Me), Proc, []),
    thread_create((X is 2 * 10, thread_send_message(Proc, X, [])), _, []),
    thread_create((X is 2 * 20, thread_send_message(Proc, X, [])), _, []),
    thread_create((X is 30 + 40, thread_send_message(Proc, X, [])), _, []),
    thread_get_message(Result),
    writef(Result).

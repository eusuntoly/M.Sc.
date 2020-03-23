solve(KB, WM, Goal) :-
    member(Rule, KB),
    Rule = [Conditions, [Action]|_], 
    \+member(Action, WM),
    foreach(member(Condition, Conditions), member(Condition, WM)),
    solve(KB, [Action|WM], Goal).
solve(_, WM, Goal) :- member(Goal, WM), writeln(WM), told, writeln("YES"), !.
solve(_, WM, _) :- writeln(WM), told, writeln("NO").

process_number(Line, 0, N) :-
    string(Line),
    atom_number(Line, N).
process_number("stop", 1, _) :-
    write('Finished'), nl, !, true.

process_string(Line, 0, Line) :-
    string(Line).
process_string("stop", 1, _) :-
    write('Finished'), nl, !, true.


read_input(KB, Goal) :-
    L = [],
    Rsp = "yes",

    writeln("What is patient temperature?"),
    read_string(user_input, "\n", "\r\t ", _, Line1),
    process_number(Line1, Stop1, Value1),
    (Stop1 =:= 1, halt ; true),
    (Value1 > 38, L1 = [temperature|L] ; L1 = L),

    writeln("For how many days has the patient been sick?"),
    read_string(user_input, "\n", "\r\t ", _, Line2),
    process_number(Line2, Stop2, Value2),
    (Stop2 =:= 1, halt ; true),
    (Value2 >= 2, L2 = [sick|L1] ; L2 = L1),

    writeln("Has patient muscle pain?"),
    read_string(user_input, "\n", "\r\t ", _, Line3),
    process_string(Line3, Stop3, Value3),
    (Stop3 =:= 1, halt ; true),
    (Value3 = Rsp, L3 = [musclepain|L2] ; L3 = L2),

    writeln("Has patient cough?"),
    read_string(user_input, "\n", "\r\t ", _, Line4),
    process_string(Line4, Stop4, Value4),
    (Stop4 =:= 1, halt ; true),
    (Value4 = Rsp, L4 = [cough|L3] ; L4 = L3),

    tell('/home/bogdan.olaru/Documents/Knowledge Representations and Reasoning/Laboratory/Laboratory 6/output.txt'),
    writeln(L),
    writeln(L4),
    solve(KB, L4, Goal),

    read_input(KB, Goal).

main :-
    see('/home/bogdan.olaru/Documents/Knowledge Representations and Reasoning/Laboratory/Laboratory 6/kb.txt'),
    read(KB),
    read(Goal),
    seen,
    read_input(KB, Goal).
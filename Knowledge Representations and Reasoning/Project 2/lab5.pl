neggation(n(X), X) :- !.
neggation(X, n(X)).

positive(n(_)) :- !, fail.
positive(_).

solveBC(_, [], 1).
solveBC(KB, [H|T], R) :- 
    member(L, KB), 
    member(H, L), 
    delete(L, H, Li), 
    maplist(neggation, Li, ML), 
    append(ML, T, Goals), 
    solveBC(KB, Goals, R), !.
solveBC(_, _, 0).

solveFC(_, [], 1).
solveFC(KB, Goals, R) :-
    member(L, KB), 
    member(P, L), 
    positive(P), 
    \+member([P], KB), 
    delete(L, P, Li), 
    maplist(neggation, Li, ML),
    foreach(member(El, ML), member([El], KB)),
    delete(Goals, P, G),
    delete(KB, L, NKB),
    solveFC([[P]|NKB], G, R), !.
solveFC(_, _, 0).

process_number(Line, 0, N) :-
    string(Line),
    atom_number(Line, N).
process_number("stop", 1, _) :-
    write('Finished'), nl, !, true.

process_string(Line, 0, Line) :-
    string(Line).
process_string("stop", 1, _) :-
    write('Finished'), nl, !, true.

read_input(KB) :-
    L = [],
    R = "yes",

    writeln("What is patient temperature?"),
    read_string(user_input, "\n", "\r\t ", _, Line1),
    process_number(Line1, Stop1, Value1),
    (Stop1 =:= 1, halt ; true),
    (Value1 > 38, L1 = [[temperature]|L] ; L1 = L),

    writeln("For how many days has the patient been sick?"),
    read_string(user_input, "\n", "\r\t ", _, Line2),
    process_number(Line2, Stop2, Value2),
    (Stop2 =:= 1, halt ; true),
    (Value2 >= 2, L2 = [[sick]|L1] ; L2 = L1),

    writeln("Has patient cough?"),
    read_string(user_input, "\n", "\r\t ", _, Line3),
    process_string(Line3, Stop3, Value3),
    (Stop3 =:= 1, halt ; true),
    (Value3 = R, L3 = [[cough]|L2] ; L3 = L2),

    append(KB, L3, Kb),
    solveBC(Kb, [pneumonia], R1),
    solveFC(Kb, [pneumonia], R2),
    nl,
    (R1 =:= 1, writeln("Backward chaining: Patient has pneumonia."); writeln("Backward chaining: Patient doesn't have pneumonia.")),
    (R2 =:= 1, writeln("Forward chaining: Patient has pneumonia."); writeln("Forward chaining: Patient doesn't have pneumonia.")),
    nl,

    read_input(KB).

main :-
    see('/home/bogdan.olaru/Documents/Knowledge Representations and Reasoning/Laboratory/Laboratory 5/kb.txt'),
    read(KB),
    seen,
    read_input(KB).
printLiterals([]).
printLiterals([H|T]) :-
    write(H),
    ( value(H) -> write(' / true') ; write(' / false') ),
    nl,
    printLiterals(T).

elim([], _, _, []).
elim([H|T], X, XN, [H|T1]) :-
    \+ member(X, H),
    \+ member(XN, H),
    elim(T, X, XN, T1), !.
elim([H|T], X, XN, [H1|T1]) :-
    \+ member(X, H),
    member(XN, H),
    select(XN, H, H1),
    elim(T, X, XN, T1), !.
elim([_|T], X, XN, T1) :-
    elim(T, X, XN, T1), !.

element_count(X, N, L) :-
    aggregate(count, member(X, L), N).
max_element_count(X, N, L) :-
    aggregate(max(N1), X1, element_count(X1, N1, L), N),
    member(X, L),
    element_count(X, N, L),
    !.    

min_element_count(X, N, L) :-
    aggregate(min(N1), X1, element_count(X1, N1, L), N),
    member(X, L),
    element_count(X, N, L),
    !. 

chooseLiteral_max(C, Literal) :- append(C, Cflat), extractLiterals(Cflat, List), max_element_count(Literal, _, List).
chooseLiteral_min(C, Literal) :- append(C, Cflat), extractLiterals(Cflat, List), min_element_count(Literal, _, List).

extractLiterals([], []).
extractLiterals([n(H)|T], [H|T1]) :- extractLiterals(T, T1).
extractLiterals([H|T], [H|T1]) :- extractLiterals(T, T1).

dp([], Literals) :- write('YES'), nl, printLiterals(Literals), !.
dp(C, _) :- member([], C), !, fail.
dp(C, Literals) :-
    chooseLiteral_min(C, L),
    (
        elim(C, L, n(L), Cp), dp(Cp, [L|Literals]), asserta(value(L) :- true)
        ;
        elim(C, n(L), L, Cnp), !, asserta(value(L) :- false), dp(Cnp, [L|Literals])
    ).
main :-
    see('C:/Users/Oly/OneDrive/Master/Anul I/Semestrul I/Knowledge Representations and Reasoning/Laboratory/Laboratory 3/input.txt'),
    read(C),
    seen,
    retractall(value(L) :- false),
    tell('C:/Users/Oly/OneDrive/Master/Anul I/Semestrul I/Knowledge Representations and Reasoning/Laboratory/Laboratory 3/output.txt'),
    ( dp(C, []) ; write('NO') ),
    told.
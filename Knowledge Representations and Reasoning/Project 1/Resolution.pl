isSubset([], _).
isSubset([H|T], Y):-
    member(H, Y),
    select(H, Y, Z),
    isSubset(T, Z).

equal(X, Y):-
    isSubset(X, Y),
    isSubset(Y, X).

membru(L1, [H|_]) :- equal(L1, H), !.
membru(L1, [_|T]) :- membru(L1, T).

neggation(n(X), X) :- !.
neggation(X, n(X)).
solve(L) :-
    member(L1, L),
    member(L2, L), 
    L1 \= L2, 
    member(X, L1), 
    neggation(X, XN), 
    member(XN, L2), 
    union(L1, L2, L3), 
    subtract(L3, [X, XN], L4), 
    (   L4 == [], 
        tell('C:/Users/Oly/OneDrive/Master/Anul I/Semestrul I/Knowledge Representations and Reasoning/Laboratory/Laboratory 3/output.txt'), 
        write('UNSATISFIABLE'), 
        told, ! 
        ; 
        \+ membru(L4, L), 
        solve([L4|L]), !
    ).                                                                                                                                            
solve(_) :-
    tell('C:/Users/Oly/OneDrive/Master/Anul I/Semestrul I/Knowledge Representations and Reasoning/Laboratory/Laboratory 3/output.txt'), 
    write('SATISFIABLE'), 
    told.
main :-
    see('C:/Users/Oly/OneDrive/Master/Anul I/Semestrul I/Knowledge Representations and Reasoning/Laboratory/Laboratory 3/input.txt'), 
    read(L), 
    seen, 
    solve(L).
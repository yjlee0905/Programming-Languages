% 2. Prolog Rules

mem(X, [X|_]).
mem(X, [_|T]) :- mem(X, T).

% 2-1
remove_item(_, [], []) :- !.
remove_item(I, [I | T], O) :- remove_item(I, T, O), !.
remove_item(I, [H | T], [H | O]) :- remove_item(I, T, O).

% remove_item(2,[1,2,2,3,4,2,5,4],O).
% remove_item(2,[],O).


% 2-2
remove_items([], [], []).
remove_items([], L, L).
remove_items([X|I], L, O) :- mem(X,L), remove_item(X,L,R), remove_items(I, R, O), !.
remove_items([X|I], L, O) :- not(mem(X,L)), remove_items(I, L, O), !.

% remove_items([1,2,3],[1,1,2,3,4,5,2,2],O).
% remove_items([1,2,3],[],O).
% remove_items([],[1,2,3],O).


% 2-3
intersection2([], _, []).
intersection2([X|L1], L2, [X|F]) :- remove_dups(L1, R1), remove_dups(L2, R2), mem(X, R2), intersection2(R1, R2, F),!. % TODO check
intersection2([X|L1], L2, F) :- remove_dups(L1, R1), remove_dups(L2, R2), not(mem(X, R2)), intersection2(R1, R2, F).

% intersection2([1,2,3,2],[2,2,3,4],F).
% intersection2([],[2,2,3,4],F).


% 2-4
is_set([]). % true
is_set([H|T]) :- not(mem(H, T)), !, is_set(T). % and return false

% is_set([]).
% is_set([1,2,3]).
% is_set([1,2,3,4,3,3]).


% 2-5 
concatenate([], L2, L2).
concatenate([H|L1], L2, [H|O]) :- concatenate(L1, L2, O).

disjunct_union([], L2, U) :- remove_dups(L2, U),!.
disjunct_union(L1, [], U) :- remove_dups(L1, U),!.
disjunct_union(L1, L2, U) :- concatenate(L1, L2, O), intersection2(L1, L2, I), remove_items(I, O, X), remove_dups(X, U).

% disjunct_union([1,2,3],[2,3,4,5,6,5,5],O).
% disjunct_union([],[2,3,4,5,6,5,5],O).
% disjunct_union([1,2,3,2],[],O).
% disjunct_union([1,2,3],[3,4,5],O).
% disjunct_union([1,2,3],[4,5],O).


% 2-6
remove_dups([],[]).
remove_dups([H|T], [H|R]) :- mem(H,T),!, remove_item(H,T,R1), remove_dups(R1, R),!.
remove_dups([H|T], [H|R]) :- remove_dups(T, R).

% remove_dups([1,2,2,3,4,2,5],L2).
% remove_dups([],L2).


% 2-7
union([], [], []) :- !.
union(L1, [], U) :- remove_dups(L1, U),!.
union([], L2, U) :- remove_dups(L2, U),!.
union(L1, [H2|T2], U) :- mem(H2,L1), union(L1,T2,U).
union(L1, [H2|T2], [H2|U]) :- not(mem(H2,L1)), union(L1,T2,U).

% union([],[],U).
% union([],[3,3,4,5,3,3],U).
% union([1,1,2,3,3],[],U).
% union([1,1,2,3,3],[2,2,3,3,5],U).
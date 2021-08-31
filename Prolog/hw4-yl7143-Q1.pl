/**
 * 1. Investigating Prolog
 *  This file only contains 
 *		- re-ordered facts and brief explanation(1-1.)
 * 		- new rules: aunt, uncle(1-4.)
 *	Rest of the solution for #1 is in hw4-sols.pdf
 */

% (1-1) re-ordered facts
male(tom). % for the faster execution (though not showed in trace)
male(brian).
male(kevin).
male(zhane).
male(fred).
male(jake).
male(bob).
male(stephen).
male(paul).

parent(tom,stephen). % This rule should comes before 'parent(tom,mary)' to prevent backtracking
parent(stephen,jennifer). % for the faster execution (though not showed in trace)
parent(tom,mary). % for the faster execution (though not showed in trace)
parent(melissa,brian).
parent(mary,sarah).
parent(bob,jane).
parent(paul,kevin).
parent(jake,bob).
parent(zhane,melissa).
parent(stephen,paul).
parent(emily,bob).
parent(zhane,mary).

grandfather(X,Y) :- male(X), parent(X,Z), parent(Z,Y).

% (1-4) new rules for aunt and uncle
female(melissa).
female(mary).
female(jennifer).

parent(tom,melissa).
parent(zhane,stephen).

grandparent(X,Y) :- parent(X,Z), parent(Z,Y).
aunt(X,Y) :- female(X), not(parent(X,Y)), parent(Z,X), grandparent(Z,Y).
uncle(X,Y) :- male(X), not(parent(X,Y)), parent(Z,X), grandparent(Z,Y).

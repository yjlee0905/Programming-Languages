% 4-1 : used $ instead of @
user($tony,public).
user($melissa,public).
user($jennifer,public).
user($lucy,public).
user($lucas,public).
user($kim,protected).
user($lee,protected).
user($alice,protected). % not followed by anyone

user($u1,public).
user($u2,public).
user($u3,public).
user($u4,public).
user($u5,public).


% 4-2 : follows(X,Y) > X follows Y
follows(user($u1,public),user($u2,public)).
follows(user($u2,public),user($u3,public)).
follows(user($u3,public),user($u4,public)).
follows(user($u4,public),user($u5,public)).

follows(user($tony, public), user($melissa, public)).
follows(user($kim,protected), user($lee,protected)).
follows(user($kim,protected), user($lucas,public)).
follows(user($kim,protected), user($lucy,public)).
follows(user($kim,protected), user($jennifer,public)).
follows(user($lucas,public), user($lucy,public)).
follows(user($lucas,public), user($tony,public)).
follows(user($lucas,public), user($lee,protected)).
follows(user($lucas,public), user($kim,protected)).
follows(user($lee,protected), user($kim,protected)).
follows(user($lee,protected), user($lucas,public)).
follows(user($lee,protected), user($jennifer,public)).
follows(user($alice,protected), user($jennifer,public)).
follows(user($jennifer,public), user($kim,protected)).
follows(user($jennifer,public), user($lee,protected)).


% 4-3
tweet(user($tony,public), 0, [$tony, this, is, some, message]).
tweet(user($tony,public), 1, [$tony, this, is, some, message]).
tweet(user($tony,public), 2, [$tony, new, message, is, posted]).
tweet(user($lucy,public), 3, [$lucy, hello, world, of, prolog]).
tweet(user($kim,protected), 4, [$kim, this, is, my, first, posting]).
tweet(user($kim,protected), 5, [$kim, this, is, my, second, posting]).
tweet(user($lee,protected), 6, [$lee, i, hope, to, finish, this, assignment, successfully]).
tweet(user($lee,protected), 7, [$lee, please]).
tweet(user($lee,protected), 8, [$lee, please, please]).
tweet(user($lee,protected), 9, [$lee, my, simple, twitter, in, prolog]).
tweet(user($lucas,public), 10, [$lucas, star, wars, series]).
tweet(user($lucas,public), 11, [$lucas, love, movies]).
tweet(user($jennifer,public), 12, [$jennifer, hello, twitter]).
tweet(user($jennifer,public), 13, [$jennifer, test1]).
tweet(user($jennifer,public), 14, [$jennifer, account, for, testing]).

tweet(user($u5,public), 15, [$u5, test, is, viral]).


% 4-4 : retweet(U,I) > user U retweets the tweet identified by I

%retweet(user(X,P), I) :- tweet(user(U, public), I, M).
%retweet(user(X,P), I) :- tweet(user(U, protected), I, M), follows(user(X,P), user(U, protected)).
%retweet should be facts, because just within the rules as above we cannot know the user will do retweet or not.

retweet(user($lucas,public), 1).
retweet(user($melissa,public), 1).
retweet(user($lee,protected), 5).
retweet(user($jennifer,public), 5).
retweet(user($lucas,public), 7).

retweet(user($u1,public),15).
retweet(user($u2,public),15).
retweet(user($u3,public),15).
retweet(user($u4,public),15).


% 4-5
get_protected_retweeted_message(U,F,I,M) :- retweet(user(F,_),I), tweet(user(O,protected),I,M), follows(user(U,_),user(O,protected)).
get_public_retweeted_message(F,I,M) :- retweet(user(F,_),I), tweet(user(_,public),I,M).
get_retweeted_message(U,F,I,M) :- get_public_retweeted_message(F,I,M);get_protected_retweeted_message(U,F,I,M).

get_messages(U,F,M,I) :- tweet(user(F,_),I,M);get_retweeted_message(U,F,I,M).
feedhelper(U,F,M,I) :- follows(user(U,_),user(F,_)), get_messages(U,F,M,I).

feed(U,M) :- uniquefeed(U,O), remove_ident(O,M).

uniquefeed(U,R) :- setof([I,F|M], feedhelper(U,F,M,I),R).

remove_ident([],[]).
remove_ident([[_|Y]|T1], [H2|T2]) :- Y=H2, remove_ident(T1,T2).


% 4-6 search only permits to public, not protected
mem(X, [X|_]).
mem(X, [_|T]) :- mem(X, T).

search(K,U,M) :- tweet(U, _, M), mem(K, M), U = user(_, public).


% 4-7
isviralhelper(S,I,X) :- S=X ; retweet(user(X,_),I).
isviral(S,I,S).
isviral(S,I,R) :- follows(user(R,_),user(X,_)), isviralhelper(S,I,X), isviral(S,I,X),!.


% 4-8
isviral(S,I,S,M) :- M =< 0.
isviral(S,I,R,M) :- follows(user(R,_),user(X,_)), isviralhelper(S,I,X), M1 is M-1, isviral(S,I,X,M1),!.

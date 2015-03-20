%% Name: Jonathan Munoz
%% Email: big.cheddar@vanderbilt.edu
%% VUnetID: munozja
%% Class: 2015
%% Date: 11/27/14
%% Honor Statement: I have not receive unauthorized help on this
%% assignment.

%% Complete description:  <<Your job to write this>>


%% use routines from the Constraint Logic Programming over Finite Domains library
:- use_module(library('clpfd')).

%% see "library clpfd: Constraint Logic Programming over Finite Domains" in
%% the provided SWI-clpfd.pdf file.


%% go is the main entry point. Enter "go." at the Prolog prompt
%%
go :-
	File = 'C:\\cs270\\prolog\\sudoku.txt',
	%File ='C:\\s.txt',
	start(File).


%% Do not change the following function, as our
%% testing script depends upon it.
%% You are free to make functions similar to it for your
%% own testing purposes.
%%
start(File) :-
	see(File),		% open file
	write(trying_file(File)),nl,nl,
	read(Board),
	seen,                   % close file
	time(sudoku(Board)),    % call your solver here, passing it the Board (with timer)
	%sudoku(Board),         % call your solver here, passing it the Board (without timer)
	pretty_sudo_print(Board),nl.




pretty_sudo_print(Board) :-
	Board = [R1,R2,R3,R4,R5,R6,R7,R8,R9],
	nl,nl,
	printsudorow(R1),
	printsudorow(R2),
	printsudorow(R3),
	write('-------+-------+-------'), nl,
	printsudorow(R4),
	printsudorow(R5),
	printsudorow(R6),
	write('-------+-------+-------'), nl,
	printsudorow(R7),
	printsudorow(R8),
	printsudorow(R9).

printsudorow(Row) :-
	Row = [C1,C2,C3,C4,C5,C6,C7,C8,C9],
	write(' '),
	write(C1), write(' '),
	write(C2), write(' '),
	write(C3), write(' '), write('|'), write(' '),
	write(C4), write(' '),
	write(C5), write(' '),
	write(C6), write(' '), write('|'), write(' '),
	write(C7), write(' '),
	write(C8), write(' '),
	write(C9), write(' '), nl.





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Main driver: sudoku(Board)
%%
%% Your job is to write this and any other needed predicates:
%%
%% This predicate should contain your rules for solving Sudoku.
%% If the puzzle can be solved, the unknowns in Board should be
%% replaced with the answer. If the puzzle cannot be solved,
%% "No" or "False" should be produced by the Prolog interpreter.
%%



sudoku(Board) :-

	%Domain
	append(Board,Numbers), %Ensures the list of lists containing values in board fit the domain given by numbers
	Numbers ins 1..9, %Defines a list of numbers as the values in the domain 1 through 9.

	%Rows
	maplist(all_distinct,Board), %Maps the all_distinct function to every row in the board which returns true if all integer values are unique

	%Blocks
	Board =[Row1,Row2,Row3,Row4,Row5,Row6,Row7,Row8,Row9], %Places each list into its designated row
	blocks(Row1,Row2,Row3), %Check the first row
	blocks(Row4,Row5,Row6), %Check the second row
	blocks(Row7,Row8,Row9), %Check the third row

	%Columns
	transpose(Board,ColumnLists), %Rotates the board so the board is now a list of the columns
	maplist(all_distinct,ColumnLists), %maps the all_distinct function to every row in the board which returns true if all integer values are unique

	%Systematic execution
	maplist(label,Board).  %Maps the label function to every row which systematically plugs in possible values


blocks([],[],[]). %Return true if block lists are null
blocks([RowTopFirst,RowTopSecond,RowTopThird|RowTopNext], [RowMiddleFirst,RowMiddleSecond,RowMiddleThird|RowMiddleNext], [RowBottomFirst,RowBottomSecond,RowBottomThird|RowBottomNext]) :-
  all_distinct([RowTopFirst,RowTopSecond,RowTopThird,RowMiddleFirst,RowMiddleSecond, RowMiddleThird,RowBottomFirst,RowBottomSecond,RowBottomThird]),
  blocks(RowTopNext,RowMiddleNext,RowBottomNext).

% Check the first three numbers in all three lists (which is essentially
% a block) to see if they are all distinct. Then, recursively check the
% tails of these lists until the lists are null (which returns true).

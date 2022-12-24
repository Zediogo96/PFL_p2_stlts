% Includes 
:- use_module(library(lists)).

% Consults
:- consult('frontend.pl').
:- consult('menu.pl').
:- consult('game_data.pl').
:- consult('game_logic.pl').
:- consult('utils.pl').

read_codes(Stream, []) :-
    at_end_of_stream(Stream).
read_codes(Stream, [Code|Codes]) :-
    get_code(Stream, Code),
    (   Code = 10
    ->  Codes = []
    ;   read_codes(Stream, Codes)
    ).
read_codes(Stream, [Code|Codes]) :-
    get_code(Stream, Code),
    Code = 32,
    read_codes(Stream, Codes).


% Main menu
% main :-
%     write('Value: '),
%     read_input_atom(Atom),
%     write('Atom: '),
%     write(Atom),
%     atomic_list_concat(Atom, ' ', Atoms),   
%     nth0(0, Atoms, FirstAtom),
%     write('First atom: '),
%     write(FirstAtom),
%     nl,
%     nth0(1, Atoms, SecondAtom),
%     write('Second atom: '),
%     write(SecondAtom),
%     nl,
%     nth0(2, Atoms, ThirdAtom),
%     write('Third atom: '),
%     write(ThirdAtom),
%     nl,
%     nth0(3, Atoms, FourthAtom),
%     write('Fourth atom: '),
%     write(FourthAtom),
%     nl.
    


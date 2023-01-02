% Includes 
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).

% Consults
:- reconsult('frontend.pl').
:- reconsult('menu.pl').
:- reconsult('game_data.pl').
:- reconsult('game_logic.pl').
:- reconsult('utils.pl').
:- reconsult('bot.pl').

% Main predicate
play :- menu.

% C19749651
% Bryan McCarthy
% Financial Advisor

% declare predicates and their arity 
:- dynamic invest_in/1.
:- dynamic savings_account/1.
:- discontiguous savings_account/1.
:- dynamic min_savings/2.
:- dynamic min_income/2.
:- dynamic max_dept/2.
:- dynamic earnings/2.
:- dynamic riskTolerance/1.



% rule 1 - if users savings amount is inadequate then they will be advised 
% to invest in savings

invest_in(savings) :- 
	savings_account(inadequate).
	

% rule 2 - if users savings amount is adequate and their income is adequate 
% then they will be advised to invest in stocks

invest_in(stocks) :- 
	savings_account(adequate), 
	income(adequate).


% rule 3 - if users savings amount is adequate and users income is inadequate
% then they will be advised to invest in a combination

invest_in(combination) :- 
	savings_account(adequate), 
	income(inadequate).


% rules 4 & 5 - if users savings amount is less than or equal to mimimum savings 
% then savings_account is inadequate

savings_account(A) :-
	amount_saved(S),
	numDependents(D),
	min_savings(D, MS),
	(S > MS,
	A = adequate;
	S =< MS, 
	A = inadequate).


% rules 6 & 7 - if users income is less then or equal to minimum income
% then income is inadequate 

income(A) :-
	earnings(E, steady),
	numDependents(D),
	min_income(D, MI),
	(E > MI, 
	A = adequate;
	E =< MI,
	A = inadequate).


% rule 8 - if earnings is unsteady then income is inadequate

income(inadequate) :- 
	earnings(E, unsteady).
	
	
% rule 9 - new rule - if users dept is greater than the maximum dept they can be in
% then savings_account is inadequate

savings_account(inadequate) :-
	currentDept(Dept),
	amount_saved(S),
	max_dept(S, DeptMax),
	Dept > DeptMax.


% function to get the minimum savings amount

min_savings(D, MS) :- 
	MS is 5000 * D.


% function to get the minimum income amount

min_income(D, MI) :- 
	MI is (4000 * D) + 15000.
	

% function to get the maximum dept amount

max_dept(S, DeptMax) :-
	DeptMax is S / 2.


% get user to input their savings amount

getSavings :-
	write('Enter savings amount '),
	read(S),
	assert(amount_saved(S)).


% get user to input their number of dependents

getDependents :-
	write('Enter number of dependents '),
	read(D),
	assert(numDependents(D)).
	
	
% get user to input their earnings

getEarnings :-
	write('Enter your earnings '),
	read(E),
	assert(earnings(E, steady)).
	

% get the user to input their current dept

getDept :-
	write('Enter your current dept '),
	read(Dept),
	assert(currentDept(Dept)).
	

% get the user to input their risk tolerance 

getRiskTolerance :-
	write('On a scale of one to ten, how risky would you like your investment to be '),
	read(RT),
	assert(riskTolerance(RT)).
	

% determine the percentage of the users savings they should invest 
% based on their risk tolerance

investment_risk(R) :-
	riskTolerance(RT),
	(RT == 1,
	R = 10;
	RT == 2,
	R = 10;
	RT == 3,
	R = 25;
	RT == 4,
	R = 25;
	RT == 5,
	R = 30;
	RT == 6,
	R = 40;
	RT == 7,
	R = 40;
	RT == 8,
	R = 50;
	RT == 9,
	R = 50;
	RT == 10,
	R = 60).
	

% check if the advice is to invest in stocks

checkIfStocks(TF) :-
	invest_in(X),
	(X == stocks,
	TF = true;
	TF = false).
	

% display the percentage the user should invest

displayInvestmentRisk :-
	checkIfStocks(TF),
	(TF == true,
	getRiskTolerance,
	investment_risk(R),
	write('Advice is to invest '),
	write(R),
	write('% '),
	write('of your savings into stocks')).
 


% go is to run the whole program

go :-
	getSavings,
	getDependents,
	getEarnings,
	getDept,
	
	write('\n'),
	
	invest_in(X),
	write('Advice is to invest in: '),
	write(X),
	
	write('\n'),
	write('\n'),
	
	checkIfStocks(TF),
	displayInvestmentRisk,
	
	!,
	cleanInputs.
	
cleanInputs :- 
	retractall(amount_saved(_)),
	retractall(numDependents(_)),
	retractall(earnings(_)),
	retractall(currentDept(_)),
	retractall(riskTolerance(_)).

	
	
	
	
	
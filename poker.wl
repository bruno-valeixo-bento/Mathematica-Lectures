(* ::Package:: *)

(*Packages always start with this command; BeginPackage["NameOfPackage`"];*)
BeginPackage["Poker`"];
	
	(*First we define Public quantities/functions; these can be accessed and used in any notebook that loads the package*)
	deck::usage = "Deck of 52 cards."; (*Whatever you write here will appear in the Help when the user evaluates ?deck *)
	Shuffle::usage = "Shuffles the deck";
	shuffledDeck::usage = "Suffled playing deck.";
	draw::usage = "Draw N cards from the suffled deck as draw[N]";
	NewGame::usage = "NewGame[N] starts a new game for N players: suffles the deck, draws 2 cards per player and shows the game.";
	
	(*Suits*)
	Hearts=Subscript[Style[\[HeartSuit],{Red,Large}],#]&;
	Clubs=Subscript[Style[\[ClubSuit],{Large}],#]&;
	Diamonds=Subscript[Style[\[DiamondSuit],{Red,Large}],#]&;
	Spades=Subscript[Style[\[SpadeSuit],{Large}],#]&;
	ranks=Flatten[{A,Range[2,10],\[DoubleStruckCapitalJ],\[DoubleStruckCapitalQ],\[DoubleStruckCapitalK]}];
	(*If we want things to appear nicely formated in the notebook where the package is loaded (i.e. without reference to the Context, in this case poker`, in every symbol), the easiest way is to make those public*)
	
(*Definition that used by the package but don't need to be publicly accessed belong in the Private section*)
Begin["`Private`"]

	(*Note that parts of these where introduced publicly; the deck is publicly accessible; so are the suits and ranks*)
	deck=#/@ranks&/@{Hearts,Clubs,Diamonds,Spades}//Flatten;

	(*Actions*)
	Shuffle:=(shuffledDeck=RandomSample[deck];player=1;)
	draw[n_]:=Module[{cardsDrawn},
		If[Length[shuffledDeck]==0,Return["No deck was shuffled!"]];
		cardsDrawn=shuffledDeck[[1;;n]];
		shuffledDeck=Drop[shuffledDeck,n];
		cardsDrawn]
	(*The actions below are not necessary outside the package itself; they can be fully private*)
	out:=(Length[hand[player]]>=5||Last[hand[player]]==="Fold");
	play:=If[out,(player=(Mod[player,NPlayers]+1);),
	(Flatten@AppendTo[hand[player],draw[1]];player=(Mod[player,NPlayers]+1))]
	fold:=If[out,(player=(Mod[player,NPlayers]+1);),
	(Flatten@AppendTo[hand[player],"Fold"];player=(Mod[player,NPlayers]+1);)]
	
	(*New Game*)
	NewGame[players_]:=(Shuffle;
	NPlayers=players;
	Table[hand[i]=draw[2],{i,NPlayers}];
	Dynamic[{{Table[{Style["Player "<>ToString[i]<>":",If[player==i,{Bold,Red},{Plain}]],hand[i]}//Flatten,{i,players}]//Grid[#,Spacings->{1, 1}]&},
	{ButtonBar[{"Play":>play,"Fold":>fold,"New Game":>NewGame[players]},ImageSize->80]}}//Grid[#,Alignment->Left,Spacings->{2, 2},Frame->All,Background->{None,{None,LightGray,LightGray}}]&]
	)

(*At the end, we first close the Private section with End[]*)
End[]

(*Finally we end the package with EndPackage[]*)
EndPackage[]




	
	
	
	

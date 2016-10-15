# x86_Assembly_Pacman

[MILESTONE 1]
Objective: Developed a Pacman game to read/print the map as it was laid out in the game map and subsequently consume the possible $ points laid out in the game map via user input.   Alternatively, if you want to work on your own problem similar to the scope we have defined for this term project, you may submit your proposal for approval.
 Part I:
2.	Create a text file contains the sample Pacman game map illustrated below; you will need to create two variation of game maps.  Each game map should contain 6-8 $points and a Pacman symbol using @ and divide the space using * as boundary of the wall with 12 X 12 setting for the minimum resolution of the game.
3.	Your program should be able to load the game map text file into memory
4.	Your program should be able to print the game map on the system console.
5.	Your program should be able to list out the position (address) of @ and positions of $ based on the map.
6.	Create your own version of game map in text file and repeat steps 2-4; your own map should have very clear spacing and available path for all the $ to be consumed by the @ in the later exercise.
Part II:
1.	From part I, the map symbol corresponding the character of the game
1.	‘@’ pacman; the user controlled charater
2.	‘*’ wall; boundary of the map where the movement of pacman shall be confined by the wall
3.	‘$’ ghost; the target that pacman going after
4.	‘#’ de-ghost; ghost converted character once touched by pacman
2.	Create a game menu for Pacman which should contain the following options
1.	Start new game (S)
2.	Print Map (P)
3.	Move Up (U)
4.	Move Down (D)
5.	Move Left (L)
6.	Move Right (R)
7.	End game (E)
3.	Menu item a) should load the new map from file
4.	Menu item b) should print the map with current game state
5.	Menu item c) should move the pacman one position UP on the map if allowed.
6.	Menu item d) should move the pacman one position DOWN on the map if allowed
7.	Menu item e) should move the pacman one position LEFT on the map if allowed.
8.	Menu item f) should move the pacman one position RIGHT on the map if allowed
9.	Menu item g) will end the game and exit the program.
10.	Once user has consumed all the ghost symbol, the game session considered over and the only option that user can do on the menu should be {S, P, E} 
[MILESTONE 2]
Objective: Continue the pacman game with demo mode which allows program to auto play to complete the game.  Alternatively, if you want to work on your own problem similar to the scope we have defined for this term project continue from milestone I, you should plan ahead to allow more difficult task completed in milestone II.
Activity:
1. DEMO mode.
Write an Assembly program to solve the Pacman game map you have designed upfront and computerize the possible routes for consuming all the $ points laid out in the game map loaded into your program.  Here is the breakdown of the requirement:
1. Continue from Term Project Milestone I, add Demo mode in the user menu.
2. Your program should be able to detect where the initial position of Pacman and start navigating the available path to consume all the $ points.
3. Your program should clearly mark the path of Pacman with ! to visualize the visited path.
4. The $ point consumed should be replaced with # which is considered hazardous and should be avoided.  Under the circumstance that it can not be avoided, you can still pass over with deduction of game points.
*** game point tracking is not important for this assignment.
5. Try to avoid the same path except backing up from the dead end.
    

* Make sure you demonstrated the use of stack frame parameter passing and work with your team using Module concept.
* The sample Maze Diagram above could prevent your program to not able to get all the $ signs on the chart; You might need to revise the map in order to complete the game.



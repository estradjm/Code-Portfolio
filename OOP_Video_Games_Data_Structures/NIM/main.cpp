#include <iostream>
#include "nim.h"
#include <cstdlib>

// driver file

using namespace std;

void test(){
nim game(11,10,5);
cout << game.is_game_over() << endl ; // should be false
cout << game. get_players_turn() << endl ; // should be 1
game.take_turn(1,10); // remove 10 stones from pile 1
cout << game.get_players_turn() << endl ; // should be 2
game.print(); // Player 2: 1 10 5
game.take_turn(2,10); // remove 10 stones from pile 2
game.print(); // Player 1: 1 0 5
game.take_turn(3,5); // remove 5 stones from pile 3
game.print(); // Player 2 : 1 0 0
cout << game.is_game_over() << endl ; // should be true
}

void play(){
nim game(11, 10, 5);
while (game.is_game_over()== false){
    game.print();
    cout << "Player " << game.get_players_turn() << ", Enter the pile and number of stones: ";
    int pile=0, stones=0;
    cin >> pile >> stones;
    cout << endl;
    game.take_turn(pile,stones)? : cout << "error" << endl;
}

cout << "Player ";
game.get_players_turn() == 1? cout << 2 : cout << 1;
cout << " wins!" << endl;

cout << "Player ";
game.get_players_turn() == 1? cout << 1 : cout << 2;
cout << " loses!" << endl;

}


int main(){
    //nim game(11,10,5);
    //test();
    play();
    return EXIT_SUCCESS;
}

#include "nim.h"
#include <iostream>
#include <cstdlib>
#include <time.h>
#include <assert.h>     /* assert */

using namespace std;

nim::nim()
{
    players_turn=1;
    srand(time(NULL));
    piles[0] = rand() % 6 + 5; // 5 - 11 stones in each pile
    piles[1] = rand() % 6 + 5;
    piles[2] = rand() % 6 + 5;
}

nim::nim(int pile1, int pile2, int pile3)
{
    players_turn=1;

    assert (pile1>=5); // Check arguements are valid
    assert (pile2>=5);
    assert (pile3>=5);

    assert (pile1<=11);
    assert (pile2<=11);
    assert (pile3<=11);

    piles[0]= pile1;
    piles[1] = pile2;
    piles[2] = pile3;
}

void nim::print(){
    cout << "Player " << players_turn << ": " << piles[0] << " " << piles[1] << " " << piles[2]<< endl;
}

int nim::get_players_turn(){
    return players_turn;
}

bool nim::take_turn(int pile, int stones_to_remove){
    switch (pile){
        case 1:
            if ((piles[0] - stones_to_remove) >= 0 && ((piles[0]+piles[1]+piles[2]) > stones_to_remove)){
                piles[0] -= stones_to_remove;
                (players_turn==1)?(players_turn=2):(players_turn=1); // determine player turn using ternary operator
                return true;
            }
            else return false;
            break;
        case 2:
            if ((piles[1] - stones_to_remove) >= 0  && ((piles[0]+piles[1]+piles[2]) > stones_to_remove)){
                piles[1] -= stones_to_remove;
                (players_turn==1)?(players_turn=2):(players_turn=1); // determine player turn using ternary operator
                return true;
            }
            else return false;
            break;
        case 3:
            if ((piles[2] - stones_to_remove) >= 0  && ((piles[0]+piles[1]+piles[2]) > stones_to_remove)){
                piles[2] -= stones_to_remove;
                (players_turn==1)?(players_turn=2):(players_turn=1); // determine player turn using ternary operator
                return true;
            }
            else return false;
            break;
        default:
            return false;
    }
}

bool nim::is_game_over(){
    return ((piles[0]+piles[1]+piles[2])==1);
}

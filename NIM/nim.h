#ifndef NIM_H_INCLUDED
#define NIM_H_INCLUDED

#include <cstdlib>

class nim
{
    public:
        nim();
        nim(int pile1, int pile2, int pile3);
        void print();

        int get_players_turn();
        bool take_turn(int pile, int stones_to_remove);
        bool is_game_over();

    private:
        int players_turn;
        int piles[3];
};

#endif // NIM_H

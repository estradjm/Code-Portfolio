#include "allegro5/allegro.h"
#include "allegro5/allegro_image.h"
#include "allegro5/allegro_primitives.h"
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <time.h>

#define not_visited 1
#define wall 2
#define on_path 3
#define dead_end 4

using namespace std;

const int SCREEN_W = 640;
const int SCREEN_H = 640;
const float FPS = 60;

class maze{
public:
    maze();
    void draw_maze();
    void redraw_maze(int r, int c);
    int rows;
    int cols;
    int ** a;
    bool unvisited(int r, int c);
    void draw_cell(int r, int c);
    void mark(int r, int c);
    void unmark(int r, int c);
    bool valid(int r, int c);
    bool isEnd(int r, int c);
    bool traverse(int row, int col);
};

maze::maze(){
    srand(time(NULL));
    ifstream file("C:/Users/Ryan/Desktop/CSIS3700/3700 Lab 9/maze.txt");
        if (!file)
           cout<< "Error";
    float n;
    file >> n;
    rows = n;
    cols = n;
    a = new int*[rows];
    for(int i=0; i<rows; i++)
        a[i] = new int[cols];
    for(int j=0; j<rows; j++)
        for(int i=0; i<rows; i++)
            a[i][j] = 0;
}

void maze::draw_maze(){
    ALLEGRO_COLOR WHITE = al_map_rgb(255,255,255);
    al_clear_to_color(WHITE);
    for(int j=0; j<rows; j++)
        for(int i=0; i<rows; i++){
            if(rand()%10 == 1 || rand()%10 == 2){// || rand()%10 == 3 || rand()%10 == 4){
                a[i][j] = wall;
                draw_cell(i, j);
            } else {
                a[i][j] = not_visited;
                draw_cell(i, j);
            }
            a[0][0] = not_visited;
            a[rows-1][cols-1] = not_visited;
        }
    al_flip_display();
}

void maze::redraw_maze(int r, int c){
    ALLEGRO_COLOR PURPLE = al_map_rgb(255,0,255);
    ALLEGRO_COLOR BLUE = al_map_rgb(0,0,255);
    ALLEGRO_COLOR RED = al_map_rgb(255,0,0);
    ALLEGRO_COLOR GREEN = al_map_rgb(0,255,0);
    if (r == 0 && c == 0)
        al_draw_filled_rectangle(0,0,(SCREEN_H)/ rows,(SCREEN_W)/ cols,GREEN);
    else if (r == (rows-1) && c == (cols-1))
        al_draw_filled_rectangle((SCREEN_H)-(SCREEN_H/ rows),(SCREEN_W)-(SCREEN_W/ cols),((r*SCREEN_H)/ rows+(SCREEN_H)/ rows),(c*SCREEN_W)/ cols+(SCREEN_W)/ cols,RED);
    else if(a[r][c] == on_path)
        al_draw_filled_rectangle((r*SCREEN_H)/ rows,(c*SCREEN_W)/ cols,((r*SCREEN_H)/ rows+(SCREEN_H)/ rows),(c*SCREEN_W)/ cols+(SCREEN_W)/ cols,BLUE);
    else
        al_draw_filled_rectangle((r*SCREEN_H)/ rows,(c*SCREEN_W)/ cols,((r*SCREEN_H)/ rows+(SCREEN_H)/ rows),(c*SCREEN_W)/ cols+(SCREEN_W)/ cols,PURPLE);
    al_flip_display();
}

void maze::draw_cell(int r, int c){
    ALLEGRO_COLOR RED = al_map_rgb(255,0,0);
    ALLEGRO_COLOR GREEN = al_map_rgb(0,255,0);
    ALLEGRO_COLOR BLACK = al_map_rgb(0,0,0);
    ALLEGRO_COLOR WHITE = al_map_rgb(255,255,255);
    if (a[r][c] == wall)
       al_draw_filled_rectangle((r*SCREEN_H)/ rows,(c*SCREEN_W)/ cols,((r*SCREEN_H)/ rows+(SCREEN_H)/ rows),(c*SCREEN_W)/ cols+(SCREEN_W)/ cols,BLACK);
    else
       al_draw_filled_rectangle((r*SCREEN_H)/ rows,(c*SCREEN_W)/ cols,((r*SCREEN_H)/ rows+(SCREEN_H)/ rows),(c*SCREEN_W)/ cols+(SCREEN_W)/ cols,WHITE);
    al_draw_filled_rectangle(0,0,(SCREEN_H)/ rows,(SCREEN_W)/ cols,GREEN);
    al_draw_filled_rectangle((SCREEN_H)-(SCREEN_H/ rows),(SCREEN_W)-(SCREEN_W/ cols),((r*SCREEN_H)/ rows+(SCREEN_H)/ rows),(c*SCREEN_W)/ cols+(SCREEN_W)/ cols,RED);
}

void maze::mark(int r, int c) {
    a[r][c] = on_path;
    redraw_maze(r, c);
};

void maze::unmark(int r, int c) {
    a[r][c] = dead_end;
    redraw_maze(r, c);
}

bool maze::valid(int r, int c) {
    if (r < 0 || c < 0 || r >= rows || c >= cols)
        return false;
    else
        return true;
};

bool maze::unvisited(int r, int c) {
    if (a[r][c] == not_visited || isEnd(r,c) == true)
        return true;
    else
        return false;
};

bool maze::isEnd(int r, int c) {
    if (r == (rows-1) && (c == cols-1))
        return true;
    else
        return false;
};

bool maze::traverse(int row, int col){
    bool done = false;
    al_rest(.05);
    if(valid(row, col) && unvisited(row, col)){
        if(isEnd(row, col))
            done = true;
        mark(row, col);
        if(!isEnd(row, col)){
            done = traverse(row+1, col);
            if (!done)
                done = traverse(row, col+1);
            if (!done)
                done = traverse(row-1, col);
            if (!done)
                done = traverse(row, col-1);
        }
        if(!done)
            unmark(row, col);
    }
    return done;
}

int main()
{
    ALLEGRO_DISPLAY *display = NULL;
    ALLEGRO_EVENT_QUEUE* event_queue = NULL;
    ALLEGRO_TIMER *timer = NULL;
    bool redraw = true;

    maze m;

    if(!al_init()) {
      fprintf(stderr, "failed to initialize allegro!\n");
      return -1;
    }

    if(!al_init_primitives_addon()){
      fprintf(stderr, "failed to initialize primitives!\n");
    }

    timer = al_create_timer(1.0 / FPS);
        if(!timer) {
            fprintf(stderr, "failed to create timer!\n");
            return -1;
    }

    display = al_create_display(SCREEN_W, SCREEN_H);
        if(!display) {
            fprintf(stderr, "failed to create display!\n");
            al_destroy_timer(timer);
            return -1;
    }

    event_queue = al_create_event_queue();
        if(!event_queue) {
            fprintf(stderr, "failed to create event_queue!\n");
            al_destroy_display(display);
            al_destroy_timer(timer);
            return -1;
    }

    al_register_event_source(event_queue, al_get_display_event_source(display));
    al_register_event_source(event_queue, al_get_timer_event_source(timer));
    al_start_timer(timer);

    ALLEGRO_EVENT ev;
    m.draw_maze();
    do{
        al_wait_for_event(event_queue, &ev);
        if(m.traverse(0,0) == true)
            break;
    } while(ev.type != ALLEGRO_EVENT_DISPLAY_CLOSE);

    al_rest(10);
    al_destroy_timer(timer);
    al_destroy_display(display);
    al_destroy_event_queue(event_queue);
}

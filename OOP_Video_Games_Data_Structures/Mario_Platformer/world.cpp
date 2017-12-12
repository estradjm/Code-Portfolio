#include "world.h"
#include "image_library.h"
#include "keyboard_manager.h"
#include <cassert>
#include <vector>
#include <algorithm>
#include "sprite.h"
#include "allegro5/allegro.h"
#include "allegro5/allegro_image.h"
#include "allegro5/allegro_font.h"
#include "player_sprite.h"
#include "obstruction_sprite.h"
#include "collision.h"
#include "enemy_sprite.h"
#include "player_sprite.h"
#include "allegro5/allegro_audio.h"
#include "allegro5/allegro_acodec.h"

#include <iostream>

using namespace std;

namespace csis3700 {

  const float gravity_acceleration = 600;

  void free_sprite(sprite* s) {
    delete s;
  }

  world::world() {
      font = al_load_font("8bit.ttf", 40, NULL);
      assert(font != NULL);
      ground = new obstruction_sprite(-1280, 565, image_library::get() -> get("ground.png"));
      sprites.push_back(ground);
      player = new player_sprite(0, 505, this);
      sprites.push_back(player);
      goomba = new enemy_sprite(500, 520);
      sprites.push_back(goomba);
      brick = new obstruction_sprite(100, 525, image_library::get() -> get("brick.png"));
      sprites.push_back(brick);
      brick = new obstruction_sprite(135, 525, image_library::get() -> get("brick.png"));
      sprites.push_back(brick);
      brick = new obstruction_sprite(170, 525, image_library::get() -> get("brick.png"));
      sprites.push_back(brick);
      brick = new obstruction_sprite(205, 525, image_library::get() -> get("brick.png"));
      sprites.push_back(brick);
      //brick = new obstruction_sprite(135, 525, image_library::get() -> get("brick.png"));
      //sprites.push_back(brick);
      tunnel = new obstruction_sprite(250, 465, image_library::get() -> get("tube.png"));
      sprites.push_back(tunnel);
      tunnel = new obstruction_sprite(750, 465, image_library::get() -> get("tube.png"));
      sprites.push_back(tunnel);
      castle = new obstruction_sprite(1000, 265, image_library::get() -> get("castle.png"));
      sprites.push_back(castle);
      coin = new obstruction_sprite(850, 400,image_library::get() -> get("coin.png"));
      sprites.push_back(coin);
      coin = new obstruction_sprite(900, 400,image_library::get() -> get("coin.png"));
      sprites.push_back(coin);
      coin = new obstruction_sprite(950, 400,image_library::get() -> get("coin.png"));
      sprites.push_back(coin);
      if (camera_x < 0)
        camera_x = 0;
      if (camera_y < 0)
        camera_y = 0;
      if (camera_x > 2560 - 1000)
        camera_x = 2560 - 1000;
      if (camera_y > 1000 - 720)
        camera_y = 1000 - 720;

        theme=NULL;
        themeInstance=NULL;
        theme = al_load_sample("Sounds/SuperMarioBros.wav");
        themeInstance = al_create_sample_instance(theme);
        al_set_sample_instance_playmode(themeInstance, ALLEGRO_PLAYMODE_LOOP);
        al_attach_sample_instance_to_mixer(themeInstance, al_get_default_mixer());

        themefast=NULL;
        themeFastInstance=NULL;
        themefast = al_load_sample("Sounds/hurryOverworld.wav");
        themeFastInstance = al_create_sample_instance(themefast);
        al_set_sample_instance_playmode(themeFastInstance, ALLEGRO_PLAYMODE_LOOP);
        al_attach_sample_instance_to_mixer(themeFastInstance, al_get_default_mixer());

        dead=NULL;
        deadInstance=NULL;
        dead = al_load_sample("Sounds/dead.wav");
        deadInstance = al_create_sample_instance(dead);
        al_set_sample_instance_playmode(deadInstance, ALLEGRO_PLAYMODE_ONCE);
        al_attach_sample_instance_to_mixer(deadInstance, al_get_default_mixer());

        if (!theme){
            cerr << "Audio clip sample not loaded!"<< endl;
        }
        else{

            al_set_sample_instance_playing(themeInstance, true);
        }
  }

  world::world(const world& other) {
    assert(false); // do not copy worlds
  }

  world& world::operator=(const world& other) {
    assert(false); // do not assign worlds
  }

  world::~world() {
    for_each(sprites.begin(), sprites.end(), free_sprite);
    sprites.clear();


  al_stop_sample_instance(themeInstance);
  }

  void world::handle_event(ALLEGRO_EVENT ev) {
    if(ev.type == ALLEGRO_EVENT_KEY_DOWN){
        keyboard_manager::get() -> get() -> key_down(ev.keyboard.keycode);
    }
    if(ev.type == ALLEGRO_EVENT_KEY_UP){
        keyboard_manager::get() -> get() -> key_up(ev.keyboard.keycode);
    }
  }

  void world::resolve_collisions() {
    //if(player -> get_position().get_x() == tunnel -> get_position().get_x()){
    //collision player_obstacle(sprites[0], sprites[i]);
    //player -> resolve(player_obstacle, sprites[i]);
    collision player_obstacle(sprites[1], sprites[0]);
        player -> resolve(player_obstacle, sprites[0]);
    for (int i = 2; i < sprites.size(); i++){
        collision player_obstacle(sprites[1], sprites[i]);
        player -> resolve(player_obstacle, sprites[i]);
        //collision enemy_obstacle(sprites[2], sprites[i]);
        //goomba -> resolve(enemy_obstacle, sprites[i]);
    }
    for (int i = 3; i < sprites.size(); i++){
        collision enemy_obstacle(sprites[2], sprites[i]);
        goomba -> resolve(enemy_obstacle, sprites[i]);
    }
    //}
  }

  void world::advance_by_time(double dt) {
    for(vector<sprite*>::iterator it = sprites.begin(); it != sprites.end(); ++it)
      (*it)->advance_by_time(dt);
    resolve_collisions();
    camera_x = player -> get_x() - 1280 / 2;
  }

  void world::draw() {
    ALLEGRO_BITMAP *bg_image = NULL;

    ALLEGRO_TRANSFORM T;
    al_identity_transform(&T);
    al_translate_transform(&T, -camera_x, camera_y);
    al_use_transform(&T);
    bg_image = image_library::get() -> get("mariobg2.png");

    for (int i = -1280; i < 12800; i += 1280)
        al_draw_bitmap(bg_image, i, 0, 0);
    //al_clear_to_color(al_map_rgb(255,255,255));

    for(vector<sprite*>::iterator it = sprites.begin(); it != sprites.end(); ++it)
      (*it)->draw();

    /*obstruction_sprite tunnel1(300,505, tunnel);
    obstruction_sprite coin1(50,505, coin);
    obstruction_sprite castle1(100,462, castle);
    obstruction_sprite brick1(200,400, brick);
    obstruction_sprite brick2(249,400, brick);*/


    al_identity_transform(&T);
    al_use_transform(&T);
    al_draw_textf(font, al_map_rgb(255, 255, 255), 100, 0, 0, "SCORE: %d", score);
    al_draw_textf(font, al_map_rgb(255, 255, 255), 1000, 0, 0, "LIVES x %d", lives);
    al_draw_textf(font, al_map_rgb(255, 255, 255), 500, 0, 0, "TIME: %d", time/10);
    time -= 1;

            if (time<=3000 && time > 10){ //start faster music due to low on time
                al_set_sample_instance_playing(themeInstance, false);
                al_set_sample_instance_playing(themeFastInstance, true);
            }
            if (time==10){ //lost by time running out - play once
                al_set_sample_instance_playing(themeInstance, false);
                al_set_sample_instance_playing(themeFastInstance, false);
                al_set_sample_instance_playing(deadInstance, true);
            }
            if (lives==0){
                al_draw_textf(font, al_map_rgb(255,255,255), 500, 250, 0, "GAME OVER");
                al_set_sample_instance_playing(themeInstance, false);
                al_set_sample_instance_playing(themeFastInstance, false);
                al_set_sample_instance_playing(deadInstance, true);
                exit = true;
                al_rest(10);
            }
  }

  bool world::should_exit() {
    if (exit == true)
        return true;
    else
        return false;
  }

  void world::playerkilled(){
    if(lives>0)
        lives--;
    else
        lives = 0;
  }





 void world::enemyKilled(sprite* enemy){

        vector <sprite*>::iterator it = find(sprites.begin(), sprites.end(), enemy);
        if (it!= sprites.end())
            sprites.erase(it);
        score +=10;
  }

  void world::coincollected(){
     score += 10;
  }
}

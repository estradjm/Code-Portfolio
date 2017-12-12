#include "player_sprite.h"
#include "keyboard_manager.h"
#include "image_library.h"
#include "image_sequence.h"
#include "vec2d.h"
#include "collision.h"
#include <cmath>

#include "allegro5/allegro_audio.h"
#include "allegro5/allegro_acodec.h"


using namespace std;

namespace csis3700 {

  player_sprite::player_sprite(float initial_x, float initial_y, world * thew) :
    phys_sprite(initial_x, initial_y) {
        time = 0;
        theworld = thew;

        set_acceleration(vec2d(0,500));
        still = new image_sequence;
        set_image_sequence(still);
        still -> add_image(image_library::get() -> get("mario_right.png"), 0.2);

        walk_right = new image_sequence;
        walk_right -> add_image(image_library::get() -> get("mario_right.png"), .1);
        walk_right -> add_image(image_library::get() -> get("mario_walk_right.png"), .1);
        walk_right -> add_image(image_library::get() -> get("mario_walk_right2.png"), .1);
        walk_right -> add_image(image_library::get() -> get("mario_walk_right.png"), .1);

        walk_left = new image_sequence;
        walk_left -> add_image(image_library::get() -> get("mario_left.png"), .1);
        walk_left -> add_image(image_library::get() -> get("mario_walk_left.png"), .1);
        walk_left -> add_image(image_library::get() -> get("mario_walk_left2.png"), .1);
        walk_left -> add_image(image_library::get() -> get("mario_walk_left.png"), .1);
  }

  bool player_sprite::is_passive() const {
    return false;
  }

  void player_sprite::set_on_ground(bool v) {
    on_ground = v;
    //if (on_ground == true)
        //set_velocity(vec2d(0,0));
  }

  void player_sprite::advance_by_time(double dt) {
    phys_sprite::advance_by_time(dt);
    if(keyboard_manager::get() -> is_key_down(ALLEGRO_KEY_RIGHT) && keyboard_manager::get() -> is_key_down(ALLEGRO_KEY_UP) && on_ground == true){
        set_velocity(vec2d(150, -325));
        jump_right = new image_sequence;
        set_image_sequence(jump_right);
        jump_right -> add_image(image_library::get() -> get("mario_jump_right.png"), 1000);
        jump_right -> add_image(image_library::get() -> get("mario_right.png"), 1000);

        ALLEGRO_SAMPLE *sample=NULL;
        sample = al_load_sample("Sounds/jump.wav");
        if (!sample){
            cerr << "Audio clip sample not loaded!"<< endl;
        }
        else{
            al_play_sample(sample, 1.0, 0.0,1.0,ALLEGRO_PLAYMODE_ONCE,NULL);
        }
        set_on_ground(false);
    } else if(keyboard_manager::get() -> is_key_down(ALLEGRO_KEY_LEFT) && keyboard_manager::get() -> is_key_down(ALLEGRO_KEY_UP) && on_ground == true){
        set_velocity(vec2d(-150, -325));
        jump_left = new image_sequence;
        set_image_sequence(jump_left);
        jump_left -> add_image(image_library::get() -> get("mario_jump_left.png"), 1000);
        jump_left -> add_image(image_library::get() -> get("mario_left.png"), 1000);

        ALLEGRO_SAMPLE *sample=NULL;
        sample = al_load_sample("Sounds/jump.wav");

        if (!sample){
            cerr << "Audio clip sample not loaded!"<< endl;
        }
        else{
            al_play_sample(sample, 1.0, 0.0,1.0,ALLEGRO_PLAYMODE_ONCE,NULL);
        }
        set_on_ground(false);
    } else if(keyboard_manager::get() -> is_key_down(ALLEGRO_KEY_UP) && on_ground == true){
        set_velocity(vec2d(0, -325));
        jump = new image_sequence;
        set_image_sequence(jump);
        jump -> add_image(image_library::get() -> get("mario_jump_right.png"), 1000);
        jump -> add_image(image_library::get() -> get("mario_right.png"), 1000);

        ALLEGRO_SAMPLE *sample=NULL;
        sample = al_load_sample("Sounds/jump.wav");
        if (!sample){
            cerr << "Audio clip sample not loaded!"<< endl;
        }
        else{
            al_play_sample(sample, 1.0, 0.0,1.0,ALLEGRO_PLAYMODE_ONCE,NULL);
        }
        set_on_ground(false);
    } else if (keyboard_manager::get() -> is_key_down(ALLEGRO_KEY_RIGHT) && on_ground == true){
        set_image_sequence(walk_right);
        set_velocity(vec2d(150, get_velocity().get_y()));

    } else if (keyboard_manager::get() -> is_key_down(ALLEGRO_KEY_LEFT) && on_ground == true){
        set_image_sequence(walk_left);
        set_velocity(vec2d(-150, get_velocity().get_y()));

    }else if(position.get_y() >= 505 || on_ground == true){
        set_on_ground(true);
        //set_velocity(vec2d(0,0));
        set_image_sequence(still);
    }
    else
        set_on_ground(false);
  }

  void player_sprite::resolve(const collision& collision, sprite *other) {
  if (!collides_with(*other)){
    return;
  }
  if(other -> is_goomba()){
     if(collision_rectangle(*other).get_height() > collision_rectangle(*other).get_width() && get_position().get_x() <= other -> get_position().get_x()){
        cout<<"dead! left" << endl;
        theworld -> playerkilled();
    }
  //else if (((other->bounding_box().upper_left_corner().get_x()+other -> get_width()) >= get_position().get_x()) && (other->bounding_box().upper_left_corner().get_y()+10 <= (get_position().get_y() + get_height())) && (other->bounding_box().upper_left_corner().get_x() <= get_position().get_x() + get_width()) && on_ground == true){
    else if(collision_rectangle(*other).get_height() > collision_rectangle(*other).get_width() && bounding_box().lower_right_corner().get_x() >= other -> get_position().get_x()){
        cout<<"dead! right" << endl;
        theworld -> playerkilled();
    }
  //else if (other->bounding_box().upper_left_corner().get_y() <= (get_position().get_y() + get_height())){ //&& other->bounding_box().upper_left_corner().get_x() <= (get_position().get_x() + get_width()) && (other->bounding_box().upper_left_corner().get_x() + other-> get_width()) >= get_position().get_x()){
    else if(collision_rectangle(*other).get_height() < collision_rectangle(*other).get_width() && bounding_box().lower_right_corner().get_y() > other -> get_position().get_y()){
        cout<<"kill" << endl;
        theworld -> enemyKilled(other);
        //set_image_sequence(still);
    }
  }
  if(other -> is_coin()){
     if(collision_rectangle(*other).get_height() > collision_rectangle(*other).get_width() && get_position().get_x() <= other -> get_position().get_x()){
        cout<<"collision! left" << endl;
        set_velocity(vec2d(-75,0));
    }
  //else if (((other->bounding_box().upper_left_corner().get_x()+other -> get_width()) >= get_position().get_x()) && (other->bounding_box().upper_left_corner().get_y()+10 <= (get_position().get_y() + get_height())) && (other->bounding_box().upper_left_corner().get_x() <= get_position().get_x() + get_width()) && on_ground == true){
    else if(collision_rectangle(*other).get_height() > collision_rectangle(*other).get_width() && bounding_box().lower_right_corner().get_x() >= other -> get_position().get_x()){
        cout<<"collision! right" << endl;
        set_velocity(vec2d(75,0));
    }
  //else if (other->bounding_box().upper_left_corner().get_y() <= (get_position().get_y() + get_height())){ //&& other->bounding_box().upper_left_corner().get_x() <= (get_position().get_x() + get_width()) && (other->bounding_box().upper_left_corner().get_x() + other-> get_width()) >= get_position().get_x()){
    else if(collision_rectangle(*other).get_height() < collision_rectangle(*other).get_width() && bounding_box().lower_right_corner().get_y() > other -> get_position().get_y()){
        cout<<"collision! up" << endl;
        set_on_ground(true);
        set_velocity(vec2d(0,0));
        set_position(vec2d(get_position().get_x(), other->get_position().get_y() - (bounding_box().get_height()+1)));
        //set_image_sequence(still);
    }
  }
  //if ((other->bounding_box().upper_left_corner().get_x() <= (get_position().get_x() + get_width())) && (other->bounding_box().upper_left_corner().get_y()+10 <= (get_position().get_y() + get_height())) && ((other->bounding_box().upper_left_corner().get_x() + other -> get_width()) >= (get_position().get_x() + get_width()))&& on_ground == true){
  if(collision_rectangle(*other).get_height() > collision_rectangle(*other).get_width() && get_position().get_x() <= other -> get_position().get_x()){
        cout<<"collision! left" << endl;
        set_velocity(vec2d(-75,0));
  }
  //else if (((other->bounding_box().upper_left_corner().get_x()+other -> get_width()) >= get_position().get_x()) && (other->bounding_box().upper_left_corner().get_y()+10 <= (get_position().get_y() + get_height())) && (other->bounding_box().upper_left_corner().get_x() <= get_position().get_x() + get_width()) && on_ground == true){
  else if(collision_rectangle(*other).get_height() > collision_rectangle(*other).get_width() && bounding_box().lower_right_corner().get_x() >= other -> get_position().get_x()){
        cout<<"collision! right" << endl;
        set_velocity(vec2d(75,0));
  }
  //else if (other->bounding_box().upper_left_corner().get_y() <= (get_position().get_y() + get_height())){ //&& other->bounding_box().upper_left_corner().get_x() <= (get_position().get_x() + get_width()) && (other->bounding_box().upper_left_corner().get_x() + other-> get_width()) >= get_position().get_x()){
  else if(collision_rectangle(*other).get_height() < collision_rectangle(*other).get_width() && bounding_box().lower_right_corner().get_y() > other -> get_position().get_y()){
        cout<<"collision! up" << endl;
        set_on_ground(true);
        set_velocity(vec2d(0,0));
        set_position(vec2d(get_position().get_x(), other->get_position().get_y() - (bounding_box().get_height()+1)));
        //set_image_sequence(still);
  }
  //else if(other->bounding_box().upper_left_corner().get_x() > (get_position().get_x() + get_width()) && (other->bounding_box().upper_left_corner().get_x() + other->get_width()) < get_position().get_x() || position.get_y() < 505){
  //      set_on_ground(false);
  //      set_acceleration(vec2d(0, 500));
  //}
}
}

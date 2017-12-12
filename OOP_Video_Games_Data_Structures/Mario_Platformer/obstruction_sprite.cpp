#include "obstruction_sprite.h"
#include "image_library.h"
#include "image_sequence.h"

namespace csis3700 {
   obstruction_sprite::obstruction_sprite(float initial_x, float initial_y, ALLEGRO_BITMAP *image) : sprite(initial_x, initial_y) {
    al_draw_bitmap(image, initial_x, initial_y, 0);
    if (image == image_library::get() -> get("ground.png")){
        ground = new image_sequence;
        set_image_sequence(ground);
        ground -> add_image(image_library::get() -> get("ground.png"), 0.2);
        //is_coin() = false;
    }
    else if (image == image_library::get() -> get("tube.png")){
        tunnel = new image_sequence;
        set_image_sequence(tunnel);
        tunnel -> add_image(image_library::get() -> get("tube.png"), 0.2);
        //is_coin() = false;
    }
    else if (image == image_library::get() -> get("coin.png")){
        coin = new image_sequence;
        set_image_sequence(coin);
        coin -> add_image(image_library::get() -> get("coin.png"), 0.2);
        //is_coin() = true;
    }
    else if (image == image_library::get() -> get("castle.png")){
        castle = new image_sequence;
        set_image_sequence(castle);
        castle -> add_image(image_library::get() -> get("castle.png"), 0.2);
        //is_coin() = false;
    }
    else if (image == image_library::get() -> get("brick.png")){
        brick = new image_sequence;
        set_image_sequence(brick);
        brick -> add_image(image_library::get() -> get("brick.png"), 0.2);
        //is_coin() = false;
    }
  }

  vec2d obstruction_sprite::get_velocity() const {
    return vec2d(0,0);
  }

  void obstruction_sprite::set_velocity(const vec2d& v) {
    assert(false);
  }

  void obstruction_sprite::resolve(const collision& collision, sprite* other) {
    // do nothing, I am not an active participant in a collision
  }



}

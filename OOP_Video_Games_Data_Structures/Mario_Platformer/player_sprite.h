#ifndef __CDS_PLAYER_SPRITE_H
#define __CDS_PLAYER_SPRITE_H
#include "phys_sprite.h"
#include "world.h"

namespace csis3700 {
    class world;
  class player_sprite : public phys_sprite {
  public:
    player_sprite(float initial_x=0, float initial_y=0, world * thew=NULL);
    virtual bool is_passive() const;
    virtual void set_on_ground(bool v);
    virtual void advance_by_time(double dt);
    virtual void resolve(const collision& collision, sprite* other);

  private:
    bool on_ground;
    image_sequence *walk_left;
    image_sequence *walk_right;
    image_sequence *still;
    image_sequence *jump_left;
    image_sequence *jump_right;
    image_sequence *jump;
    world *theworld;
  };
}


#endif /* PLAYER_SPRITE_H */

#ifndef __CDS_ENEMY_SPRITE_H
#define __CDS_ENEMY_SPRITE_H
#include "phys_sprite.h"

namespace csis3700 {
  class enemy_sprite : public phys_sprite {
  public:
    enemy_sprite(float initial_x=0, float initial_y=0);
    virtual bool is_passive() const;
    virtual void set_on_ground(bool v);
    virtual void advance_by_time(double dt);
    virtual bool is_goomba(){return true;}
    virtual void resolve(const collision& collision, sprite* other);
    bool changedir = false;
  private:
    bool on_ground;
    image_sequence *walk;
  };
}


#endif /* ENEMY_SPRITE_H */

#ifndef __CDS_PHYS_SPRITE_H
#define __CDS_PHYS_SPRITE_H

#include <vector>
#include "sprite.h"

namespace csis3700 {

  /**
   * Physical sprites move using an approximation of newtonian
   * kinematics.
   */
  class phys_sprite : public sprite {
  public:
    phys_sprite(float initial_x=0, float initial_y=0, float initial_vx=0, float initial_vy=0);

    virtual void advance_by_time(double dt);

    virtual vec2d get_acceleration() const;
    virtual void set_acceleration(const vec2d& a);

    virtual vec2d get_velocity() const;
    virtual void set_velocity(const vec2d& v);

    //virtual void add_force(vec2d f);

  private:
    vec2d velocity;
    vec2d acceleration;
  };
}
#endif /* PHYS_SPRITE_H */

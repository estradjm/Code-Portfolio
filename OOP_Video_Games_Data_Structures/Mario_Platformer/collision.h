#ifndef __CDS_COLLISION_H
#define __CDS_COLLISION_H

#include "sprite.h"
#include "rectangle.h"

namespace csis3700 {
  class collision {
  public:
    collision(sprite* p1, sprite* p2);
    void resolve();
    bool is_active() const;
    rectangle collision_rectangle() const;

    bool operator<(const collision& other) const;

  private:
    sprite* participant1;
    sprite* participant2;
  };
}
#endif /* COLLISION_H */

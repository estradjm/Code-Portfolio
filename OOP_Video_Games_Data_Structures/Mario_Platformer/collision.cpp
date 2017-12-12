#include "collision.h"
#include "rectangle.h"
#include <iostream>
using namespace std;

namespace csis3700 {
  collision::collision(sprite* p1, sprite* p2) {
    // arrange for participant1 to be the active participant, if there
    // is one
    if (p1->is_passive()) {
      participant1 = p2;
      participant2 = p1;
    } else {
      participant1 = p1;
      participant2 = p2;
    }
  }

  void collision::resolve() {
    // do nothing if both participants are passive
    if (participant1->is_passive()) return;

    participant1->resolve(*this, participant2);
  }

  bool collision::is_active() const {
    return participant1->collides_with(*participant2);
  }

  rectangle collision::collision_rectangle() const {
    return participant1->collision_rectangle(*participant2);
  }

  bool collision::operator<(const collision& other) const {
    return collision_rectangle().get_area() < other.collision_rectangle().get_area();
  }
}

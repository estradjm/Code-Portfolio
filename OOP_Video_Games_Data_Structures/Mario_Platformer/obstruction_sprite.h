#ifndef __CDS_OBSTRUCTION_SPRITE_H
#define __CDS_OBSTRUCTION_SPRITE_H

#include "sprite.h"

namespace csis3700 {

  /**
   * obstruction_sprites don't typically move and when they
   * participate in a collision they are unimpacted by it. They
   * typically render themslves as a single, static bitmap.
   */
  class obstruction_sprite : public sprite {
  public:
         obstruction_sprite(float initial_x, float initial_y, ALLEGRO_BITMAP *image=NULL);
        virtual void set_velocity(const vec2d& v);
        virtual vec2d get_velocity() const;
        virtual bool is_coin(){return true;}
        virtual void resolve(const collision& collision, sprite* other);
    private:
        image_sequence *ground;
        image_sequence *tunnel;
        image_sequence *coin;
        image_sequence *castle;
        image_sequence *brick;
  };

/*
    class tunnel_sprite : public obstruction_sprite{
    public:
        tunnel_sprite(float initial_x, float initial_y, ALLEGRO_BITMAP *image=NULL);
        void set_velocity(const vec2d& v);
        vec2d get_velocity() const;
        void resolve(const collision& collision, sprite* other);
    private:
        image_sequence *tunnel;
  };
*/
}


#endif /* OBSTRUCTION_SPRITE_H */

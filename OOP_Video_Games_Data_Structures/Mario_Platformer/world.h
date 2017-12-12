#ifndef __CDS_WORLD_H
#define __CDS_WORLD_H

#include "allegro5/allegro.h"
#include "allegro5/allegro_font.h"
#include "sprite.h"
#include "player_sprite.h"
#include "enemy_sprite.h"
#include "obstruction_sprite.h"
#include <vector>

#include "allegro5/allegro_audio.h"
#include "allegro5/allegro_acodec.h"

namespace csis3700 {
    class enemy_sprite;
    class player_sprite;

  class world {
  public:
    /**
     * Construct the world. The display is passed in simply to make it
     * possible to modify options or access the backbuffer. DO NOT
     * store the display in an instance variable. DO NOT start drawing
     * on the screen. Just load bitmaps etc.
     */
    world();

    /**
     * Free any resources being used by the world.
     */
    ~world();

    /**
     * Block the copy constructor.  Worlds should not be copied to
     * just assert(false)
     */
    world(const world& other);

    /**
     * Block operator =.  Worlds should not be assigned.
     */
    world& operator =(const world& other);

    /**
     * Update the state of the world based on the event ev.
     */
    void handle_event(ALLEGRO_EVENT ev);

    /**
     * Advance the state of the world forward by the specified time.
     */
    void advance_by_time(double dt);

    /**
     * Draw the world. Note that the display variable is passed only
     * because it might be needed to switch the target bitmap back to
     * the backbuffer.
     */
    void draw();

    /**
     * Return true iff game is over and window should close
     */
    bool should_exit();
    void playerkilled();
    void enemyKilled(sprite* enemy);
    void coincollected();

  private:
    void resolve_collisions();
    bool exit = false;
    player_sprite *player;
    enemy_sprite *goomba;
    obstruction_sprite *ground;
    obstruction_sprite *tunnel;
    obstruction_sprite *coin;
    obstruction_sprite *castle;
    obstruction_sprite *brick;
    std::vector<sprite*> sprites;
    float camera_x = 0;
    float camera_y = 0;
    int score = 0;
    int lives = 3;
    int time = 10000;
    ALLEGRO_FONT* font;
    ALLEGRO_SAMPLE_ID id;
    ALLEGRO_SAMPLE *theme;
    ALLEGRO_SAMPLE_INSTANCE *themeInstance;
    ALLEGRO_SAMPLE *themefast=NULL;
    ALLEGRO_SAMPLE_INSTANCE *themeFastInstance=NULL;
    ALLEGRO_SAMPLE *dead=NULL;
    ALLEGRO_SAMPLE_INSTANCE *deadInstance=NULL;

  };
}

#endif /* WORLD_H */

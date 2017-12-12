#include "keyboard_manager.h"
#include "allegro5/allegro.h"
#include "player_sprite.h"
#include <cstdlib>


namespace csis3700 {
  keyboard_manager *keyboard_manager::default_instance = NULL;

  keyboard_manager *keyboard_manager::get() {
    if (default_instance == NULL)
      default_instance = new keyboard_manager();
    return default_instance;
  }

  keyboard_manager::keyboard_manager() {
  }

  bool keyboard_manager::is_key_down(int keycode) {
    return down.find(keycode) != down.end();
  }

  void keyboard_manager::key_down(int keycode) {
    down.insert(keycode);
  }

  void keyboard_manager::key_up(int keycode) {
    down.erase(keycode);
  }

}

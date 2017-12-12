#include "image_sequence.h"
#include "allegro5/allegro.h"
#include <cassert>

namespace csis3700 {

  image_with_offset::image_with_offset(ALLEGRO_BITMAP* i, double o) {
    image = i;
    offset = o;
  }

  image_sequence::image_sequence() {
    current = 0;
    last_change_time = 0;
    loop_index = 0;
  }

  void image_sequence::add_image(ALLEGRO_BITMAP *image, double offset) {
    assert(image != NULL);
    images.push_back(image_with_offset(image, offset));
  }

  void image_sequence::draw_current(float x, float y) {
    al_draw_bitmap(images[current].image, x, y, 0);
  }

  void image_sequence::draw(double time, float x, float y) {
    assert(images.size() > 0);
    if (images.size() == 1) {
      draw_current(x, y);
      return;
    }
    image_with_offset visible = images[current];
    size_t next_index = current+1;
    if (next_index >= images.size()) {
      next_index = loop_index;
    }
    image_with_offset next = images[next_index];
    if (time - last_change_time > next.offset) {
      current = next_index;
      last_change_time = time;
    }
    draw_current(x, y);
  }

  int image_sequence::get_width() const {
    assert(images.size() > 0);
    return al_get_bitmap_width(images[0].image);
  }

  int image_sequence::get_height() const {
    assert(images.size() > 0);
    return al_get_bitmap_height(images[0].image);
  }

  void image_sequence::set_loop_index(size_t loop_index) {
    assert(loop_index < images.size());
    this->loop_index = loop_index;
  }

}

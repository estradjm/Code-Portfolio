#ifndef __CDS_IMAGE_SEQUENCE_H_
#define __CDS_IMAGE_SEQUENCE_H_
#include <cstdlib>
#include <vector>
#include "allegro5/allegro.h"
#include "allegro5/allegro_image.h"

namespace csis3700 {
  class image_with_offset {
  public:
    image_with_offset(ALLEGRO_BITMAP* image, double offset);
    
    ALLEGRO_BITMAP *image;
    double offset;
  };

  class image_sequence {
  public:
    image_sequence();

    /**
     * Adds an image to this sequence which will play offset seconds
     * from the previous image.
     */
    void add_image(ALLEGRO_BITMAP *image, double offset);

    /**
     * Draw the current image on the current allegro target.
     */
    void draw(double time, float x, float y);

    /**
     * Set the loop index. When the last image in the sequence is
     * reached, the image at this index will be next. Defaults to 0
     * (zero).
     */
    void set_loop_index(std::size_t loop_index);
    
    /**
     * Returns the width of the first image in the sequence
     */
    int get_width() const;

    /**
     * Returns the height of the first image in the sequence
     */
    int get_height() const;


  private:
    void draw_current(float x, float y);
    std::vector<image_with_offset> images;
    std::size_t current;
    double last_change_time;
    std::size_t loop_index;
    
  };
}

#endif /* IMAGE_SEQUENCE_H */

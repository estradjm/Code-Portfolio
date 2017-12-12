#ifndef __CDS_IMAGE_LIBRARY_H
#define __CDS_IMAGE_LIBRARY_H
#include <string>
#include <map>
#include <iostream>
#include "allegro5/allegro.h"
#include "allegro5/allegro_image.h"

namespace csis3700 {

  /**
   * Change this if your images are stored in some other directory.
   * This path is relative to the current directory.
   */
  const std::string image_directory = "images";

  class image_library {
  public:

    /**
     * There should only be one instance of image_library in your
     * application. Use this method to fetch that library.  You call
     * it with image_library::get_instance().
     */
    static image_library *get();

    image_library(std::string dir);

    ALLEGRO_BITMAP *get(std::string name);

  private:
    static image_library *default_instance;
    std::string directory;
    std::map<std::string,ALLEGRO_BITMAP *> images;

    void load_image(std::string name);

  };


}
#endif /* IMAGE_LIBRARY_H */

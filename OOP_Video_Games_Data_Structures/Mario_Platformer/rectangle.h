#ifndef __CDS_RECTANGLE_H
#define __CDS_RECTANGLE_H
#include "vec2d.h"

namespace csis3700 {

  /**
   * I represent an oriented rectangle. My sides are parallel to the x
   * and y axes of the coordinate system.
   */
  class rectangle {
  public:

    /**
     * Construct a rectangle. Note if width or height is negative then
     * this rectangle is considered degenerate (empty).
     */
    rectangle(float x, float y, float width, float height);

    /**
     * Construct a rectangle by specifying the position of its upper
     * left corner as well as its dimensions.
     */
    rectangle(vec2d corner, float width, float height);

    /**
     * Construct a rectangle given two corners. The order of the
     * corners is important. upper_left_corner must be above and to
     * the left of lower_right_corner or the rectangle will be
     * degenerate. Note orientation is in terms of typical graphical
     * coordinates (increasing y is down).
     */
    rectangle(vec2d upper_left_corner, vec2d lower_right_corner);

    float get_width() const;

    float get_height() const;

    float get_area() const;

    /**
     * Return my upper left corner
     */
    vec2d upper_left_corner() const;

    /**
     * Return my lower right corner
     */
    vec2d lower_right_corner() const;

    /**
     * Return the rectangle representing the intersection (overlap)
     * between this rectangle and other. If I do not intersect other,
     * return a degenerate rectangle.
     */
    rectangle intersection(const rectangle& other) const;

    /**
     * Returns true if this rectangle contains the point specified by
     * the supplied vector (relative to the origin).
     */
    bool contains(vec2d point) const;

    /**
     * Return true if this rectangle is degenerate.  A degenerate
     * rectangle is one with negative width or height.
     */
    bool is_degenerate() const;

  private:
    void init(float x, float y, float width, float height);
    float x, y, width, height;
  };
}
#endif /* RECTANGLE_H */

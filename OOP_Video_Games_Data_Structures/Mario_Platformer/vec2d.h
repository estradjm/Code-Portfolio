#ifndef __CDS_VEC2D_H
#define __CDS_VEC2D_H
#include <ostream>

namespace csis3700 {

  /**
   * A 2-dimensional vector. Also used for point-like operations in
   * which case, as a point, this vector is interpreted as the point
   * corresponding to its endpoint if it began at the origin (that is
   * a point with coordinates (x,y)).
   */
  class vec2d {
  public:
    vec2d(float initial_x=0, float initial_y=0) {
      x = initial_x;
      y = initial_y;
    }
    float get_x() const { return x; }
    float get_y() const { return y; }

    /**
     * The vector sum of this and other.
     */
    vec2d operator+(const vec2d& other) const;

    /**
     * The vector difference (this - other)
     */
    vec2d operator-(const vec2d& other) const;

    /**
     * Two vectors are equal iff their components are exactly equal.
     * Be careful with floats!
     */
    bool operator==(const vec2d& other) const;

    /**
     * Return a vector whose x is the max of this.x and other.x and
     * whose y is the max of this.y and other.y.
     */
    vec2d max(const vec2d& other) const;

    /**
     * Return a vector whose x is the min of this.x and other.x and
     * whose y is the min of this.y and other.y.
     */
    vec2d min(const vec2d& other) const;

    /**
     * Return a vector whose x component is between -max_x and max_x
     * and whose y component is between -max_y and max_y.  If the
     * condition on the component is already met, do nothing to it,
     * otherwise set it to the max with the appropriate sign.
     */
    vec2d clamp(float max_x, float max_y) const;

    vec2d& operator+=(const vec2d& other);

  private:
    float x,y;
  };

  /**
   * Make it easy to display points.
   */
  std::ostream& operator<<(std::ostream& outs, const vec2d& v);

  /**
   * The product of a scalar and a vector (scales both components by d).
   */
  vec2d operator*(const double d, const vec2d& v);

}


#endif /* VEC2D_H */

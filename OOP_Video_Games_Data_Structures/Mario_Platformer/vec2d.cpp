#include "vec2d.h"
#include <cmath>
using namespace std;

namespace csis3700 {

  vec2d operator*(const double d, const vec2d& v) {
    return vec2d(d*v.get_x(),d*v.get_y());
  }
  
  vec2d vec2d::operator+(const vec2d& other) const {
    return vec2d(get_x()+other.get_x(), get_y()+other.get_y());
  }

  vec2d vec2d::operator-(const vec2d& other) const {
    return vec2d(get_x()-other.get_x(), get_y()-other.get_y());
  }
  
  bool vec2d::operator==(const vec2d& other) const {
    return get_x() == other.get_x() && get_y() == other.get_y();
  }
  
  vec2d vec2d::max(const vec2d& other) const {
    return vec2d(fmax(x,other.x), fmax(y, other.y));
  }
  
  vec2d vec2d::min(const vec2d& other) const {
    return vec2d(fmin(x,other.x), fmin(y, other.y));
  }

  std::ostream& operator<<(std::ostream& outs, const vec2d& v) {
    outs << v.get_x() << ", " << v.get_y();
    return outs;
  }

  vec2d vec2d::clamp(float max_x, float max_y) const {
    float tmp_x = x;
    float tmp_y = y;
    if (fabs(x) > max_x)
      tmp_x = ((x > 0 ? 1 : -1) * max_x);
    if (fabs(y) > max_y)
      tmp_y = ((y > 0 ? 1 : -1) * max_y);
    return vec2d(tmp_x, tmp_y);
  }

  vec2d& vec2d::operator+=(const vec2d& other) {
    x += other.x;
    y += other.y;
    return *this;
  }


  
}

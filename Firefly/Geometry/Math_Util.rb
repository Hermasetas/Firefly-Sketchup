module Firefly
  # A module with handy math methods
  module MathUtil
    # Checks if two line segments intersect
    def self.line_segments_intersect?(p1, p2, p3, p4)
      # https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection#Given_two_points_on_each_line_segment
      d = (p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x)

      return false if d.zero?

      nt = (p1.x - p3.x) * (p3.y - p4.y) - (p1.y - p3.y) * (p3.x - p4.x)
      nu = (p1.x - p3.x) * (p1.y - p2.y) - (p1.y - p3.y) * (p1.x - p2.x)

      t = nt / d
      u = nu / d

      t.between?(0, 1) && u.between?(0, 1)
    end

    # Decompose a 4×4 transformation matrix into translation, scaling and rotation components.
    # @param m transformation matrix
    # @return [Array(3),Array(3),Array(3)] three arrays representing:
    #     the translation vector,
    #     the scaling factor per axis
    #     the Euler rotation angles in radians (XYZ)
    def self.decompose_transformation_matrix(m)
      m = m.to_a
      # Extract translation
      translation = m.values_at(12, 13, 14)

      # Extract scaling, considering uniform scale factor (last matrix element)
      scaling = Array.new(3)
      scaling[0] = m[15] * Math.sqrt(m[0]**2 + m[1]**2 + m[2]**2)
      scaling[1] = m[15] * Math.sqrt(m[4]**2 + m[5]**2 + m[6]**2)
      scaling[2] = m[15] * Math.sqrt(m[8]**2 + m[9]**2 + m[10]**2)

      # Remove scaling to prepare for extraction of rotation
      [0, 1, 2].each { |i| m[i] /= scaling[0] } unless scaling[0].zero?
      [4, 5, 6].each { |i| m[i] /= scaling[1] } unless scaling[1].zero?
      [8, 9, 10].each { |i| m[i] /= scaling[2] } unless scaling[2].zero?
      m[15] = 1.0

      # Verify orientation, if necessary invert it.
      tmp_z_axis = Geom::Vector3d.new(m[0], m[1], m[2]).cross(Geom::Vector3d.new(m[4], m[5], m[6]))
      if tmp_z_axis.dot(Geom::Vector3d.new(m[8], m[9], m[10])) < 0
        scaling[0] *= -1
        m[0] = -m[0]
        m[1] = -m[1]
        m[2] = -m[2]
      end

      # Extract rotation
      theta1 = Math.atan2(m[6], m[10])
      c2 = Math.sqrt(m[0]**2 + m[1]**2)
      theta2 = Math.atan2(-m[2], c2)
      s1 = Math.sin(theta1)
      c1 = Math.cos(theta1)
      theta3 = Math.atan2(s1 * m[8] - c1 * m[4], c1 * m[5] - s1 * m[9])
      rotation = [theta1, theta2, theta3]

      [translation, scaling, rotation]
    end

    def self.compose_transformation_matrix(translation, scaling, rotations)
      tran = Geom::Transformation

      tl = tran.translation translation
      ts = tran.scaling scaling.x, scaling.y, scaling.z

      tx = tran.rotation [0, 0, 0], [1, 0, 0], rotations.x
      ty = tran.rotation [0, 0, 0], [0, 1, 0], rotations.y
      tz = tran.rotation [0, 0, 0], [0, 0, 1], rotations.z

      tl * tz * ty * tx * ts
    end
  end
end

module Firefly
  # A module that creates string representations of radiance surfaces
  module RadSurface
    # Creates a string representing a Radiance polygon
    # @param points An array of points of the polygon in order
    # @param material_name The name of the Radiance material to apply to the polygon
    # @param name A unique name to give the polygon
    # @return A string representation of a radiance polygon
    def self.polygon(points, material_name, name)
      verticies = points.map do |p|
        MathUtil.convert_point_to_metric(p)
      end

      s1 = "\"#{material_name}\" polygon \"#{name}\""
      s2 = '0'
      s3 = '0'
      s4 = "#{verticies.length * 3} #{verticies.each { |p| p.join(' ') }.join(' ')}"
  
      "#{[s1, s2, s3, s4].join("\n")} \n"
    end

    # Creates a string representing a Radiance cylinder
    # @param point1 Point at one end of the cylinder
    # @param point2 Point at other end of the cylinder
    # @param radius Radius of the cylinder
    # @param material_name The name of the Radiance material to apply to the cylinder
    # @param name A unique name to give the cylinder
    # @return A string representation of a radiance cylinder
    def self.cylinder(point1, point2, radius, material_name, name)
      p1 = MathUtil.convert_point_to_metric(point1).join(' ')
      p2 = MathUtil.convert_point_to_metric(point2).join(' ')
      radius = radius.round(3)

      s1 = "\"#{material_name}\" cylinder \"#{name}\""
      s2 = '0'
      s3 = '0'
      s4 = "7 #{p1} #{p2} #{radius}"

      "#{[s1, s2, s3, s4].join("\n")} \n"
    end
  end
end

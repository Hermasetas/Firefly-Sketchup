module Firefly
  # A module that creates string representations of radiance surfaces
  module RadSurface
    # Creates a string representing a Radiance polygon
    # @param points An array of points of the polygon in order
    # @param material_name The name of the Radiance material to apply to the polygon
    # @param name A unique name to give the polygon
    # @return A string representation of a radiance polygon
    def self.polygon(points, material_name, name)
      # Convert to metric and round
      verticies = points.map do |p|
        p.map {|v| (v.to_f * 0.0254).round(3)}
      end

      s1 = material_name + ' polygon ' + name
      s2 = '0'
      s3 = '0'
      s4 = "#{verticies.length * 3} #{verticies.each {|p| p.join(" ")}.join(" ")}"
  
      [s1,s2,s3,s4].join("\r\n") + "\r\n"
    end

    # Creates a string representing a Radiance cylinder
    # @param point1 Point at one end of the cylinder
    # @param point2 Point at other end of the cylinder
    # @param radius Radius of the cylinder
    # @param material_name The name of the Radiance material to apply to the cylinder
    # @param name A unique name to give the cylinder
    # @return A string representation of a radiance cylinder
    def self.cylinder(point1, point2, radius, material_name, name)
      p1 = point1.map {|v| v.round(3)}.join(" ")
      p2 = point2.map {|v| v.round(3)}.join(" ")

      s1 = material_name + ' cylinder ' + name
      s2 = '0'
      s3 = '0'
      s4 = "7 #{p1} #{p2} #{radius.round(3)}"
    end
  end
end
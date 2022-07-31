module Firefly
  module RadMaterial
    # Creates a string representing a radiance plastic material
    # @param name Name of the material
    # @param color A sketchup color
    # @param specularity [0-1f] 
    # @param roughness [0-1f]
    def self.plastic(name, color, specularity, roughness)
      r = (color.red / 255.0).round(3)
      g = (color.green / 255.0).round(3)
      b = (color.blue / 255.0).round(3)
      
      s1 = 'void plastic ' + name
      s2 = '0'
      s3 = '0'
      s4 = "5 #{r} #{g} #{b} #{specularity} #{roughness}"
      
      [s1, s2, s3, s4].join("\n") + "\n\n"
    end

    # Creates a default plastic material in 50% grey.
    def self.default_material
      return "void plastic default\n0\n0\n5 0.5 0.5 0.5 0 0 \n\n"
    end
  end
end
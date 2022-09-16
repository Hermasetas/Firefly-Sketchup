module Firefly
  # A module that creates string representations of Radiance materials
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

      <<~PLASTIC
        void plastic "#{name}"
        0
        0
        5 #{r} #{g} #{b} #{specularity} #{roughness}
      PLASTIC
    end

    # Creates a default plastic material in 50% grey.
    def self.default
      <<~DEFAULT
        void plastic default
        0
        0
        5 0.5 0.5 0.5 0 0
      DEFAULT
    end

    def self.glass_from_color(name, color, alpha)
      trans = 1 - alpha
      rt = (color.red / 255.0) * trans
      gt = (color.green / 255.0) * trans
      bt = (color.blue / 255.0) * trans

      glass name, rt, gt, bt
    end

    def self.glass(name, r_trans, g_trans, b_trans)
      # Transmittance to transmissivity (Simplified)
      r = (r_trans * 1.09).round(3)
      b = (b_trans * 1.09).round(3)
      g = (g_trans * 1.09).round(3)

      <<~GLASS
        void glass "#{name}"
        0
        0
        3 #{r} #{g} #{b}
      GLASS
    end
  end
end

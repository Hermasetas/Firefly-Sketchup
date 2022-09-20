module Firefly
  module Attributes

    def self.save_sky_options(sky_options)
      model = Sketchup.active_model
      model.set_attribute 'Firefly', 'sky_options', sky_options
    end

    def self.sky_options
      model = Sketchup.active_model
      model.get_attribute 'Firefly', 'sky_options', ''
    end

  end
end

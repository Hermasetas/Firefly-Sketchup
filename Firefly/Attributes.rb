require JSON

module Firefly
  module Attributes
    def self.save_sky_options(sky_options)
      model = Sketchup.active_model
      model.set_attribute 'Firefly', 'sky_options', sky_options.to_json
    end

    def self.sky_options
      model = Sketchup.active_model
      sky_options = model.get_attribute 'Firefly', 'sky_options'

      return nil if sky_options.nil?

      JSON.parse sky_options
    end
  end
end

module Firefly
  unless file_loaded?(__FILE__)
    ex = SketchupExtension.new('Firefly', 'Firefly/Main.rb')
    ex.description = 'Firefly Daylight and Lighting simulations.'
    ex.creator = 'Hermasetas'
    Sketchup.register_extension(ex, true)
    file_loaded(__FILE__)
  end

  def self.reload
    load 'Firefly/Main.rb'
    load 'Firefly/Geometry/Math_Util.rb'
    load 'Firefly/Geometry/Component_Util.rb'
  end
end

require 'sketchup.rb'
require 'extensions.rb'

module Firefly
    module main
        unless file_loaded?(__FILE__)
            ex = SketchupExtension.new('Firefly', 'Firefly/Main.rb')
            ex.description = 'Firefly Daylight and Lighting simulations.'
            ex.creator = 'Hermasetas'
            Skecthup.register_extension(ex, true)
            file_loaded(__FILE__)
        end
    end
end
module Firefly
  def self.reload
    files = Dir['C:/Users/herma/Documents/GitHub/Firefly-Sketchup/Firefly/**/*.rb']
    files.each do |f|
      load f
      puts "#{File.basename(f)} loaded"
    end
    nil
  end

  def self.extension
    Sketchup.extensions['Firefly']
  end

  unless file_loaded?(__FILE__)
    ex = SketchupExtension.new('Firefly', 'Firefly/Main.rb')
    ex.description = 'Firefly Daylight and Lighting simulations.'
    ex.creator = 'Hermasetas'
    Sketchup.register_extension(ex, true)
    file_loaded(__FILE__)

    reload
    Dialog.init_ui
  end
end

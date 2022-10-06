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

  def self.puts_all_attributes(ent)
    ent.attribute_dictionaries.each do |dict|
      puts "#{dict.name}"
      dict.each do |k, v|
        puts "  #{k}: #{v}"
      end
      puts
    end
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

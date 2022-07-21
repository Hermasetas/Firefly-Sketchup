module Firefly
  module SkpToRad
    def self.write_all_to_rad(dir_name)    
      # Write materials to a file
      write_all_materials(dir_name)
      
      # Write component/Group definitions to seperate files
      
      # Write all component/group instances to a file
      
      # Write all faces to a file
    end
    
    private_class_method def self.write_all_materials(dir_name)
      model = Sketchup.active_model

      materials_file = File.join(dir_name, "materials.rad")
      File.open(materials_file, 'w') do |file|
        model.materials.each do |m|
          mat = RadMaterials.plastic(m.name, m.color, 0, 0)
          file.write(mat)
        end
      end
    end
    
    
    
    
  end
end

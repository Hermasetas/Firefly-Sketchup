module Firefly
  module SkpToRad
    
    def self.write_all_to_rad(dir_name)    
      # TODO check if dir exists
      
      write_all_materials(dir_name)
      
      # Write component/Group definitions to seperate files
      
      # Write all component/group instances to a file
      
      write_all_faces(dir_name)
    end
    
    def self.write_all_materials(dir_name)
      model = Sketchup.active_model
      
      materials_file = File.join(dir_name, "materials.rad")
      
      File.open(materials_file, 'w') do |file|
        file.write(RadMaterial.default_material)
        
        model.materials.each do |m|
          mat = RadMaterial.plastic(m.name, m.color, 0, 0)
          file.write(mat)
        end
      end
    end
    
    def self.write_all_faces(dir_name)    
      model = Sketchup.active_model
      
      faces_file = File.join(dir_name, "faces.rad")
      
      File.open(faces_file, 'w') do |file|
        faces = model.entities.select {|e| e.is_a? Sketchup::Face}
        faces.each do |face|
          points = FaceToPolygon.face_to_polygon face
          material_name = face_material_name face
          name = "Face-#{face.entityID}"
          
          polygon = RadSurface.polygon(points, material_name, name)
          
          file.write(polygon)
        end
      end
    end
    
    def self.face_material_name(face)
      if face.material
        return face.material.name
      elsif face.back_material
        return face.back_material.name
      else
        return 'default'
      end
    end
  end
end

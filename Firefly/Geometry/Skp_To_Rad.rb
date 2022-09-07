require 'fileutils'

module Firefly
  module SkpToRad
    class << self
      def write_all_to_rad(dir_name)
        FileUtils.mkdir_p dir_name

        materials_file = write_all_materials(dir_name)

        write_all_defintions(dir_name)

        instances_file = write_all_instances(dir_name)

        faces_file = write_all_faces(dir_name)

        [materials_file, faces_file, instances_file]
      end

      private #-----------------------------------------------

      def write_all_materials(dir_name)
        model = Sketchup.active_model

        materials_file = File.join(dir_name, "materials.rad")

        File.open(materials_file, 'w') do |file|
          file.write(RadMaterial.default)

          model.materials.each do |m|
            mat = RadMaterial.plastic(m.name, m.color, 0, 0)
            file.write(mat)
          end
        end

        materials_file
      end

      def write_all_faces(dir_name)
        model = Sketchup.active_model

        faces_file = File.join(dir_name, "faces.rad")

        File.open(faces_file, 'w') do |file|
          faces = model.entities.select { |e| e.is_a? Sketchup::Face }
          write_faces faces, file
        end

        faces_file
      end

      def defintion_name(d)
        "#{d.name}-#{d.entityID}.rad"
      end

      def write_all_defintions(dir_name)
        model = Sketchup.active_model
        definitions = model.definitions.filter { |d| d.count_used_instances > 0 }
        return if definitions.empty?

        dir_name = File.join(dir_name, 'definitions')
        FileUtils.mkdir_p dir_name
        files = []

        definitions.each do |d|
          file_name = defintion_name d
          file_name = File.join(dir_name, file_name)

          File.open(file_name, 'w') do |file|
            faces = d.entities.filter { |e| e.is_a? Sketchup::Face }
            write_faces faces, file

            nested_instances = d.entities.filter { |e| e.is_a? Sketchup::ComponentInstance }
            nested_instances.each do |ni|
              name = defintion_name(ni.definition)
              transformation = ni.transformation
              xform = RadXform.xform name, transformation
              file.puts xform
            end
          end
          files << file_name
        end
      end

      def write_all_instances(dir_name)
        model = Sketchup.active_model
        instances = model.entities.filter { |e| e.is_a? Sketchup::ComponentInstance }

        instances_file = File.join(dir_name, 'instances.rad')

        File.open(instances_file, 'w') do |file|
          instances.each do |i|
            file_name = File.join('definitions', defintion_name(i.definition))
            transformation = i.transformation
            xform = RadXform.xform file_name, transformation
            file.puts xform
          end
        end

        instances_file
      end

      def write_faces(faces, file)
        # TODO: create two polygons for front and back. Offset with normal.
        faces.each do |face|
          points = FaceToPolygon.face_to_polygon face
          material_name = face_material_name face
          name = "Face-#{face.entityID}"

          polygon = RadSurface.polygon(points, material_name, name)

          file.write(polygon)
        end
      end

      def face_material_name(face)
        return face.material.name if face.material

        return face.back_material.name if face.back_material

        'default'
      end
    end
  end
end

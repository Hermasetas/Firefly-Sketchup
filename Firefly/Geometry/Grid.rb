module Firefly
  module Grid
    # Creates a grid of points parallel to the xy plane
    # A base face determines the size of the grid and which points to include
    # @param face The face to base the grid on
    # @param spacing the space between points in meters
    # @param height The height to offset the points above the face
    # @return A 2D array of points
    def self.create_grid(face, spacing, height = 0)
      bounds = face.bounds
      x = bounds.min.x
      y = bounds.min.y
      z = bounds.min.z
      w = bounds.width
      h = bounds.height
      
      # Meters to inches
      spacing = spacing.m
      height = height.m
      
      nx = (w / spacing).ceil
      ny = (h / spacing).ceil
      
      pts = []
      
      for i in (0..nx-1) do
        pts << []
        
        for j in (0..ny-1) do
          px = x + spacing * i
          py = y + spacing * j
          p = [px, py, z]
          
          if face.classify_point(p) != Sketchup::Face::PointOutside
            p.x = p.x.round(2)
            p.y = p.y.round(2)
            p.z = (p.z+height).round(2)
            pts[i] << p
          else
            pts[i] << nil
          end
        end
      end
      
      pts
    end
    
    def self.create_cpoints(pts)
      Sketchup.active_model.start_operation("Create points", true)
      
      ents = Sketchup.active_model.active_entities
      g = ents.add_group.entities
      
      pts.each do |l|
        l.each do |p|
          g.add_cpoint(p) if p
        end
      end
      
      Sketchup.active_model.commit_operation()
    end
    
    def self.grid_to_file(pts, file_name)
      File.open(file_name, 'w') do |file|
        for l in pts
          for p in l
            if p
              pm = MathUtil.convert_point_to_metric p
              file.puts "#{pm.x} #{pm.y} #{pm.z}"
            end
          end
        end
      end
    end
  end
end

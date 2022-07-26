module Firefly
  module FaceToPolygon
    
    def self.face_to_polygon(face)
      # If face has no inner loops return it
      return face.vertices.map {|v| v.position} if face.loops.count == 1
      
      mesh = face.mesh
      point_map = Array.new face.vertices.count, -1
      loops = face.loops
      
      # Convert loops to arrays of mesh indices
      # Populate point map with mesh indices for each loop in face
      loops.each_with_index do |loop, i|
        indices = []
        
        loop.vertices.each do |v|
          index = mesh.point_index(v.position) - 1 # mesh indices starts at 1
          
          indices << index
          point_map[index] = i
        end
        
        loops[i] = indices
      end
      
      # Collapse loops into one continous loop by using the mesh edges
      # Remember mesh indices start at 1
      final_loop = []
      
      catch (:done) do
        mesh.polygons.each do |poly|
          points = poly.map{|p| p.abs - 1}
          
          # Find the first two loops connected by this polygon (Might not be unique loops)
          l0 = point_map[points[0]]
          l1 = point_map[points[1]]
          
          if l0 != l1
            l01 = merge_loops(l0, l1, points[0..1])
            
            # If the loop contains all points break
            if l01.count == face.vertices.count
              final_loop = l01
              throw :done
            end
            
            # TODO: Update point_map
          end
          
        end
      end
      
      # Turn loop into point array
      return final_loop
    end
    
    
    private_class_method def self.merge_loops(l1, l2, edge)
    l1.rotate! l1.index edge[0]
    l2.rotate! l2.index edge[1]
    
    result = [edge[0]] + l2 + l1
  end
  
end
end

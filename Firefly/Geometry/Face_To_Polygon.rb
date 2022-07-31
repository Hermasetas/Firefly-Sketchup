module Firefly
  module FaceToPolygon
    
    def self.face_to_polygon(face)
      # If face has no inner loops return it
      return face.vertices.map {|v| v.position} if face.loops.count == 1
      
      mesh = face.mesh
      point_map = Array.new face.vertices.count, -1 # [v_index] => loop_index
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
          for i in 0..2 do
            p1 = points[i]
            p2 = points[(i+1)%3]
            
            # Find the two loops connected by this edge (Might not be unique loops)
            loop1_index = point_map[p1]
            loop2_index = point_map[p2]
            loop1 = loops[loop1_index]
            loop2 = loops[loop2_index]
            
            if loop1 != loop2
              merged_loop = merge_loops(loop1, loop2, [p1, p2])
              
              loops[loop1_index] = merged_loop
              loops[loop2_index] = nil
              
              # Update point map
              merged_loop.each {|n| point_map[n] = loop1_index}
              
              # If the merged loop contains all points break
              if all_equal? point_map
                final_loop = merged_loop
                throw :done
              end            
            end
          end
        end
      end
      
      if not all_equal? point_map 
        raise "Face could not be turned into a polygon: #{face.entityID}"
      end
      
      # Turn loop into a point array
      return final_loop.map {|i| mesh.points[i]}
    end
    
    
    def self.merge_loops(l1, l2, edge)
      l1.rotate! l1.index edge[0]
      l2.rotate! l2.index edge[1]
      
      result = [edge[0]] + l2 + [edge[1]] + l1
    end
    
    def self.all_equal?(array)
      return array.all? {|e| e == array.first}
    end
    
  end
end

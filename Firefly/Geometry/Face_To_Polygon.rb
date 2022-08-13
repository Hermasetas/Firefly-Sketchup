module Firefly
  # A module which converts Sketchup faces to single-line polygons
  module FaceToPolygon

    def self.face_to_polygon(face)
      # If face has no inner loops return it
      return face.vertices.map(&position) if face.loops.count == 1

      mesh = face.mesh

      loops, point_map = loops_to_indices(face.loops, mesh)

      final_loop = collapse_loops(mesh, loops, point_map)

      # Turn loop into a point array
      final_loop.map { |i| mesh.points[i] }
    end

    def self.merge_loops(l1, l2, edge)
      l1.rotate! l1.index edge[0]
      l2.rotate! l2.index edge[1]
      [edge[0]] + l2 + [edge[1]] + l1
    end

    def self.all_equal?(array)
      array.all? { |e| e == array.first }
    end

    # Convert loops to arrays of mesh indices
    # Populate point map with mesh indices for each loop in face
    def self.loops_to_indices(loops, mesh)
      indices_array = []
      point_map = Array.new mesh.points.count, -1 # [v_index] => loop_index

      loops.each_with_index do |loop, i|
        indices = []

        loop.vertices.each do |v|
          index = mesh.point_index(v.position) - 1 # mesh indices starts at 1

          indices << index
          point_map[index] = i
        end

        indices_array << indices
      end

      [indices_array, point_map]
    end

    def self.collapse_loops(mesh, loops, point_map)
      # Collapse loops into one continous loop by using the mesh edges
      # Remember mesh indices start at 1

      mesh.polygons.each do |poly|
        points = poly.map { |p| p.abs - 1 }
        (0..2).each do |i|
          p1 = points[i]
          p2 = points[(i + 1) % 3]

          # Find the two loops connected by this edge (Might not be unique loops)
          loop1_index = point_map[p1]
          loop2_index = point_map[p2]
          loop1 = loops[loop1_index]
          loop2 = loops[loop2_index]

          next if loop1 == loop2

          merged_loop = merge_loops(loop1, loop2, [p1, p2])

          loops[loop1_index] = merged_loop
          loops[loop2_index] = nil

          # Update point map
          merged_loop.each { |n| point_map[n] = loop1_index }

          # If the merged loop contains all points, return
          return merged_loop if all_equal? point_map
        end
      end

      raise "Face could not be turned into a polygon: #{face.entityID}"
    end
  end
end

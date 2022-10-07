module Firefly
  module Grid
    class << self
      # Creates a grid of points parallel to the xy plane
      # A base face determines the size of the grid and which points to include
      # @param face The face to base the grid on
      # @param spacing the space between points in meters
      # @param height The height to offset the points above the face
      # @return A 2D array of points
      def create_points(face, spacing, height = 0)
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

      # Creates a group in Sketchup conatining the grid points and other information.
      # @param pts A 2D array of points.
      # @return A Sketchup::Group of cpoints
      def create_grid_group(pts, name)
        Sketchup.active_model.start_operation('Create grid points', true)

        ents = Sketchup.active_model.active_entities
        grid = ents.add_group
        grid.name = name
        ents = grid.entities

        pts.each do |row|
          row.each do |p|
            ents.add_cpoint p if p
          end
        end

        set_grid_attributes grid, pts

        Sketchup.active_model.commit_operation
      end

      # Writes a firefly grid to a text file with a direction vector of [0,0,1].
      # @param grid A Sketchup::Group containing a series of cpoints
      # @param file_name The name of the text file to write to
      def grid_points_to_file(grid, file_name)
        File.open(file_name, 'w') do |file|
          grid.entities.each do |p|
            pm = MathUtil.convert_point_to_metric p.position
            file.puts "#{pm.x} #{pm.y} #{pm.z} 0 0 1"
          end
        end
      end

      # Writes the attributes of a grid to a file
      # @param grid A Sketchup::Group containing a series of cpoints
      # @param file_name The name of the text file to write to
      def grid_attributes_to_file(grid, file_name)
        attributes = {}
        attributes['grid_pattern'] = grid.get_attribute 'Firefly', 'grid_pattern'
        attributes['grid_width'] = grid.get_attribute 'Firefly', 'grid_width'
        attributes['grid_height'] = grid.get_attribute 'Firefly', 'grid_height'
        attributes['position'] = MathUtil.convert_point_to_metric grid.bounds.min
        attributes['width'] = MathUtil.convert_to_metric grid.bounds.width
        attributes['height'] = MathUtil.convert_to_metric grid.bounds.height
        attributes['results'] = '#RESULTS'

        File.open(file_name, 'w') do |file|
          file.puts JSON.pretty_generate(attributes)
        end
      end

      private

      def set_grid_attributes(grid, pts)
        # TODO: Pattern is in the wrong orientation
        pattern = StringIO.new
        pts.each do |row|
          row.each do |p|
            pattern << (p.nil? ? '0' : '1')
          end
        end

        grid_width = pts.size
        grid_height = pts.first.size

        grid.set_attribute 'Firefly', 'isGrid', true
        grid.set_attribute('Firefly', 'grid_pattern', pattern.string)
        grid.set_attribute('Firefly', 'grid_width', grid_width)
        grid.set_attribute('Firefly', 'grid_height', grid_height)
        nil
      end
    end
  end
end

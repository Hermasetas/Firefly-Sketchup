module Firefly
  # A module to generate string representations of radiance commands.
  module RadCommand
    # Creates a string representation of a xform command.
    # @param file_name The name of the radiance file to manipulate with xform.
    # @param transformation A Sketchup::Transformation object.
    # Note: Non-uniform scaling is not currently supported.
    def self.xform(file_name, transformation)
      trans = MathUtil.decompose_transformation_matrix transformation
      rx, ry, rz = trans[2].map(&:radians)
      s = trans[1][0].abs
      tx, ty, tz = trans[0].map { |v| MathUtil.convert_to_metric v }
      mx = trans[1][0].negative? ? '-mx' : ''
      my = trans[1][1].negative? ? '-my' : ''
      mz = trans[1][2].negative? ? '-mz' : ''

      "!xform #{mx} #{my} #{mz} -rx #{rx} -ry #{ry} -rz #{rz} -s #{s} -t #{tx} #{ty} #{tz} \"#{file_name}\""
    end
  end
end

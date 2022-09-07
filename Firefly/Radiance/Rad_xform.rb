module Firefly
  module RadXform
    def self.xform(file_name, transformation)
      trans = MathUtil.decompose_transformation_matrix transformation.to_a
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

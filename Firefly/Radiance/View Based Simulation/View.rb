module Firefly
  module View
    
    def self.get_perspective_view()
      view = Sketchup.active_model.active_view
      camera = view.camera

      # Convert to metric and round
      vp = MathUtil.convert_point_to_metric(camera.eye).join(' ')
      vd = MathUtil.convert_point_to_metric(camera.direction).join(' ')
      vu = MathUtil.convert_point_to_metric(camera.up).join(' ')

      fov = camera.fov
      width = view.vpwidth
      height = view.vpheight
      pa = camera.aspect_ratio

      return "-vtv -vp #{vp} -vd #{vd} -vu #{vu} -vh #{fov} -x #{width} -y #{height} -pa #{pa}"
    end
    
    
  end
end
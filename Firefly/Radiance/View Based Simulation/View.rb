module Firefly
  # A module to grab views from sketchup
  module View
    # Grab the perspective view from Sketchup
    def self.grab_perspective_view
      view = Sketchup.active_model.active_view
      camera = view.camera

      # Convert to metric and round
      vp = MathUtil.convert_point_to_metric(camera.eye).join(' ')
      vd = MathUtil.round_vector(camera.direction).join(' ')
      vu = MathUtil.roundVector(camera.up).join(' ')

      fov = camera.fov * 2
      width = view.vpwidth
      height = view.vpheight
      pa = camera.aspect_ratio

      "-vtv -vp #{vp} -vd #{vd} -vu #{vu} -vh #{fov} -x #{width} -y #{height} -pa #{pa}"
    end
  end
end

module Firefly
  # A module that executes perspective renderings in Radiance
  module PerspectiveRendering
    def self.run_simple_rendering(dir_name)
      materials_file, faces_file = SkpToRad.write_all_to_rad(dir_name)
      view = View.get_perspective_view

      command_file = File.join(dir_name, 'render_command.bat')

      File.open(command_file, 'w') do |file|
        file.write "cd /D \"#{dir_name}\" \n"
        file.write "oconv \"#{materials_file}\" \"#{faces_file}\" > scene.oct \n"
        file.write "rpict #{view} scene.oct > image.hdr \n"
        file.write "pfilt image.hdr > imageFilt.hdr \n"
        file.write "pcond -h imageFilt.hdr > imageCond.hdr \n"
        file.write "ra_bmp imageCond.hdr image.bmp \n"
        file.write "image.bmp \n"
      end

      UI.openURL("file://#{command_file}")
    end
  end
end

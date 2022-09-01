module Firefly
  # A module that executes perspective renderings in Radiance
  module PerspectiveRendering
    def self.run_simple_rendering(dir_name, options)
      materials_file, faces_file = SkpToRad.write_all_to_rad(dir_name)
      view = View.grab_perspective_view

      if options['sky_options']
        sky_file = File.join(dir_name, 'sky.rad')
        RadSky.generate_sky_file sky_file, options['sky_options']
        sky_file = "\"#{sky_file}\""
      else
        sky_file = ''
      end

      rad_params = Options.rad_params options['params_index'].to_i
      command_file = File.join(dir_name, 'render_command.bat')

      File.open(command_file, 'w') do |file|
        file.write "cd /D \"#{dir_name}\" \n"
        file.write "oconv \"#{materials_file}\" \"#{faces_file}\" #{sky_file}> scene.oct \n"
        file.write "rpict -t 1 #{rad_params} #{view} scene.oct > image.hdr \n"
        file.write "pfilt image.hdr > imageFilt.hdr \n"
        file.write "pcond -h imageFilt.hdr > imageCond.hdr \n"
        file.write "ra_bmp imageCond.hdr image.bmp \n"
        file.write "image.bmp \n"
      end

      UI.openURL("file://#{command_file}")
    end
  end
end

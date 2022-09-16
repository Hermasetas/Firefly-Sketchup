module Firefly
  # A module that executes perspective renderings in Radiance
  module PerspectiveRendering
    def self.run_rendering(options)
      Directory.clear_working_dir
      dir_name = Directory.working_dir

      materials_file, faces_file, instances_file = SkpToRad.write_all_to_rad(dir_name)
      view = View.grab_perspective_view

      if options['sky_options']
        sky_file = File.join(dir_name, 'sky.rad')
        RadSky.generate_sky_file sky_file, options['sky_options']
        sky_file = "\"#{sky_file}\""
      else
        sky_file = ''
      end

      rpict_params = Options.rpict_params options['params_label']
      command_file = File.join(dir_name, 'render_command.bat')

      t = Time.now
      result_name = "#{t.day}-#{t.month} #{t.hour}-#{t.min}-#{t.sec} simple-render.hdr"
      result_file = File.join(Directory.results_dir, result_name)

      File.open(command_file, 'w') do |file|
        file.puts "cd /D \"#{dir_name}\""
        file.puts "oconv \"#{materials_file}\" \"#{faces_file}\" \"#{instances_file}\" #{sky_file}> scene.oct"
        file.puts "rpict -t 1 #{rpict_params} #{view} scene.oct > \"#{result_file}\""
      end

      # Setup wait for result
      ResultHandler.await_image result_file

      # Run command
      UI.openURL("file://#{command_file}")
    end
  end
end
